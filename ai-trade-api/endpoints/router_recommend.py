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
    # Normalize category input
    category = category.lower()
    valid_categories = ["general", "image", "video"]
    
    if category not in valid_categories:
        raise HTTPException(
            status_code=400, 
            detail=f"Invalid category. Supported categories are: {', '.join(valid_categories)}"
        )

    # Fetch live telemetry metrics from Redis using the new provider-based keys
    raw_data = await db.redis_client.hgetall(f"live_provider_status:{region}")
    if not raw_data:
        # Fallback to alternative region if cache is empty
        raw_data = await db.redis_client.hgetall("live_provider_status:tokyo")

    # Dynamic pricing filter based on category to match `prices_realtime.py` logic
    pricing_filter = ""
    if category == "image":
        pricing_filter = "AND cp.image_price IS NOT NULL"
    elif category == "video":
        pricing_filter = "AND cp.video_price_per_second IS NOT NULL"
    elif category == "general":
        pricing_filter = "AND cp.image_price IS NULL AND cp.video_price_per_second IS NULL"

    # SQL query: Ranks models by category, extracts the latest active model per provider 
    # that MATCHES the category criteria (using MAX model_id to break ties), 
    # ensures deprecated_at is null, and fetches their current and previous 30-day prices.
    query = f"""
        WITH ranked_prices AS (
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
        current_p AS (SELECT * FROM ranked_prices WHERE prn = 1),
        previous_p AS (SELECT * FROM ranked_prices WHERE prn = 2),
        
        -- Apply the category filter FIRST so MAX(model_id) only picks from valid models
        -- Use DISTINCT to avoid duplicating models that have multiple pricing tiers
        filtered_models AS (
            SELECT DISTINCT m.model_id, m.provider_id, m.slug, m.display_name
            FROM llm_models m
            JOIN current_p cp ON m.model_id = cp.model_id
            WHERE m.is_active = true 
              AND m.deprecated_at IS NULL
              {pricing_filter}
        ),
        latest_provider_model AS (
            SELECT provider_id, MAX(model_id) as latest_model_id
            FROM filtered_models
            GROUP BY provider_id
        )
        
        SELECT 
            r.rank,
            p.name AS provider_name,
            fm.model_id,
            fm.slug AS model_slug,
            fm.display_name AS model_name,
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
                WHEN pp.input_price_per_1m IS NULL THEN 'UNCHANGED'
                WHEN cp.input_price_per_1m < pp.input_price_per_1m THEN 'DECREASED'
                WHEN cp.input_price_per_1m > pp.input_price_per_1m THEN 'INCREASED'
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
        JOIN latest_provider_model lpm ON r.provider_id = lpm.provider_id
        JOIN filtered_models fm ON lpm.latest_model_id = fm.model_id
        JOIN current_p cp ON fm.model_id = cp.model_id
        LEFT JOIN previous_p pp 
            ON cp.model_id = pp.model_id 
           AND cp.processing_tier = pp.processing_tier 
           AND cp.tier_label = pp.tier_label
        WHERE r.category = $1
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
        
        # Initialize the model's group if it's the first time we see it
        if m_id not in recommendations_dict:
            # Parse live status from Redis telemetry payload matching the provider name
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
        
        # Calculate price differences and change boolean flag
        diffs = {}
        prev_price = None
        has_changed = False
        
        if r["previous_input_price"] is not None:
            diffs = {
                "input_price_diff_30d": float(r["input_price_diff_30d"]),
                "cached_input_price_diff_30d": float(r["cached_input_price_diff_30d"]),
                "output_price_diff_30d": float(r["output_price_diff_30d"]),
                "cached_price_diff_30d": float(r["cached_price_diff_30d"]),
                "thinking_output_price_diff_30d": float(r["thinking_output_price_diff_30d"]),
                "image_price_diff_30d": float(r["image_price_diff_30d"]),
                "video_price_diff_30d": float(r["video_price_diff_30d"])
            }
            # True if ANY of the prices changed over 30 days
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

        # Append specific tier pricing to the model
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

    # Sort the dictionary strictly by the database rank
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