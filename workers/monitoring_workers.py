import asyncio
import time
import os
import httpx
from datetime import datetime, timezone
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# --- CENTRAL GATEWAY CONFIGURATION ---
CENTRAL_API_URL = os.getenv("CENTRAL_API_URL", "http://localhost:8000/v1/telemetry/report")
WORKER_SECRET = os.getenv("WORKER_SECRET", "your-internal-worker-secret-key")
WORKER_REGION = os.getenv("WORKER_REGION", "us-east")

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
        "api_key": os.getenv("MIMO_KEY", os.getenv("XIAOMI_KEY", ""))
    }    
]

# --- LIVE SYNTHETIC PROBE WORKER ---
async def probe_llm_service(client: httpx.AsyncClient, model: dict, region: str = "us-east"):
    """Pings an LLM endpoint and posts latency telemetry to the central API gateway via HTTP."""
    headers = {
        "Authorization": f"Bearer {model.get('api_key', '')}",
        "Content-Type": "application/json"
    }
    
    # Strip the routing prefix (e.g., 'deepseek/') for the provider payload
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
        gen_time = total_time - (ttft_ms / 1000 if ttft_ms else 0)
        tps = round(tokens / gen_time, 2) if gen_time > 0 else 0.0
    except httpx.HTTPStatusError as e:
        status_code = e.response.status_code
        error_type = f"HTTP_{status_code}"
    except Exception as e:
        status_code = 0
        error_type = "NETWORK_ERROR"

    ttft_ms = float(ttft_ms or 0)
    tps = float(tps if 'tps' in locals() else 0.0)

    # Prepare HTTP Telemetry Payload matching main.py's TelemetryPayload model
    telemetry_payload = {
        "region": region,
        "model_id": model["id"],
        "provider": model["provider"],
        "status_code": status_code,
        "ttft_ms": ttft_ms,
        "tokens_per_sec": tps,
        "error_type": error_type or "none"
    }

    # Transmit telemetry via HTTP POST to the central API gateway
    report_headers = {
        "X-Worker-Secret": WORKER_SECRET,
        "Content-Type": "application/json"
    }

    try:
        report_resp = await client.post(CENTRAL_API_URL, json=telemetry_payload, headers=report_headers)
        report_resp.raise_for_status()
        print(f"[{region}] Ping {model['id']:<25} | TTFT: {ttft_ms}ms | TPS: {tps:<6} | Status: {status_code} -> Reported OK")
    except Exception as e:
        print(f"⚠️ [{region}] Failed to transmit telemetry for {model['id']}: {e}")

# --- ORCHESTRATION LOOP ---
async def probe_worker_loop():
    """Continuously runs live synthetic probes and posts results every 45 seconds."""
    current_region = WORKER_REGION
    print(f"🚀 Starting HTTP Telemetry Worker in region: [{current_region}]")
    print(f"📡 Target Central Gateway: {CENTRAL_API_URL}")
    
    async with httpx.AsyncClient(timeout=15.0) as client:
        while True:
            tasks = [probe_llm_service(client, model, region=current_region) for model in TARGET_PROBE_MODELS]
            await asyncio.gather(*tasks)
            await asyncio.sleep(45)

async def main():
    await probe_worker_loop()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nMonitoring Worker shut down successfully.")