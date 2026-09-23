import asyncio
import time
import json
import os
import httpx
import asyncpg
import redis
from datetime import datetime, timezone
from dotenv import load_dotenv

# Load variables from .env file into os.environ
load_dotenv()

# --- CONFIGURATION ---
REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://trade_app:LocalTest123@localhost:5432/ai_trade")

# Setup Redis Client
REDIS = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=0, decode_responses=True)

# Target configurations for the daily price scraper
#TARGET_PROVIDERS = ["deepseek", "qwen", "moonshot", "kimi", "glm", "minimax"]
#TARGET_PROVIDERS = ["deepseek", "moonshot", "qwen", "glm"]
TARGET_PROVIDERS = ["deepseek", "qwen", "moonshot", "kimi", "glm", "minimax", "xiaomi", "mimo"]

# Live probe endpoints for high-frequency latency testing
TARGET_PROBE_MODELS = [
    {
        "id": "deepseek/deepseek-chat", 
        "provider": "DeepSeek", 
        "endpoint": "https://api.deepseek.com/v1/chat/completions", 
        "api_key": os.getenv("DEEPSEEK_KEY", "")
    },
    {
        "id": "qwen/qwen-max", 
        "provider": "Alibaba", 
        "endpoint": "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions", 
        "api_key": os.getenv("QWEN_KEY", "")
    },
    {
        "id": "moonshot/kimi-k2.7-code", 
        "provider": "Moonshot", 
        "endpoint": "https://api.moonshot.cn/v1/chat/completions", 
        "api_key": os.getenv("KIMI_KEY", "")
    },
    {
        "id": "zhipu/glm-5.3-flash", 
        "provider": "Zhipu", 
        "endpoint": "https://open.bigmodel.cn/api/paas/v4/chat/completions", 
        "api_key": os.getenv("GLM_KEY", "")
    },
    {
        "id": "xiaomi/mimo-v2.6-pro", 
        "provider": "Xiaomi", 
        "endpoint": "https://api.xiaomimimo.com/v1/chat/completions", 
        "api_key": os.getenv("MIMO_KEY", "")
    }    
]

# --- 1. DAILY PRICE SCRAPER ---
async def scrape_and_store_prices(pg_pool: asyncpg.Pool):
    """Fetches global pricing from LiteLLM and updates the DB if prices changed."""
    url = "https://raw.githubusercontent.com/BerriAI/litellm/main/model_prices_and_context_window.json"
    print(f"[{datetime.now(timezone.utc).isoformat()}] Starting daily price scrape...")
    
    async with httpx.AsyncClient(timeout=15.0) as client:
        try:
            res = await client.get(url)
            res.raise_for_status()
            data = res.json()
        except Exception as e:
            print(f"Failed to fetch pricing data: {e}")
            return
        
        async with pg_pool.acquire() as conn:
            processed = 0
            for model_id, info in data.items():
                if any(kw in model_id.lower() for kw in TARGET_PROVIDERS):
                    
                    # LiteLLM prices are per 1 token. Convert to per 1 Million.
                    in_cost = float((info.get("input_cost_per_token") or 0)) * 1_000_000
                    out_cost = float((info.get("output_cost_per_token") or 0)) * 1_000_000
                    cached_cost = float((info.get("cache_read_input_token_cost") or 0)) * 1_000_000
                    
                    provider_name = model_id.split('/')[0].capitalize() if '/' in model_id else "Chinese AI"
                    
                    # 1. Register the model (Idempotent - ignores if already exists)
                    await conn.execute(
                        "INSERT INTO llm_models (model_id, provider, display_name) VALUES ($1, $2, $3) ON CONFLICT DO NOTHING",
                        model_id, provider_name, model_id
                    )
                    
                    # 2. Diff Check: Fetch the latest recorded price to avoid DB bloat
                    latest_price = await conn.fetchrow(
                        "SELECT input_price_per_1m, output_price_per_1m, cached_price_per_1m FROM llm_prices WHERE model_id = $1 ORDER BY recorded_at DESC LIMIT 1",
                        model_id
                    )
                    
                    is_new = not latest_price
                    price_changed = False
                    
                    if not is_new:
                        price_changed = (
                            float(latest_price["input_price_per_1m"]) != in_cost or 
                            float(latest_price["output_price_per_1m"]) != out_cost or
                            float(latest_price["cached_price_per_1m"]) != cached_cost
                        )
                        
                    # 3. Only insert a new time-series row if it's a new model or the price shifted
                    if is_new or price_changed:
                        await conn.execute(
                            "INSERT INTO llm_prices (model_id, input_price_per_1m, output_price_per_1m, cached_price_per_1m) VALUES ($1, $2, $3, $4)",
                            model_id, in_cost, out_cost, cached_cost
                        )
                        processed += 1
                        
            print(f"[{datetime.now(timezone.utc).isoformat()}] Scrape complete. Recorded {processed} price shifts.")

