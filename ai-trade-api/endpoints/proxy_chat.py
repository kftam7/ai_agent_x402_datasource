# endpoints/proxy_chat.py
import json
import httpx
from fastapi import APIRouter, HTTPException, Request, Depends
from fastapi.responses import StreamingResponse
from core.auth import auth_dependency
from core.responses import CustomJSONResponse
from core.db import redis_client
import config

router = APIRouter()

@router.post("/v1/chat/completions", tags=["Proxy Inferences"])
async def proxy_chat_completions(request: Request, auth=Depends(auth_dependency)):
    body = await request.json()
    requested_model = body.get("model")
    is_streaming = body.get("stream", False)
    
    region = request.headers.get("X-Agent-Region", "us-east")
    category = request.headers.get("X-Task-Category")

    if requested_model == "auto":
        if not category:
            prompt_text = " ".join([m.get("content", "") for m in body.get("messages", [])]).lower()
            if any(kw in prompt_text for kw in ["def ", "class ", "python", "javascript", "code", "html", "react"]):
                category = "coding"
            elif any(kw in prompt_text for kw in ["math", "equation", "calculate", "integral", "geometry"]):
                category = "math"
            else:
                category = "general"

        capable_ids = [m_id for m_id, cfg in config.MODEL_CONFIG.items() if category in cfg.get("categories", ["general"])]
        raw_data = await redis_client.hgetall(f"live_llm_status:{region}")
        valid_models = [m for m in capable_ids if m in raw_data and json.loads(raw_data[m]).get("status") == 200]

        if not valid_models:
            valid_models = [m for m, data in raw_data.items() if json.loads(data).get("status") == 200 and m in config.MODEL_CONFIG]

        if not valid_models:
            raise HTTPException(status_code=503, detail="No healthy models available for auto-routing.")

        requested_model = min(valid_models, key=lambda m: json.loads(raw_data[m]).get("ttft_ms", float('inf')))

    if requested_model not in config.MODEL_CONFIG:
        raise HTTPException(status_code=400, detail=f"Model '{requested_model}' not supported.")

    cfg = config.MODEL_CONFIG[requested_model]
    if not cfg["key"]:
        raise HTTPException(status_code=500, detail=f"Server missing API key for {requested_model}.")

    body["model"] = cfg["provider_model"]

    client = httpx.AsyncClient(timeout=60.0)
    req = client.build_request(
        "POST", cfg["url"],
        headers={"Authorization": f"Bearer {cfg['key']}", "Content-Type": "application/json"},
        json=body
    )

    if is_streaming:
        async def stream_generator():
            try:
                async with client.stream('POST', cfg["url"], headers=req.headers, json=body) as response:
                    response.raise_for_status()
                    async for chunk in response.aiter_bytes():
                        yield chunk
            except httpx.HTTPStatusError as e:
                yield f"data: {{\"error\": \"Provider Error: {e.response.status_code}\"}}\n\n".encode()
            finally:
                await client.aclose()
        return StreamingResponse(stream_generator(), media_type="text/event-stream")
    else:
        try:
            response = await client.send(req)
            response.raise_for_status()
            await client.aclose()
            resp = CustomJSONResponse(content=response.json())
            if auth.get("is_x402") and auth.get("tx_hash"):
                resp.headers["PAYMENT-RESPONSE"] = json.dumps({"tx_hash": auth["tx_hash"]})
            return resp
        except httpx.HTTPStatusError as e:
            await client.aclose()
            raise HTTPException(status_code=e.response.status_code, detail=f"Provider Error: {e.response.text}")