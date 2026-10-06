import os
import json
import base64
import httpx
from decimal import Decimal
from datetime import datetime
from typing import Any
from contextlib import asynccontextmanager
import requests
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Request, Header, Depends
from fastapi.responses import JSONResponse, StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from pydantic import BaseModel
import psycopg2
from psycopg2.extras import RealDictCursor
import redis.asyncio as redis
import asyncpg
from cdp.x402 import create_facilitator_config

load_dotenv()

# --- CONFIGURATION ---
REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://trade_app:LocalTest123@localhost:5432/ai_trade")
WORKER_SECRET = os.getenv("WORKER_SECRET", "your-internal-worker-secret-key")

# LLM Endpoint & Key Mappings
MODEL_CONFIG = {
    "deepseek/deepseek-chat": {
        "url": "https://api.deepseek.com/v1/chat/completions",
        "key": os.getenv("DEEPSEEK_KEY"),
        "provider_model": "deepseek-chat",
        "categories": ["coding", "math", "general"]
    },
    "qwen/qwen-max": {
        "url": "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
        "key": os.getenv("QWEN_KEY"),
        "provider_model": "qwen-max",
        "categories": ["general", "math", "coding"]
    },
    "moonshot/kimi-k2.7-code": {
        "url": "https://api.moonshot.cn/v1/chat/completions",
        "key": os.getenv("KIMI_KEY"),
        "provider_model": "kimi-k2.7-code",
        "categories": ["coding"]
    },
    "zhipu/glm-5.3-flash": {
        "url": "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        "key": os.getenv("GLM_KEY"),
        "provider_model": "glm-5.3-flash",
        "categories": ["general"]
    },
    "minimax/MiniMax-M3": {
        "url": "https://api.minimax.io/v1/chat/completions",
        "key": os.getenv("MINIMAX_KEY"),
        "provider_model": "MiniMax-M3",
        "categories": ["general", "math"]
    },
    "xiaomi/mimo-v2.6-flash": {
        "url": "https://api.mimo.mi.com/v1/chat/completions",
        "key": os.getenv("XIAOMI_KEY"),
        "provider_model": "mimo-v2.6-flash",
        "categories": ["math", "coding"]
    }
}

# Async Connection Pools
pg_pool = None
redis_client = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    global pg_pool, redis_client
    pg_pool = await asyncpg.create_pool(DATABASE_URL)
    redis_client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=0, decode_responses=True)
    print("🚀 Connection pools to PostgreSQL and Redis established.", flush=True)
    yield
    await pg_pool.close()
    await redis_client.close()
    print("🛑 Connection pools closed.", flush=True)

app = FastAPI(title="AI Trade Data & x402 LLM Inference Gateway", lifespan=lifespan)

# Rate limiter & CORS
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Custom JSON encoder
class DecimalDatetimeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)

class CustomJSONResponse(JSONResponse):
    def render(self, content: Any) -> bytes:
        return json.dumps(content, cls=DecimalDatetimeEncoder, ensure_ascii=True).encode("utf-8")

# --- DATABASE (Sync Helper for Auth Audit) ---
def get_db_conn():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
    )

# --- X402 / CDP CONFIGURATION ---
CDP_API_KEY_ID = os.getenv("CDP_API_KEY_ID") or os.getenv("COINBASE_API_KEY_ID") or ""
CDP_API_KEY_SECRET = os.getenv("CDP_API_KEY_SECRET") or os.getenv("COINBASE_API_SECRET") or ""
X402_ENABLED = os.getenv("X402_ENABLED", "False").lower() == "true"
X402_WALLET_ADDRESS = os.getenv("X402_WALLET_ADDRESS", "")
X402_NETWORK_CAIP2 = os.getenv("X402_NETWORK_CAIP2", "eip155:84532")
X402_ASSET_CONTRACT = os.getenv("X402_ASSET_CONTRACT", "")
X402_AMOUNT_ATOMIC = os.getenv("X402_AMOUNT_ATOMIC", "")
X402_ASSET_NAME = os.getenv("X402_ASSET_NAME", "USDC")
X402_ASSET_VERSION = os.getenv("X402_ASSET_VERSION", "2")
X402_MAX_TIMEOUT = int(os.getenv("X402_MAX_TIMEOUT_SECONDS", "60"))
X402_PROTOCOL_VERSION = int(os.getenv("X402_PROTOCOL_VERSION", "2"))