# --- 2. LIVE SYNTHETIC PROBE WORKER ---
async def probe_llm_service(client: httpx.AsyncClient, pg_pool: asyncpg.Pool, model: dict, region: str = "us-east"):
    """Pings a single LLM to measure TTFT and TPS, updating Redis and Postgres."""
    headers = {
        "Authorization": f"Bearer {model.get('api_key', '')}",
        "Content-Type": "application/json"
    }
    
    # Strip the routing prefix (e.g., 'deepseek/') for the actual API payload
    raw_model_name = model["id"].split('/')[-1] if '/' in model["id"] else model["id"]
    
    payload = {
        "model": raw_model_name, 
        "messages": [{"role": "user", "content": "Say 'hello' in one word."}], 
        "max_tokens": 5, 
        "stream": True
    }
    
    start = time.perf_counter()
    ttft_ms = None
    tokens = 0
    status_code = 500
    error_type = None

    try:
        async with client.stream("POST", model["endpoint"], headers=headers, json=payload) as resp:
            status_code = resp.status_code
            resp.raise_for_status()
            async for chunk in resp.aiter_text():
                if not chunk.strip(): 
                    continue
                if ttft_ms is None:
                    ttft_ms = int((time.perf_counter() - start) * 1000)
                tokens += 1
                
        total_time = time.perf_counter() - start
        gen_time = total_time - (ttft_ms / 1000)
        tps = round(tokens / gen_time, 2) if gen_time > 0 else 0.0
    except httpx.HTTPStatusError as e:
        status_code = e.response.status_code
        error_type = f"HTTP_{status_code}"
    except Exception as e:
        status_code = 0
        error_type = "NETWORK_ERROR"

    ttft_ms = ttft_ms or 0
    tps = tps if 'tps' in locals() else 0.0

    # 1. Write to Redis Hash for instant /v1/status/live API reads
    snapshot = {
        "status": status_code,
        "ttft_ms": ttft_ms,
        "tps": tps,
        "region": region,
        "error": error_type,
        "updated_at": datetime.now(timezone.utc).isoformat()
    }
    REDIS.hset("live_llm_status", model["id"], json.dumps(snapshot))

    # 2. Record historical row in PostgreSQL for the /v1/latency/heatmap
    async with pg_pool.acquire() as conn:
        # Ensure model exists in llm_models catalog to satisfy FK constraint
        await conn.execute(
            """
            INSERT INTO llm_models (model_id, provider, display_name) 
            VALUES ($1, $2, $3) 
            ON CONFLICT (model_id) DO NOTHING
            """,
            model["id"], model["provider"], model["id"]
        )

        # Record telemetry probe
        await conn.execute(
            """
            INSERT INTO llm_probes (model_id, region, status_code, ttft_ms, tokens_per_sec, error_type) 
            VALUES ($1, $2, $3, $4, $5, $6)
            """,
            model["id"], region, status_code, ttft_ms, tps, error_type
        )
    print(f"Ping {model['id']:<25} | TTFT: {ttft_ms}ms | TPS: {tps:<6} | Status: {status_code}")

# --- 3. ORCHESTRATION LOOPS ---
async def price_scraper_loop(pg_pool: asyncpg.Pool):
    """Runs the price scraper once every 24 hours."""
    while True:
        await scrape_and_store_prices(pg_pool)
        await asyncio.sleep(86400) # Sleep for 24 hours

async def probe_worker_loop(pg_pool: asyncpg.Pool):
    """Runs the live synthetic probes every 45 seconds."""
    current_region = os.getenv("WORKER_REGION", "us-east")
    
    async with httpx.AsyncClient(timeout=15.0) as client:
        while True:
            tasks = [probe_llm_service(client, pg_pool, model, region=current_region) for model in TARGET_PROBE_MODELS]
            await asyncio.gather(*tasks)
            await asyncio.sleep(45)

async def main():
    print("Starting x402 Monitoring Workers...")
    pg_pool = await asyncpg.create_pool(DATABASE_URL)
    
    # Run both the 24h loop and the 45s loop concurrently
    await asyncio.gather(
        price_scraper_loop(pg_pool),
        probe_worker_loop(pg_pool)
    )

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nMonitoring Workers shut down successfully.")