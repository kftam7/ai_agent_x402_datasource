import json
from fastapi import APIRouter, HTTPException, Request, Depends
from psycopg2.extras import RealDictCursor
from core.auth import auth_dependency
from core.db import get_db_conn
from core.responses import CustomJSONResponse

router = APIRouter(prefix="/ai-trade", tags=["Trade Data"])

@router.get("/monthly")
async def get_monthly_data(
    request: Request,
    month: str,
    auth=Depends(auth_dependency),
):
    conn = get_db_conn()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        cur.execute("SELECT * FROM ai_customs_monthly WHERE data_month = %s", (month,))
        record = cur.fetchone()
    finally:
        cur.close()
        conn.close()
        
    if not record:
        raise HTTPException(status_code=404, detail="No data for given month")
    
    resp = CustomJSONResponse(content={"data": dict(record)})
    if auth.get("is_x402") and auth.get("tx_hash"):
        resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
    return resp