_facilitator_cfg = create_facilitator_config(
    api_key_id=CDP_API_KEY_ID or None,
    api_key_secret=CDP_API_KEY_SECRET or None,
)
X402_FACILITATOR_URL = _facilitator_cfg["url"]
_create_x402_headers = _facilitator_cfg["create_headers"]

# --- X402 HELPERS & AUDIT ---
def get_payment_requirements() -> dict[str, Any]:
    req: dict[str, Any] = {
        "scheme": "exact",
        "network": X402_NETWORK_CAIP2,
        "asset": X402_ASSET_CONTRACT,
        "amount": str(X402_AMOUNT_ATOMIC),
        "payTo": X402_WALLET_ADDRESS,
        "maxTimeoutSeconds": X402_MAX_TIMEOUT,
    }
    if X402_PROTOCOL_VERSION >= 2:
        req["extra"] = {"name": X402_ASSET_NAME, "version": X402_ASSET_VERSION}
    return req

def get_x402_challenge_payload(resource_url: str) -> dict[str, Any]:
    accepts = get_payment_requirements()
    if X402_PROTOCOL_VERSION >= 2:
        return {
            "x402Version": 2,
            "error": "Payment required",
            "accepts": [accepts],
            "resource": {
                "url": resource_url,
                "description": "AI Trade & LLM Gateway Data, pay-per-call via x402",
                "mimeType": "application/json",
            },
        }
    return {
        "x402Version": 1,
        "resource": {
            "url": resource_url,
            "description": "AI Trade & LLM Gateway Data, pay-per-call via x402",
            "mimeType": "application/json",
        },
        "accepts": [accepts],
    }

def decode_payment_header(raw: str) -> dict[str, Any]:
    raw = raw.strip()
    try:
        padded = raw + "=" * (-len(raw) % 4)
        decoded = base64.b64decode(padded).decode("utf-8")
        return json.loads(decoded)
    except Exception:
        pass
    try:
        return json.loads(raw)
    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid payment header: not base64 JSON or JSON ({e})",
        )

def audit_payment(
    request_path: str,
    payment_header: str,
    network_caip2: str,
    asset_contract: str,
    amount_atomic: str,
    wallet_payto: str,
    verify_success: bool,
    settle_success: bool = False,
    settle_tx_hash: str | None = None,
    settle_error: str | None = None,
):
    conn = get_db_conn()
    cur = conn.cursor()
    try:
        cur.execute(
            """
            INSERT INTO x402_payment_audit
            (request_path, payment_header, network_caip2, asset_contract, amount_atomic,
             wallet_payto, verify_success, settle_success, settle_tx_hash, settle_error)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """,
            (
                request_path,
                payment_header,
                network_caip2,
                asset_contract,
                amount_atomic,
                wallet_payto,
                verify_success,
                settle_success,
                settle_tx_hash,
                settle_error,
            ),
        )
        conn.commit()
    finally:
        cur.close()
        conn.close()

