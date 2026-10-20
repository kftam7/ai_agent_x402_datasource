import json
from typing import Optional
from fastapi import APIRouter, Depends, Query, HTTPException
from core.auth import auth_dependency
from core.responses import CustomJSONResponse
from core import db

router = APIRouter(tags=["Prices"])

@router.get("/v1/prices/realtime")
async def get_realtime_prices(
    provider: Optional[str] = Query(None, description="Filter by provider name (case-insensitive)"),
    model_type: Optional[str] = Query(None, description="Filter by model type: general, image, or video"),
    auth=Depends(auth_dependency)
):
    # Validate model_type if provided
    if model_type:
        model_type = model_type.lower()
        if model_type not in ["general", "image", "video"]:
            raise HTTPException(status_code=400, detail="model_type must be one of: general, image, video")

    # Build dynamic WHERE clause safely using parameterized queries
    conditions = ["m.deprecated_at IS NULL"]
    args = []
    param_idx = 1
    
    if provider:
        conditions.append(f"p.name ILIKE ${param_idx}")
        args.append(provider)
        param_idx += 1
    else:
        # Default fallback if provider is not explicitly requested
        conditions.append("m.provider_id IN (4, 5, 15, 17, 18, 19)")
        
    if model_type == "image":
        conditions.append("cp.image_price IS NOT NULL")
    elif model_type == "video":
        conditions.append("cp.video_price_per_second IS NOT NULL")
    elif model_type == "general":
        conditions.append("(cp.image_price IS NULL AND cp.video_price_per_second IS NULL)")
        
    where_clause = " WHERE " + " AND ".join(conditions)

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
                ) as rn
            FROM llm_prices h
            WHERE h.recorded_at >= NOW() - INTERVAL '30 days'
        ),
        current_p AS (SELECT * FROM ranked_prices WHERE rn = 1),
        previous_p AS (SELECT * FROM ranked_prices WHERE rn = 2)
        SELECT 
            m.model_id, m.slug AS model_slug, m.display_name AS model_name, p.name AS provider_name,
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

        FROM current_p cp
        JOIN llm_models m ON cp.model_id = m.model_id
        LEFT JOIN providers p ON m.provider_id = p.provider_id
        LEFT JOIN previous_p pp 
            ON cp.model_id = pp.model_id 
           AND cp.processing_tier = pp.processing_tier 
           AND cp.tier_label = pp.tier_label
        {where_clause}
        ORDER BY m.display_name, cp.processing_tier;
    """

    async with db.pg_pool.acquire() as conn:
        rows = await conn.fetch(query, *args)

    models_dict = {}
    for r in rows:
        m_id = r["model_id"]
        if m_id not in models_dict:
            models_dict[m_id] = {
                "model_id": m_id,
                "model_slug": r["model_slug"] or m_id,
                "model_name": r["model_name"],
                "provider": r["provider_name"],
                "tiers": []
            }
        
        # Determine differences and change status
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
            # True if ANY of the prices changed
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

        models_dict[m_id]["tiers"].append({
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

    resp_data = list(models_dict.values())
    resp = CustomJSONResponse(content={"status": "success", "count": len(resp_data), "data": resp_data})
    
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
    return resp