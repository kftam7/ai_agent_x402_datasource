"""
faucet_official.py — CDP EVM faucet per official API docs
https://docs.cdp.coinbase.com/api-reference/v2/rest-api/faucets/request-funds-on-evm-test-networks
"""
import os
import requests
from dotenv import load_dotenv
from cdp.auth.utils.http import get_auth_headers, GetAuthHeadersOptions

load_dotenv()

ADDRESS = os.getenv("FAUCET_ADDRESS", "0x7B5A5AF76c2490010D68e4d0DdB4f5C1FC7e7309")  # 0x + 40 hex
NETWORK = "base-sepolia"
TOKENS = ["eth", "usdc"]  # claim both for x402 testing

API_KEY_ID = os.environ["CDP_API_KEY_ID"]
API_KEY_SECRET = os.environ["CDP_API_KEY_SECRET"]

FAUCET_PATH = "/platform/v2/evm/faucet"
FAUCET_URL = f"https://api.cdp.coinbase.com{FAUCET_PATH}"


def claim(token: str) -> None:
    body = {
        "network": NETWORK,
        "address": ADDRESS,
        "token": token,
    }
    headers = get_auth_headers(
        GetAuthHeadersOptions(
            api_key_id=API_KEY_ID,
            api_key_secret=API_KEY_SECRET,
            request_host="api.cdp.coinbase.com",
            request_path=FAUCET_PATH,
            request_method="POST",
            request_body=body,  # include body if your SDK version supports it
        )
    )
    # ensure Content-Type
    headers = {**headers, "Content-Type": "application/json"}

    r = requests.post(FAUCET_URL, json=body, headers=headers, timeout=30)
    print(f"\n[{token}] status={r.status_code}")
    print(r.text[:500])

    if r.status_code == 200:
        tx = r.json().get("transactionHash")
        print(f"  explorer: https://sepolia.basescan.org/tx/{tx}")
    elif r.status_code == 401:
        print("  → JWT rejected. Use the key that returned 200 on /evm/accounts.")
    elif r.status_code == 429:
        print("  → Rate limit (faucet_limit_exceeded). Wait and retry.")
    elif r.status_code == 403:
        print("  → Forbidden for this address.")


if __name__ == "__main__":
    if not ADDRESS.startswith("0x") or len(ADDRESS) != 42:
        raise SystemExit("Set FAUCET_ADDRESS=0x... (40 hex chars)")
    print("Key ID:", API_KEY_ID[:8], "...", API_KEY_ID[-4:])
    print("Address:", ADDRESS)
    for t in TOKENS:
        claim(t)