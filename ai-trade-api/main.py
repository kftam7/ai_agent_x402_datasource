"""
AI Hardware Trade Data API with CDP x402 facilitator (JWT auth).
Fix: Decimal + datetime JSON serialization, pure ASCII hyphens, full audit.
"""
import os
import json
import base64
from decimal import Decimal
from datetime import datetime
from typing import Any

import requests
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Request, Header, Depends
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
import psycopg2
from psycopg2.extras import RealDictCursor

from cdp.x402 import create_facilitator_config

load_dotenv()

app = FastAPI(title="AI Hardware Trade Data API")

# Rate limiter
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Custom JSON encoder for PostgreSQL Decimal and datetime types
class DecimalDatetimeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)


# ---------------------------------------------------------------------------
# Database
# ---------------------------------------------------------------------------
def get_db_conn():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
    )


# ---------------------------------------------------------------------------
# X402 / CDP config (prefer official CDP_* names; fall back to old COINBASE_*)
# ---------------------------------------------------------------------------
CDP_API_KEY_ID = os.getenv("CDP_API_KEY_ID") or os.getenv("COINBASE_API_KEY_ID") or ""
CDP_API_KEY_SECRET = os.getenv("CDP_API_KEY_SECRET") or os.getenv("COINBASE_API_SECRET") or ""

X402_ENABLED = os.getenv("X402_ENABLED", "False").lower() == "true"
X402_WALLET_ADDRESS = os.getenv("X402_WALLET_ADDRESS", "")
X402_NETWORK_CAIP2 = os.getenv("X402_NETWORK_CAIP2", "eip155:84532")  # Base Sepolia default
X402_ASSET_CONTRACT = os.getenv("X402_ASSET_CONTRACT", "")
X402_AMOUNT_ATOMIC = os.getenv("X402_AMOUNT_ATOMIC", "")
X402_ASSET_NAME = os.getenv("X402_ASSET_NAME", "USDC")
X402_ASSET_VERSION = os.getenv("X402_ASSET_VERSION", "2")
X402_MAX_TIMEOUT = int(os.getenv("X402_MAX_TIMEOUT_SECONDS", "60"))
X402_PROTOCOL_VERSION = int(os.getenv("X402_PROTOCOL_VERSION", "2"))  # 1 or 2

# Facilitator config (JWT auth for /verify and /settle)
_facilitator_cfg = create_facilitator_config(
    api_key_id=CDP_API_KEY_ID or None,
    api_key_secret=CDP_API_KEY_SECRET or None,
)
X402_FACILITATOR_URL = _facilitator_cfg["url"]
_create_x402_headers = _facilitator_cfg["create_headers"]

print("\n==== X402 ENV STARTUP DEBUG ====")
print(f"X402_ENABLED: {X402_ENABLED}")
print(
    f"CDP_API_KEY_ID loaded: {bool(CDP_API_KEY_ID)}, "
    f"snippet: {CDP_API_KEY_ID[:12]}***" if CDP_API_KEY_ID else "CDP_API_KEY_ID: EMPTY"
)
print(
    f"CDP_API_KEY_SECRET loaded: {bool(CDP_API_KEY_SECRET)}, "
    f"len={len(CDP_API_KEY_SECRET)}" if CDP_API_KEY_SECRET else "CDP_API_KEY_SECRET: EMPTY"
)
print(f"X402_FACILITATOR_URL: {X402_FACILITATOR_URL}")
print(f"X402_WALLET_ADDRESS: {X402_WALLET_ADDRESS}")
print(f"X402_NETWORK_CAIP2: {X402_NETWORK_CAIP2}")
print(f"X402_PROTOCOL_VERSION: {X402_PROTOCOL_VERSION}")
print("================================\n")


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def get_payment_requirements() -> dict[str, Any]:
    """Server‑side payment requirements sent to the facilitator."""
    req: dict[str, Any] = {
        "scheme": "exact",
        "network": X402_NETWORK_CAIP2,
        "asset": X402_ASSET_CONTRACT,
        "amount": str(X402_AMOUNT_ATOMIC),
        "payTo": X402_WALLET_ADDRESS,
        "maxTimeoutSeconds": X402_MAX_TIMEOUT,  # MANDATORY for X402‑V2
    }
    if X402_PROTOCOL_VERSION >= 2:
        req["extra"] = {"name": X402_ASSET_NAME, "version": X402_ASSET_VERSION}
    return req


