import os, requests
from dotenv import load_dotenv
from cdp.auth.utils.http import get_auth_headers, GetAuthHeadersOptions

load_dotenv()

headers = get_auth_headers(
    GetAuthHeadersOptions(
        api_key_id="b0bc49f3-774a-41c2-9dba-ccb3e325f107",
        api_key_secret="yk35lXyUQ/Rwbrihh9VTrk5MxwZjtDaA1CQnoj1fftOCLAxyl9L0vfI8b7T7kHuwnjHXghn9OqTbde0XwbSG1Q==",
        request_host="api.cdp.coinbase.com",
        request_path="/platform/v2/evm/accounts",
        request_method="GET",
    )
)
r = requests.get(
    "https://api.cdp.coinbase.com/platform/v2/evm/accounts",
    headers=headers,
    timeout=12,
)
print(r.status_code, r.text[:300])
