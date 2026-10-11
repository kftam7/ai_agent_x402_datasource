# main.py
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

from core.db import init_db_pools, close_db_pools
from endpoints.api import api_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db_pools()
    print("🚀 Connection pools to PostgreSQL and Redis established.", flush=True)
    yield
    await close_db_pools()
    print("🛑 Connection pools closed.", flush=True)

app = FastAPI(title="AI Trade Data & x402 LLM Inference Gateway", lifespan=lifespan)

# Rate limiter & CORS
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Attach the master router containing all single-function endpoints
app.include_router(api_router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)