def verify_and_settle_x402_payment(payment_header_raw: str, request_path: str):
    if not X402_ENABLED:
        return True, None
    required = [
        CDP_API_KEY_ID, CDP_API_KEY_SECRET, X402_WALLET_ADDRESS,
        X402_NETWORK_CAIP2, X402_ASSET_CONTRACT, X402_AMOUNT_ATOMIC,
    ]
    if not all(required):
        raise HTTPException(status_code=503, detail="X402 configuration incomplete on server")
        
    payment_payload = decode_payment_header(payment_header_raw)
    payment_requirements = get_payment_requirements()
    
    if "x402Version" not in payment_payload:
        payment_payload = {**payment_payload, "x402Version": X402_PROTOCOL_VERSION}
        
    body = {
        "x402Version": payment_payload.get("x402Version", X402_PROTOCOL_VERSION),
        "paymentPayload": payment_payload,
        "paymentRequirements": payment_requirements,
    }
    
    op_headers = _create_x402_headers()
    settle_tx_hash = None
    settle_ok = False
    
    try:
        # /verify
        resp_verify = requests.post(
            f"{X402_FACILITATOR_URL}/verify",
            json=body,
            headers=op_headers["verify"],
            timeout=12,
        )
        if resp_verify.status_code == 401:
            audit_payment(request_path, payment_header_raw, X402_NETWORK_CAIP2, X402_ASSET_CONTRACT, X402_AMOUNT_ATOMIC, X402_WALLET_ADDRESS, False)
            raise HTTPException(status_code=503, detail="X402 facilitator auth failed (401).")
            
        data_verify = resp_verify.json() if resp_verify.text else {}
        is_valid = data_verify.get("isValid", data_verify.get("valid", False))
        
        if resp_verify.status_code >= 400 or not is_valid:
            audit_payment(request_path, payment_header_raw, X402_NETWORK_CAIP2, X402_ASSET_CONTRACT, X402_AMOUNT_ATOMIC, X402_WALLET_ADDRESS, False)
            reason = data_verify.get("invalidReason") or data_verify.get("errorMessage") or resp_verify.text
            raise HTTPException(status_code=402, detail=f"X402 payment invalid: {reason}")
            
        # /settle
        resp_settle = requests.post(
            f"{X402_FACILITATOR_URL}/settle",
            json=body,
            headers=op_headers["settle"],
            timeout=30,
        )
        if resp_settle.status_code == 401:
            audit_payment(request_path, payment_header_raw, X402_NETWORK_CAIP2, X402_ASSET_CONTRACT, X402_AMOUNT_ATOMIC, X402_WALLET_ADDRESS, True, False)
            raise HTTPException(status_code=503, detail="X402 settle auth failed (401)")
            
        data_settle = resp_settle.json() if resp_settle.text else {}
        settle_ok = bool(data_settle.get("success") or data_settle.get("settled") or data_settle.get("transaction"))
        settle_tx_hash = data_settle.get("transaction") or data_settle.get("tx_hash") or data_settle.get("txHash")
        
        if resp_settle.status_code >= 400 or not settle_ok:
            settle_err_msg = data_settle.get("errorReason") or data_settle.get("errorMessage") or resp_settle.text
            audit_payment(request_path, payment_header_raw, X402_NETWORK_CAIP2, X402_ASSET_CONTRACT, X402_AMOUNT_ATOMIC, X402_WALLET_ADDRESS, True, False, settle_error=settle_err_msg)
            raise HTTPException(status_code=402, detail=f"X402 settle failed: {settle_err_msg}")
            
    except HTTPException:
        raise
    except Exception as e:
        audit_payment(request_path, payment_header_raw, X402_NETWORK_CAIP2, X402_ASSET_CONTRACT, X402_AMOUNT_ATOMIC, X402_WALLET_ADDRESS, False, settle_error=str(e))
        raise HTTPException(status_code=503, detail=f"X402 error: {str(e)}")

    audit_payment(request_path, payment_header_raw, X402_NETWORK_CAIP2, X402_ASSET_CONTRACT, X402_AMOUNT_ATOMIC, X402_WALLET_ADDRESS, True, settle_ok, settle_tx_hash)
    return True, settle_tx_hash

def validate_api_key(api_key: str):
    conn = get_db_conn()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        cur.execute("SELECT is_active FROM subscriber_api_keys WHERE api_key = %s AND is_active = true", (api_key,))
        row = cur.fetchone()
    finally:
        cur.close()
        conn.close()
    if row is None:
        raise HTTPException(status_code=401, detail="Invalid or inactive api key")
    return row

