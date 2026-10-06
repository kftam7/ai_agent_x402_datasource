import asyncio
import time
import os
import httpx
from datetime import datetime, timezone

# --- CONFIGURATION (set these as Lambda Environment Variables) ---
CENTRAL_API_URL = os.environ.get("CENTRAL_API_URL", "http://localhost:8000/v1/telemetry/report")
WORKER_SECRET = os.environ.get("WORKER_SECRET", "your-internal-worker-secret-key")
WORKER_REGION = os.environ.get("WORKER_REGION", "us-east-1")

# Live probe endpoints
TARGET_PROBE_MODELS = [
    {
        "id": "deepseek/deepseek-chat",
        "provider": "DeepSeek",
        "endpoint": "https://api.deepseek.com/v1/chat/completions",
        "api_key": os.environ.get("DEEPSEEK_KEY", "")
    },
    {
        "id": "qwen/qwen-max",
        "provider": "Alibaba",
        "endpoint": "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
        "api_key": os.environ.get("QWEN_KEY", "")
    },
    {
        "id": "moonshot/kimi-k2.7-code",
        "provider": "Moonshot",
        "endpoint": "https://api.moonshot.cn/v1/chat/completions",
        "api_key": os.environ.get("KIMI_KEY", "")
    },
    {
        "id": "zhipu/glm-5.3-flash",
        "provider": "Zhipu",
        "endpoint": "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        "api_key": os.environ.get("GLM_KEY", "")
    },
    {
        "id": "xiaomi/mimo-v2.6-pro",
        "provider": "Xiaomi",
        "endpoint": "https://api.xiaomimimo.com/v1/chat/completions",
        "api_key": os.environ.get("MIMO_KEY", os.environ.get("XIAOMI_KEY", ""))
    }
]


async def probe_llm_service(client: httpx.AsyncClient, model: dict, region: str):
    """Pings an LLM endpoint and posts latency telemetry to the central API."""
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
    tps = 0.0

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
        print(f"[{region}] Network/Error probing {model['id']}: {str(e)}")

    ttft_ms = float(ttft_ms or 0)

    # Telemetry payload
    telemetry_payload = {
        "region": region,
        "model_id": model["id"],
        "provider": model["provider"],
        "status_code": status_code,
        "ttft_ms": ttft_ms,
        "tokens_per_sec": tps,
        "error_type": error_type or "none",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }

    # Send to central gateway
    report_headers = {
        "X-Worker-Secret": WORKER_SECRET,
        "Content-Type": "application/json"
    }

    try:
        report_resp = await client.post(
            CENTRAL_API_URL,
            json=telemetry_payload,
            headers=report_headers,
            timeout=10.0
        )
        report_resp.raise_for_status()
        print(f"[{region}] {model['id']:<28} | TTFT: {ttft_ms:>6.0f}ms | TPS: {tps:<6.1f} | Status: {status_code} → OK")
    except Exception as e:
        print(f"⚠️  [{region}] Failed to report {model['id']}: {e}")


async def run_all_probes():
    """Run probes for all models concurrently."""
    async with httpx.AsyncClient(timeout=20.0) as client:
        tasks = [
            probe_llm_service(client, model, region=WORKER_REGION)
            for model in TARGET_PROBE_MODELS
        ]
        await asyncio.gather(*tasks)


def lambda_handler(event, context):
    """
    AWS Lambda entry point.
    Triggered by EventBridge Scheduler (recommended every 1–5 minutes).
    """
    print(f"🚀 Starting probes | Region: {WORKER_REGION} | Time: {datetime.now(timezone.utc).isoformat()}")
    
    try:
        asyncio.run(run_all_probes())
        return {
            "statusCode": 200,
            "body": f"Probes completed successfully in {WORKER_REGION}"
        }
    except Exception as e:
        print(f"❌ Fatal error in lambda_handler: {e}")
        return {
            "statusCode": 500,
            "body": f"Error: {str(e)}"
        }


# Optional: allow local testing
if __name__ == "__main__":
    print("Running locally (simulating Lambda)...")
    lambda_handler({}, None)