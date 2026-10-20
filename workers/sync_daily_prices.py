import sys
import os
import json
import asyncio
import hashlib
from datetime import datetime
import requests
import asyncpg

# Add the parent/target directory to sys.path to import config.py
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../ai-trade-api')))
# Fallback in case the script is run from the directory above
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import config

DATASET_URL = "https://www.llmrates.ai/api/dataset"

def parse_iso_datetime(dt_str: str | None) -> datetime | None:
    """Safely converts ISO datetime string from JSON into a Python datetime object for asyncpg."""
    if not dt_str:
        return None
    # Replace trailing 'Z' with UTC offset for Python fromisoformat compatibility
    clean_str = dt_str.replace("Z", "+00:00")
    return datetime.fromisoformat(clean_str)

def compute_price_hash(pr: dict) -> str:
    """Creates a deterministic MD5 hash of price values to identify price changes."""
    price_signature = f"{pr.get('inputPricePerMillion')}|{pr.get('cachedInputPricePerMillion')}|{pr.get('outputPricePerMillion')}|{pr.get('thinkingOutputPricePerMillion')}|{pr.get('imagePrice')}|{pr.get('videoPricePerSecond')}"
    return hashlib.md5(price_signature.encode('utf-8')).hexdigest()

async def sync_daily_llm_prices(url: str):
    print(f"📦 Fetching live dataset from: {url}...")
    
    # Download the dataset
    response = requests.get(url, timeout=30)
    response.raise_for_status()
    data = response.json()

    conn = await asyncpg.connect(config.DATABASE_URL)
    
    try:
        async with conn.transaction():
            # 1. Upsert Providers
            providers = data.get("providers", [])
            for p in providers:
                await conn.execute("""
                    INSERT INTO providers (provider_id, slug, name, website, pricing_url, provider_type)
                    VALUES ($1, $2, $3, $4, $5, $6)
                    ON CONFLICT (provider_id) DO UPDATE SET
                        name = EXCLUDED.name,
                        website = EXCLUDED.website,
                        pricing_url = EXCLUDED.pricing_url,
                        provider_type = EXCLUDED.provider_type,
                        updated_at = NOW();
                """, p["id"], p["slug"], p["name"], p.get("website"), p.get("pricingUrl"), p.get("providerType"))
            print(f"Upserted {len(providers)} providers.")

            # 2. Upsert Models
            models = data.get("models", [])
            inserted_count = 0
            skipped_count = 0

            for m in models:
                provider_slug = m.get("provider", {}).get("slug")
                provider_id = await conn.fetchval("SELECT provider_id FROM providers WHERE slug = $1", provider_slug)

                # Parse deprecatedAt ISO string to datetime object
                deprecated_at_dt = parse_iso_datetime(m.get("deprecatedAt"))

                model_id_str = str(m["id"])
                await conn.execute("""
                    INSERT INTO llm_models (
                        model_id, numeric_id, slug, display_name, provider, provider_id, family, model_type, 
                        max_context_tokens, max_output, supports_tools, supports_batch, 
                        supports_caching, supports_streaming, deprecated_at
                    )
                    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
                    ON CONFLICT (model_id) DO UPDATE SET
                        numeric_id = EXCLUDED.numeric_id,
                        slug = EXCLUDED.slug,
                        display_name = EXCLUDED.display_name,
                        provider_id = EXCLUDED.provider_id,
                        max_context_tokens = EXCLUDED.max_context_tokens,
                        max_output = EXCLUDED.max_output,
                        deprecated_at = EXCLUDED.deprecated_at,
                        updated_at = NOW();
                """, 
                    model_id_str, m["id"], m["slug"], m["name"], m.get("provider", {}).get("name", "Unknown"),
                    provider_id, m.get("family"), m.get("modelType"), m.get("contextWindow", 128000),
                    m.get("maxOutput"), m.get("supportsTools", False), m.get("supportsBatch", False),
                    m.get("supportsCaching", False), m.get("supportsStreaming", False), deprecated_at_dt
                )

                # 3. CDC Deduplicated Insert into llm_prices
                prices = m.get("prices", [])
                for pr in prices:
                    tier = pr.get("processingTier") or "standard"
                    tier_label = pr.get("tierLabel") or "default"
                    if tier_label.startswith("{priceOf!"):
                        tier_label = "standard_tier"

                    current_hash = compute_price_hash(pr)

                    # Check latest hash for this model & tier
                    last_hash = await conn.fetchval("""
                        SELECT price_hash FROM llm_prices
                        WHERE model_id = $1 AND processing_tier = $2 AND tier_label = $3
                        ORDER BY recorded_at DESC LIMIT 1
                    """, model_id_str, tier, tier_label)

                    if last_hash != current_hash:
                        await conn.execute("""
                            INSERT INTO llm_prices (
                                model_id, processing_tier, tier_label, price_unit,
                                input_price_per_1m, output_price_per_1m, cached_input_price_per_1m,
                                thinking_output_price_per_1m, image_price, video_price_per_second, price_hash
                            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
                        """,
                            model_id_str, tier, tier_label, pr.get("priceUnit") or "USD",
                            pr.get("inputPricePerMillion") or 0.0,
                            pr.get("outputPricePerMillion") or 0.0,
                            pr.get("cachedInputPricePerMillion"),
                            pr.get("thinkingOutputPricePerMillion"),
                            pr.get("imagePrice"),
                            pr.get("videoPricePerSecond"),
                            current_hash
                        )
                        inserted_count += 1
                    else:
                        skipped_count += 1

            print(f"✅ Sync completed successfully: {inserted_count} price updates written, {skipped_count} duplicate records skipped.")

    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(sync_daily_llm_prices(DATASET_URL))