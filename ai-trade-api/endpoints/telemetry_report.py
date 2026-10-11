import json
from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel
from core import db
import config

router = APIRouter(tags=["System & Telemetry"])

class TelemetryPayload(BaseModel):
    region: str
    model_id: str
    provider: str
    status_code: int
    ttft_ms: float
    tokens_per_sec: float
    error_type: str = "none"

@router.post("/v1/telemetry/report")
async def report_telemetry(payload: TelemetryPayload, x_worker_secret: str = Header(None)):
    if x_worker_secret != config.WORKER_SECRET:
        raise HTTPException(status_code=403, detail="Invalid worker secret")

    snapshot = {
        "status": payload.status_code,
        "ttft_ms": payload.ttft_ms,
        "tps": payload.tokens_per_sec,
        "error": payload.error_type,
        "region": payload.region
    }

    # Update Redis cache
    redis_key = f"live_llm_status:{payload.region}"
    await db.redis_client.hset(redis_key, payload.model_id, json.dumps(snapshot))

    # Persist metrics to Postgres
    async with db.pg_pool.acquire() as conn:
        await conn.execute(
            "INSERT INTO llm_models (model_id, provider, display_name) VALUES ($1, $2, $3) ON CONFLICT DO NOTHING;",
            payload.model_id, payload.provider, payload.model_id
        )
        await conn.execute(
            """
            INSERT INTO llm_probes (model_id, region, status_code, ttft_ms, tokens_per_sec, error_type)
            VALUES ($1, $2, $3, $4, $5, $6);
            """,
            payload.model_id, payload.region, payload.status_code, 
            payload.ttft_ms, payload.tokens_per_sec, payload.error_type
        )
    return {"status": "accepted"}