async def auth_dependency(
    request: Request,
    x_api_key: str | None = Header(default=None, alias="X-API-Key"),
    payment_signature: str | None = Header(default=None, alias="PAYMENT-SIGNATURE"),
    x_payment: str | None = Header(default=None, alias="X-PAYMENT"),
    x402: str | None = Header(default=None, alias="x402"),
):
    if x_api_key is not None:
        validate_api_key(x_api_key)
        return {"is_x402": False, "tx_hash": None}
        
    payment_header = payment_signature or x_payment or x402
    if X402_ENABLED and payment_header is not None:
        is_valid, tx_hash = verify_and_settle_x402_payment(payment_header, str(request.url))
        if is_valid:
            return {"is_x402": True, "tx_hash": tx_hash}
        raise HTTPException(status_code=402, detail="X402 payment invalid or not settled")
        
    challenge = get_x402_challenge_payload(str(request.url))
    try:
        pr_b64 = base64.b64encode(json.dumps(challenge).encode()).decode()
    except Exception:
        pr_b64 = None
    headers = {}
    if pr_b64:
        headers["PAYMENT-REQUIRED"] = pr_b64
    raise HTTPException(status_code=402, detail=challenge, headers=headers)

# --- PHOENIX TELEMETRY MODEL ---
class TelemetryPayload(BaseModel):
    region: str
    model_id: str
    provider: str
    status_code: int
    ttft_ms: float
    tokens_per_sec: float
    error_type: str = "none"

# --- SYSTEM & TELEMETRY ROUTES ---

@app.get("/health")
async def health_check():
    return {
        "status": "ok",
        "x402_enabled": X402_ENABLED,
        "facilitator_url": X402_FACILITATOR_URL,
        "key_id_loaded": bool(CDP_API_KEY_ID),
        "network": X402_NETWORK_CAIP2,
        "protocol_version": X402_PROTOCOL_VERSION,
        "asset_contract": X402_ASSET_CONTRACT
    }

@app.post("/v1/telemetry/report")
async def report_telemetry(payload: TelemetryPayload, x_worker_secret: str = Header(None)):
    """Internal ingestion route for global probe workers."""
    if x_worker_secret != WORKER_SECRET:
        raise HTTPException(status_code=403, detail="Invalid worker secret")

    snapshot = {
        "status": payload.status_code,
        "ttft_ms": payload.ttft_ms,
        "tps": payload.tokens_per_sec,
        "error": payload.error_type,
        "region": payload.region
    }

    # Redis region hash
    redis_key = f"live_llm_status:{payload.region}"
    await redis_client.hset(redis_key, payload.model_id, json.dumps(snapshot))

    # Async PostgreSQL insert
    async with pg_pool.acquire() as conn:
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

# --- HARDWARE TRADE DATA ROUTES (x402 / API Key Protected) ---

@app.get("/ai-trade/monthly")
@limiter.limit("20/minute")
async def get_monthly_data(
    request: Request,
    month: str,
    auth=Depends(auth_dependency),
):
    conn = get_db_conn()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        cur.execute("SELECT * FROM ai_customs_monthly WHERE data_month = %s", (month,))
        record = cur.fetchone()
    finally:
        cur.close()
        conn.close()
    if not record:
        raise HTTPException(status_code=404, detail="No data for given month")
    
    resp = CustomJSONResponse(content={"data": dict(record)})
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
    return resp

# --- LLM TELEMETRY & ROUTING ROUTES (x402 / API Key Protected) ---

@app.get("/v1/status/live")
async def get_live_status(region: str = "us-east", auth=Depends(auth_dependency)):
    raw_data = await redis_client.hgetall(f"live_llm_status:{region}")
    if not raw_data:
        raw_data = await redis_client.hgetall("live_llm_status:tokyo")
        
    results = {m_id: json.loads(data) for m_id, data in raw_data.items()}
    resp = CustomJSONResponse(content={"status": "success", "count": len(results), "region": region, "data": results})
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
    return resp

