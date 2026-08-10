-- Table 1: Monthly AI Customs Trade Data
CREATE TABLE ai_customs_monthly (
    data_month TEXT PRIMARY KEY,
    currency TEXT NOT NULL DEFAULT 'USD',
    ai_hardware_total_import BIGINT NOT NULL,
    ai_hardware_total_export BIGINT NOT NULL,
    import_mom_pct NUMERIC(6,2) NOT NULL,
    export_mom_pct NUMERIC(6,2) NOT NULL,
    import_ytd_sum_h1 BIGINT,
    export_ytd_sum_h1 BIGINT,
    annualized_import_run_rate BIGINT,
    annualized_export_run_rate BIGINT,
    import_export_divergence_score NUMERIC(8,2),
    update_date TEXT NOT NULL
);
CREATE INDEX idx_month ON ai_customs_monthly(data_month);

-- ---------------

-- Table 2: Future Daily GPU/RAM Prices
CREATE TABLE hardware_daily_prices (
    ticker TEXT,
    trade_date DATE,
    price_usd NUMERIC(12,2) NOT NULL,
    source TEXT NOT NULL,
    supply_status TEXT,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (ticker, trade_date)
);
CREATE INDEX idx_price_ticker_date ON hardware_daily_prices(ticker, trade_date);

-- ---------------

TRUNCATE TABLE ai_customs_monthly;

WITH imp AS (
    SELECT
        data_month,
        SUM(usd_value) AS total_import
    FROM raw_import_hs
    GROUP BY data_month
),
exp AS (
    SELECT
        data_month,
        SUM(usd_value) AS total_export
    FROM raw_export_hs
    GROUP BY data_month
),
combined AS (
    SELECT
        i.data_month,
        i.total_import,
        e.total_export,
        LAG(i.total_import) OVER (ORDER BY i.data_month) AS prev_import,
        LAG(e.total_export) OVER (ORDER BY i.data_month) AS prev_export
    FROM imp i
    INNER JOIN exp e
        ON i.data_month = e.data_month
)
INSERT INTO ai_customs_monthly (
    data_month,
    ai_hardware_total_import,
    ai_hardware_total_export,
    import_mom_pct,
    export_mom_pct,
    import_export_divergence_score,
    computed_at
)
SELECT
    data_month,
    total_import,
    total_export,
    -- First month will naturally produce NULL
    ROUND(
        ((total_import - prev_import)::NUMERIC / prev_import) * 100,
        2
    ) AS import_mom_pct,
    ROUND(
        ((total_export - prev_export)::NUMERIC / prev_export) * 100,
        2
    ) AS export_mom_pct,
    ROUND(
        ((total_import::NUMERIC / total_export) - 1) * 100,
        2
    ) AS import_export_divergence_score,
    NOW()
FROM combined
ON CONFLICT (data_month) DO UPDATE
SET
    ai_hardware_total_import = EXCLUDED.ai_hardware_total_import,
    ai_hardware_total_export = EXCLUDED.ai_hardware_total_export,
    import_mom_pct = EXCLUDED.import_mom_pct,
    export_mom_pct = EXCLUDED.export_mom_pct,
    import_export_divergence_score = EXCLUDED.import_export_divergence_score,
    computed_at = EXCLUDED.computed_at;

-- ---------------

-- 订阅用户API密钥表
CREATE TABLE subscriber_api_keys (
    id SERIAL PRIMARY KEY,
    api_key TEXT NOT NULL UNIQUE,
    customer_name TEXT,
    customer_email TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    max_requests_daily INT DEFAULT 1000,
    notes TEXT
);

-- X402 发票记录表
CREATE TABLE x402_invoices (
    invoice_id TEXT PRIMARY KEY,
    resource_path TEXT,
    query_params JSONB,
    amount_usdc NUMERIC,
    recipient_wallet TEXT,
    chain_id TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP,
    status TEXT
);

-- X402 已消费发票（防重放）
CREATE TABLE x402_consumed_invoices (
    id SERIAL PRIMARY KEY,
    invoice_id TEXT UNIQUE,
    nonce TEXT,
    tx_hash TEXT,
    consumed_at TIMESTAMP DEFAULT NOW()
);

-- 请求访问日志（区分订阅 / X402流量）
CREATE TABLE api_access_logs (
    id SERIAL PRIMARY KEY,
    access_mode TEXT,
    api_key TEXT,
    x402_proof TEXT,
    path TEXT,
    query_params JSONB,
    accessed_at TIMESTAMP DEFAULT NOW()
);

-- ---------------


CREATE TABLE IF NOT EXISTS x402_payment_audit (
    id BIGSERIAL PRIMARY KEY,
    request_path TEXT NOT NULL,
    payment_header TEXT,
    settle_tx_hash TEXT,
    network_caip2 TEXT NOT NULL,
    asset_contract TEXT NOT NULL,
    amount_atomic TEXT NOT NULL,
    wallet_payto TEXT NOT NULL,
    verify_success BOOLEAN NOT NULL DEFAULT false,
    settle_success BOOLEAN NOT NULL DEFAULT false,
    settle_error TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);