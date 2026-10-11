import json
from fastapi import APIRouter, HTTPException, Depends
from core.auth import auth_dependency
from core.responses import CustomJSONResponse
from core import db
import config

router = APIRouter(prefix="/v1", tags=["Router"])

@router.get("/router/recommend")
async def recommend_fastest_model(
    category: str = "general",
    region: str = "us-east",
    auth=Depends(auth_dependency)
):
    capable_ids = [m_id for m_id, cfg in config.MODEL_CONFIG.items() if category in cfg.get("categories", ["general"])]
    if not capable_ids:
        capable_ids = list(config.MODEL_CONFIG.keys())

    raw_data = await db.redis_client.hgetall(f"live_llm_status:{region}")
    if not raw_data:
        # Fallback to alternative region
        raw_data = await db.redis_client.hgetall("live_llm_status:tokyo")

    candidates = []
    for model_id in capable_ids:
        if model_id in raw_data:
            snapshot = json.loads(raw_data[model_id])
            if snapshot.get("status") == 200:
                snapshot["model_id"] = model_id
                candidates.append(snapshot)

    if not candidates:
        raise HTTPException(status_code=503, detail="No online models available for this category.")

    best_model = min(candidates, key=lambda x: x.get("ttft_ms", float('inf')))
    
    resp = CustomJSONResponse(content={
        "status": "success",
        "category_requested": category,
        "region_evaluated": region,
        "recommendation": best_model
    })
    
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
    return resp