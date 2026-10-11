import json
from fastapi import APIRouter, Depends
from core.auth import auth_dependency
from core.responses import CustomJSONResponse
from core import db

router = APIRouter(tags=["Prices"])

@router.get("/v1/prices/realtime")
async def get_realtime_prices(auth=Depends(auth_dependency)):
    query = """
        WITH ranked_prices AS (
            SELECT 
                h.model_id, h.processing_tier, h.tier_label, h.price_unit,
                h.input_price_per_1m, h.cached_input_price_per_1m,
                h.output_price_per_1m, h.recorded_at,
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
            cp.input_price_per_1m AS current_input_price,
            cp.cached_input_price_per_1m AS current_cached_input_price,
            cp.output_price_per_1m AS current_output_price,
            cp.recorded_at AS current_recorded_at,
            pp.input_price_per_1m AS previous_input_price,
            pp.output_price_per_1m AS previous_output_price,
            pp.recorded_at AS previous_recorded_at,
            CASE 
                WHEN pp.input_price_per_1m IS NULL THEN 'UNCHANGED'
                WHEN cp.input_price_per_1m < pp.input_price_per_1m THEN 'DECREASED'
                WHEN cp.input_price_per_1m > pp.input_price_per_1m THEN 'INCREASED'
                ELSE 'UNCHANGED'
            END AS input_price_trend_30d,
            ROUND(COALESCE(cp.input_price_per_1m - pp.input_price_per_1m, 0.0), 6) AS input_price_diff_30d
        FROM current_p cp
        JOIN llm_models m ON cp.model_id = m.model_id
        LEFT JOIN providers p ON m.provider_id = p.provider_id
        LEFT JOIN previous_p pp 
            ON cp.model_id = pp.model_id 
           AND cp.processing_tier = pp.processing_tier 
           AND cp.tier_label = pp.tier_label
        ORDER BY m.display_name, cp.processing_tier;
    """

    async with db.pg_pool.acquire() as conn:
        rows = await conn.fetch(query)

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
        
        models_dict[m_id]["tiers"].append({
            "processing_tier": r["processing_tier"],
            "tier_label": r["tier_label"],
            "price_unit": r["price_unit"],
            "current_price": {
                "input_per_1m": float(r["current_input_price"]) if r["current_input_price"] is not None else None,
                "cached_input_per_1m": float(r["current_cached_input_price"]) if r["current_cached_input_price"] is not None else None,
                "output_per_1m": float(r["current_output_price"]) if r["current_output_price"] is not None else None,
                "recorded_at": r["current_recorded_at"].isoformat() if r["current_recorded_at"] else None
            },
            "price_change_30d": {
                "has_changed": r["previous_input_price"] is not None and r["input_price_trend_30d"] != 'UNCHANGED',
                "trend": r["input_price_trend_30d"],
                "input_diff_30d": float(r["input_price_diff_30d"]),
                "previous_price": {
                    "input_per_1m": float(r["previous_input_price"]) if r["previous_input_price"] is not None else None,
                    "output_per_1m": float(r["previous_output_price"]) if r["previous_output_price"] is not None else None,
                    "recorded_at": r["previous_recorded_at"].isoformat() if r["previous_recorded_at"] else None
                } if r["previous_input_price"] is not None else None
            }
        })

    resp_data = list(models_dict.values())
    resp = CustomJSONResponse(content={"status": "success", "count": len(resp_data), "data": resp_data})
    
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
    return resp