def get_x402_challenge_payload(resource_url: str) -> dict[str, Any]:
    """Body/detail for HTTP 402 when payment is missing."""
    accepts = get_payment_requirements()
    if X402_PROTOCOL_VERSION >= 2:
        return {
            "x402Version": 2,
            "error": "Payment required",
            "accepts": [accepts],
            "resource": {
                "url": resource_url,
                "description": "AI hardware customs trade data, pay-per-call via x402",
                "mimeType": "application/json",
            },
        }
    return {
        "x402Version": 1,
        "resource": {
            "url": resource_url,
            "description": "AI hardware customs trade data, pay-per-call via x402",
            "mimeType": "application/json",
        },
        "accepts": [accepts],
    }


def decode_payment_header(raw: str) -> dict[str, Any]:
    """
    Client sends PAYMENT-SIGNATURE (v2) or X-PAYMENT (v1) as base64 JSON,
    or occasionally raw JSON. Return the paymentPayload dict.
    """
    raw = raw.strip()
    # Try base64 first
    try:
        padded = raw + "=" * (-len(raw) % 4)
        decoded = base64.b64decode(padded).decode("utf-8")
        return json.loads(decoded)
    except Exception:
        pass
    # Raw JSON
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
                X402_NETWORK_CAIP2,
                X402_ASSET_CONTRACT,
                X402_AMOUNT_ATOMIC,
                X402_WALLET_ADDRESS,
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
    """
    Decode client payment header, call CDP facilitator /verify then /settle
    with JWT auth and correct JSON body.
    """
    if not X402_ENABLED:
        return True, None

    required = [
        CDP_API_KEY_ID,
        CDP_API_KEY_SECRET,
        X402_WALLET_ADDRESS,
        X402_NETWORK_CAIP2,
        X402_ASSET_CONTRACT,
        X402_AMOUNT_ATOMIC,
    ]
    if not all(required):
        raise HTTPException(status_code=503, detail="X402 configuration incomplete on server")

    payment_payload = decode_payment_header(payment_header_raw)
    payment_requirements = get_payment_requirements()

    # Ensure version on payload if client omitted it
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
    settle_err_msg = None

    try:
        # ---------- /verify ----------
        verify_url = f"{X402_FACILITATOR_URL}/verify"
        print("\n==== CDP REQUEST DEBUG /verify ====")
        print(f"POST URL: {verify_url}")
        print(f"Request header keys: {list(op_headers['verify'].keys())}")
        print(f"Body keys: {list(body.keys())}")
        resp_verify = requests.post(
            verify_url,
            json=body,
            headers=op_headers["verify"],
            timeout=12,
        )
        print(f"Response status: {resp_verify.status_code}")
        print(f"Response body: {resp_verify.text[:800]}")
        print("====================================\n")

        if resp_verify.status_code == 401:
            audit_payment(request_path, payment_header_raw, verify_success=False)
            raise HTTPException(
                status_code=503,
                detail="X402 facilitator auth failed (401). Check CDP_API_KEY_ID / CDP_API_KEY_SECRET.",
            )

        data_verify = resp_verify.json() if resp_verify.text else {}
        # CDP uses isValid (v2); some older responses used valid
        is_valid = data_verify.get("isValid", data_verify.get("valid", False))

        if resp_verify.status_code >= 400 or not is_valid:
            audit_payment(request_path, payment_header_raw, verify_success=False)
            reason = data_verify.get("invalidReason") or data_verify.get("errorMessage") or resp_verify.text
            raise HTTPException(status_code=402, detail=f"X402 payment invalid: {reason}")

        # ---------- /settle ----------
        settle_url = f"{X402_FACILITATOR_URL}/settle"
        print("\n==== CDP REQUEST DEBUG /settle ====")
        print(f"POST URL: {settle_url}")
        resp_settle = requests.post(
            settle_url,
            json=body,
            headers=op_headers["settle"],
            timeout=30,
        )
        print(f"Response status: {resp_settle.status_code}")
        print(f"Response body: {resp_settle.text[:800]}")
        print("====================================\n")

        if resp_settle.status_code == 401:
            audit_payment(request_path, payment_header_raw, verify_success=True, settle_success=False)
            raise HTTPException(status_code=503, detail="X402 settle auth failed (401)")

        data_settle = resp_settle.json() if resp_settle.text else {}
        settle_ok = bool(
            data_settle.get("success")
            or data_settle.get("settled")
            or data_settle.get("transaction")
        )
        settle_tx_hash = (
            data_settle.get("transaction")
            or data_settle.get("tx_hash")
            or data_settle.get("txHash")
        )

        if resp_settle.status_code >= 400 or not settle_ok:
            settle_err_msg = (
                data_settle.get("errorReason")
                or data_settle.get("errorMessage")
                or resp_settle.text
            )
            audit_payment(
                request_path,
                payment_header_raw,
                verify_success=True,
                settle_success=False,
                settle_error=settle_err_msg,
            )
            raise HTTPException(status_code=402, detail=f"X402 settle failed: {settle_err_msg}")

    except HTTPException:
        raise
    except requests.exceptions.RequestException as e:
        settle_err_msg = str(e)
        audit_payment(request_path, payment_header_raw, verify_success=False, settle_error=settle_err_msg)
        raise HTTPException(status_code=503, detail=f"X402 facilitator error: {settle_err_msg}")
    except Exception as e:
        settle_err_msg = str(e)
        audit_payment(request_path, payment_header_raw, verify_success=False, settle_error=settle_err_msg)
        raise HTTPException(status_code=503, detail=f"X402 error: {settle_err_msg}")

    audit_payment(
        request_path=request_path,
        payment_header=payment_header_raw,
        verify_success=True,
        settle_success=settle_ok,
        settle_tx_hash=settle_tx_hash,
        settle_error=None,
    )
    return True, settle_tx_hash


