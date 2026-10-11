import os
from dotenv import load_dotenv
from cdp.x402 import create_facilitator_config

load_dotenv()

REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://trade_app:LocalTest123@localhost:5432/ai_trade")
WORKER_SECRET = os.getenv("WORKER_SECRET", "your-internal-worker-secret-key")

# Database Sync Auth credentials
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

# x402 / CDP Configuration
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
CREATE_X402_HEADERS = _facilitator_cfg["create_headers"]

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
    # ... remaining model configs ...
}