from fastapi import APIRouter
import config

router = APIRouter(tags=["System & Telemetry"])

@router.get("/health")
async def health_check():
    return {
        "status": "ok",
        "x402_enabled": config.X402_ENABLED,
        "facilitator_url": config.X402_FACILITATOR_URL,
        "key_id_loaded": bool(config.CDP_API_KEY_ID),
        "network": config.X402_NETWORK_CAIP2,
        "protocol_version": config.X402_PROTOCOL_VERSION,
        "asset_contract": config.X402_ASSET_CONTRACT
    }