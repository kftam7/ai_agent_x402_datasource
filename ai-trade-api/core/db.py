import json
from decimal import Decimal
from datetime import datetime
from typing import Any
import psycopg2
import asyncpg
import redis.asyncio as redis
from fastapi.responses import JSONResponse
import config

pg_pool: asyncpg.Pool = None
redis_client: redis.Redis = None

async def init_db_pools():
    global pg_pool, redis_client
    pg_pool = await asyncpg.create_pool(config.DATABASE_URL)
    redis_client = redis.Redis(host=config.REDIS_HOST, port=config.REDIS_PORT, db=0, decode_responses=True)

async def close_db_pools():
    global pg_pool, redis_client
    if pg_pool:
        await pg_pool.close()
    if redis_client:
        await redis_client.close()

def get_db_conn():
    return psycopg2.connect(
        host=config.DB_HOST,
        port=config.DB_PORT,
        dbname=config.DB_NAME,
        user=config.DB_USER,
        password=config.DB_PASSWORD,
    )

class DecimalDatetimeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)

class CustomJSONResponse(JSONResponse):
    def render(self, content: Any) -> bytes:
        return json.dumps(content, cls=DecimalDatetimeEncoder, ensure_ascii=True).encode("utf-8")