@app.get("/v1/prices/realtime")
async def get_realtime_prices(auth=Depends(auth_dependency)):
    async with pg_pool.acquire() as conn:
        rows = await conn.fetch("""
            SELECT DISTINCT ON (m.model_id) 
                m.model_id, m.provider, p.input_price_per_1m, p.output_price_per_1m
            FROM llm_models m JOIN llm_prices p ON m.model_id = p.model_id
            ORDER BY m.model_id, p.recorded_at DESC
        """)
        
    resp = CustomJSONResponse(content={"status": "success", "data": [dict(r) for r in rows]})
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
    return resp

@app.get("/v1/router/recommend")
async def recommend_fastest_model(
    category: str = "general",
    region: str = "us-east",
    auth=Depends(auth_dependency)
):
    capable_ids = [m_id for m_id, cfg in MODEL_CONFIG.items() if category in cfg.get("categories", ["general"])]
    if not capable_ids:
        capable_ids = list(MODEL_CONFIG.keys())

    raw_data = await redis_client.hgetall(f"live_llm_status:{region}")
    if not raw_data:
        raw_data = await redis_client.hgetall("live_llm_status:tokyo")

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

# --- THE X402 PROXY ROUTE ---

@app.post("/v1/chat/completions")
async def proxy_chat_completions(request: Request, auth=Depends(auth_dependency)):
    body = await request.json()
    requested_model = body.get("model")
    is_streaming = body.get("stream", False)
    
    region = request.headers.get("X-Agent-Region", "us-east")
    category = request.headers.get("X-Task-Category")

    if requested_model == "auto":
        if not category:
            prompt_text = " ".join([m.get("content", "") for m in body.get("messages", [])]).lower()
            if any(kw in prompt_text for kw in ["def ", "class ", "python", "javascript", "code", "html", "react"]):
                category = "coding"
            elif any(kw in prompt_text for kw in ["math", "equation", "calculate", "integral", "geometry"]):
                category = "math"
            else:
                category = "general"

        capable_ids = [m_id for m_id, cfg in MODEL_CONFIG.items() if category in cfg.get("categories", ["general"])]
        raw_data = await redis_client.hgetall(f"live_llm_status:{region}")
        valid_models = [m for m in capable_ids if m in raw_data and json.loads(raw_data[m]).get("status") == 200]

        if not valid_models:
            valid_models = [m for m, data in raw_data.items() if json.loads(data).get("status") == 200 and m in MODEL_CONFIG]

        if not valid_models:
            raise HTTPException(status_code=503, detail="No healthy models available for auto-routing.")

        requested_model = min(valid_models, key=lambda m: json.loads(raw_data[m]).get("ttft_ms", float('inf')))

    if requested_model not in MODEL_CONFIG:
        raise HTTPException(status_code=400, detail=f"Model '{requested_model}' not supported.")

    config = MODEL_CONFIG[requested_model]
    if not config["key"]:
        raise HTTPException(status_code=500, detail=f"Server missing API key for {requested_model}.")

    body["model"] = config["provider_model"]

    client = httpx.AsyncClient(timeout=60.0)
    req = client.build_request(
        "POST",
        config["url"],
        headers={"Authorization": f"Bearer {config['key']}", "Content-Type": "application/json"},
        json=body
    )

    if is_streaming:
        async def stream_generator():
            try:
                async with client.stream('POST', config["url"], headers=req.headers, json=body) as response:
                    response.raise_for_status()
                    async for chunk in response.aiter_bytes():
                        yield chunk
            except httpx.HTTPStatusError as e:
                yield f"data: {{\"error\": \"Provider Error: {e.response.status_code}\"}}\n\n".encode()
            finally:
                await client.aclose()
                
        return StreamingResponse(stream_generator(), media_type="text/event-stream")
    else:
        try:
            response = await client.send(req)
            response.raise_for_status()
            await client.aclose()
            
            resp = CustomJSONResponse(content=response.json())
            if auth.get("is_x402") and auth.get("tx_hash"):
                resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
            return resp
        except httpx.HTTPStatusError as e:
            await client.aclose()
            raise HTTPException(status_code=e.response.status_code, detail=f"Provider Error: {e.response.text}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)