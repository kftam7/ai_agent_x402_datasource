import json
from decimal import Decimal
from datetime import datetime
from typing import Any
from fastapi.responses import JSONResponse

class DecimalDatetimeEncoder(json.JSONEncoder):
    """
    Custom JSON Encoder that safely converts Decimal objects to floats 
    and datetime objects to ISO 8601 formatted strings.
    """
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)

class CustomJSONResponse(JSONResponse):
    """
    FastAPI JSONResponse subclass that applies the DecimalDatetimeEncoder
    to ensure database records containing numeric/timestamp data serialize cleanly.
    """
    def render(self, content: Any) -> bytes:
        return json.dumps(
            content, 
            cls=DecimalDatetimeEncoder, 
            ensure_ascii=True
        ).encode("utf-8")