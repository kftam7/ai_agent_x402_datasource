import json
from fastapi import APIRouter, HTTPException, Depends, Query
from core.auth import auth_dependency
from core.responses import CustomJSONResponse
from core import db

router = APIRouter(prefix="/v1", tags=["Router"])

@router.get("/router/recommend")
async def recommend_fastest_model(
    category: str = Query(..., description="Select category: general, image, or video"),
    region: str = Query("us-east", description="Region for live status latency routing"),
    auth=Depends(auth_dependency)
):
    category = category.lower()
    valid_categories = ["general", "image", "video"]
    
    if category not in valid_categories:
        raise HTTPException(
            status_code=400, 
            detail=f"Invalid category. Supported categories are: {', '.join(valid_categories)}"
        )

    raw_data = await db.redis_client.hgetall(f"live_provider_status:{region}")
    if not raw_data:
        raw_data = await db.redis_client.hgetall("live_provider_status:tokyo")

    # SQL query: Categories are now strictly dictated by llm_ranking, 
    # so we remove the dynamic pricing column filters entirely.
    query = """
        WITH all_prices AS (
            SELECT 
                h.model_id, h.processing_tier, h.tier_label, h.price_unit,
                h.input_price_per_1m, h.cached_input_price_per_1m,
                h.output_price_per_1m, h.cached_price_per_1m,
                h.thinking_output_price_per_1m, h.image_price, h.video_price_per_second, h.recorded_at,
                ROW_NUMBER() OVER (
                    PARTITION BY h.model_id, h.processing_tier, h.tier_label 
                    ORDER BY h.recorded_at DESC
                ) as prn
            FROM llm_prices h
            WHERE h.recorded_at >= NOW() - INTERVAL '30 days'
        ),
        current_p AS (SELECT * FROM all_prices WHERE prn = 1),
        previous_p AS (
            SELECT DISTINCT ON (ap.model_id, ap.processing_tier, ap.tier_label) ap.*
            FROM all_prices ap
            JOIN current_p cp 
              ON ap.model_id = cp.model_id 
             AND ap.processing_tier = cp.processing_tier 
             AND ap.tier_label = cp.tier_label
            WHERE ap.prn > 1
              AND (
                  ap.input_price_per_1m IS DISTINCT FROM cp.input_price_per_1m OR
                  ap.cached_input_price_per_1m IS DISTINCT FROM cp.cached_input_price_per_1m OR
                  ap.output_price_per_1m IS DISTINCT FROM cp.output_price_per_1m OR
                  ap.cached_price_per_1m IS DISTINCT FROM cp.cached_price_per_1m OR
                  ap.thinking_output_price_per_1m IS DISTINCT FROM cp.thinking_output_price_per_1m OR
                  ap.image_price IS DISTINCT FROM cp.image_price OR
                  ap.video_price_per_second IS DISTINCT FROM cp.video_price_per_second
              )
            ORDER BY ap.model_id, ap.processing_tier, ap.tier_label, ap.recorded_at DESC
        )
        
        SELECT 
            r.rank,
            p.name AS provider_name,
            m.model_id,
            m.slug AS model_slug,
            m.display_name AS model_name,
            cp.processing_tier, cp.tier_label, cp.price_unit,
            
            -- Current Prices
            cp.input_price_per_1m AS current_input_price,
            cp.cached_input_price_per_1m AS current_cached_input_price,
            cp.output_price_per_1m AS current_output_price,
            cp.cached_price_per_1m AS current_cached_price,
            cp.thinking_output_price_per_1m AS current_thinking_output_price,
            cp.image_price AS current_image_price,
            cp.video_price_per_second AS current_video_price,
            cp.recorded_at AS current_recorded_at,
            
            -- Previous Prices
            pp.input_price_per_1m AS previous_input_price,
            pp.cached_input_price_per_1m AS previous_cached_input_price,
            pp.output_price_per_1m AS previous_output_price,
            pp.cached_price_per_1m AS previous_cached_price,
            pp.thinking_output_price_per_1m AS previous_thinking_output_price,
            pp.image_price AS previous_image_price,
            pp.video_price_per_second AS previous_video_price,
            pp.recorded_at AS previous_recorded_at,
            
            -- Trends and Diffs
            CASE 
                WHEN pp.input_price_per_1m IS NULL AND pp.image_price IS NULL AND pp.video_price_per_second IS NULL THEN 'UNCHANGED'
                WHEN COALESCE(cp.input_price_per_1m, cp.image_price, cp.video_price_per_second) < COALESCE(pp.input_price_per_1m, pp.image_price, pp.video_price_per_second) THEN 'DECREASED'
                WHEN COALESCE(cp.input_price_per_1m, cp.image_price, cp.video_price_per_second) > COALESCE(pp.input_price_per_1m, pp.image_price, pp.video_price_per_second) THEN 'INCREASED'
                ELSE 'UNCHANGED'
            END AS input_price_trend_30d,
            ROUND(COALESCE(cp.input_price_per_1m - pp.input_price_per_1m, 0.0), 6) AS input_price_diff_30d,
            ROUND(COALESCE(cp.cached_input_price_per_1m - pp.cached_input_price_per_1m, 0.0), 6) AS cached_input_price_diff_30d,
            ROUND(COALESCE(cp.output_price_per_1m - pp.output_price_per_1m, 0.0), 6) AS output_price_diff_30d,
            ROUND(COALESCE(cp.cached_price_per_1m - pp.cached_price_per_1m, 0.0), 6) AS cached_price_diff_30d,
            ROUND(COALESCE(cp.thinking_output_price_per_1m - pp.thinking_output_price_per_1m, 0.0), 6) AS thinking_output_price_diff_30d,
            ROUND(COALESCE(cp.image_price - pp.image_price, 0.0), 6) AS image_price_diff_30d,
            ROUND(COALESCE(cp.video_price_per_second - pp.video_price_per_second, 0.0), 6) AS video_price_diff_30d

        FROM llm_ranking r
        JOIN providers p ON r.provider_id = p.provider_id
        JOIN llm_models m ON (m.slug = r.model_name OR m.model_id = r.model_name) AND m.provider_id = r.provider_id
        JOIN current_p cp ON m.model_id = cp.model_id
        LEFT JOIN previous_p pp 
            ON cp.model_id = pp.model_id 
           AND cp.processing_tier = pp.processing_tier 
           AND cp.tier_label = pp.tier_label
        WHERE r.category = $1
          AND m.is_active = true 
          AND m.deprecated_at IS NULL
        ORDER BY r.rank, cp.processing_tier;
    """

    async with db.pg_pool.acquire() as conn:
        rows = await conn.fetch(query, category)

    if not rows:
        raise HTTPException(status_code=404, detail=f"No active recommendations found for category: {category}")

    recommendations_dict = {}
    
    for r in rows:
        m_id = r["model_id"]
        provider_name = r["provider_name"]
        
        if m_id not in recommendations_dict:
            live_stat = json.loads(raw_data.get(provider_name, "{}")) if raw_data else {}
            
            recommendations_dict[m_id] = {
                "rank": r["rank"],
                "provider": provider_name,
                "model_id": m_id,
                "model_slug": r["model_slug"] or m_id,
                "model_name": r["model_name"],
                "live_status": live_stat,
                "tiers": []
            }
        
        diffs = {}
        prev_price = None
        has_changed = False
        
        if r["previous_recorded_at"] is not None:
            diffs = {
                "input_price_diff_30d": float(r["input_price_diff_30d"]),
                "cached_input_price_diff_30d": float(r["cached_input_price_diff_30d"]),
                "output_price_diff_30d": float(r["output_price_diff_30d"]),
                "cached_price_diff_30d": float(r["cached_price_diff_30d"]),
                "thinking_output_price_diff_30d": float(r["thinking_output_price_diff_30d"]),
                "image_price_diff_30d": float(r["image_price_diff_30d"]),
                "video_price_diff_30d": float(r["video_price_diff_30d"])
            }
            has_changed = any(val != 0.0 for val in diffs.values())
            
            prev_price = {
                "input_price_per_1m": float(r["previous_input_price"]) if r["previous_input_price"] is not None else None,
                "cached_input_price_per_1m": float(r["previous_cached_input_price"]) if r["previous_cached_input_price"] is not None else None,
                "output_price_per_1m": float(r["previous_output_price"]) if r["previous_output_price"] is not None else None,
                "cached_price_per_1m": float(r["previous_cached_price"]) if r["previous_cached_price"] is not None else None,
                "thinking_output_price_per_1m": float(r["previous_thinking_output_price"]) if r["previous_thinking_output_price"] is not None else None,
                "image_price": float(r["previous_image_price"]) if r["previous_image_price"] is not None else None,
                "video_price_per_second": float(r["previous_video_price"]) if r["previous_video_price"] is not None else None,
                "recorded_at": r["previous_recorded_at"].isoformat() if r["previous_recorded_at"] else None
            }

        if r["processing_tier"] is not None:
            recommendations_dict[m_id]["tiers"].append({
                "processing_tier": r["processing_tier"],
                "tier_label": r["tier_label"],
                "price_unit": r["price_unit"],
                "current_price": {
                    "input_price_per_1m": float(r["current_input_price"]) if r["current_input_price"] is not None else None,
                    "cached_input_price_per_1m": float(r["current_cached_input_price"]) if r["current_cached_input_price"] is not None else None,
                    "output_price_per_1m": float(r["current_output_price"]) if r["current_output_price"] is not None else None,
                    "cached_price_per_1m": float(r["current_cached_price"]) if r["current_cached_price"] is not None else None,
                    "thinking_output_price_per_1m": float(r["current_thinking_output_price"]) if r["current_thinking_output_price"] is not None else None,
                    "image_price": float(r["current_image_price"]) if r["current_image_price"] is not None else None,
                    "video_price_per_second": float(r["current_video_price"]) if r["current_video_price"] is not None else None,
                    "recorded_at": r["current_recorded_at"].isoformat() if r["current_recorded_at"] else None
                },
                "price_change_30d": {
                    "has_changed": has_changed,
                    "trend": r["input_price_trend_30d"],
                    "differences": diffs if diffs else None,
                    "previous_price": prev_price
                }
            })

    final_recommendations = sorted(list(recommendations_dict.values()), key=lambda x: x["rank"])

    resp = CustomJSONResponse(content={
        "status": "success",
        "category_requested": category,
        "region_evaluated": region,
        "recommendations": final_recommendations
    })
    
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
        
    return resp