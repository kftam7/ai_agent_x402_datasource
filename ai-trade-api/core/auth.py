import json
import base64
import requests
from typing import Any
from fastapi import HTTPException, Request, Header
from psycopg2.extras import RealDictCursor
from core.db import get_db_conn
import config

def get_payment_requirements() -> dict[str, Any]:
    req: dict[str, Any] = {
        "scheme": "exact",
        "network": config.X402_NETWORK_CAIP2,
        "asset": config.X402_ASSET_CONTRACT,
        "amount": str(config.X402_AMOUNT_ATOMIC),
        "payTo": config.X402_WALLET_ADDRESS,
        "maxTimeoutSeconds": config.X402_MAX_TIMEOUT,
    }
    if config.X402_PROTOCOL_VERSION >= 2:
        req["extra"] = {"name": config.X402_ASSET_NAME, "version": config.X402_ASSET_VERSION}
    return req

def get_x402_challenge_payload(resource_url: str) -> dict[str, Any]:
    accepts = get_payment_requirements()
    if config.X402_PROTOCOL_VERSION >= 2:
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
        return json.loads(base64.b64decode(padded).decode("utf-8"))
    except Exception:
        pass
    try:
        return json.loads(raw)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Invalid payment header: not base64 JSON or JSON ({e})")

def audit_payment(
    request_path: str, payment_header: str, network_caip2: str, asset_contract: str,
    amount_atomic: str, wallet_payto: str, verify_success: bool, settle_success: bool = False,
    settle_tx_hash: str | None = None, settle_error: str | None = None,
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
            (request_path, payment_header, network_caip2, asset_contract, amount_atomic,
             wallet_payto, verify_success, settle_success, settle_tx_hash, settle_error),
        )
        conn.commit()
    finally:
        cur.close()
        conn.close()

def verify_and_settle_x402_payment(payment_header_raw: str, request_path: str):
    if not config.X402_ENABLED:
        return True, None
    required = [
        config.CDP_API_KEY_ID, config.CDP_API_KEY_SECRET, config.X402_WALLET_ADDRESS,
        config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC,
    ]
    if not all(required):
        raise HTTPException(status_code=503, detail="X402 configuration incomplete on server")
        
    payment_payload = decode_payment_header(payment_header_raw)
    payment_requirements = get_payment_requirements()
    
    if "x402Version" not in payment_payload:
        payment_payload = {**payment_payload, "x402Version": config.X402_PROTOCOL_VERSION}
        
    body = {
        "x402Version": payment_payload.get("x402Version", config.X402_PROTOCOL_VERSION),
        "paymentPayload": payment_payload,
        "paymentRequirements": payment_requirements,
    }
    
    op_headers = config.CREATE_X402_HEADERS()
    settle_tx_hash = None
    settle_ok = False
    
    try:
        resp_verify = requests.post(f"{config.X402_FACILITATOR_URL}/verify", json=body, headers=op_headers["verify"], timeout=12)
        if resp_verify.status_code == 401:
            audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, False)
            raise HTTPException(status_code=503, detail="X402 facilitator auth failed (401).")
            
        data_verify = resp_verify.json() if resp_verify.text else {}
        is_valid = data_verify.get("isValid", data_verify.get("valid", False))
        
        if resp_verify.status_code >= 400 or not is_valid:
            audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, False)
            reason = data_verify.get("invalidReason") or data_verify.get("errorMessage") or resp_verify.text
            raise HTTPException(status_code=402, detail=f"X402 payment invalid: {reason}")
            
        resp_settle = requests.post(f"{config.X402_FACILITATOR_URL}/settle", json=body, headers=op_headers["settle"], timeout=30)
        if resp_settle.status_code == 401:
            audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, True, False)
            raise HTTPException(status_code=503, detail="X402 settle auth failed (401)")
            
        data_settle = resp_settle.json() if resp_settle.text else {}
        settle_ok = bool(data_settle.get("success") or data_settle.get("settled") or data_settle.get("transaction"))
        settle_tx_hash = data_settle.get("transaction") or data_settle.get("tx_hash") or data_settle.get("txHash")
        
        if resp_settle.status_code >= 400 or not settle_ok:
            settle_err_msg = data_settle.get("errorReason") or data_settle.get("errorMessage") or resp_settle.text
            audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, True, False, settle_error=settle_err_msg)
            raise HTTPException(status_code=402, detail=f"X402 settle failed: {settle_err_msg}")
            
    except HTTPException:
        raise
    except Exception as e:
        audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, False, settle_error=str(e))
        raise HTTPException(status_code=503, detail=f"X402 error: {str(e)}")

    audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, True, settle_ok, settle_tx_hash)
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
    if config.X402_ENABLED and payment_header is not None:
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