import json
from fastapi import APIRouter, Depends
from core.auth import auth_dependency
from core.responses import CustomJSONResponse
from core import db

router = APIRouter(prefix="/v1", tags=["Router"])

@router.get("/status/live")
async def get_live_status(region: str = "us-east", auth=Depends(auth_dependency)):
    # Fetch provider-level telemetry from Redis
    raw_data = await db.redis_client.hgetall(f"live_provider_status:{region}")
    
    if not raw_data:
        # Fallback region if empty
        raw_data = await db.redis_client.hgetall("live_provider_status:tokyo")
        
    # Keys are now provider names, not model_ids
    results = {provider_name: json.loads(data) for provider_name, data in raw_data.items()}
    
    resp = CustomJSONResponse(content={"status": "success", "count": len(results), "region": region, "data": results})
    
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
        
    return resp