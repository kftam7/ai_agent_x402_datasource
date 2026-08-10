# stimulate_paid_x402.py
import os
from dotenv import load_dotenv
from web3 import Web3
import asyncio
from x402 import x402Client
from x402.http.clients import x402HttpxClient
from x402.mechanisms.evm import EthAccountSigner
from x402.mechanisms.evm.exact.register import register_exact_evm_client

load_dotenv(".env")

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

    print("="*70)
    print(f"[BUYER TEST CLIENT] Buyer wallet address: {account.address}")
    print(f"Target API endpoint: {target_url}")
    print("="*70,"\n")

    client = x402Client()
    register_exact_evm_client(client, signer=evm_signer)

    x402_http = x402HttpxClient(x402_client=client)

    resp = asyncio.run(x402_http.get(target_url))

    print("\n"+"="*70)
    print(f"FINAL RESPONSE STATUS CODE: {resp.status_code}")
    print("="*70)

    print("\n[ALL RESPONSE HEADERS]")
    for k,v in sorted(resp.headers.items()):
        print(f"  {k}: {v}")

    payment_response_raw = resp.headers.get("PAYMENT-RESPONSE")
    print("\n[X402 PAYMENT-RESPONSE HEADER]")
    if payment_response_raw:
        import json
        try:
            pr_data = json.loads(payment_response_raw)
            print(f"Decoded PAYMENT‑RESPONSE: {json.dumps(pr_data, indent=2)}")
            tx_hash = pr_data.get("tx_hash")
            if tx_hash:
                print(f"\n✅ Transaction hash: {tx_hash}")
                print(f"🔗 Base‑Sepolia Block Explorer: https://sepolia.basescan.org/tx/{tx_hash}")
        except Exception as e:
            print(f"Cannot decode PAYMENT‑RESPONSE JSON: {e}, raw={payment_response_raw}")
    else:
        print("⚠️ PAYMENT‑RESPONSE header NOT present")

    print("\n[RESPONSE JSON BODY]")
    print(resp.text)

    print("\n"+"="*70)
    print("Test client finished.")
    print("="*70)

if __name__ == "__main__":
    main()