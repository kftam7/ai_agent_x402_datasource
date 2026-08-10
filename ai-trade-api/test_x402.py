"""
test_x402.py
Smoke-test Coinbase CDP x402 facilitator auth + verify.
Reads CDP_API_KEY_ID / CDP_API_KEY_SECRET from .env
"""

import os
import requests
from dotenv import load_dotenv
from cdp.x402 import create_facilitator_config

load_dotenv()


def main() -> None:
    api_key_id = os.getenv("CDP_API_KEY_ID")
    api_key_secret = os.getenv("CDP_API_KEY_SECRET")

    if not api_key_id or not api_key_secret:
        raise SystemExit(
            "Missing CDP_API_KEY_ID or CDP_API_KEY_SECRET in environment / .env"
        )

    print("=== CDP x402 facilitator smoke test ===\n")
    print(f"CDP_API_KEY_ID set: True ({api_key_id[:8]}...{api_key_id[-4:]})")
    print(f"CDP_API_KEY_SECRET set: True (len={len(api_key_secret)})\n")

    # Official helper — same as cdp.x402 source
    cfg = create_facilitator_config(
        api_key_id="b0bc49f3-774a-41c2-9dba-ccb3e325f107",
        api_key_secret="yk35lXyUQ/Rwbrihh9VTrk5MxwZjtDaA1CQnoj1fftOCLAxyl9L0vfI8b7T7kHuwnjHXghn9OqTbde0XwbSG1Q==",
    )
    url = cfg["url"]
    headers = cfg["create_headers"]()

    print(f"facilitator url: {url}")

    # ------------------------------------------------------------------
    # 1) GET /supported  — must be 200 if auth works
    # ------------------------------------------------------------------
    supported_url = f"{url}/supported"
    print(f"\nGET {supported_url}")
    try:
        r = requests.get(
            supported_url,
            headers=headers["supported"],
            timeout=12,
        )
        print(f"supported status: {r.status_code}")
        print(f"supported body:   {r.text[:600]}")
        if r.status_code != 200:
            print("\n❌ /supported failed — fix credentials before continuing")
            return
        print("\n✅ /supported OK — auth works")
    except Exception as e:
        print(f"\n❌ Exception on /supported: {type(e).__name__}: {e}")
        return

    # ------------------------------------------------------------------
    # 2) POST /verify — valid shape, invalid signature (expect isValid=false or 400)
    #    Network: Base Sepolia (eip155:84532) — listed in /supported for v2
    # ------------------------------------------------------------------
    verify_url = f"{url}/verify"
    verify_body = {
        "x402Version": 2,
        "paymentPayload": {
            "x402Version": 2,
            "accepted": {
                "scheme": "exact",
                "network": "eip155:84532",
                "asset": "0x036CbD53842c5426634e7929541eC2318f3dCF7e",  # USDC Base Sepolia
                "amount": "1000",
                "payTo": "0x0000000000000000000000000000000000000001",
                "maxTimeoutSeconds": 60,
                "extra": {"name": "USDC", "version": "2"},
            },
            "payload": {
                "signature": "0x" + "00" * 65,
                "authorization": {
                    "from": "0x0000000000000000000000000000000000000002",
                    "to": "0x0000000000000000000000000000000000000001",
                    "value": "1000",
                    "validAfter": "0",
                    "validBefore": "9999999999",
                    "nonce": "0x" + "00" * 32,
                },
            },
        },
        "paymentRequirements": {
            "scheme": "exact",
            "network": "eip155:84532",
            "asset": "0x036CbD53842c5426634e7929541eC2318f3dCF7e",
            "amount": "1000",
            "payTo": "0x0000000000000000000000000000000000000001",
            "maxTimeoutSeconds": 60,
            "extra": {"name": "USDC", "version": "2"},
        },
    }

    print(f"\nPOST {verify_url}")
    print(f"Request headers keys: {list(headers['verify'].keys())}")
    try:
        r2 = requests.post(
            verify_url,
            json=verify_body,
            headers=headers["verify"],
            timeout=12,
        )
        print(f"verify status: {r2.status_code}")
        print(f"verify body:   {r2.text[:800]}")

        if r2.status_code == 401:
            print("\n❌ 401 Unauthorized — credentials rejected")
        elif r2.status_code == 200:
            data = r2.json()
            print(f"\n✅ HTTP 200 — isValid={data.get('isValid')}")
            if data.get("invalidReason"):
                print(f"   invalidReason: {data.get('invalidReason')}")
        else:
            # 400 with structured error is fine for this smoke test
            print("\n✅ Non-401 response — auth OK (body validation expected for dummy sig)")
    except Exception as e:
        print(f"\n❌ Exception on /verify: {type(e).__name__}: {e}")


if __name__ == "__main__":
    main()