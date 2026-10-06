import asyncio
import os
import httpx
import asyncpg
from datetime import datetime, timezone
from dotenv import load_dotenv

# Load database credentials from your .env file
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://trade_app:LocalTest123@localhost:5432/ai_trade")
TARGET_PROVIDERS = ["deepseek", "qwen", "moonshot", "kimi", "glm", "minimax", "xiaomi", "mimo"]

async def scrape_and_store_prices():
    """Fetches global pricing from LiteLLM and updates the DB if prices changed."""
    url = "https://raw.githubusercontent.com/BerriAI/litellm/main/model_prices_and_context_window.json"
    print(f"[{datetime.now(timezone.utc).isoformat()}] Starting daily price scrape...")
    
    async with httpx.AsyncClient(timeout=15.0) as client:
        try:
            res = await client.get(url)
            res.raise_for_status()
            data = res.json()
        except Exception as e:
            print(f"Failed to fetch pricing data: {e}")
            return
        
        # Connect directly to the central PostgreSQL database
        conn = await asyncpg.connect(DATABASE_URL)
        try:
            processed = 0
            for model_id, info in data.items():
                if any(kw in model_id.lower() for kw in TARGET_PROVIDERS):
                    
                    # LiteLLM prices are per 1 token. Convert to per 1 Million.
                    in_cost = float((info.get("input_cost_per_token") or 0)) * 1_000_000
                    out_cost = float((info.get("output_cost_per_token") or 0)) * 1_000_000
                    
                    provider_name = model_id.split('/')[0].capitalize() if '/' in model_id else "Chinese AI"
                    
                    # 1. Register the model (Idempotent - ignores if already exists)
                    await conn.execute(
                        "INSERT INTO llm_models (model_id, provider, display_name) VALUES ($1, $2, $3) ON CONFLICT DO NOTHING",
                        model_id, provider_name, model_id
                    )
                    
                    # 2. Diff Check: Fetch the latest recorded price to avoid DB bloat
                    latest_price = await conn.fetchrow(
                        "SELECT input_price_per_1m, output_price_per_1m FROM llm_prices WHERE model_id = $1 ORDER BY recorded_at DESC LIMIT 1",
                        model_id
                    )
                    
                    is_new = not latest_price
                    price_changed = False
                    
                    if not is_new:
                        price_changed = (
                            float(latest_price["input_price_per_1m"]) != in_cost or 
                            float(latest_price["output_price_per_1m"]) != out_cost
                        )
                        
                    # 3. Only insert a new time-series row if it's a new model or the price shifted
                    if is_new or price_changed:
                        await conn.execute(
                            "INSERT INTO llm_prices (model_id, input_price_per_1m, output_price_per_1m) VALUES ($1, $2, $3)",
                            model_id, in_cost, out_cost
                        )
                        processed += 1
                        
            print(f"[{datetime.now(timezone.utc).isoformat()}] Scrape complete. Recorded {processed} price shifts.")
        finally:
            await conn.close()

if __name__ == "__main__":
    try:
        asyncio.run(scrape_and_store_prices())
    except KeyboardInterrupt:
        print("Scraper aborted by user.")