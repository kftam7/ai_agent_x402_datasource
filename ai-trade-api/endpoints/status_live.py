import json
from fastapi import APIRouter, Depends
from core.auth import auth_dependency
from core.responses import CustomJSONResponse
from core import db

router = APIRouter(prefix="/v1", tags=["Router"])

@router.get("/status/live")
async def get_live_status(
    region: str = "us-east", 
    provider: str = None, 
    auth=Depends(auth_dependency)
):
    if provider:
        # Bypass Redis and fetch the last 10 provider records directly from PostgreSQL
        query = """
            SELECT * FROM llm_probes 
            WHERE provider = $1 
            ORDER BY "timestamp" DESC 
            LIMIT 10;
        """
        # Execute query using the correct asyncpg pool syntax
        async with db.pg_pool.acquire() as conn:
            rows = await conn.fetch(query, provider)
        
        # Convert asyncpg Record objects to dicts and serialize datetime objects
        results = [dict(row) for row in rows]
        for row in results:
            if row.get("timestamp"):
                row["timestamp"] = row["timestamp"].isoformat()
    else:
        # Fallback to existing Redis logic for overall regional live status
        raw_data = await db.redis_client.hgetall(f"live_provider_status:{region}")
        
        if not raw_data:
            raw_data = await db.redis_client.hgetall("live_provider_status:tokyo")
            
        results = {provider_name: json.loads(data) for provider_name, data in raw_data.items()}
    
    resp = CustomJSONResponse(content={
        "status": "success", 
        "count": len(results), 
        "region": region,
        "provider": provider,
        "data": results
    })
    
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
        
    return resp