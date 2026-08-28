# stimulate_paid_x402.py
import os
import sys
import json
import traceback
import logging
from dotenv import load_dotenv
from web3 import Web3
import asyncio

# Enable DEBUG logging for x402 SDK
logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    stream=sys.stdout,
)

# FIXED: Import these from the global 'x402' package, not 'cdp.x402'
from x402 import x402Client
from x402.http.clients import x402HttpxClient
from x402.mechanisms.evm import EthAccountSigner
from x402.mechanisms.evm.exact.register import register_exact_evm_client

load_dotenv(".env_client")

NETWORK = "eip155:8453"


def main():
    buyer_private_key = os.getenv("BUYER_WALLET_PRIVATE_KEY")
    target_url = os.getenv("TARGET_API_URL")

    if not buyer_private_key or not target_url:
        raise RuntimeError("Missing BUYER_WALLET_PRIVATE_KEY or TARGET_API_URL in .env")

    pk_hex = buyer_private_key.removeprefix("0x")
    pk_bytes = bytes.fromhex(pk_hex)
    w3 = Web3()
    account = w3.eth.account.from_key(pk_bytes)
    evm_signer = EthAccountSigner(account=account)

    print("=" * 70)
    print(f"[BUYER TEST CLIENT] Buyer wallet address: {account.address}")
    print(f"Target API endpoint: {target_url}")
    print(f"Network: {NETWORK}")
    print("=" * 70, "\n")

    # --- DEBUG: Create and register client ---
    print("[DEBUG] Creating x402Client...")
    client = x402Client()

    print(f"[DEBUG] Registering exact EVM client for network: {NETWORK}")
    register_exact_evm_client(client, signer=evm_signer, networks=[NETWORK])

    # --- DEBUG: Inspect registered mechanisms ---
    print("[DEBUG] Registered client mechanisms:")
    if hasattr(client, "schemes"):
        print(f"  schemes: {client.schemes}")
    if hasattr(client, "_schemes"):
        print(f"  _schemes: {client._schemes}")
    if hasattr(client, "registrations"):
        print(f"  registrations: {client.registrations}")
    # Try to print all attributes
    print(f"  client dir: {[a for a in dir(client) if not a.startswith('__')]}")

    x402_http = x402HttpxClient(x402_client=client)
    print(f"[DEBUG] x402HttpxClient created: {x402_http}")

    # --- DEBUG: Make the request with full error tracing ---
    print("\n[DEBUG] Sending GET request (this will trigger 402 -> payment -> retry)...")
    try:
        resp = asyncio.run(x402_http.get(target_url))
        print(f"[DEBUG] GET completed without exception")
    except Exception as e:
        print(f"\n❌ [DEBUG] CLIENT EXCEPTION: {type(e).__name__}: {e}")
        print("[DEBUG] Full traceback:")
        traceback.print_exc()
        print("\n[DEBUG] Request may have partially completed. Checking if resp exists...")
        resp = None

    if resp is None:
        print("[DEBUG] No response object, exiting")
        return

    print("\n" + "=" * 70)
    print(f"FINAL RESPONSE STATUS CODE: {resp.status_code}")
    print("=" * 70)

    print("\n[ALL RESPONSE HEADERS]")
    for k, v in sorted(resp.headers.items()):
        print(f"  {k}: {v}")

    payment_response_raw = resp.headers.get("PAYMENT-RESPONSE")
    print("\n[X402 PAYMENT-RESPONSE HEADER]")
    if payment_response_raw:
        try:
            pr_data = json.loads(payment_response_raw)
            print(f"Decoded PAYMENT-RESPONSE: {json.dumps(pr_data, indent=2)}")
            tx_hash = pr_data.get("tx_hash")
            if tx_hash:
                print(f"\n✅ Transaction hash: {tx_hash}")
                print(f"🔗 Base Mainnet Block Explorer: https://basescan.org/tx/{tx_hash}")
        except Exception as e:
            print(f"Cannot decode PAYMENT-RESPONSE JSON: {e}, raw={payment_response_raw}")
    else:
        print("⚠️ PAYMENT-RESPONSE header NOT present")

    print("\n[RESPONSE JSON BODY]")
    print(resp.text)

    print("\n" + "=" * 70)
    print("Test client finished.")
    print("=" * 70)


if __name__ == "__main__":
    main()