def validate_api_key(api_key: str):
    conn = get_db_conn()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        cur.execute(
            """
            SELECT is_active FROM subscriber_api_keys
            WHERE api_key = %s AND is_active = true
            """,
            (api_key,),
        )
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
    # v2 standard
    payment_signature: str | None = Header(default=None, alias="PAYMENT-SIGNATURE"),
    # v1 / legacy aliases
    x_payment: str | None = Header(default=None, alias="X-PAYMENT"),
    x402: str | None = Header(default=None, alias="x402"),
):
    # 1) Classic API key
    if x_api_key is not None:
        return {"is_x402": False, "tx_hash": None}

    # 2) x402 payment header
    payment_header = payment_signature or x_payment or x402
    if X402_ENABLED and payment_header is not None:
        is_valid, tx_hash = verify_and_settle_x402_payment(payment_header, str(request.url))
        if is_valid:
            return {"is_x402": True, "tx_hash": tx_hash}
        raise HTTPException(status_code=402, detail="X402 payment invalid or not settled")

    # 3) No auth → 402 challenge
    challenge = get_x402_challenge_payload(str(request.url))
    # Protocol-friendly: also put requirements in PAYMENT-REQUIRED (base64)
    try:
        pr_b64 = base64.b64encode(json.dumps(challenge).encode()).decode()
    except Exception:
        pr_b64 = None

    headers = {}
    if pr_b64:
        headers["PAYMENT-REQUIRED"] = pr_b64
    raise HTTPException(status_code=402, detail=challenge, headers=headers)


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------
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
        cur.execute(
            "SELECT * FROM ai_customs_monthly WHERE data_month = %s",
            (month,),
        )
        record = cur.fetchone()
    finally:
        cur.close()
        conn.close()
    if not record:
        raise HTTPException(status_code=404, detail="No data for given month")

    payload = {"data": dict(record)}
    # Serialize with encoder supporting Decimal + datetime
    json_body = json.dumps(payload, cls=DecimalDatetimeEncoder)
    resp = JSONResponse(content=json_body, media_type="application/json")

    # Inject PAYMENT-RESPONSE header only for X402 payment flow
    if auth.get("is_x402") and auth.get("tx_hash"):
        payment_response_obj = json.dumps({"tx_hash": auth["tx_hash"]})
        resp.headers["PAYMENT-RESPONSE"] = payment_response_obj

    return resp


@app.get("/health")
async def health_check():
    return {
        "status": "ok",
        "x402_enabled": X402_ENABLED,
        "facilitator_url": X402_FACILITATOR_URL,
        "key_id_loaded": bool(CDP_API_KEY_ID),
        "network": X402_NETWORK_CAIP2,
        "protocol_version": X402_PROTOCOL_VERSION,
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)