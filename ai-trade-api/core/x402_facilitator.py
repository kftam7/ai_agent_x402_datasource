import json
import base64
import requests
from typing import Any
from fastapi import HTTPException
from core.db import get_db_conn
import config

def get_payment_requirements() -> dict[str, Any]:
    """Generates the minimum requirements for a valid x402 payment."""
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
    """Builds the 402 Payment Required JSON challenge returned to agents."""
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
    """Safely decodes the agent's payment signature (handles Base64 or plain JSON)."""
    raw = raw.strip()
    try:
        padded = raw + "=" * (-len(raw) % 4)
        return json.loads(base64.b64decode(padded).decode("utf-8"))
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
    """Synchronously records the payment attempt into PostgreSQL."""
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
    """Verifies the agent's signature and explicitly settles the payment via the CDP Facilitator."""
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
        # Step 1: Verify Signature via Facilitator
        resp_verify = requests.post(
            f"{config.X402_FACILITATOR_URL}/verify",
            json=body,
            headers=op_headers["verify"],
            timeout=12,
        )
        if resp_verify.status_code == 401:
            audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, False)
            raise HTTPException(status_code=503, detail="X402 facilitator auth failed (401).")
            
        data_verify = resp_verify.json() if resp_verify.text else {}
        is_valid = data_verify.get("isValid", data_verify.get("valid", False))
        
        if resp_verify.status_code >= 400 or not is_valid:
            audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, False)
            reason = data_verify.get("invalidReason") or data_verify.get("errorMessage") or resp_verify.text
            raise HTTPException(status_code=402, detail=f"X402 payment invalid: {reason}")
            
        # Step 2: Settle Funds via Facilitator
        resp_settle = requests.post(
            f"{config.X402_FACILITATOR_URL}/settle",
            json=body,
            headers=op_headers["settle"],
            timeout=30,
        )
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

    # Audit successful payment
    audit_payment(request_path, payment_header_raw, config.X402_NETWORK_CAIP2, config.X402_ASSET_CONTRACT, config.X402_AMOUNT_ATOMIC, config.X402_WALLET_ADDRESS, True, settle_ok, settle_tx_hash)
    
    return True, settle_tx_hash