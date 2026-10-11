# endpoints/api.py
from fastapi import APIRouter

# Import the individual route files
from endpoints import health
from endpoints import telemetry_report
from endpoints import trade_monthly
from endpoints import status_live
from endpoints import prices_realtime
from endpoints import router_recommend
from endpoints import proxy_chat

api_router = APIRouter()

# Register each mini-router
api_router.include_router(health.router)
api_router.include_router(telemetry_report.router)
api_router.include_router(trade_monthly.router)
api_router.include_router(status_live.router)
api_router.include_router(prices_realtime.router)
api_router.include_router(router_recommend.router)
api_router.include_router(proxy_chat.router)