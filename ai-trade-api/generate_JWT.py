import os
from cdp.auth.utils.jwt import generate_jwt, JwtOptions
from dotenv import load_dotenv

load_dotenv()

# Generate the JWT using the CDP SDK
jwt_token = generate_jwt(JwtOptions(

    api_key_id = os.getenv("CDP_API_KEY_ID"),
    api_key_secret = os.getenv("CDP_API_KEY_SECRET"),
    request_method="GET",
    request_host="api.cdp.coinbase.com",
    request_path="/platform/v2/evm/token-balances/base-sepolia/0x8fddcc0c5c993a1968b46787919cc34577d6dc5c",
    expires_in=120  # optional (defaults to 120 seconds)
))

print(jwt_token)