--
-- PostgreSQL database dump
--

\restrict UMxlHsVrmRxsw6aGYXuAIVPR42hzj2UMgemmIocaX4N8WY6PArE1Na2ePYDz0LH

-- Dumped from database version 16.14 (Homebrew)
-- Dumped by pg_dump version 16.14 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ai_customs_monthly; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.ai_customs_monthly (
    data_month text NOT NULL,
    currency text DEFAULT 'USD'::text NOT NULL,
    ai_hardware_total_import bigint NOT NULL,
    ai_hardware_total_export bigint NOT NULL,
    import_mom_pct numeric(6,2),
    export_mom_pct numeric(6,2),
    import_ytd_sum bigint,
    export_ytd_sum bigint,
    annualized_import_run_rate bigint,
    annualized_export_run_rate bigint,
    import_export_divergence_score numeric(8,2),
    computed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ai_customs_monthly OWNER TO trade_app;

--
-- Name: api_access_logs; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.api_access_logs (
    id integer NOT NULL,
    access_mode text,
    api_key text,
    x402_proof text,
    path text,
    query_params jsonb,
    accessed_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.api_access_logs OWNER TO trade_app;

--
-- Name: api_access_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: trade_app
--

CREATE SEQUENCE public.api_access_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.api_access_logs_id_seq OWNER TO trade_app;

--
-- Name: api_access_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trade_app
--

ALTER SEQUENCE public.api_access_logs_id_seq OWNED BY public.api_access_logs.id;


--
-- Name: llm_benchmarks; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.llm_benchmarks (
    id integer NOT NULL,
    model_id text,
    task_type text NOT NULL,
    capability_score numeric(5,2) NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.llm_benchmarks OWNER TO trade_app;

--
-- Name: llm_benchmarks_id_seq; Type: SEQUENCE; Schema: public; Owner: trade_app
--

ALTER TABLE public.llm_benchmarks ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.llm_benchmarks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: llm_models; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.llm_models (
    model_id text NOT NULL,
    provider text NOT NULL,
    display_name text NOT NULL,
    max_context_tokens integer DEFAULT 128000,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.llm_models OWNER TO trade_app;

--
-- Name: llm_prices; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.llm_prices (
    id bigint NOT NULL,
    model_id text,
    input_price_per_1m numeric(16,6) NOT NULL,
    output_price_per_1m numeric(16,6) NOT NULL,
    cached_price_per_1m numeric(16,6) DEFAULT 0,
    recorded_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.llm_prices OWNER TO trade_app;

--
-- Name: llm_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: trade_app
--

ALTER TABLE public.llm_prices ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.llm_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: llm_probes; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.llm_probes (
    id bigint NOT NULL,
    model_id text,
    region text NOT NULL,
    status_code integer NOT NULL,
    ttft_ms integer NOT NULL,
    tokens_per_sec numeric(8,2) NOT NULL,
    error_type text,
    "timestamp" timestamp with time zone DEFAULT now()
);


ALTER TABLE public.llm_probes OWNER TO trade_app;

--
-- Name: llm_probes_id_seq; Type: SEQUENCE; Schema: public; Owner: trade_app
--

ALTER TABLE public.llm_probes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.llm_probes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: raw_export_hs; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.raw_export_hs (
    data_month text NOT NULL,
    hs_code text NOT NULL,
    commodity_name text,
    quantity bigint,
    unit text,
    supplementary_quantity bigint,
    supplementary_unit text,
    usd_value bigint NOT NULL,
    ingested_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.raw_export_hs OWNER TO trade_app;

--
-- Name: raw_import_hs; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.raw_import_hs (
    data_month text NOT NULL,
    hs_code text NOT NULL,
    commodity_name text,
    quantity bigint,
    unit text,
    supplementary_quantity bigint,
    supplementary_unit text,
    usd_value bigint NOT NULL,
    ingested_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.raw_import_hs OWNER TO trade_app;

--
-- Name: subscriber_api_keys; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.subscriber_api_keys (
    id integer NOT NULL,
    api_key text NOT NULL,
    customer_name text,
    customer_email text,
    created_at timestamp without time zone DEFAULT now(),
    expires_at timestamp without time zone,
    is_active boolean DEFAULT true,
    max_requests_daily integer DEFAULT 1000,
    notes text,
    customer_id text
);


ALTER TABLE public.subscriber_api_keys OWNER TO trade_app;

--
-- Name: subscriber_api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: trade_app
--

CREATE SEQUENCE public.subscriber_api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscriber_api_keys_id_seq OWNER TO trade_app;

--
-- Name: subscriber_api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trade_app
--

ALTER SEQUENCE public.subscriber_api_keys_id_seq OWNED BY public.subscriber_api_keys.id;


--
-- Name: v_llm_prices_7d_trends; Type: VIEW; Schema: public; Owner: trade_app
--

CREATE VIEW public.v_llm_prices_7d_trends AS
 WITH latest_prices AS (
         SELECT DISTINCT ON (llm_prices.model_id) llm_prices.model_id,
            llm_prices.input_price_per_1m,
            llm_prices.output_price_per_1m,
            llm_prices.cached_price_per_1m,
            llm_prices.recorded_at
           FROM public.llm_prices
          ORDER BY llm_prices.model_id, llm_prices.recorded_at DESC
        ), past_prices AS (
         SELECT DISTINCT ON (llm_prices.model_id) llm_prices.model_id,
            llm_prices.input_price_per_1m,
            llm_prices.output_price_per_1m
           FROM public.llm_prices
          WHERE (llm_prices.recorded_at <= (now() - '7 days'::interval))
          ORDER BY llm_prices.model_id, llm_prices.recorded_at DESC
        )
 SELECT l.model_id,
    l.input_price_per_1m AS current_input_price,
    l.output_price_per_1m AS current_output_price,
    l.cached_price_per_1m AS current_cached_price,
    l.recorded_at AS last_updated,
    COALESCE(p.input_price_per_1m, l.input_price_per_1m) AS input_price_7d_ago,
    COALESCE(p.output_price_per_1m, l.output_price_per_1m) AS output_price_7d_ago,
        CASE
            WHEN ((p.input_price_per_1m IS NULL) OR (p.input_price_per_1m = (0)::numeric)) THEN 0.0
            ELSE round((((l.input_price_per_1m - p.input_price_per_1m) / p.input_price_per_1m) * (100)::numeric), 2)
        END AS input_change_7d_pct,
        CASE
            WHEN ((p.output_price_per_1m IS NULL) OR (p.output_price_per_1m = (0)::numeric)) THEN 0.0
            ELSE round((((l.output_price_per_1m - p.output_price_per_1m) / p.output_price_per_1m) * (100)::numeric), 2)
        END AS output_change_7d_pct,
        CASE
            WHEN (p.input_price_per_1m IS NULL) THEN 'NEW_MODEL'::text
            WHEN ((l.input_price_per_1m < p.input_price_per_1m) OR (l.output_price_per_1m < p.output_price_per_1m)) THEN 'PRICE_DROP'::text
            WHEN ((l.input_price_per_1m > p.input_price_per_1m) OR (l.output_price_per_1m > p.output_price_per_1m)) THEN 'PRICE_HIKE'::text
            ELSE 'STABLE'::text
        END AS trend_7d
   FROM (latest_prices l
     LEFT JOIN past_prices p ON ((l.model_id = p.model_id)));


ALTER VIEW public.v_llm_prices_7d_trends OWNER TO trade_app;

--
-- Name: x402_consumed_invoices; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.x402_consumed_invoices (
    id integer NOT NULL,
    invoice_id text,
    nonce text,
    tx_hash text,
    consumed_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.x402_consumed_invoices OWNER TO trade_app;

--
-- Name: x402_consumed_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: trade_app
--

CREATE SEQUENCE public.x402_consumed_invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.x402_consumed_invoices_id_seq OWNER TO trade_app;

--
-- Name: x402_consumed_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trade_app
--

ALTER SEQUENCE public.x402_consumed_invoices_id_seq OWNED BY public.x402_consumed_invoices.id;


--
-- Name: x402_invoices; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.x402_invoices (
    invoice_id text NOT NULL,
    resource_path text,
    query_params jsonb,
    amount_usdc numeric,
    recipient_wallet text,
    chain_id text,
    created_at timestamp without time zone DEFAULT now(),
    expires_at timestamp without time zone,
    status text
);


ALTER TABLE public.x402_invoices OWNER TO trade_app;

--
-- Name: x402_payment_audit; Type: TABLE; Schema: public; Owner: trade_app
--

CREATE TABLE public.x402_payment_audit (
    id bigint NOT NULL,
    request_path text NOT NULL,
    payment_header text,
    settle_tx_hash text,
    network_caip2 text NOT NULL,
    asset_contract text NOT NULL,
    amount_atomic text NOT NULL,
    wallet_payto text NOT NULL,
    verify_success boolean DEFAULT false NOT NULL,
    settle_success boolean DEFAULT false NOT NULL,
    settle_error text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.x402_payment_audit OWNER TO trade_app;

--
-- Name: x402_payment_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: trade_app
--

CREATE SEQUENCE public.x402_payment_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.x402_payment_audit_id_seq OWNER TO trade_app;

--
-- Name: x402_payment_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: trade_app
--

ALTER SEQUENCE public.x402_payment_audit_id_seq OWNED BY public.x402_payment_audit.id;


--
-- Name: api_access_logs id; Type: DEFAULT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.api_access_logs ALTER COLUMN id SET DEFAULT nextval('public.api_access_logs_id_seq'::regclass);


--
-- Name: subscriber_api_keys id; Type: DEFAULT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.subscriber_api_keys ALTER COLUMN id SET DEFAULT nextval('public.subscriber_api_keys_id_seq'::regclass);


--
-- Name: x402_consumed_invoices id; Type: DEFAULT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.x402_consumed_invoices ALTER COLUMN id SET DEFAULT nextval('public.x402_consumed_invoices_id_seq'::regclass);


--
-- Name: x402_payment_audit id; Type: DEFAULT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.x402_payment_audit ALTER COLUMN id SET DEFAULT nextval('public.x402_payment_audit_id_seq'::regclass);


--
-- Data for Name: ai_customs_monthly; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.ai_customs_monthly (data_month, currency, ai_hardware_total_import, ai_hardware_total_export, import_mom_pct, export_mom_pct, import_ytd_sum, export_ytd_sum, annualized_import_run_rate, annualized_export_run_rate, import_export_divergence_score, computed_at) FROM stdin;
202101	USD	8512628549	13222319216	\N	\N	\N	\N	\N	\N	-35.62	2026-07-26 10:08:27.730632
202102	USD	7700562454	11511980963	-9.54	-12.94	\N	\N	\N	\N	-33.11	2026-07-26 10:08:27.730632
202103	USD	9653972312	16069372894	25.37	39.59	\N	\N	\N	\N	-39.92	2026-07-26 10:08:27.730632
202104	USD	9356201157	14070396542	-3.08	-12.44	\N	\N	\N	\N	-33.50	2026-07-26 10:08:27.730632
202105	USD	9656594722	14519359093	3.21	3.19	\N	\N	\N	\N	-33.49	2026-07-26 10:08:27.730632
202106	USD	10777246379	16945352591	11.61	16.71	\N	\N	\N	\N	-36.40	2026-07-26 10:08:27.730632
202107	USD	10666780918	14816304287	-1.02	-12.56	\N	\N	\N	\N	-28.01	2026-07-26 10:08:27.730632
202108	USD	11749949281	15363882096	10.15	3.70	\N	\N	\N	\N	-23.52	2026-07-26 10:08:27.730632
202109	USD	11571445325	17839267870	-1.52	16.11	\N	\N	\N	\N	-35.13	2026-07-26 10:08:27.730632
202110	USD	10794778189	14053947458	-6.71	-21.22	\N	\N	\N	\N	-23.19	2026-07-26 10:08:27.730632
202111	USD	12358669550	16936664925	14.49	20.51	\N	\N	\N	\N	-27.03	2026-07-26 10:08:27.730632
202112	USD	12853682961	18914422686	4.01	11.68	\N	\N	\N	\N	-32.04	2026-07-26 10:08:27.730632
202201	USD	11003732659	16451503343	-14.39	-13.02	\N	\N	\N	\N	-33.11	2026-07-26 10:08:27.730632
202202	USD	7878810586	13357194032	-28.40	-18.81	\N	\N	\N	\N	-41.01	2026-07-26 10:08:27.730632
202203	USD	9902911022	17017231803	25.69	27.40	\N	\N	\N	\N	-41.81	2026-07-26 10:08:27.730632
202204	USD	8317254128	15614004020	-16.01	-8.25	\N	\N	\N	\N	-46.73	2026-07-26 10:08:27.730632
202205	USD	8374209103	14153512450	0.68	-9.35	\N	\N	\N	\N	-40.83	2026-07-26 10:08:27.730632
202206	USD	9565456654	15824663753	14.23	11.81	\N	\N	\N	\N	-39.55	2026-07-26 10:08:27.730632
202207	USD	9095491409	14873604722	-4.91	-6.01	\N	\N	\N	\N	-38.85	2026-07-26 10:08:27.730632
202208	USD	8029273890	13762249016	-11.72	-7.47	\N	\N	\N	\N	-41.66	2026-07-26 10:08:27.730632
202209	USD	9494344139	16677185961	18.25	21.18	\N	\N	\N	\N	-43.07	2026-07-26 10:08:27.730632
202210	USD	7201438154	15307783630	-24.15	-8.21	\N	\N	\N	\N	-52.96	2026-07-26 10:08:27.730632
202211	USD	6734329705	13319029242	-6.49	-12.99	\N	\N	\N	\N	-49.44	2026-07-26 10:08:27.730632
202212	USD	7891275423	15167010740	17.18	13.87	\N	\N	\N	\N	-47.97	2026-07-26 10:08:27.730632
202301	USD	5095046191	10906705542	-35.43	-28.09	\N	\N	\N	\N	-53.29	2026-07-26 10:08:27.730632
202302	USD	5857868410	11608365720	14.97	6.43	\N	\N	\N	\N	-49.54	2026-07-26 10:08:27.730632
202303	USD	6657751627	15198643325	13.65	30.93	\N	\N	\N	\N	-56.20	2026-07-26 10:08:27.730632
202304	USD	6574563030	12416374662	-1.25	-18.31	\N	\N	\N	\N	-47.05	2026-07-26 10:08:27.730632
202305	USD	6262616771	12386541955	-4.74	-0.24	\N	\N	\N	\N	-49.44	2026-07-26 10:08:27.730632
202306	USD	7403272806	14429860457	18.21	16.50	\N	\N	\N	\N	-48.69	2026-07-26 10:08:27.730632
202307	USD	6485007434	13296490897	-12.40	-7.85	\N	\N	\N	\N	-51.23	2026-07-26 10:08:27.730632
202308	USD	6485249260	14006150561	0.00	5.34	\N	\N	\N	\N	-53.70	2026-07-26 10:08:27.730632
202309	USD	7930808173	14407076344	22.29	2.86	\N	\N	\N	\N	-44.95	2026-07-26 10:08:27.730632
202310	USD	6398385054	14600613056	-19.32	1.34	\N	\N	\N	\N	-56.18	2026-07-26 10:08:27.730632
202311	USD	7405058330	15030328822	15.73	2.94	\N	\N	\N	\N	-50.73	2026-07-26 10:08:27.730632
202312	USD	8407076350	15171998711	13.53	0.94	\N	\N	\N	\N	-44.59	2026-07-26 10:08:27.730632
202401	USD	7121777647	13416199506	-15.29	-11.57	\N	\N	\N	\N	-46.92	2026-07-26 10:08:27.730632
202402	USD	7061869623	10933835228	-0.84	-18.50	\N	\N	\N	\N	-35.41	2026-07-26 10:08:27.730632
202403	USD	8881717168	14020373661	25.77	28.23	\N	\N	\N	\N	-36.65	2026-07-26 10:08:27.730632
202404	USD	8066420587	14429746137	-9.18	2.92	\N	\N	\N	\N	-44.10	2026-07-26 10:08:27.730632
202405	USD	8412892702	14047534324	4.30	-2.65	\N	\N	\N	\N	-40.11	2026-07-26 10:08:27.730632
202406	USD	8370859498	14520442002	-0.50	3.37	\N	\N	\N	\N	-42.35	2026-07-26 10:08:27.730632
202407	USD	8394642735	15264539468	0.28	5.12	\N	\N	\N	\N	-45.01	2026-07-26 10:08:27.730632
202408	USD	7675662478	15504801089	-8.56	1.57	\N	\N	\N	\N	-50.49	2026-07-26 10:08:27.730632
202409	USD	7845521408	17636953557	2.21	13.75	\N	\N	\N	\N	-55.52	2026-07-26 10:08:27.730632
202410	USD	7721792806	16222843792	-1.58	-8.02	\N	\N	\N	\N	-52.40	2026-07-26 10:08:27.730632
202411	USD	7522297032	16552305732	-2.58	2.03	\N	\N	\N	\N	-54.55	2026-07-26 10:08:27.730632
202412	USD	8377809771	17873356462	11.37	7.98	\N	\N	\N	\N	-53.13	2026-07-26 10:08:27.730632
202501	USD	7039375243	14639865307	-15.98	-18.09	\N	\N	\N	\N	-51.92	2026-07-26 10:08:27.730632
202502	USD	5876809237	12895630236	-16.52	-11.91	\N	\N	\N	\N	-54.43	2026-07-26 10:08:27.730632
202503	USD	7992760527	16899572598	36.01	31.05	\N	\N	\N	\N	-52.70	2026-07-26 10:08:27.730632
202504	USD	8766866095	17667757112	9.69	4.55	\N	\N	\N	\N	-50.38	2026-07-26 10:08:27.730632
202505	USD	9002080405	18507707867	2.68	4.75	\N	\N	\N	\N	-51.36	2026-07-26 10:08:27.730632
202506	USD	9361067393	17601292707	3.99	-4.90	\N	\N	\N	\N	-46.82	2026-07-26 10:08:27.730632
202507	USD	10222719189	17459266995	9.20	-0.81	\N	\N	\N	\N	-41.45	2026-07-26 10:08:27.730632
202508	USD	10045405495	16425378676	-1.73	-5.92	\N	\N	\N	\N	-38.84	2026-07-26 10:08:27.730632
202509	USD	10601444938	18916552730	5.54	15.17	\N	\N	\N	\N	-43.96	2026-07-26 10:08:27.730632
202510	USD	10576175741	16937831536	-0.24	-10.46	\N	\N	\N	\N	-37.56	2026-07-26 10:08:27.730632
202511	USD	12034423965	16548536577	13.79	-2.30	\N	\N	\N	\N	-27.28	2026-07-26 10:08:27.730632
202512	USD	14164811622	17985447654	17.70	8.68	\N	\N	\N	\N	-21.24	2026-07-26 10:08:27.730632
202601	USD	15890936388	8079824593	12.19	-55.08	\N	\N	\N	\N	96.67	2026-07-26 10:08:27.730632
202602	USD	16759739568	5777605193	5.47	-28.49	\N	\N	\N	\N	190.08	2026-07-26 10:08:27.730632
202603	USD	23499499580	8102442590	40.21	40.24	\N	\N	\N	\N	190.03	2026-07-26 10:08:27.730632
202604	USD	26980103482	7895490089	14.81	-2.55	\N	\N	\N	\N	241.72	2026-07-26 10:08:27.730632
202605	USD	30932679917	7908705218	14.65	0.17	\N	\N	\N	\N	291.12	2026-07-26 10:08:27.730632
202606	USD	32237966821	8570623488	4.22	8.37	\N	\N	\N	\N	276.14	2026-07-26 10:08:27.730632
\.


--
-- Data for Name: api_access_logs; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.api_access_logs (id, access_mode, api_key, x402_proof, path, query_params, accessed_at) FROM stdin;
\.


--
-- Data for Name: llm_benchmarks; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.llm_benchmarks (id, model_id, task_type, capability_score, updated_at) FROM stdin;
\.


--
-- Data for Name: llm_models; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.llm_models (model_id, provider, display_name, max_context_tokens, is_active, created_at) FROM stdin;
azure_ai/FW-DeepSeek-V3.2	Azure_ai	azure_ai/FW-DeepSeek-V3.2	128000	t	2026-09-16 22:14:42.85832
azure_ai/FW-DeepSeek-V4-Pro	Azure_ai	azure_ai/FW-DeepSeek-V4-Pro	128000	t	2026-09-16 22:14:42.889559
azure_ai/FW-GLM-5	Azure_ai	azure_ai/FW-GLM-5	128000	t	2026-09-16 22:14:42.890898
azure_ai/FW-GLM-5.1	Azure_ai	azure_ai/FW-GLM-5.1	128000	t	2026-09-16 22:14:42.891796
azure_ai/FW-GLM-5.2	Azure_ai	azure_ai/FW-GLM-5.2	128000	t	2026-09-16 22:14:42.894477
azure_ai/FW-GLM-5.2-Fast	Azure_ai	azure_ai/FW-GLM-5.2-Fast	128000	t	2026-09-16 22:14:42.895338
azure_ai/FW-Kimi-K2.5	Azure_ai	azure_ai/FW-Kimi-K2.5	128000	t	2026-09-16 22:14:42.896664
azure_ai/FW-Kimi-K2.6	Azure_ai	azure_ai/FW-Kimi-K2.6	128000	t	2026-09-16 22:14:42.897378
azure_ai/FW-Kimi-K2.7-Code	Azure_ai	azure_ai/FW-Kimi-K2.7-Code	128000	t	2026-09-16 22:14:42.898381
azure_ai/FW-Kimi-K3	Azure_ai	azure_ai/FW-Kimi-K3	128000	t	2026-09-16 22:14:42.899112
azure_ai/FW-MiniMax-M2.5	Azure_ai	azure_ai/FW-MiniMax-M2.5	128000	t	2026-09-16 22:14:42.899802
azure_ai/FW-MiniMax-M3	Azure_ai	azure_ai/FW-MiniMax-M3	128000	t	2026-09-16 22:14:42.900496
azure_ai/deepseek-v3.2	Azure_ai	azure_ai/deepseek-v3.2	128000	t	2026-09-16 22:14:42.901272
azure_ai/deepseek-v3.2-speciale	Azure_ai	azure_ai/deepseek-v3.2-speciale	128000	t	2026-09-16 22:14:42.90201
azure_ai/deepseek-r1	Azure_ai	azure_ai/deepseek-r1	128000	t	2026-09-16 22:14:42.902737
azure_ai/deepseek-v3	Azure_ai	azure_ai/deepseek-v3	128000	t	2026-09-16 22:14:42.903511
azure_ai/deepseek-v3-0324	Azure_ai	azure_ai/deepseek-v3-0324	128000	t	2026-09-16 22:14:42.904277
azure_ai/deepseek-v3.1	Azure_ai	azure_ai/deepseek-v3.1	128000	t	2026-09-16 22:14:42.905084
azure_ai/deepseek-v4-pro	Azure_ai	azure_ai/deepseek-v4-pro	128000	t	2026-09-16 22:14:42.905824
azure_ai/deepseek-v4-flash	Azure_ai	azure_ai/deepseek-v4-flash	128000	t	2026-09-16 22:14:42.906545
azure_ai/DeepSeek-V4-Flash-0731	Azure_ai	azure_ai/DeepSeek-V4-Flash-0731	128000	t	2026-09-16 22:14:42.907214
azure_ai/kimi-k2.5	Azure_ai	azure_ai/kimi-k2.5	128000	t	2026-09-16 22:14:42.907998
azure_ai/kimi-k2.6	Azure_ai	azure_ai/kimi-k2.6	128000	t	2026-09-16 22:14:42.908729
bedrock/ap-northeast-1/deepseek.v3.2	Bedrock	bedrock/ap-northeast-1/deepseek.v3.2	128000	t	2026-09-16 22:14:42.910235
bedrock/ap-northeast-1/minimax.minimax-m2.1	Bedrock	bedrock/ap-northeast-1/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.910974
bedrock/ap-northeast-1/minimax.minimax-m2.5	Bedrock	bedrock/ap-northeast-1/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.91186
bedrock/ap-northeast-1/moonshotai.kimi-k2-thinking	Bedrock	bedrock/ap-northeast-1/moonshotai.kimi-k2-thinking	128000	t	2026-09-16 22:14:42.91249
bedrock/ap-northeast-1/moonshotai.kimi-k2.5	Bedrock	bedrock/ap-northeast-1/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.913073
bedrock/ap-northeast-1/qwen.qwen3-coder-next	Bedrock	bedrock/ap-northeast-1/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.913677
bedrock/moonshotai.kimi-k2-thinking	Bedrock	bedrock/moonshotai.kimi-k2-thinking	128000	t	2026-09-16 22:14:42.914516
bedrock/moonshotai.kimi-k2.5	Bedrock	bedrock/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.915187
bedrock/ap-south-1/deepseek.v3.2	Bedrock	bedrock/ap-south-1/deepseek.v3.2	128000	t	2026-09-16 22:14:42.915817
bedrock/ap-south-1/minimax.minimax-m2.1	Bedrock	bedrock/ap-south-1/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.916447
bedrock/ap-south-1/minimax.minimax-m2.5	Bedrock	bedrock/ap-south-1/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.917072
bedrock/ap-south-1/moonshotai.kimi-k2-thinking	Bedrock	bedrock/ap-south-1/moonshotai.kimi-k2-thinking	128000	t	2026-09-16 22:14:42.917692
bedrock/ap-south-1/moonshotai.kimi-k2.5	Bedrock	bedrock/ap-south-1/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.918362
bedrock/ap-south-1/qwen.qwen3-coder-next	Bedrock	bedrock/ap-south-1/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.919109
bedrock/ap-southeast-2/minimax.minimax-m2.5	Bedrock	bedrock/ap-southeast-2/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.91977
bedrock/ap-southeast-3/deepseek.v3.2	Bedrock	bedrock/ap-southeast-3/deepseek.v3.2	128000	t	2026-09-16 22:14:42.920466
bedrock/ap-southeast-3/minimax.minimax-m2.1	Bedrock	bedrock/ap-southeast-3/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.921039
bedrock/ap-southeast-3/minimax.minimax-m2.5	Bedrock	bedrock/ap-southeast-3/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.921538
bedrock/ap-southeast-3/moonshotai.kimi-k2.5	Bedrock	bedrock/ap-southeast-3/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.922031
bedrock/ap-southeast-3/qwen.qwen3-coder-next	Bedrock	bedrock/ap-southeast-3/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.922517
bedrock/eu-north-1/deepseek.v3.2	Bedrock	bedrock/eu-north-1/deepseek.v3.2	128000	t	2026-09-16 22:14:42.92298
bedrock/eu-north-1/minimax.minimax-m2.1	Bedrock	bedrock/eu-north-1/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.923487
bedrock/eu-north-1/minimax.minimax-m2.5	Bedrock	bedrock/eu-north-1/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.923982
bedrock/eu-north-1/moonshotai.kimi-k2.5	Bedrock	bedrock/eu-north-1/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.924648
bedrock/eu-central-1/minimax.minimax-m2.1	Bedrock	bedrock/eu-central-1/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.925193
bedrock/eu-central-1/minimax.minimax-m2.5	Bedrock	bedrock/eu-central-1/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.92566
bedrock/eu-central-1/qwen.qwen3-coder-next	Bedrock	bedrock/eu-central-1/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.926632
bedrock/eu-west-1/minimax.minimax-m2.1	Bedrock	bedrock/eu-west-1/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.927463
bedrock/eu-west-1/minimax.minimax-m2.5	Bedrock	bedrock/eu-west-1/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.927981
bedrock/eu-west-1/qwen.qwen3-coder-next	Bedrock	bedrock/eu-west-1/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.928438
bedrock/eu-west-2/minimax.minimax-m2.1	Bedrock	bedrock/eu-west-2/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.928869
bedrock/eu-west-2/minimax.minimax-m2.5	Bedrock	bedrock/eu-west-2/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.929287
bedrock/eu-west-2/qwen.qwen3-coder-next	Bedrock	bedrock/eu-west-2/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.929696
bedrock/eu-south-1/minimax.minimax-m2.1	Bedrock	bedrock/eu-south-1/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.93011
bedrock/eu-south-1/minimax.minimax-m2.5	Bedrock	bedrock/eu-south-1/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.930618
bedrock/eu-south-1/qwen.qwen3-coder-next	Bedrock	bedrock/eu-south-1/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.931065
bedrock/sa-east-1/deepseek.v3.2	Bedrock	bedrock/sa-east-1/deepseek.v3.2	128000	t	2026-09-16 22:14:42.93152
bedrock/sa-east-1/minimax.minimax-m2.1	Bedrock	bedrock/sa-east-1/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.931948
bedrock/sa-east-1/minimax.minimax-m2.5	Bedrock	bedrock/sa-east-1/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.932413
bedrock/sa-east-1/moonshotai.kimi-k2-thinking	Bedrock	bedrock/sa-east-1/moonshotai.kimi-k2-thinking	128000	t	2026-09-16 22:14:42.932741
bedrock/sa-east-1/moonshotai.kimi-k2.5	Bedrock	bedrock/sa-east-1/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.933083
bedrock/sa-east-1/qwen.qwen3-coder-next	Bedrock	bedrock/sa-east-1/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.933441
moonshot/kimi-k2.5	Moonshot	moonshot/kimi-k2.5	128000	t	2026-09-16 22:14:43.045919
bedrock/us-east-1/deepseek.v3.2	Bedrock	bedrock/us-east-1/deepseek.v3.2	128000	t	2026-09-16 22:14:42.933795
bedrock/us-east-1/minimax.minimax-m2.1	Bedrock	bedrock/us-east-1/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.935096
bedrock/us-east-1/minimax.minimax-m2.5	Bedrock	bedrock/us-east-1/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.935532
bedrock/us-east-1/moonshotai.kimi-k2-thinking	Bedrock	bedrock/us-east-1/moonshotai.kimi-k2-thinking	128000	t	2026-09-16 22:14:42.936032
bedrock/us-east-1/moonshotai.kimi-k2.5	Bedrock	bedrock/us-east-1/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.936367
bedrock/us-east-1/qwen.qwen3-coder-next	Bedrock	bedrock/us-east-1/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.936701
bedrock/us-east-2/deepseek.v3.2	Bedrock	bedrock/us-east-2/deepseek.v3.2	128000	t	2026-09-16 22:14:42.937067
bedrock/us-east-2/minimax.minimax-m2.1	Bedrock	bedrock/us-east-2/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.937398
bedrock/us-east-2/minimax.minimax-m2.5	Bedrock	bedrock/us-east-2/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.937726
bedrock/us-east-2/moonshotai.kimi-k2-thinking	Bedrock	bedrock/us-east-2/moonshotai.kimi-k2-thinking	128000	t	2026-09-16 22:14:42.938074
bedrock/us-east-2/moonshotai.kimi-k2.5	Bedrock	bedrock/us-east-2/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.938406
bedrock/us-east-2/qwen.qwen3-coder-next	Bedrock	bedrock/us-east-2/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.938756
bedrock/us-west-2/deepseek.v3.2	Bedrock	bedrock/us-west-2/deepseek.v3.2	128000	t	2026-09-16 22:14:42.939116
bedrock/us-west-2/minimax.minimax-m2.1	Bedrock	bedrock/us-west-2/minimax.minimax-m2.1	128000	t	2026-09-16 22:14:42.939443
bedrock/us-west-2/minimax.minimax-m2.5	Bedrock	bedrock/us-west-2/minimax.minimax-m2.5	128000	t	2026-09-16 22:14:42.939776
bedrock/us-west-2/moonshotai.kimi-k2-thinking	Bedrock	bedrock/us-west-2/moonshotai.kimi-k2-thinking	128000	t	2026-09-16 22:14:42.94011
bedrock/us-west-2/moonshotai.kimi-k2.5	Bedrock	bedrock/us-west-2/moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:42.9404
bedrock/us-west-2/qwen.qwen3-coder-next	Bedrock	bedrock/us-west-2/qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:42.940711
cerebras/qwen-3-32b	Cerebras	cerebras/qwen-3-32b	128000	t	2026-09-16 22:14:42.94104
cerebras/zai-glm-4.6	Cerebras	cerebras/zai-glm-4.6	128000	t	2026-09-16 22:14:42.94167
cerebras/zai-glm-4.7	Cerebras	cerebras/zai-glm-4.7	128000	t	2026-09-16 22:14:42.94198
cerebras/qwen-3.8-27b	Cerebras	cerebras/qwen-3.8-27b	128000	t	2026-09-16 22:14:42.942264
cloudflare/@cf/moonshotai/kimi-k2.7-code	Cloudflare	cloudflare/@cf/moonshotai/kimi-k2.7-code	128000	t	2026-09-16 22:14:42.942584
cloudflare/@cf/deepseek-ai/deepseek-r1-distill-qwen-32b	Cloudflare	cloudflare/@cf/deepseek-ai/deepseek-r1-distill-qwen-32b	128000	t	2026-09-16 22:14:42.942874
cloudflare/@cf/moonshotai/kimi-k2.6	Cloudflare	cloudflare/@cf/moonshotai/kimi-k2.6	128000	t	2026-09-16 22:14:42.943164
cloudflare/@cf/zai-org/glm-4.7-flash	Cloudflare	cloudflare/@cf/zai-org/glm-4.7-flash	128000	t	2026-09-16 22:14:42.94346
cloudflare/@cf/qwen/qwen2.5-coder-32b-instruct	Cloudflare	cloudflare/@cf/qwen/qwen2.5-coder-32b-instruct	128000	t	2026-09-16 22:14:42.9439
cloudflare/@cf/zai-org/glm-5.2	Cloudflare	cloudflare/@cf/zai-org/glm-5.2	128000	t	2026-09-16 22:14:42.944285
cloudflare/@cf/qwen/qwen3-30b-a3b-fp8	Cloudflare	cloudflare/@cf/qwen/qwen3-30b-a3b-fp8	128000	t	2026-09-16 22:14:42.944589
cloudflare/@cf/qwen/qwq-32b	Cloudflare	cloudflare/@cf/qwen/qwq-32b	128000	t	2026-09-16 22:14:42.944897
deepseek-chat	Chinese AI	deepseek-chat	128000	t	2026-09-16 22:14:42.945215
deepseek-reasoner	Chinese AI	deepseek-reasoner	128000	t	2026-09-16 22:14:42.945522
dashscope/deepseek-v4-flash	Dashscope	dashscope/deepseek-v4-flash	128000	t	2026-09-16 22:14:42.945858
dashscope/deepseek-v4-flash-0731	Dashscope	dashscope/deepseek-v4-flash-0731	128000	t	2026-09-16 22:14:42.946184
dashscope/deepseek-v4-pro	Dashscope	dashscope/deepseek-v4-pro	128000	t	2026-09-16 22:14:42.946496
dashscope/glm-5.1	Dashscope	dashscope/glm-5.1	128000	t	2026-09-16 22:14:42.946806
dashscope/glm-5.2	Dashscope	dashscope/glm-5.2	128000	t	2026-09-16 22:14:42.947158
dashscope/kimi-k2.7-code	Dashscope	dashscope/kimi-k2.7-code	128000	t	2026-09-16 22:14:42.947495
dashscope/qwen-coder	Dashscope	dashscope/qwen-coder	128000	t	2026-09-16 22:14:42.947858
dashscope/qwen-flash	Dashscope	dashscope/qwen-flash	128000	t	2026-09-16 22:14:42.948195
dashscope/qwen-flash-2025-07-28	Dashscope	dashscope/qwen-flash-2025-07-28	128000	t	2026-09-16 22:14:42.94847
dashscope/qwen-max	Dashscope	dashscope/qwen-max	128000	t	2026-09-16 22:14:42.948773
dashscope/qwen-plus	Dashscope	dashscope/qwen-plus	128000	t	2026-09-16 22:14:42.949052
dashscope/qwen-plus-2025-01-25	Dashscope	dashscope/qwen-plus-2025-01-25	128000	t	2026-09-16 22:14:42.949338
dashscope/qwen-plus-2025-04-28	Dashscope	dashscope/qwen-plus-2025-04-28	128000	t	2026-09-16 22:14:42.949648
dashscope/qwen-plus-2025-07-14	Dashscope	dashscope/qwen-plus-2025-07-14	128000	t	2026-09-16 22:14:42.94993
dashscope/qwen-plus-2025-07-28	Dashscope	dashscope/qwen-plus-2025-07-28	128000	t	2026-09-16 22:14:42.950211
dashscope/qwen-plus-2025-09-11	Dashscope	dashscope/qwen-plus-2025-09-11	128000	t	2026-09-16 22:14:42.950518
dashscope/qwen-plus-latest	Dashscope	dashscope/qwen-plus-latest	128000	t	2026-09-16 22:14:42.950847
dashscope/qwen-turbo	Dashscope	dashscope/qwen-turbo	128000	t	2026-09-16 22:14:42.951336
dashscope/qwen-turbo-2024-11-01	Dashscope	dashscope/qwen-turbo-2024-11-01	128000	t	2026-09-16 22:14:42.951667
dashscope/qwen-turbo-2025-04-28	Dashscope	dashscope/qwen-turbo-2025-04-28	128000	t	2026-09-16 22:14:42.951995
dashscope/qwen-turbo-latest	Dashscope	dashscope/qwen-turbo-latest	128000	t	2026-09-16 22:14:42.952386
dashscope/qwen3-30b-a3b	Dashscope	dashscope/qwen3-30b-a3b	128000	t	2026-09-16 22:14:42.952708
dashscope/qwen3-coder-flash	Dashscope	dashscope/qwen3-coder-flash	128000	t	2026-09-16 22:14:42.953023
dashscope/qwen3-coder-flash-2025-07-28	Dashscope	dashscope/qwen3-coder-flash-2025-07-28	128000	t	2026-09-16 22:14:42.953347
dashscope/qwen3-coder-plus	Dashscope	dashscope/qwen3-coder-plus	128000	t	2026-09-16 22:14:42.953676
dashscope/qwen3-coder-plus-2025-07-22	Dashscope	dashscope/qwen3-coder-plus-2025-07-22	128000	t	2026-09-16 22:14:42.954015
dashscope/qwen3-max-preview	Dashscope	dashscope/qwen3-max-preview	128000	t	2026-09-16 22:14:42.954348
dashscope/qwen3-max	Dashscope	dashscope/qwen3-max	128000	t	2026-09-16 22:14:42.954677
dashscope/qwen3-max-2026-01-23	Dashscope	dashscope/qwen3-max-2026-01-23	128000	t	2026-09-16 22:14:42.954996
dashscope/qwen3-next-80b-a3b-instruct	Dashscope	dashscope/qwen3-next-80b-a3b-instruct	128000	t	2026-09-16 22:14:42.955337
dashscope/qwen3-next-80b-a3b-thinking	Dashscope	dashscope/qwen3-next-80b-a3b-thinking	128000	t	2026-09-16 22:14:42.955698
dashscope/qwen3-vl-235b-a22b-instruct	Dashscope	dashscope/qwen3-vl-235b-a22b-instruct	128000	t	2026-09-16 22:14:42.956034
dashscope/qwen3-vl-235b-a22b-thinking	Dashscope	dashscope/qwen3-vl-235b-a22b-thinking	128000	t	2026-09-16 22:14:42.956365
dashscope/qwen3-vl-32b-instruct	Dashscope	dashscope/qwen3-vl-32b-instruct	128000	t	2026-09-16 22:14:42.956693
dashscope/qwen3-vl-32b-thinking	Dashscope	dashscope/qwen3-vl-32b-thinking	128000	t	2026-09-16 22:14:42.957022
moonshot/kimi-k2.6	Moonshot	moonshot/kimi-k2.6	128000	t	2026-09-16 22:14:43.046219
dashscope/qwen3-vl-plus	Dashscope	dashscope/qwen3-vl-plus	128000	t	2026-09-16 22:14:42.957303
dashscope/qwen3.5-plus	Dashscope	dashscope/qwen3.5-plus	128000	t	2026-09-16 22:14:42.958672
dashscope/qwen3.7-max	Dashscope	dashscope/qwen3.7-max	128000	t	2026-09-16 22:14:42.958949
dashscope/qwen3.7-plus	Dashscope	dashscope/qwen3.7-plus	128000	t	2026-09-16 22:14:42.95924
dashscope/qwen3.8-max	Dashscope	dashscope/qwen3.8-max	128000	t	2026-09-16 22:14:42.959526
dashscope/qwen-image-2.0	Dashscope	dashscope/qwen-image-2.0	128000	t	2026-09-16 22:14:42.959859
dashscope/qwen-image-2.0-pro	Dashscope	dashscope/qwen-image-2.0-pro	128000	t	2026-09-16 22:14:42.960339
dashscope/qwen-image-3.0	Dashscope	dashscope/qwen-image-3.0	128000	t	2026-09-16 22:14:42.960641
dashscope/qwen-image-3.0-pro	Dashscope	dashscope/qwen-image-3.0-pro	128000	t	2026-09-16 22:14:42.96093
qwencloud/deepseek-v4-flash	Qwencloud	qwencloud/deepseek-v4-flash	128000	t	2026-09-16 22:14:42.961222
qwencloud/deepseek-v4-flash-0731	Qwencloud	qwencloud/deepseek-v4-flash-0731	128000	t	2026-09-16 22:14:42.961511
qwencloud/deepseek-v4-pro	Qwencloud	qwencloud/deepseek-v4-pro	128000	t	2026-09-16 22:14:42.961802
qwencloud/glm-5.1	Qwencloud	qwencloud/glm-5.1	128000	t	2026-09-16 22:14:42.962101
qwencloud/glm-5.2	Qwencloud	qwencloud/glm-5.2	128000	t	2026-09-16 22:14:42.962385
qwencloud/kimi-k2.7-code	Qwencloud	qwencloud/kimi-k2.7-code	128000	t	2026-09-16 22:14:42.962663
qwencloud/qwen-coder	Qwencloud	qwencloud/qwen-coder	128000	t	2026-09-16 22:14:42.962953
qwencloud/qwen-flash	Qwencloud	qwencloud/qwen-flash	128000	t	2026-09-16 22:14:42.963252
qwencloud/qwen-flash-2025-07-28	Qwencloud	qwencloud/qwen-flash-2025-07-28	128000	t	2026-09-16 22:14:42.963899
qwencloud/qwen-max	Qwencloud	qwencloud/qwen-max	128000	t	2026-09-16 22:14:42.964224
qwencloud/qwen-plus	Qwencloud	qwencloud/qwen-plus	128000	t	2026-09-16 22:14:42.964506
qwencloud/qwen-plus-2025-01-25	Qwencloud	qwencloud/qwen-plus-2025-01-25	128000	t	2026-09-16 22:14:42.96481
qwencloud/qwen-plus-2025-04-28	Qwencloud	qwencloud/qwen-plus-2025-04-28	128000	t	2026-09-16 22:14:42.965129
qwencloud/qwen-plus-2025-07-14	Qwencloud	qwencloud/qwen-plus-2025-07-14	128000	t	2026-09-16 22:14:42.965457
qwencloud/qwen-plus-2025-07-28	Qwencloud	qwencloud/qwen-plus-2025-07-28	128000	t	2026-09-16 22:14:42.965791
qwencloud/qwen-plus-2025-09-11	Qwencloud	qwencloud/qwen-plus-2025-09-11	128000	t	2026-09-16 22:14:42.966115
qwencloud/qwen-plus-latest	Qwencloud	qwencloud/qwen-plus-latest	128000	t	2026-09-16 22:14:42.96643
qwencloud/qwen-turbo	Qwencloud	qwencloud/qwen-turbo	128000	t	2026-09-16 22:14:42.96678
qwencloud/qwen-turbo-2024-11-01	Qwencloud	qwencloud/qwen-turbo-2024-11-01	128000	t	2026-09-16 22:14:42.967091
qwencloud/qwen-turbo-2025-04-28	Qwencloud	qwencloud/qwen-turbo-2025-04-28	128000	t	2026-09-16 22:14:42.967582
qwencloud/qwen-turbo-latest	Qwencloud	qwencloud/qwen-turbo-latest	128000	t	2026-09-16 22:14:42.967905
qwencloud/qwen3-30b-a3b	Qwencloud	qwencloud/qwen3-30b-a3b	128000	t	2026-09-16 22:14:42.968233
qwencloud/qwen3-coder-flash	Qwencloud	qwencloud/qwen3-coder-flash	128000	t	2026-09-16 22:14:42.96856
qwencloud/qwen3-coder-flash-2025-07-28	Qwencloud	qwencloud/qwen3-coder-flash-2025-07-28	128000	t	2026-09-16 22:14:42.96887
qwencloud/qwen3-coder-plus	Qwencloud	qwencloud/qwen3-coder-plus	128000	t	2026-09-16 22:14:42.969186
qwencloud/qwen3-coder-plus-2025-07-22	Qwencloud	qwencloud/qwen3-coder-plus-2025-07-22	128000	t	2026-09-16 22:14:42.969503
qwencloud/qwen3-max-preview	Qwencloud	qwencloud/qwen3-max-preview	128000	t	2026-09-16 22:14:42.969826
qwencloud/qwen3-max	Qwencloud	qwencloud/qwen3-max	128000	t	2026-09-16 22:14:42.970148
qwencloud/qwen3-max-2026-01-23	Qwencloud	qwencloud/qwen3-max-2026-01-23	128000	t	2026-09-16 22:14:42.970459
qwencloud/qwen3-next-80b-a3b-instruct	Qwencloud	qwencloud/qwen3-next-80b-a3b-instruct	128000	t	2026-09-16 22:14:42.970767
qwencloud/qwen3-next-80b-a3b-thinking	Qwencloud	qwencloud/qwen3-next-80b-a3b-thinking	128000	t	2026-09-16 22:14:42.971091
qwencloud/qwen3-vl-235b-a22b-instruct	Qwencloud	qwencloud/qwen3-vl-235b-a22b-instruct	128000	t	2026-09-16 22:14:42.971413
qwencloud/qwen3-vl-235b-a22b-thinking	Qwencloud	qwencloud/qwen3-vl-235b-a22b-thinking	128000	t	2026-09-16 22:14:42.971731
qwencloud/qwen3-vl-32b-instruct	Qwencloud	qwencloud/qwen3-vl-32b-instruct	128000	t	2026-09-16 22:14:42.972065
qwencloud/qwen3-vl-32b-thinking	Qwencloud	qwencloud/qwen3-vl-32b-thinking	128000	t	2026-09-16 22:14:42.972428
qwencloud/qwen3-vl-plus	Qwencloud	qwencloud/qwen3-vl-plus	128000	t	2026-09-16 22:14:42.972732
qwencloud/qwen3.5-plus	Qwencloud	qwencloud/qwen3.5-plus	128000	t	2026-09-16 22:14:42.973022
qwencloud/qwen3.7-max	Qwencloud	qwencloud/qwen3.7-max	128000	t	2026-09-16 22:14:42.973293
qwencloud/qwen3.7-plus	Qwencloud	qwencloud/qwen3.7-plus	128000	t	2026-09-16 22:14:42.973604
qwencloud/qwen3.8-max	Qwencloud	qwencloud/qwen3.8-max	128000	t	2026-09-16 22:14:42.973915
qwencloud/qwq-plus	Qwencloud	qwencloud/qwq-plus	128000	t	2026-09-16 22:14:42.974251
qwencloud/qwen-image-2.0	Qwencloud	qwencloud/qwen-image-2.0	128000	t	2026-09-16 22:14:42.974719
qwencloud/qwen-image-2.0-pro	Qwencloud	qwencloud/qwen-image-2.0-pro	128000	t	2026-09-16 22:14:42.97506
qwencloud/qwen-image-3.0	Qwencloud	qwencloud/qwen-image-3.0	128000	t	2026-09-16 22:14:42.975363
qwencloud/qwen-image-3.0-pro	Qwencloud	qwencloud/qwen-image-3.0-pro	128000	t	2026-09-16 22:14:42.975659
qwen_ai_platform/deepseek-v4-flash	Qwen_ai_platform	qwen_ai_platform/deepseek-v4-flash	128000	t	2026-09-16 22:14:42.975963
qwen_ai_platform/deepseek-v4-flash-0731	Qwen_ai_platform	qwen_ai_platform/deepseek-v4-flash-0731	128000	t	2026-09-16 22:14:42.976271
qwen_ai_platform/deepseek-v4-pro	Qwen_ai_platform	qwen_ai_platform/deepseek-v4-pro	128000	t	2026-09-16 22:14:42.976586
qwen_ai_platform/glm-5.1	Qwen_ai_platform	qwen_ai_platform/glm-5.1	128000	t	2026-09-16 22:14:42.976897
qwen_ai_platform/glm-5.2	Qwen_ai_platform	qwen_ai_platform/glm-5.2	128000	t	2026-09-16 22:14:42.977226
qwen_ai_platform/kimi-k2.7-code	Qwen_ai_platform	qwen_ai_platform/kimi-k2.7-code	128000	t	2026-09-16 22:14:42.977545
qwen_ai_platform/qwen-coder	Qwen_ai_platform	qwen_ai_platform/qwen-coder	128000	t	2026-09-16 22:14:42.977866
qwen_ai_platform/qwen-flash	Qwen_ai_platform	qwen_ai_platform/qwen-flash	128000	t	2026-09-16 22:14:42.978162
qwen_ai_platform/qwen-flash-2025-07-28	Qwen_ai_platform	qwen_ai_platform/qwen-flash-2025-07-28	128000	t	2026-09-16 22:14:42.978461
qwen_ai_platform/qwen-max	Qwen_ai_platform	qwen_ai_platform/qwen-max	128000	t	2026-09-16 22:14:42.978758
qwen_ai_platform/qwen-plus	Qwen_ai_platform	qwen_ai_platform/qwen-plus	128000	t	2026-09-16 22:14:42.979055
qwen_ai_platform/qwen-plus-2025-01-25	Qwen_ai_platform	qwen_ai_platform/qwen-plus-2025-01-25	128000	t	2026-09-16 22:14:42.979348
qwen_ai_platform/qwen-plus-2025-04-28	Qwen_ai_platform	qwen_ai_platform/qwen-plus-2025-04-28	128000	t	2026-09-16 22:14:42.97965
qwen_ai_platform/qwen-plus-2025-07-14	Qwen_ai_platform	qwen_ai_platform/qwen-plus-2025-07-14	128000	t	2026-09-16 22:14:42.980001
qwen_ai_platform/qwen-plus-2025-07-28	Qwen_ai_platform	qwen_ai_platform/qwen-plus-2025-07-28	128000	t	2026-09-16 22:14:42.98074
qwen_ai_platform/qwen-plus-2025-09-11	Qwen_ai_platform	qwen_ai_platform/qwen-plus-2025-09-11	128000	t	2026-09-16 22:14:42.981068
qwen_ai_platform/qwen-plus-latest	Qwen_ai_platform	qwen_ai_platform/qwen-plus-latest	128000	t	2026-09-16 22:14:42.981381
qwen_ai_platform/qwen-turbo	Qwen_ai_platform	qwen_ai_platform/qwen-turbo	128000	t	2026-09-16 22:14:42.981724
qwen_ai_platform/qwen-turbo-2024-11-01	Qwen_ai_platform	qwen_ai_platform/qwen-turbo-2024-11-01	128000	t	2026-09-16 22:14:42.982042
qwen_ai_platform/qwen-turbo-2025-04-28	Qwen_ai_platform	qwen_ai_platform/qwen-turbo-2025-04-28	128000	t	2026-09-16 22:14:42.98238
qwen_ai_platform/qwen-turbo-latest	Qwen_ai_platform	qwen_ai_platform/qwen-turbo-latest	128000	t	2026-09-16 22:14:42.982725
qwen_ai_platform/qwen3-30b-a3b	Qwen_ai_platform	qwen_ai_platform/qwen3-30b-a3b	128000	t	2026-09-16 22:14:42.983076
qwen_ai_platform/qwen3-coder-flash	Qwen_ai_platform	qwen_ai_platform/qwen3-coder-flash	128000	t	2026-09-16 22:14:42.983401
qwen_ai_platform/qwen3-coder-flash-2025-07-28	Qwen_ai_platform	qwen_ai_platform/qwen3-coder-flash-2025-07-28	128000	t	2026-09-16 22:14:42.983756
qwen_ai_platform/qwen3-coder-plus	Qwen_ai_platform	qwen_ai_platform/qwen3-coder-plus	128000	t	2026-09-16 22:14:42.984086
qwen_ai_platform/qwen3-coder-plus-2025-07-22	Qwen_ai_platform	qwen_ai_platform/qwen3-coder-plus-2025-07-22	128000	t	2026-09-16 22:14:42.984479
qwen_ai_platform/qwen3-max-preview	Qwen_ai_platform	qwen_ai_platform/qwen3-max-preview	128000	t	2026-09-16 22:14:42.984814
qwen_ai_platform/qwen3-max	Qwen_ai_platform	qwen_ai_platform/qwen3-max	128000	t	2026-09-16 22:14:42.985142
qwen_ai_platform/qwen3-max-2026-01-23	Qwen_ai_platform	qwen_ai_platform/qwen3-max-2026-01-23	128000	t	2026-09-16 22:14:42.985491
qwen_ai_platform/qwen3-next-80b-a3b-instruct	Qwen_ai_platform	qwen_ai_platform/qwen3-next-80b-a3b-instruct	128000	t	2026-09-16 22:14:42.985861
qwen_ai_platform/qwen3-next-80b-a3b-thinking	Qwen_ai_platform	qwen_ai_platform/qwen3-next-80b-a3b-thinking	128000	t	2026-09-16 22:14:42.986204
qwen_ai_platform/qwen3-vl-235b-a22b-instruct	Qwen_ai_platform	qwen_ai_platform/qwen3-vl-235b-a22b-instruct	128000	t	2026-09-16 22:14:42.986548
qwen_ai_platform/qwen3-vl-235b-a22b-thinking	Qwen_ai_platform	qwen_ai_platform/qwen3-vl-235b-a22b-thinking	128000	t	2026-09-16 22:14:42.98689
qwen_ai_platform/qwen3-vl-32b-instruct	Qwen_ai_platform	qwen_ai_platform/qwen3-vl-32b-instruct	128000	t	2026-09-16 22:14:42.987233
qwen_ai_platform/qwen3-vl-32b-thinking	Qwen_ai_platform	qwen_ai_platform/qwen3-vl-32b-thinking	128000	t	2026-09-16 22:14:42.987579
qwen_ai_platform/qwen3-vl-plus	Qwen_ai_platform	qwen_ai_platform/qwen3-vl-plus	128000	t	2026-09-16 22:14:42.987926
qwen_ai_platform/qwen3.5-plus	Qwen_ai_platform	qwen_ai_platform/qwen3.5-plus	128000	t	2026-09-16 22:14:42.988438
qwen_ai_platform/qwen3.7-max	Qwen_ai_platform	qwen_ai_platform/qwen3.7-max	128000	t	2026-09-16 22:14:42.988774
qwen_ai_platform/qwen3.7-plus	Qwen_ai_platform	qwen_ai_platform/qwen3.7-plus	128000	t	2026-09-16 22:14:42.989124
qwen_ai_platform/qwen3.8-max	Qwen_ai_platform	qwen_ai_platform/qwen3.8-max	128000	t	2026-09-16 22:14:42.989454
qwen_ai_platform/qwq-plus	Qwen_ai_platform	qwen_ai_platform/qwq-plus	128000	t	2026-09-16 22:14:42.989768
qwen_ai_platform/qwen-image-2.0	Qwen_ai_platform	qwen_ai_platform/qwen-image-2.0	128000	t	2026-09-16 22:14:42.990091
qwen_ai_platform/qwen-image-2.0-pro	Qwen_ai_platform	qwen_ai_platform/qwen-image-2.0-pro	128000	t	2026-09-16 22:14:42.990431
qwen_ai_platform/qwen-image-3.0	Qwen_ai_platform	qwen_ai_platform/qwen-image-3.0	128000	t	2026-09-16 22:14:42.990754
qwen_ai_platform/qwen-image-3.0-pro	Qwen_ai_platform	qwen_ai_platform/qwen-image-3.0-pro	128000	t	2026-09-16 22:14:42.991086
databricks/databricks-deepseek-v4-flash-0731	Databricks	databricks/databricks-deepseek-v4-flash-0731	128000	t	2026-09-16 22:14:42.991423
databricks/databricks-deepseek-v4-pro-0813	Databricks	databricks/databricks-deepseek-v4-pro-0813	128000	t	2026-09-16 22:14:42.991744
databricks/databricks-glm-5-2	Databricks	databricks/databricks-glm-5-2	128000	t	2026-09-16 22:14:42.992076
databricks/databricks-glm-5-3	Databricks	databricks/databricks-glm-5-3	128000	t	2026-09-16 22:14:42.992391
databricks/databricks-glm-5-3-flash	Databricks	databricks/databricks-glm-5-3-flash	128000	t	2026-09-16 22:14:42.992697
databricks/databricks-kimi-k3	Databricks	databricks/databricks-kimi-k3	128000	t	2026-09-16 22:14:42.993053
databricks/databricks-qwen35-122b-a10b	Databricks	databricks/databricks-qwen35-122b-a10b	128000	t	2026-09-16 22:14:42.993368
databricks/databricks-qwen3-next-80b-a3b-instruct	Databricks	databricks/databricks-qwen3-next-80b-a3b-instruct	128000	t	2026-09-16 22:14:42.993707
databricks/databricks-qwen3-embedding-0-6b	Databricks	databricks/databricks-qwen3-embedding-0-6b	128000	t	2026-09-16 22:14:42.994028
deepinfra/Qwen/QwQ-32B	Deepinfra	deepinfra/Qwen/QwQ-32B	128000	t	2026-09-16 22:14:42.994392
deepinfra/Qwen/Qwen2.5-72B-Instruct	Deepinfra	deepinfra/Qwen/Qwen2.5-72B-Instruct	128000	t	2026-09-16 22:14:42.994729
deepinfra/Qwen/Qwen2.5-7B-Instruct	Deepinfra	deepinfra/Qwen/Qwen2.5-7B-Instruct	128000	t	2026-09-16 22:14:42.995155
deepinfra/Qwen/Qwen2.5-VL-32B-Instruct	Deepinfra	deepinfra/Qwen/Qwen2.5-VL-32B-Instruct	128000	t	2026-09-16 22:14:42.995493
deepinfra/Qwen/Qwen3-14B	Deepinfra	deepinfra/Qwen/Qwen3-14B	128000	t	2026-09-16 22:14:42.996035
deepinfra/Qwen/Qwen3-235B-A22B	Deepinfra	deepinfra/Qwen/Qwen3-235B-A22B	128000	t	2026-09-16 22:14:42.996376
deepinfra/Qwen/Qwen3-235B-A22B-Instruct-2507	Deepinfra	deepinfra/Qwen/Qwen3-235B-A22B-Instruct-2507	128000	t	2026-09-16 22:14:42.996714
deepinfra/Qwen/Qwen3-235B-A22B-Thinking-2507	Deepinfra	deepinfra/Qwen/Qwen3-235B-A22B-Thinking-2507	128000	t	2026-09-16 22:14:42.997054
deepinfra/Qwen/Qwen3-30B-A3B	Deepinfra	deepinfra/Qwen/Qwen3-30B-A3B	128000	t	2026-09-16 22:14:42.997463
deepinfra/Qwen/Qwen3-32B	Deepinfra	deepinfra/Qwen/Qwen3-32B	128000	t	2026-09-16 22:14:42.997787
deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct	Deepinfra	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct	128000	t	2026-09-16 22:14:42.998087
deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct-Turbo	Deepinfra	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct-Turbo	128000	t	2026-09-16 22:14:42.998394
deepinfra/Qwen/Qwen3-Next-80B-A3B-Instruct	Deepinfra	deepinfra/Qwen/Qwen3-Next-80B-A3B-Instruct	128000	t	2026-09-16 22:14:42.998743
deepinfra/Qwen/Qwen3-Next-80B-A3B-Thinking	Deepinfra	deepinfra/Qwen/Qwen3-Next-80B-A3B-Thinking	128000	t	2026-09-16 22:14:42.99908
deepinfra/deepseek-ai/DeepSeek-R1	Deepinfra	deepinfra/deepseek-ai/DeepSeek-R1	128000	t	2026-09-16 22:14:42.999411
deepinfra/deepseek-ai/DeepSeek-R1-0528	Deepinfra	deepinfra/deepseek-ai/DeepSeek-R1-0528	128000	t	2026-09-16 22:14:42.999718
deepinfra/deepseek-ai/DeepSeek-R1-0528-Turbo	Deepinfra	deepinfra/deepseek-ai/DeepSeek-R1-0528-Turbo	128000	t	2026-09-16 22:14:43.00003
deepinfra/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	Deepinfra	deepinfra/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	128000	t	2026-09-16 22:14:43.000345
deepinfra/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B	Deepinfra	deepinfra/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B	128000	t	2026-09-16 22:14:43.000674
deepinfra/deepseek-ai/DeepSeek-R1-Turbo	Deepinfra	deepinfra/deepseek-ai/DeepSeek-R1-Turbo	128000	t	2026-09-16 22:14:43.000997
deepinfra/deepseek-ai/DeepSeek-V3	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V3	128000	t	2026-09-16 22:14:43.001318
deepinfra/deepseek-ai/DeepSeek-V3-0324	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V3-0324	128000	t	2026-09-16 22:14:43.001676
deepinfra/deepseek-ai/DeepSeek-V3.1	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V3.1	128000	t	2026-09-16 22:14:43.002004
deepinfra/deepseek-ai/DeepSeek-V3.1-Terminus	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V3.1-Terminus	128000	t	2026-09-16 22:14:43.002346
deepinfra/moonshotai/Kimi-K2-Instruct	Deepinfra	deepinfra/moonshotai/Kimi-K2-Instruct	128000	t	2026-09-16 22:14:43.002692
deepinfra/moonshotai/Kimi-K2-Instruct-0905	Deepinfra	deepinfra/moonshotai/Kimi-K2-Instruct-0905	128000	t	2026-09-16 22:14:43.003019
deepinfra/zai-org/GLM-4.5	Deepinfra	deepinfra/zai-org/GLM-4.5	128000	t	2026-09-16 22:14:43.003553
deepseek/deepseek-chat	Deepseek	deepseek/deepseek-chat	128000	t	2026-09-16 22:14:43.003892
deepseek/deepseek-coder	Deepseek	deepseek/deepseek-coder	128000	t	2026-09-16 22:14:43.00423
deepseek/deepseek-r1	Deepseek	deepseek/deepseek-r1	128000	t	2026-09-16 22:14:43.004556
deepseek/deepseek-reasoner	Deepseek	deepseek/deepseek-reasoner	128000	t	2026-09-16 22:14:43.004871
deepseek/deepseek-v3	Deepseek	deepseek/deepseek-v3	128000	t	2026-09-16 22:14:43.00521
deepseek/deepseek-v3.2	Deepseek	deepseek/deepseek-v3.2	128000	t	2026-09-16 22:14:43.005619
deepseek.v3-v1:0	Chinese AI	deepseek.v3-v1:0	128000	t	2026-09-16 22:14:43.005968
deepseek.v3.2	Chinese AI	deepseek.v3.2	128000	t	2026-09-16 22:14:43.006301
deepseek-v3-2-251201	Chinese AI	deepseek-v3-2-251201	128000	t	2026-09-16 22:14:43.006637
glm-4-7-251222	Chinese AI	glm-4-7-251222	128000	t	2026-09-16 22:14:43.006962
kimi-k2-thinking-251104	Chinese AI	kimi-k2-thinking-251104	128000	t	2026-09-16 22:14:43.007285
fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-instruct	128000	t	2026-09-16 22:14:43.007711
fireworks_ai/accounts/fireworks/models/deepseek-r1	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1	128000	t	2026-09-16 22:14:43.008093
fireworks_ai/accounts/fireworks/models/deepseek-r1-0528	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-0528	128000	t	2026-09-16 22:14:43.008417
fireworks_ai/accounts/fireworks/models/deepseek-r1-basic	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-basic	128000	t	2026-09-16 22:14:43.008724
fireworks_ai/accounts/fireworks/models/deepseek-v3	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v3	128000	t	2026-09-16 22:14:43.009201
fireworks_ai/accounts/fireworks/models/deepseek-v3-0324	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v3-0324	128000	t	2026-09-16 22:14:43.009511
fireworks_ai/accounts/fireworks/models/deepseek-v3p1	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v3p1	128000	t	2026-09-16 22:14:43.009823
fireworks_ai/accounts/fireworks/models/deepseek-v3p1-terminus	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v3p1-terminus	128000	t	2026-09-16 22:14:43.010155
fireworks_ai/accounts/fireworks/models/deepseek-v3p2	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v3p2	128000	t	2026-09-16 22:14:43.010461
fireworks_ai/accounts/fireworks/models/deepseek-v4-flash	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v4-flash	128000	t	2026-09-16 22:14:43.010776
fireworks_ai/accounts/fireworks/models/deepseek-v4-pro	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v4-pro	128000	t	2026-09-16 22:14:43.011108
fireworks_ai/accounts/fireworks/models/deepseek-v4-pro-0813	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v4-pro-0813	128000	t	2026-09-16 22:14:43.011437
fireworks_ai/accounts/fireworks/models/glm-4p5	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-4p5	128000	t	2026-09-16 22:14:43.011779
fireworks_ai/accounts/fireworks/models/glm-4p5-air	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-4p5-air	128000	t	2026-09-16 22:14:43.012091
fireworks_ai/accounts/fireworks/models/glm-4p6	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-4p6	128000	t	2026-09-16 22:14:43.012392
fireworks_ai/accounts/fireworks/models/glm-4p7	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-4p7	128000	t	2026-09-16 22:14:43.012708
fireworks_ai/accounts/fireworks/models/glm-5p1	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-5p1	128000	t	2026-09-16 22:14:43.013011
fireworks_ai/accounts/fireworks/models/glm-5p2	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-5p2	128000	t	2026-09-16 22:14:43.013758
fireworks_ai/accounts/fireworks/models/kimi-k2-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/kimi-k2-instruct	128000	t	2026-09-16 22:14:43.014295
fireworks_ai/accounts/fireworks/models/kimi-k2-instruct-0905	Fireworks_ai	fireworks_ai/accounts/fireworks/models/kimi-k2-instruct-0905	128000	t	2026-09-16 22:14:43.014822
fireworks_ai/accounts/fireworks/models/kimi-k2-thinking	Fireworks_ai	fireworks_ai/accounts/fireworks/models/kimi-k2-thinking	128000	t	2026-09-16 22:14:43.015154
fireworks_ai/accounts/fireworks/models/kimi-k2p5	Fireworks_ai	fireworks_ai/accounts/fireworks/models/kimi-k2p5	128000	t	2026-09-16 22:14:43.015497
fireworks_ai/accounts/fireworks/models/kimi-k2p6	Fireworks_ai	fireworks_ai/accounts/fireworks/models/kimi-k2p6	128000	t	2026-09-16 22:14:43.015833
fireworks_ai/accounts/fireworks/models/kimi-k2p7-code	Fireworks_ai	fireworks_ai/accounts/fireworks/models/kimi-k2p7-code	128000	t	2026-09-16 22:14:43.016161
fireworks_ai/accounts/fireworks/models/minimax-m2p1	Fireworks_ai	fireworks_ai/accounts/fireworks/models/minimax-m2p1	128000	t	2026-09-16 22:14:43.016538
fireworks_ai/accounts/fireworks/models/minimax-m2p7	Fireworks_ai	fireworks_ai/accounts/fireworks/models/minimax-m2p7	128000	t	2026-09-16 22:14:43.01687
fireworks_ai/accounts/fireworks/models/minimax-m3	Fireworks_ai	fireworks_ai/accounts/fireworks/models/minimax-m3	128000	t	2026-09-16 22:14:43.017215
fireworks_ai/accounts/fireworks/models/qwen2-72b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2-72b-instruct	128000	t	2026-09-16 22:14:43.017544
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct	128000	t	2026-09-16 22:14:43.017887
fireworks_ai/deepseek-v4-flash	Fireworks_ai	fireworks_ai/deepseek-v4-flash	128000	t	2026-09-16 22:14:43.01822
fireworks_ai/deepseek-v4-pro	Fireworks_ai	fireworks_ai/deepseek-v4-pro	128000	t	2026-09-16 22:14:43.018559
fireworks_ai/glm-4p7	Fireworks_ai	fireworks_ai/glm-4p7	128000	t	2026-09-16 22:14:43.018901
fireworks_ai/glm-5p1	Fireworks_ai	fireworks_ai/glm-5p1	128000	t	2026-09-16 22:14:43.019243
fireworks_ai/glm-5p1-fast	Fireworks_ai	fireworks_ai/glm-5p1-fast	128000	t	2026-09-16 22:14:43.019618
fireworks_ai/glm-5p2	Fireworks_ai	fireworks_ai/glm-5p2	128000	t	2026-09-16 22:14:43.019948
fireworks_ai/kimi-k2p5	Fireworks_ai	fireworks_ai/kimi-k2p5	128000	t	2026-09-16 22:14:43.02027
fireworks_ai/kimi-k2p6	Fireworks_ai	fireworks_ai/kimi-k2p6	128000	t	2026-09-16 22:14:43.0206
fireworks_ai/kimi-k2p6-fast	Fireworks_ai	fireworks_ai/kimi-k2p6-fast	128000	t	2026-09-16 22:14:43.020935
fireworks_ai/kimi-k2p7-code	Fireworks_ai	fireworks_ai/kimi-k2p7-code	128000	t	2026-09-16 22:14:43.021227
fireworks_ai/kimi-k2p7-code-fast	Fireworks_ai	fireworks_ai/kimi-k2p7-code-fast	128000	t	2026-09-16 22:14:43.021528
fireworks_ai/minimax-m2p1	Fireworks_ai	fireworks_ai/minimax-m2p1	128000	t	2026-09-16 22:14:43.021848
fireworks_ai/minimax-m2p7	Fireworks_ai	fireworks_ai/minimax-m2p7	128000	t	2026-09-16 22:14:43.022355
fireworks_ai/minimax-m3	Fireworks_ai	fireworks_ai/minimax-m3	128000	t	2026-09-16 22:14:43.022694
fireworks_ai/qwen3p7-plus	Fireworks_ai	fireworks_ai/qwen3p7-plus	128000	t	2026-09-16 22:14:43.023038
friendliai/zai-org/GLM-5.3-Flash	Friendliai	friendliai/zai-org/GLM-5.3-Flash	128000	t	2026-09-16 22:14:43.023353
friendliai/zai-org/GLM-5.3	Friendliai	friendliai/zai-org/GLM-5.3	128000	t	2026-09-16 22:14:43.023648
friendliai/zai-org/GLM-5.2	Friendliai	friendliai/zai-org/GLM-5.2	128000	t	2026-09-16 22:14:43.023939
friendliai/deepseek-ai/DeepSeek-V3.2	Friendliai	friendliai/deepseek-ai/DeepSeek-V3.2	128000	t	2026-09-16 22:14:43.024274
friendliai/MiniMaxAI/MiniMax-M2.5	Friendliai	friendliai/MiniMaxAI/MiniMax-M2.5	128000	t	2026-09-16 22:14:43.024594
friendliai/zai-org/GLM-5.1	Friendliai	friendliai/zai-org/GLM-5.1	128000	t	2026-09-16 22:14:43.024919
gmi/deepseek-ai/DeepSeek-V3.2	Gmi	gmi/deepseek-ai/DeepSeek-V3.2	128000	t	2026-09-16 22:14:43.025375
gmi/deepseek-ai/DeepSeek-V3-0324	Gmi	gmi/deepseek-ai/DeepSeek-V3-0324	128000	t	2026-09-16 22:14:43.02568
gmi/moonshotai/Kimi-K2-Thinking	Gmi	gmi/moonshotai/Kimi-K2-Thinking	128000	t	2026-09-16 22:14:43.025973
gmi/MiniMaxAI/MiniMax-M2.1	Gmi	gmi/MiniMaxAI/MiniMax-M2.1	128000	t	2026-09-16 22:14:43.026289
baseten/MiniMaxAI/MiniMax-M2.5	Baseten	baseten/MiniMaxAI/MiniMax-M2.5	128000	t	2026-09-16 22:14:43.026584
baseten/zai-org/GLM-5	Baseten	baseten/zai-org/GLM-5	128000	t	2026-09-16 22:14:43.026911
baseten/zai-org/GLM-4.7	Baseten	baseten/zai-org/GLM-4.7	128000	t	2026-09-16 22:14:43.027219
baseten/zai-org/GLM-4.6	Baseten	baseten/zai-org/GLM-4.6	128000	t	2026-09-16 22:14:43.027512
baseten/moonshotai/Kimi-K2.5	Baseten	baseten/moonshotai/Kimi-K2.5	128000	t	2026-09-16 22:14:43.027809
baseten/moonshotai/Kimi-K2-Thinking	Baseten	baseten/moonshotai/Kimi-K2-Thinking	128000	t	2026-09-16 22:14:43.028127
baseten/moonshotai/Kimi-K2-Instruct-0905	Baseten	baseten/moonshotai/Kimi-K2-Instruct-0905	128000	t	2026-09-16 22:14:43.028456
baseten/deepseek-ai/DeepSeek-V3.1	Baseten	baseten/deepseek-ai/DeepSeek-V3.1	128000	t	2026-09-16 22:14:43.028796
baseten/deepseek-ai/DeepSeek-V3-0324	Baseten	baseten/deepseek-ai/DeepSeek-V3-0324	128000	t	2026-09-16 22:14:43.029114
gmi/Qwen/Qwen3-VL-235B-A22B-Instruct-FP8	Gmi	gmi/Qwen/Qwen3-VL-235B-A22B-Instruct-FP8	128000	t	2026-09-16 22:14:43.02943
gmi/zai-org/GLM-4.7-FP8	Gmi	gmi/zai-org/GLM-4.7-FP8	128000	t	2026-09-16 22:14:43.029945
gradient_ai/alibaba-qwen3-32b	Gradient_ai	gradient_ai/alibaba-qwen3-32b	128000	t	2026-09-16 22:14:43.030356
gradient_ai/deepseek-r1-distill-llama-70b	Gradient_ai	gradient_ai/deepseek-r1-distill-llama-70b	128000	t	2026-09-16 22:14:43.030701
lemonade/Qwen3-Coder-30B-A3B-Instruct-GGUF	Lemonade	lemonade/Qwen3-Coder-30B-A3B-Instruct-GGUF	128000	t	2026-09-16 22:14:43.031077
lemonade/Qwen3-4B-Instruct-2507-GGUF	Lemonade	lemonade/Qwen3-4B-Instruct-2507-GGUF	128000	t	2026-09-16 22:14:43.031404
groq/moonshotai/kimi-k2-instruct-0905	Groq	groq/moonshotai/kimi-k2-instruct-0905	128000	t	2026-09-16 22:14:43.031741
groq/qwen/qwen3.6-27b	Groq	groq/qwen/qwen3.6-27b	128000	t	2026-09-16 22:14:43.032057
groq/qwen/qwen3-32b	Groq	groq/qwen/qwen3-32b	128000	t	2026-09-16 22:14:43.03239
hyperbolic/Qwen/QwQ-32B	Hyperbolic	hyperbolic/Qwen/QwQ-32B	128000	t	2026-09-16 22:14:43.032723
hyperbolic/Qwen/Qwen2.5-72B-Instruct	Hyperbolic	hyperbolic/Qwen/Qwen2.5-72B-Instruct	128000	t	2026-09-16 22:14:43.033049
hyperbolic/Qwen/Qwen2.5-Coder-32B-Instruct	Hyperbolic	hyperbolic/Qwen/Qwen2.5-Coder-32B-Instruct	128000	t	2026-09-16 22:14:43.033364
hyperbolic/Qwen/Qwen3-235B-A22B	Hyperbolic	hyperbolic/Qwen/Qwen3-235B-A22B	128000	t	2026-09-16 22:14:43.033672
hyperbolic/deepseek-ai/DeepSeek-R1	Hyperbolic	hyperbolic/deepseek-ai/DeepSeek-R1	128000	t	2026-09-16 22:14:43.033967
hyperbolic/deepseek-ai/DeepSeek-R1-0528	Hyperbolic	hyperbolic/deepseek-ai/DeepSeek-R1-0528	128000	t	2026-09-16 22:14:43.034272
hyperbolic/deepseek-ai/DeepSeek-V3	Hyperbolic	hyperbolic/deepseek-ai/DeepSeek-V3	128000	t	2026-09-16 22:14:43.034556
hyperbolic/deepseek-ai/DeepSeek-V3-0324	Hyperbolic	hyperbolic/deepseek-ai/DeepSeek-V3-0324	128000	t	2026-09-16 22:14:43.034844
hyperbolic/moonshotai/Kimi-K2-Instruct	Hyperbolic	hyperbolic/moonshotai/Kimi-K2-Instruct	128000	t	2026-09-16 22:14:43.035172
crusoe/deepseek-ai/DeepSeek-R1-0528	Crusoe	crusoe/deepseek-ai/DeepSeek-R1-0528	128000	t	2026-09-16 22:14:43.035535
crusoe/deepseek-ai/DeepSeek-V3-0324	Crusoe	crusoe/deepseek-ai/DeepSeek-V3-0324	128000	t	2026-09-16 22:14:43.035851
crusoe/moonshotai/Kimi-K2-Thinking	Crusoe	crusoe/moonshotai/Kimi-K2-Thinking	128000	t	2026-09-16 22:14:43.036184
crusoe/Qwen/Qwen3-235B-A22B-Instruct-2507	Crusoe	crusoe/Qwen/Qwen3-235B-A22B-Instruct-2507	128000	t	2026-09-16 22:14:43.036509
lambda_ai/deepseek-llama3.3-70b	Lambda_ai	lambda_ai/deepseek-llama3.3-70b	128000	t	2026-09-16 22:14:43.036829
lambda_ai/deepseek-r1-0528	Lambda_ai	lambda_ai/deepseek-r1-0528	128000	t	2026-09-16 22:14:43.037365
lambda_ai/deepseek-r1-671b	Lambda_ai	lambda_ai/deepseek-r1-671b	128000	t	2026-09-16 22:14:43.03771
lambda_ai/deepseek-v3-0324	Lambda_ai	lambda_ai/deepseek-v3-0324	128000	t	2026-09-16 22:14:43.038032
lambda_ai/qwen25-coder-32b-instruct	Lambda_ai	lambda_ai/qwen25-coder-32b-instruct	128000	t	2026-09-16 22:14:43.038375
lambda_ai/qwen3-32b-fp8	Lambda_ai	lambda_ai/qwen3-32b-fp8	128000	t	2026-09-16 22:14:43.038737
minimax.minimax-m2	Chinese AI	minimax.minimax-m2	128000	t	2026-09-16 22:14:43.039069
minimax.minimax-m2.1	Chinese AI	minimax.minimax-m2.1	128000	t	2026-09-16 22:14:43.039395
minimax.minimax-m2.5	Chinese AI	minimax.minimax-m2.5	128000	t	2026-09-16 22:14:43.039779
minimax/speech-02-hd	Minimax	minimax/speech-02-hd	128000	t	2026-09-16 22:14:43.04011
minimax/speech-02-turbo	Minimax	minimax/speech-02-turbo	128000	t	2026-09-16 22:14:43.04043
minimax/speech-2.6-hd	Minimax	minimax/speech-2.6-hd	128000	t	2026-09-16 22:14:43.040753
minimax/speech-2.6-turbo	Minimax	minimax/speech-2.6-turbo	128000	t	2026-09-16 22:14:43.04108
minimax/MiniMax-M2.1	Minimax	minimax/MiniMax-M2.1	128000	t	2026-09-16 22:14:43.041404
minimax/MiniMax-M2.1-lightning	Minimax	minimax/MiniMax-M2.1-lightning	128000	t	2026-09-16 22:14:43.0419
minimax/MiniMax-M2.5	Minimax	minimax/MiniMax-M2.5	128000	t	2026-09-16 22:14:43.042219
minimax/MiniMax-M2.5-lightning	Minimax	minimax/MiniMax-M2.5-lightning	128000	t	2026-09-16 22:14:43.042524
minimax/MiniMax-M2	Minimax	minimax/MiniMax-M2	128000	t	2026-09-16 22:14:43.042825
minimax/MiniMax-M3	Minimax	minimax/MiniMax-M3	128000	t	2026-09-16 22:14:43.043136
mistral/zai-glm-5-2	Mistral	mistral/zai-glm-5-2	128000	t	2026-09-16 22:14:43.043458
mistral/glm-5-2	Mistral	mistral/glm-5-2	128000	t	2026-09-16 22:14:43.04378
moonshot.kimi-k2-thinking	Chinese AI	moonshot.kimi-k2-thinking	128000	t	2026-09-16 22:14:43.044124
moonshotai.kimi-k2.5	Chinese AI	moonshotai.kimi-k2.5	128000	t	2026-09-16 22:14:43.04442
moonshot/kimi-k2-0711-preview	Moonshot	moonshot/kimi-k2-0711-preview	128000	t	2026-09-16 22:14:43.044718
moonshot/kimi-k2-0905-preview	Moonshot	moonshot/kimi-k2-0905-preview	128000	t	2026-09-16 22:14:43.045017
moonshot/kimi-k2.7-code	Moonshot	moonshot/kimi-k2.7-code	128000	t	2026-09-16 22:14:43.045321
moonshot/kimi-k2-turbo-preview	Moonshot	moonshot/kimi-k2-turbo-preview	128000	t	2026-09-16 22:14:43.045622
moonshot/kimi-k3	Moonshot	moonshot/kimi-k3	128000	t	2026-09-16 22:14:43.046517
moonshot/kimi-latest	Moonshot	moonshot/kimi-latest	128000	t	2026-09-16 22:14:43.046837
moonshot/kimi-latest-128k	Moonshot	moonshot/kimi-latest-128k	128000	t	2026-09-16 22:14:43.047138
moonshot/kimi-latest-32k	Moonshot	moonshot/kimi-latest-32k	128000	t	2026-09-16 22:14:43.047426
moonshot/kimi-latest-8k	Moonshot	moonshot/kimi-latest-8k	128000	t	2026-09-16 22:14:43.047714
moonshot/kimi-thinking-preview	Moonshot	moonshot/kimi-thinking-preview	128000	t	2026-09-16 22:14:43.047996
moonshot/kimi-k2-thinking	Moonshot	moonshot/kimi-k2-thinking	128000	t	2026-09-16 22:14:43.048302
moonshot/kimi-k2-thinking-turbo	Moonshot	moonshot/kimi-k2-thinking-turbo	128000	t	2026-09-16 22:14:43.048607
moonshot/moonshot-v1-128k	Moonshot	moonshot/moonshot-v1-128k	128000	t	2026-09-16 22:14:43.049711
moonshot/moonshot-v1-128k-0430	Moonshot	moonshot/moonshot-v1-128k-0430	128000	t	2026-09-16 22:14:43.050547
moonshot/moonshot-v1-128k-vision-preview	Moonshot	moonshot/moonshot-v1-128k-vision-preview	128000	t	2026-09-16 22:14:43.050839
moonshot/moonshot-v1-32k	Moonshot	moonshot/moonshot-v1-32k	128000	t	2026-09-16 22:14:43.051163
moonshot/moonshot-v1-32k-0430	Moonshot	moonshot/moonshot-v1-32k-0430	128000	t	2026-09-16 22:14:43.05148
moonshot/moonshot-v1-32k-vision-preview	Moonshot	moonshot/moonshot-v1-32k-vision-preview	128000	t	2026-09-16 22:14:43.051816
moonshot/moonshot-v1-8k	Moonshot	moonshot/moonshot-v1-8k	128000	t	2026-09-16 22:14:43.052132
moonshot/moonshot-v1-8k-0430	Moonshot	moonshot/moonshot-v1-8k-0430	128000	t	2026-09-16 22:14:43.052481
moonshot/moonshot-v1-8k-vision-preview	Moonshot	moonshot/moonshot-v1-8k-vision-preview	128000	t	2026-09-16 22:14:43.052906
moonshot/moonshot-v1-auto	Moonshot	moonshot/moonshot-v1-auto	128000	t	2026-09-16 22:14:43.053242
nscale/Qwen/QwQ-32B	Nscale	nscale/Qwen/QwQ-32B	128000	t	2026-09-16 22:14:43.053578
nscale/Qwen/Qwen2.5-Coder-32B-Instruct	Nscale	nscale/Qwen/Qwen2.5-Coder-32B-Instruct	128000	t	2026-09-16 22:14:43.053898
nscale/Qwen/Qwen2.5-Coder-3B-Instruct	Nscale	nscale/Qwen/Qwen2.5-Coder-3B-Instruct	128000	t	2026-09-16 22:14:43.054231
nscale/Qwen/Qwen2.5-Coder-7B-Instruct	Nscale	nscale/Qwen/Qwen2.5-Coder-7B-Instruct	128000	t	2026-09-16 22:14:43.054546
nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	Nscale	nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	128000	t	2026-09-16 22:14:43.05489
nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-8B	Nscale	nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-8B	128000	t	2026-09-16 22:14:43.055235
nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B	Nscale	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B	128000	t	2026-09-16 22:14:43.055582
nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B	Nscale	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B	128000	t	2026-09-16 22:14:43.055938
nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B	Nscale	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B	128000	t	2026-09-16 22:14:43.056278
nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B	Nscale	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B	128000	t	2026-09-16 22:14:43.056609
nebius/deepseek-ai/DeepSeek-R1	Nebius	nebius/deepseek-ai/DeepSeek-R1	128000	t	2026-09-16 22:14:43.056947
nebius/deepseek-ai/DeepSeek-R1-0528	Nebius	nebius/deepseek-ai/DeepSeek-R1-0528	128000	t	2026-09-16 22:14:43.057276
nebius/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	Nebius	nebius/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	128000	t	2026-09-16 22:14:43.057599
nebius/deepseek-ai/DeepSeek-V3	Nebius	nebius/deepseek-ai/DeepSeek-V3	128000	t	2026-09-16 22:14:43.058095
nebius/deepseek-ai/DeepSeek-V3-0324	Nebius	nebius/deepseek-ai/DeepSeek-V3-0324	128000	t	2026-09-16 22:14:43.05843
nebius/Qwen/Qwen3-235B-A22B	Nebius	nebius/Qwen/Qwen3-235B-A22B	128000	t	2026-09-16 22:14:43.058795
nebius/Qwen/Qwen3-32B	Nebius	nebius/Qwen/Qwen3-32B	128000	t	2026-09-16 22:14:43.059116
nebius/Qwen/Qwen3-30B-A3B	Nebius	nebius/Qwen/Qwen3-30B-A3B	128000	t	2026-09-16 22:14:43.05942
nebius/Qwen/Qwen3-14B	Nebius	nebius/Qwen/Qwen3-14B	128000	t	2026-09-16 22:14:43.059735
nebius/Qwen/Qwen3-4B	Nebius	nebius/Qwen/Qwen3-4B	128000	t	2026-09-16 22:14:43.060042
nebius/Qwen/QwQ-32B	Nebius	nebius/Qwen/QwQ-32B	128000	t	2026-09-16 22:14:43.060351
nebius/Qwen/Qwen2.5-72B-Instruct	Nebius	nebius/Qwen/Qwen2.5-72B-Instruct	128000	t	2026-09-16 22:14:43.060641
nebius/Qwen/Qwen2.5-32B-Instruct	Nebius	nebius/Qwen/Qwen2.5-32B-Instruct	128000	t	2026-09-16 22:14:43.060953
nebius/Qwen/Qwen2.5-Coder-7B	Nebius	nebius/Qwen/Qwen2.5-Coder-7B	128000	t	2026-09-16 22:14:43.061259
nebius/Qwen/Qwen2.5-VL-72B-Instruct	Nebius	nebius/Qwen/Qwen2.5-VL-72B-Instruct	128000	t	2026-09-16 22:14:43.061578
nebius/Qwen/Qwen2-VL-72B-Instruct	Nebius	nebius/Qwen/Qwen2-VL-72B-Instruct	128000	t	2026-09-16 22:14:43.061902
nebius/Qwen/Qwen2-VL-7B-Instruct	Nebius	nebius/Qwen/Qwen2-VL-7B-Instruct	128000	t	2026-09-16 22:14:43.062278
nebius/deepseek-ai/DeepSeek-V4-Flash	Nebius	nebius/deepseek-ai/DeepSeek-V4-Flash	128000	t	2026-09-16 22:14:43.062625
nebius/deepseek-ai/DeepSeek-V4-Flash-0731	Nebius	nebius/deepseek-ai/DeepSeek-V4-Flash-0731	128000	t	2026-09-16 22:14:43.062958
nebius/deepseek-ai/DeepSeek-V4-Pro	Nebius	nebius/deepseek-ai/DeepSeek-V4-Pro	128000	t	2026-09-16 22:14:43.063289
nebius/MiniMaxAI/MiniMax-M2.5	Nebius	nebius/MiniMaxAI/MiniMax-M2.5	128000	t	2026-09-16 22:14:43.063646
nebius/MiniMaxAI/MiniMax-M3	Nebius	nebius/MiniMaxAI/MiniMax-M3	128000	t	2026-09-16 22:14:43.064004
nebius/moonshotai/Kimi-K2.6	Nebius	nebius/moonshotai/Kimi-K2.6	128000	t	2026-09-16 22:14:43.064392
nebius/moonshotai/Kimi-K2.7-Code	Nebius	nebius/moonshotai/Kimi-K2.7-Code	128000	t	2026-09-16 22:14:43.06471
nebius/moonshotai/Kimi-K3	Nebius	nebius/moonshotai/Kimi-K3	128000	t	2026-09-16 22:14:43.065051
nebius/Qwen/Qwen3-235B-A22B-Instruct-2507	Nebius	nebius/Qwen/Qwen3-235B-A22B-Instruct-2507	128000	t	2026-09-16 22:14:43.065389
nebius/Qwen/Qwen3-30B-A3B-Instruct-2507	Nebius	nebius/Qwen/Qwen3-30B-A3B-Instruct-2507	128000	t	2026-09-16 22:14:43.066044
nebius/Qwen/Qwen3-Next-80B-A3B-Thinking	Nebius	nebius/Qwen/Qwen3-Next-80B-A3B-Thinking	128000	t	2026-09-16 22:14:43.066422
nebius/Qwen/Qwen3.5-397B-A17B	Nebius	nebius/Qwen/Qwen3.5-397B-A17B	128000	t	2026-09-16 22:14:43.066742
nebius/zai-org/GLM-5.1	Nebius	nebius/zai-org/GLM-5.1	128000	t	2026-09-16 22:14:43.067085
nebius/zai-org/GLM-5.2	Nebius	nebius/zai-org/GLM-5.2	128000	t	2026-09-16 22:14:43.067399
nebius/zai-org/GLM-5.3-Flash	Nebius	nebius/zai-org/GLM-5.3-Flash	128000	t	2026-09-16 22:14:43.067716
nebius/Qwen/Qwen3-Embedding-8B	Nebius	nebius/Qwen/Qwen3-Embedding-8B	128000	t	2026-09-16 22:14:43.068044
ollama/deepseek-coder-v2-base	Ollama	ollama/deepseek-coder-v2-base	128000	t	2026-09-16 22:14:43.068411
ollama/deepseek-coder-v2-instruct	Ollama	ollama/deepseek-coder-v2-instruct	128000	t	2026-09-16 22:14:43.068719
ollama/deepseek-coder-v2-lite-base	Ollama	ollama/deepseek-coder-v2-lite-base	128000	t	2026-09-16 22:14:43.069052
ollama/deepseek-coder-v2-lite-instruct	Ollama	ollama/deepseek-coder-v2-lite-instruct	128000	t	2026-09-16 22:14:43.069383
ollama/deepseek-v3.1:671b-cloud	Ollama	ollama/deepseek-v3.1:671b-cloud	128000	t	2026-09-16 22:14:43.069751
ollama/qwen3-coder:480b-cloud	Ollama	ollama/qwen3-coder:480b-cloud	128000	t	2026-09-16 22:14:43.070256
openrouter/deepseek/deepseek-chat	Openrouter	openrouter/deepseek/deepseek-chat	128000	t	2026-09-16 22:14:43.070603
openrouter/deepseek/deepseek-chat-v3-0324	Openrouter	openrouter/deepseek/deepseek-chat-v3-0324	128000	t	2026-09-16 22:14:43.070938
openrouter/deepseek/deepseek-chat-v3.1	Openrouter	openrouter/deepseek/deepseek-chat-v3.1	128000	t	2026-09-16 22:14:43.071298
openrouter/deepseek/deepseek-v3.2	Openrouter	openrouter/deepseek/deepseek-v3.2	128000	t	2026-09-16 22:14:43.071671
openrouter/deepseek/deepseek-v3.2-exp	Openrouter	openrouter/deepseek/deepseek-v3.2-exp	128000	t	2026-09-16 22:14:43.071974
openrouter/deepseek/deepseek-r1	Openrouter	openrouter/deepseek/deepseek-r1	128000	t	2026-09-16 22:14:43.072267
openrouter/deepseek/deepseek-r1-0528	Openrouter	openrouter/deepseek/deepseek-r1-0528	128000	t	2026-09-16 22:14:43.072559
openrouter/deepseek/deepseek-v4-pro	Openrouter	openrouter/deepseek/deepseek-v4-pro	128000	t	2026-09-16 22:14:43.072921
openrouter/deepseek/deepseek-v4.1-flash	Openrouter	openrouter/deepseek/deepseek-v4.1-flash	128000	t	2026-09-16 22:14:43.073251
openrouter/deepseek/deepseek-v4-pro-0813	Openrouter	openrouter/deepseek/deepseek-v4-pro-0813	128000	t	2026-09-16 22:14:43.073586
openrouter/minimax/minimax-m2	Openrouter	openrouter/minimax/minimax-m2	128000	t	2026-09-16 22:14:43.073934
openrouter/moonshotai/kimi-k2.5	Openrouter	openrouter/moonshotai/kimi-k2.5	128000	t	2026-09-16 22:14:43.074268
openrouter/qwen/qwen-2.5-coder-32b-instruct	Openrouter	openrouter/qwen/qwen-2.5-coder-32b-instruct	128000	t	2026-09-16 22:14:43.074623
openrouter/qwen/qwen-vl-plus	Openrouter	openrouter/qwen/qwen-vl-plus	128000	t	2026-09-16 22:14:43.074945
openrouter/qwen/qwen3-coder	Openrouter	openrouter/qwen/qwen3-coder	128000	t	2026-09-16 22:14:43.075263
openrouter/qwen/qwen3-coder-plus	Openrouter	openrouter/qwen/qwen3-coder-plus	128000	t	2026-09-16 22:14:43.075562
openrouter/qwen/qwen3-235b-a22b-2507	Openrouter	openrouter/qwen/qwen3-235b-a22b-2507	128000	t	2026-09-16 22:14:43.075856
openrouter/qwen/qwen3-235b-a22b-thinking-2507	Openrouter	openrouter/qwen/qwen3-235b-a22b-thinking-2507	128000	t	2026-09-16 22:14:43.076172
openrouter/qwen/qwen3.6-plus	Openrouter	openrouter/qwen/qwen3.6-plus	128000	t	2026-09-16 22:14:43.076466
openrouter/qwen/qwen3.5-35b-a3b	Openrouter	openrouter/qwen/qwen3.5-35b-a3b	128000	t	2026-09-16 22:14:43.076771
openrouter/qwen/qwen3.5-27b	Openrouter	openrouter/qwen/qwen3.5-27b	128000	t	2026-09-16 22:14:43.077076
openrouter/qwen/qwen3.5-122b-a10b	Openrouter	openrouter/qwen/qwen3.5-122b-a10b	128000	t	2026-09-16 22:14:43.077538
openrouter/qwen/qwen3.5-flash-02-23	Openrouter	openrouter/qwen/qwen3.5-flash-02-23	128000	t	2026-09-16 22:14:43.077844
openrouter/qwen/qwen3.5-plus-02-15	Openrouter	openrouter/qwen/qwen3.5-plus-02-15	128000	t	2026-09-16 22:14:43.078156
openrouter/qwen/qwen3.5-397b-a17b	Openrouter	openrouter/qwen/qwen3.5-397b-a17b	128000	t	2026-09-16 22:14:43.078488
openrouter/z-ai/glm-4.6	Openrouter	openrouter/z-ai/glm-4.6	128000	t	2026-09-16 22:14:43.078803
openrouter/z-ai/glm-4.6:exacto	Openrouter	openrouter/z-ai/glm-4.6:exacto	128000	t	2026-09-16 22:14:43.079175
openrouter/z-ai/glm-4.7	Openrouter	openrouter/z-ai/glm-4.7	128000	t	2026-09-16 22:14:43.07954
openrouter/z-ai/glm-4.7-flash	Openrouter	openrouter/z-ai/glm-4.7-flash	128000	t	2026-09-16 22:14:43.079876
openrouter/z-ai/glm-5	Openrouter	openrouter/z-ai/glm-5	128000	t	2026-09-16 22:14:43.080237
openrouter/z-ai/glm-5.1	Openrouter	openrouter/z-ai/glm-5.1	128000	t	2026-09-16 22:14:43.080601
openrouter/minimax/minimax-m2.1	Openrouter	openrouter/minimax/minimax-m2.1	128000	t	2026-09-16 22:14:43.081117
openrouter/minimax/minimax-m2.5	Openrouter	openrouter/minimax/minimax-m2.5	128000	t	2026-09-16 22:14:43.081535
ovhcloud/DeepSeek-R1-Distill-Llama-70B	Ovhcloud	ovhcloud/DeepSeek-R1-Distill-Llama-70B	128000	t	2026-09-16 22:14:43.081887
ovhcloud/Qwen2.5-Coder-32B-Instruct	Ovhcloud	ovhcloud/Qwen2.5-Coder-32B-Instruct	128000	t	2026-09-16 22:14:43.082216
ovhcloud/Qwen2.5-VL-72B-Instruct	Ovhcloud	ovhcloud/Qwen2.5-VL-72B-Instruct	128000	t	2026-09-16 22:14:43.082588
ovhcloud/Qwen3-32B	Ovhcloud	ovhcloud/Qwen3-32B	128000	t	2026-09-16 22:14:43.083422
perplexity/perplexity/deepseek-v4-flash-0731	Perplexity	perplexity/perplexity/deepseek-v4-flash-0731	128000	t	2026-09-16 22:14:43.083792
perplexity/perplexity/glm-5.2	Perplexity	perplexity/perplexity/glm-5.2	128000	t	2026-09-16 22:14:43.084292
perplexity/perplexity/kimi-k3	Perplexity	perplexity/perplexity/kimi-k3	128000	t	2026-09-16 22:14:43.0846
perplexity/perplexity/kimi-k2.7-code	Perplexity	perplexity/perplexity/kimi-k2.7-code	128000	t	2026-09-16 22:14:43.08627
publicai/aisingapore/Qwen-SEA-LION-v4-32B-IT	Publicai	publicai/aisingapore/Qwen-SEA-LION-v4-32B-IT	128000	t	2026-09-16 22:14:43.087199
qwen.qwen3-coder-480b-a35b-v1:0	Chinese AI	qwen.qwen3-coder-480b-a35b-v1:0	128000	t	2026-09-16 22:14:43.087508
qwen.qwen3-235b-a22b-2507-v1:0	Chinese AI	qwen.qwen3-235b-a22b-2507-v1:0	128000	t	2026-09-16 22:14:43.087839
qwen.qwen3-coder-30b-a3b-v1:0	Chinese AI	qwen.qwen3-coder-30b-a3b-v1:0	128000	t	2026-09-16 22:14:43.088556
qwen.qwen3-32b-v1:0	Chinese AI	qwen.qwen3-32b-v1:0	128000	t	2026-09-16 22:14:43.088964
qwen.qwen3-next-80b-a3b	Chinese AI	qwen.qwen3-next-80b-a3b	128000	t	2026-09-16 22:14:43.089274
qwen.qwen3-vl-235b-a22b	Chinese AI	qwen.qwen3-vl-235b-a22b	128000	t	2026-09-16 22:14:43.089734
qwen.qwen3-coder-next	Chinese AI	qwen.qwen3-coder-next	128000	t	2026-09-16 22:14:43.090044
replicate/qwen/qwen3-235b-a22b-instruct-2507	Replicate	replicate/qwen/qwen3-235b-a22b-instruct-2507	128000	t	2026-09-16 22:14:43.09046
replicate/deepseek-ai/deepseek-v3	Replicate	replicate/deepseek-ai/deepseek-v3	128000	t	2026-09-16 22:14:43.090769
replicate/deepseek-ai/deepseek-v3.1	Replicate	replicate/deepseek-ai/deepseek-v3.1	128000	t	2026-09-16 22:14:43.091071
replicate/deepseek-ai/deepseek-r1	Replicate	replicate/deepseek-ai/deepseek-r1	128000	t	2026-09-16 22:14:43.091395
sambanova/MiniMax-M2.7	Sambanova	sambanova/MiniMax-M2.7	128000	t	2026-09-16 22:14:43.09222
sambanova/DeepSeek-R1	Sambanova	sambanova/DeepSeek-R1	128000	t	2026-09-16 22:14:43.092529
sambanova/DeepSeek-R1-Distill-Llama-70B	Sambanova	sambanova/DeepSeek-R1-Distill-Llama-70B	128000	t	2026-09-16 22:14:43.092811
sambanova/DeepSeek-V3-0324	Sambanova	sambanova/DeepSeek-V3-0324	128000	t	2026-09-16 22:14:43.0931
sambanova/Qwen2-Audio-7B-Instruct	Sambanova	sambanova/Qwen2-Audio-7B-Instruct	128000	t	2026-09-16 22:14:43.093388
sambanova/Qwen3-32B	Sambanova	sambanova/Qwen3-32B	128000	t	2026-09-16 22:14:43.093679
sambanova/DeepSeek-V3.1	Sambanova	sambanova/DeepSeek-V3.1	128000	t	2026-09-16 22:14:43.093988
sambanova/DeepSeek-V3.2	Sambanova	sambanova/DeepSeek-V3.2	128000	t	2026-09-16 22:14:43.094371
scx-ai/GLM-5.2	Scx-ai	scx-ai/GLM-5.2	128000	t	2026-09-16 22:14:43.0947
scx-ai/Qwen3.8-Max	Scx-ai	scx-ai/Qwen3.8-Max	128000	t	2026-09-16 22:14:43.09501
snowflake/deepseek-r1	Snowflake	snowflake/deepseek-r1	128000	t	2026-09-16 22:14:43.095308
together_ai/Qwen/Qwen2.5-72B-Instruct-Turbo	Together_ai	together_ai/Qwen/Qwen2.5-72B-Instruct-Turbo	128000	t	2026-09-16 22:14:43.095679
together_ai/Qwen/Qwen2.5-7B-Instruct-Turbo	Together_ai	together_ai/Qwen/Qwen2.5-7B-Instruct-Turbo	128000	t	2026-09-16 22:14:43.096027
together_ai/Qwen/Qwen3-235B-A22B-Instruct-2507-tput	Together_ai	together_ai/Qwen/Qwen3-235B-A22B-Instruct-2507-tput	128000	t	2026-09-16 22:14:43.096309
together_ai/Qwen/Qwen3-235B-A22B-Thinking-2507	Together_ai	together_ai/Qwen/Qwen3-235B-A22B-Thinking-2507	128000	t	2026-09-16 22:14:43.097462
together_ai/Qwen/Qwen3-235B-A22B-fp8-tput	Together_ai	together_ai/Qwen/Qwen3-235B-A22B-fp8-tput	128000	t	2026-09-16 22:14:43.097761
together_ai/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	Together_ai	together_ai/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	128000	t	2026-09-16 22:14:43.098067
together_ai/deepseek-ai/DeepSeek-R1	Together_ai	together_ai/deepseek-ai/DeepSeek-R1	128000	t	2026-09-16 22:14:43.098368
together_ai/deepseek-ai/DeepSeek-R1-0528-tput	Together_ai	together_ai/deepseek-ai/DeepSeek-R1-0528-tput	128000	t	2026-09-16 22:14:43.098661
together_ai/deepseek-ai/DeepSeek-V3	Together_ai	together_ai/deepseek-ai/DeepSeek-V3	128000	t	2026-09-16 22:14:43.098953
together_ai/deepseek-ai/DeepSeek-V3.1	Together_ai	together_ai/deepseek-ai/DeepSeek-V3.1	128000	t	2026-09-16 22:14:43.099238
together_ai/moonshotai/Kimi-K2-Instruct	Together_ai	together_ai/moonshotai/Kimi-K2-Instruct	128000	t	2026-09-16 22:14:43.099542
together_ai/zai-org/GLM-4.5-Air-FP8	Together_ai	together_ai/zai-org/GLM-4.5-Air-FP8	128000	t	2026-09-16 22:14:43.099871
together_ai/zai-org/GLM-4.6	Together_ai	together_ai/zai-org/GLM-4.6	128000	t	2026-09-16 22:14:43.100161
together_ai/zai-org/GLM-4.7	Together_ai	together_ai/zai-org/GLM-4.7	128000	t	2026-09-16 22:14:43.100456
together_ai/moonshotai/Kimi-K2.5	Together_ai	together_ai/moonshotai/Kimi-K2.5	128000	t	2026-09-16 22:14:43.100752
together_ai/moonshotai/Kimi-K2-Instruct-0905	Together_ai	together_ai/moonshotai/Kimi-K2-Instruct-0905	128000	t	2026-09-16 22:14:43.101048
together_ai/Qwen/Qwen3-Next-80B-A3B-Instruct	Together_ai	together_ai/Qwen/Qwen3-Next-80B-A3B-Instruct	128000	t	2026-09-16 22:14:43.101345
together_ai/Qwen/Qwen3-Next-80B-A3B-Thinking	Together_ai	together_ai/Qwen/Qwen3-Next-80B-A3B-Thinking	128000	t	2026-09-16 22:14:43.101648
together_ai/Qwen/Qwen3.5-397B-A17B	Together_ai	together_ai/Qwen/Qwen3.5-397B-A17B	128000	t	2026-09-16 22:14:43.101946
together_ai/MiniMaxAI/MiniMax-M3	Together_ai	together_ai/MiniMaxAI/MiniMax-M3	128000	t	2026-09-16 22:14:43.102247
together_ai/Qwen/Qwen3.5-9B	Together_ai	together_ai/Qwen/Qwen3.5-9B	128000	t	2026-09-16 22:14:43.102564
together_ai/Qwen/Qwen3.6-Plus	Together_ai	together_ai/Qwen/Qwen3.6-Plus	128000	t	2026-09-16 22:14:43.102873
together_ai/Qwen/Qwen3.7-Max	Together_ai	together_ai/Qwen/Qwen3.7-Max	128000	t	2026-09-16 22:14:43.103189
together_ai/Qwen/Qwen3.7-Plus	Together_ai	together_ai/Qwen/Qwen3.7-Plus	128000	t	2026-09-16 22:14:43.103516
together_ai/Qwen/Qwen3.8-2.4T-A95B	Together_ai	together_ai/Qwen/Qwen3.8-2.4T-A95B	128000	t	2026-09-16 22:14:43.103816
together_ai/arize-ai/qwen-2-1.5b-instruct	Together_ai	together_ai/arize-ai/qwen-2-1.5b-instruct	128000	t	2026-09-16 22:14:43.104281
together_ai/deepseek-ai/DeepSeek-V4-Flash-0731	Together_ai	together_ai/deepseek-ai/DeepSeek-V4-Flash-0731	128000	t	2026-09-16 22:14:43.104574
together_ai/deepseek-ai/DeepSeek-V4-Pro	Together_ai	together_ai/deepseek-ai/DeepSeek-V4-Pro	128000	t	2026-09-16 22:14:43.104889
together_ai/deepseek-ai/DeepSeek-V4-Pro-0813	Together_ai	together_ai/deepseek-ai/DeepSeek-V4-Pro-0813	128000	t	2026-09-16 22:14:43.105197
together_ai/moonshotai/Kimi-K2.7-Code	Together_ai	together_ai/moonshotai/Kimi-K2.7-Code	128000	t	2026-09-16 22:14:43.105514
together_ai/moonshotai/Kimi-K3	Together_ai	together_ai/moonshotai/Kimi-K3	128000	t	2026-09-16 22:14:43.105808
together_ai/zai-org/GLM-5.2	Together_ai	together_ai/zai-org/GLM-5.2	128000	t	2026-09-16 22:14:43.106119
together_ai/zai-org/GLM-5.3	Together_ai	together_ai/zai-org/GLM-5.3	128000	t	2026-09-16 22:14:43.106424
together_ai/zai-org/GLM-5.3-Flash	Together_ai	together_ai/zai-org/GLM-5.3-Flash	128000	t	2026-09-16 22:14:43.106738
us.deepseek.r1-v1:0	Chinese AI	us.deepseek.r1-v1:0	128000	t	2026-09-16 22:14:43.107074
us.deepseek.v3.2	Chinese AI	us.deepseek.v3.2	128000	t	2026-09-16 22:14:43.107403
eu.deepseek.v3.2	Chinese AI	eu.deepseek.v3.2	128000	t	2026-09-16 22:14:43.1077
vercel_ai_gateway/alibaba/qwen-3-14b	Vercel_ai_gateway	vercel_ai_gateway/alibaba/qwen-3-14b	128000	t	2026-09-16 22:14:43.108033
vercel_ai_gateway/alibaba/qwen-3-235b	Vercel_ai_gateway	vercel_ai_gateway/alibaba/qwen-3-235b	128000	t	2026-09-16 22:14:43.10833
vercel_ai_gateway/alibaba/qwen-3-30b	Vercel_ai_gateway	vercel_ai_gateway/alibaba/qwen-3-30b	128000	t	2026-09-16 22:14:43.108635
vercel_ai_gateway/alibaba/qwen-3-32b	Vercel_ai_gateway	vercel_ai_gateway/alibaba/qwen-3-32b	128000	t	2026-09-16 22:14:43.108932
vercel_ai_gateway/alibaba/qwen3-coder	Vercel_ai_gateway	vercel_ai_gateway/alibaba/qwen3-coder	128000	t	2026-09-16 22:14:43.109381
vercel_ai_gateway/deepseek/deepseek-r1	Vercel_ai_gateway	vercel_ai_gateway/deepseek/deepseek-r1	128000	t	2026-09-16 22:14:43.109722
vercel_ai_gateway/deepseek/deepseek-r1-distill-llama-70b	Vercel_ai_gateway	vercel_ai_gateway/deepseek/deepseek-r1-distill-llama-70b	128000	t	2026-09-16 22:14:43.110038
vercel_ai_gateway/deepseek/deepseek-v3	Vercel_ai_gateway	vercel_ai_gateway/deepseek/deepseek-v3	128000	t	2026-09-16 22:14:43.110345
vercel_ai_gateway/moonshotai/kimi-k2	Vercel_ai_gateway	vercel_ai_gateway/moonshotai/kimi-k2	128000	t	2026-09-16 22:14:43.110685
vercel_ai_gateway/zai/glm-4.5	Vercel_ai_gateway	vercel_ai_gateway/zai/glm-4.5	128000	t	2026-09-16 22:14:43.111021
vercel_ai_gateway/zai/glm-4.5-air	Vercel_ai_gateway	vercel_ai_gateway/zai/glm-4.5-air	128000	t	2026-09-16 22:14:43.111514
vercel_ai_gateway/zai/glm-4.6	Vercel_ai_gateway	vercel_ai_gateway/zai/glm-4.6	128000	t	2026-09-16 22:14:43.111859
vertex_ai/deepseek-ai/deepseek-v3.1-maas	Vertex_ai	vertex_ai/deepseek-ai/deepseek-v3.1-maas	128000	t	2026-09-16 22:14:43.112226
vertex_ai/deepseek-ai/deepseek-v3.2-maas	Vertex_ai	vertex_ai/deepseek-ai/deepseek-v3.2-maas	128000	t	2026-09-16 22:14:43.112551
vertex_ai/deepseek-ai/deepseek-r1-0528-maas	Vertex_ai	vertex_ai/deepseek-ai/deepseek-r1-0528-maas	128000	t	2026-09-16 22:14:43.112884
vertex_ai/minimaxai/minimax-m2-maas	Vertex_ai	vertex_ai/minimaxai/minimax-m2-maas	128000	t	2026-09-16 22:14:43.113222
vertex_ai/moonshotai/kimi-k2-thinking-maas	Vertex_ai	vertex_ai/moonshotai/kimi-k2-thinking-maas	128000	t	2026-09-16 22:14:43.11352
vertex_ai/zai-org/glm-4.7-maas	Vertex_ai	vertex_ai/zai-org/glm-4.7-maas	128000	t	2026-09-16 22:14:43.113849
vertex_ai/zai-org/glm-5-maas	Vertex_ai	vertex_ai/zai-org/glm-5-maas	128000	t	2026-09-16 22:14:43.114156
vertex_ai/deepseek-ai/deepseek-ocr-maas	Vertex_ai	vertex_ai/deepseek-ai/deepseek-ocr-maas	128000	t	2026-09-16 22:14:43.114462
vertex_ai/qwen/qwen3-235b-a22b-instruct-2507-maas	Vertex_ai	vertex_ai/qwen/qwen3-235b-a22b-instruct-2507-maas	128000	t	2026-09-16 22:14:43.114777
vertex_ai/qwen/qwen3-coder-480b-a35b-instruct-maas	Vertex_ai	vertex_ai/qwen/qwen3-coder-480b-a35b-instruct-maas	128000	t	2026-09-16 22:14:43.115083
vertex_ai/qwen/qwen3-next-80b-a3b-instruct-maas	Vertex_ai	vertex_ai/qwen/qwen3-next-80b-a3b-instruct-maas	128000	t	2026-09-16 22:14:43.115385
vertex_ai/qwen/qwen3-next-80b-a3b-thinking-maas	Vertex_ai	vertex_ai/qwen/qwen3-next-80b-a3b-thinking-maas	128000	t	2026-09-16 22:14:43.115693
wandb/zai-org/GLM-4.5	Wandb	wandb/zai-org/GLM-4.5	128000	t	2026-09-16 22:14:43.116037
wandb/Qwen/Qwen3-235B-A22B-Instruct-2507	Wandb	wandb/Qwen/Qwen3-235B-A22B-Instruct-2507	128000	t	2026-09-16 22:22:53.246249
wandb/Qwen/Qwen3-Coder-480B-A35B-Instruct	Wandb	wandb/Qwen/Qwen3-Coder-480B-A35B-Instruct	128000	t	2026-09-16 22:22:53.246978
wandb/Qwen/Qwen3-235B-A22B-Thinking-2507	Wandb	wandb/Qwen/Qwen3-235B-A22B-Thinking-2507	128000	t	2026-09-16 22:22:53.247323
wandb/moonshotai/Kimi-K2-Instruct	Wandb	wandb/moonshotai/Kimi-K2-Instruct	128000	t	2026-09-16 22:22:53.247661
wandb/moonshotai/Kimi-K2.5	Wandb	wandb/moonshotai/Kimi-K2.5	128000	t	2026-09-16 22:22:53.248018
wandb/MiniMaxAI/MiniMax-M2.5	Wandb	wandb/MiniMaxAI/MiniMax-M2.5	128000	t	2026-09-16 22:22:53.24837
wandb/deepseek-ai/DeepSeek-V3.1	Wandb	wandb/deepseek-ai/DeepSeek-V3.1	128000	t	2026-09-16 22:22:53.248882
wandb/deepseek-ai/DeepSeek-R1-0528	Wandb	wandb/deepseek-ai/DeepSeek-R1-0528	128000	t	2026-09-16 22:22:53.249257
wandb/deepseek-ai/DeepSeek-V3-0324	Wandb	wandb/deepseek-ai/DeepSeek-V3-0324	128000	t	2026-09-16 22:22:53.249629
zai.glm-4.7	Chinese AI	zai.glm-4.7	128000	t	2026-09-16 22:22:53.250027
zai.glm-5	Chinese AI	zai.glm-5	128000	t	2026-09-16 22:22:53.250372
zai.glm-4.7-flash	Chinese AI	zai.glm-4.7-flash	128000	t	2026-09-16 22:22:53.250703
zai/glm-5	Zai	zai/glm-5	128000	t	2026-09-16 22:22:53.251086
zai/glm-5.3	Zai	zai/glm-5.3	128000	t	2026-09-16 22:22:53.251408
zai/glm-5.3-flash	Zai	zai/glm-5.3-flash	128000	t	2026-09-16 22:22:53.251751
zai/glm-5.1	Zai	zai/glm-5.1	128000	t	2026-09-16 22:22:53.252094
zai/glm-5-code	Zai	zai/glm-5-code	128000	t	2026-09-16 22:22:53.252442
zai/glm-4.7	Zai	zai/glm-4.7	128000	t	2026-09-16 22:22:53.252798
zai/glm-4.7-flash	Zai	zai/glm-4.7-flash	128000	t	2026-09-16 22:22:53.253097
zai/glm-4.6	Zai	zai/glm-4.6	128000	t	2026-09-16 22:22:53.253384
zai/glm-4.5	Zai	zai/glm-4.5	128000	t	2026-09-16 22:22:53.253721
zai/glm-4.5v	Zai	zai/glm-4.5v	128000	t	2026-09-16 22:22:53.254013
zai/glm-4.5-x	Zai	zai/glm-4.5-x	128000	t	2026-09-16 22:22:53.25431
zai/glm-4.5-air	Zai	zai/glm-4.5-air	128000	t	2026-09-16 22:22:53.254603
zai/glm-4.5-airx	Zai	zai/glm-4.5-airx	128000	t	2026-09-16 22:22:53.254906
zai/glm-4-32b-0414-128k	Zai	zai/glm-4-32b-0414-128k	128000	t	2026-09-16 22:22:53.255217
zai/glm-4.5-flash	Zai	zai/glm-4.5-flash	128000	t	2026-09-16 22:22:53.255524
fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-a35b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-a35b-instruct	128000	t	2026-09-16 22:22:53.25587
fireworks_ai/accounts/fireworks/models/code-qwen-1p5-7b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/code-qwen-1p5-7b	128000	t	2026-09-16 22:22:53.256402
fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-14b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-14b	128000	t	2026-09-16 22:22:53.256785
fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-32b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-32b	128000	t	2026-09-16 22:22:53.257161
fireworks_ai/accounts/fireworks/models/deepseek-coder-1b-base	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-coder-1b-base	128000	t	2026-09-16 22:22:53.25753
fireworks_ai/accounts/fireworks/models/deepseek-coder-33b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-coder-33b-instruct	128000	t	2026-09-16 22:22:53.257876
fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base	128000	t	2026-09-16 22:22:53.258218
fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base-v1p5	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base-v1p5	128000	t	2026-09-16 22:22:53.258583
fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-instruct-v1p5	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-instruct-v1p5	128000	t	2026-09-16 22:22:53.258944
fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-lite-base	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-lite-base	128000	t	2026-09-16 22:22:53.259292
fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-lite-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-lite-instruct	128000	t	2026-09-16 22:22:53.25967
fireworks_ai/accounts/fireworks/models/deepseek-prover-v2	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-prover-v2	128000	t	2026-09-16 22:22:53.260045
fireworks_ai/accounts/fireworks/models/deepseek-r1-0528-distill-qwen3-8b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-0528-distill-qwen3-8b	128000	t	2026-09-16 22:22:53.26045
fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-70b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-70b	128000	t	2026-09-16 22:22:53.260809
fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-8b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-8b	128000	t	2026-09-16 22:22:53.261176
fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-14b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-14b	128000	t	2026-09-16 22:22:53.261684
fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-1p5b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-1p5b	128000	t	2026-09-16 22:22:53.262049
fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-32b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-32b	128000	t	2026-09-16 22:22:53.26241
fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-7b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-7b	128000	t	2026-09-16 22:22:53.262765
fireworks_ai/accounts/fireworks/models/deepseek-v2-lite-chat	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v2-lite-chat	128000	t	2026-09-16 22:22:53.2631
fireworks_ai/accounts/fireworks/models/deepseek-v2p5	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v2p5	128000	t	2026-09-16 22:22:53.263447
fireworks_ai/accounts/fireworks/models/dolphin-2-9-2-qwen2-72b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/dolphin-2-9-2-qwen2-72b	128000	t	2026-09-16 22:22:53.263863
fireworks_ai/accounts/fireworks/models/glm-4p5v	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-4p5v	128000	t	2026-09-16 22:22:53.264265
fireworks_ai/accounts/fireworks/models/minimax-m1-80k	Fireworks_ai	fireworks_ai/accounts/fireworks/models/minimax-m1-80k	128000	t	2026-09-16 22:22:53.264663
fireworks_ai/accounts/fireworks/models/minimax-m2	Fireworks_ai	fireworks_ai/accounts/fireworks/models/minimax-m2	128000	t	2026-09-16 22:22:53.265034
fireworks_ai/accounts/fireworks/models/qwen-qwq-32b-preview	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen-qwq-32b-preview	128000	t	2026-09-16 22:22:53.265446
fireworks_ai/accounts/fireworks/models/qwen-v2p5-14b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen-v2p5-14b-instruct	128000	t	2026-09-16 22:22:53.265807
fireworks_ai/accounts/fireworks/models/qwen-v2p5-7b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen-v2p5-7b	128000	t	2026-09-16 22:22:53.266174
fireworks_ai/accounts/fireworks/models/qwen1p5-72b-chat	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen1p5-72b-chat	128000	t	2026-09-16 22:22:53.266536
fireworks_ai/accounts/fireworks/models/qwen2-7b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2-7b-instruct	128000	t	2026-09-16 22:22:53.266891
fireworks_ai/accounts/fireworks/models/qwen2-vl-2b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2-vl-2b-instruct	128000	t	2026-09-16 22:22:53.267252
fireworks_ai/accounts/fireworks/models/qwen2-vl-72b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2-vl-72b-instruct	128000	t	2026-09-16 22:22:53.267621
fireworks_ai/accounts/fireworks/models/qwen2-vl-7b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2-vl-7b-instruct	128000	t	2026-09-16 22:22:53.267978
fireworks_ai/accounts/fireworks/models/qwen2p5-0p5b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-0p5b-instruct	128000	t	2026-09-16 22:22:53.268333
fireworks_ai/accounts/fireworks/models/qwen2p5-14b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-14b	128000	t	2026-09-16 22:22:53.268683
fireworks_ai/accounts/fireworks/models/qwen2p5-1p5b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-1p5b-instruct	128000	t	2026-09-16 22:22:53.26919
fireworks_ai/accounts/fireworks/models/qwen2p5-32b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-32b	128000	t	2026-09-16 22:22:53.269526
fireworks_ai/accounts/fireworks/models/qwen2p5-32b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-32b-instruct	128000	t	2026-09-16 22:22:53.269836
fireworks_ai/accounts/fireworks/models/qwen2p5-72b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-72b	128000	t	2026-09-16 22:22:53.270168
fireworks_ai/accounts/fireworks/models/qwen2p5-72b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-72b-instruct	128000	t	2026-09-16 22:22:53.270501
fireworks_ai/accounts/fireworks/models/qwen2p5-7b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-7b-instruct	128000	t	2026-09-16 22:22:53.270817
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b	128000	t	2026-09-16 22:22:53.27114
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b-instruct	128000	t	2026-09-16 22:22:53.271475
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b	128000	t	2026-09-16 22:22:53.271796
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b-instruct	128000	t	2026-09-16 22:22:53.27211
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b	128000	t	2026-09-16 22:22:53.272441
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b-instruct	128000	t	2026-09-16 22:22:53.272751
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b	128000	t	2026-09-16 22:22:53.273078
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-128k	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-128k	128000	t	2026-09-16 22:22:53.273386
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-32k-rope	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-32k-rope	128000	t	2026-09-16 22:22:53.273706
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-64k	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-64k	128000	t	2026-09-16 22:22:53.274029
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b	128000	t	2026-09-16 22:22:53.274353
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b-instruct	128000	t	2026-09-16 22:22:53.274909
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b	128000	t	2026-09-16 22:22:53.275249
fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b-instruct	128000	t	2026-09-16 22:22:53.275617
fireworks_ai/accounts/fireworks/models/qwen2p5-math-72b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-math-72b-instruct	128000	t	2026-09-16 22:22:53.275998
fireworks_ai/accounts/fireworks/models/qwen2p5-vl-32b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-32b-instruct	128000	t	2026-09-16 22:22:53.276366
fireworks_ai/accounts/fireworks/models/qwen2p5-vl-3b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-3b-instruct	128000	t	2026-09-16 22:22:53.276742
fireworks_ai/accounts/fireworks/models/qwen2p5-vl-72b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-72b-instruct	128000	t	2026-09-16 22:22:53.277327
fireworks_ai/accounts/fireworks/models/qwen2p5-vl-7b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-7b-instruct	128000	t	2026-09-16 22:22:53.277688
fireworks_ai/accounts/fireworks/models/qwen3-0p6b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-0p6b	128000	t	2026-09-16 22:22:53.278041
fireworks_ai/accounts/fireworks/models/qwen3-14b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-14b	128000	t	2026-09-16 22:22:53.2784
fireworks_ai/accounts/fireworks/models/qwen3-1p7b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-1p7b	128000	t	2026-09-16 22:22:53.278748
fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft	128000	t	2026-09-16 22:22:53.279104
fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-131072	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-131072	128000	t	2026-09-16 22:22:53.279453
fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-40960	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-40960	128000	t	2026-09-16 22:22:53.279817
fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b	128000	t	2026-09-16 22:22:53.28018
fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b-instruct-2507	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b-instruct-2507	128000	t	2026-09-16 22:22:53.28057
fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b-thinking-2507	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b-thinking-2507	128000	t	2026-09-16 22:22:53.280981
fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b	128000	t	2026-09-16 22:22:53.281352
fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-instruct-2507	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-instruct-2507	128000	t	2026-09-16 22:22:53.281715
fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-thinking-2507	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-thinking-2507	128000	t	2026-09-16 22:22:53.282076
fireworks_ai/accounts/fireworks/models/qwen3-32b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-32b	128000	t	2026-09-16 22:22:53.282405
fireworks_ai/accounts/fireworks/models/qwen3-4b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-4b	128000	t	2026-09-16 22:22:53.282725
novita/deepseek/deepseek-r1-distill-qwen-32b	Novita	novita/deepseek/deepseek-r1-distill-qwen-32b	128000	t	2026-09-16 22:22:53.302764
fireworks_ai/accounts/fireworks/models/qwen3-4b-instruct-2507	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-4b-instruct-2507	128000	t	2026-09-16 22:22:53.283064
fireworks_ai/accounts/fireworks/models/qwen3-8b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-8b	128000	t	2026-09-16 22:22:53.283436
fireworks_ai/accounts/fireworks/models/qwen3-coder-30b-a3b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-coder-30b-a3b-instruct	128000	t	2026-09-16 22:22:53.283801
fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-instruct-bf16	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-instruct-bf16	128000	t	2026-09-16 22:22:53.284316
fireworks_ai/accounts/fireworks/models/qwen3-embedding-0p6b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-embedding-0p6b	128000	t	2026-09-16 22:22:53.284687
fireworks_ai/accounts/fireworks/models/qwen3-embedding-4b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-embedding-4b	128000	t	2026-09-16 22:22:53.285028
fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-instruct	128000	t	2026-09-16 22:22:53.285334
fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-thinking	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-thinking	128000	t	2026-09-16 22:22:53.285693
fireworks_ai/accounts/fireworks/models/qwen3-reranker-0p6b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-reranker-0p6b	128000	t	2026-09-16 22:22:53.28607
fireworks_ai/accounts/fireworks/models/qwen3-reranker-4b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-reranker-4b	128000	t	2026-09-16 22:22:53.286397
fireworks_ai/accounts/fireworks/models/qwen3-reranker-8b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-reranker-8b	128000	t	2026-09-16 22:22:53.286713
fireworks_ai/accounts/fireworks/models/qwen3-vl-235b-a22b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-vl-235b-a22b-instruct	128000	t	2026-09-16 22:22:53.287037
fireworks_ai/accounts/fireworks/models/qwen3-vl-235b-a22b-thinking	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-vl-235b-a22b-thinking	128000	t	2026-09-16 22:22:53.287383
fireworks_ai/accounts/fireworks/models/qwen3-vl-30b-a3b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-vl-30b-a3b-instruct	128000	t	2026-09-16 22:22:53.287702
fireworks_ai/accounts/fireworks/models/qwen3-vl-30b-a3b-thinking	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-vl-30b-a3b-thinking	128000	t	2026-09-16 22:22:53.288026
fireworks_ai/accounts/fireworks/models/qwen3-vl-32b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-vl-32b-instruct	128000	t	2026-09-16 22:22:53.288334
fireworks_ai/accounts/fireworks/models/qwen3-vl-8b-instruct	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-vl-8b-instruct	128000	t	2026-09-16 22:22:53.288647
fireworks_ai/accounts/fireworks/models/qwen3p7-plus	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3p7-plus	128000	t	2026-09-16 22:22:53.288974
fireworks_ai/accounts/fireworks/routers/glm-5p1-fast	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/glm-5p1-fast	128000	t	2026-09-16 22:22:53.289307
fireworks_ai/accounts/fireworks/routers/kimi-k2p6-fast	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/kimi-k2p6-fast	128000	t	2026-09-16 22:22:53.289622
fireworks_ai/accounts/fireworks/routers/kimi-k2p7-code-fast	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/kimi-k2p7-code-fast	128000	t	2026-09-16 22:22:53.289931
scaleway/qwen/qwen3.5-397b-a17b	Scaleway	scaleway/qwen/qwen3.5-397b-a17b	128000	t	2026-09-16 22:22:53.290238
scaleway/qwen/qwen3.6-35b-a3b	Scaleway	scaleway/qwen/qwen3.6-35b-a3b	128000	t	2026-09-16 22:22:53.290722
scaleway/qwen/qwen3-235b-a22b-instruct-2507	Scaleway	scaleway/qwen/qwen3-235b-a22b-instruct-2507	128000	t	2026-09-16 22:22:53.291056
scaleway/qwen/qwen3-embedding-8b	Scaleway	scaleway/qwen/qwen3-embedding-8b	128000	t	2026-09-16 22:22:53.291403
scaleway/qwen/qwen3-coder-30b-a3b-instruct	Scaleway	scaleway/qwen/qwen3-coder-30b-a3b-instruct	128000	t	2026-09-16 22:22:53.291747
novita/deepseek/deepseek-v3.2	Novita	novita/deepseek/deepseek-v3.2	128000	t	2026-09-16 22:22:53.292123
novita/minimax/minimax-m2.1	Novita	novita/minimax/minimax-m2.1	128000	t	2026-09-16 22:22:53.292481
novita/zai-org/glm-4.7	Novita	novita/zai-org/glm-4.7	128000	t	2026-09-16 22:22:53.292835
novita/zai-org/autoglm-phone-9b-multilingual	Novita	novita/zai-org/autoglm-phone-9b-multilingual	128000	t	2026-09-16 22:22:53.293197
novita/moonshotai/kimi-k2-thinking	Novita	novita/moonshotai/kimi-k2-thinking	128000	t	2026-09-16 22:22:53.293567
novita/minimax/minimax-m2	Novita	novita/minimax/minimax-m2	128000	t	2026-09-16 22:22:53.293915
novita/deepseek/deepseek-v3.2-exp	Novita	novita/deepseek/deepseek-v3.2-exp	128000	t	2026-09-16 22:22:53.294257
novita/qwen/qwen3-vl-235b-a22b-thinking	Novita	novita/qwen/qwen3-vl-235b-a22b-thinking	128000	t	2026-09-16 22:22:53.294596
novita/zai-org/glm-4.6v	Novita	novita/zai-org/glm-4.6v	128000	t	2026-09-16 22:22:53.294925
novita/zai-org/glm-4.6	Novita	novita/zai-org/glm-4.6	128000	t	2026-09-16 22:22:53.295267
novita/qwen/qwen3-next-80b-a3b-instruct	Novita	novita/qwen/qwen3-next-80b-a3b-instruct	128000	t	2026-09-16 22:22:53.295754
novita/qwen/qwen3-next-80b-a3b-thinking	Novita	novita/qwen/qwen3-next-80b-a3b-thinking	128000	t	2026-09-16 22:22:53.29609
novita/deepseek/deepseek-ocr	Novita	novita/deepseek/deepseek-ocr	128000	t	2026-09-16 22:22:53.296435
novita/deepseek/deepseek-v3.1-terminus	Novita	novita/deepseek/deepseek-v3.1-terminus	128000	t	2026-09-16 22:22:53.296776
novita/qwen/qwen3-vl-235b-a22b-instruct	Novita	novita/qwen/qwen3-vl-235b-a22b-instruct	128000	t	2026-09-16 22:22:53.297171
novita/qwen/qwen3-max	Novita	novita/qwen/qwen3-max	128000	t	2026-09-16 22:22:53.297538
novita/deepseek/deepseek-v3.1	Novita	novita/deepseek/deepseek-v3.1	128000	t	2026-09-16 22:22:53.297878
novita/moonshotai/kimi-k2-0905	Novita	novita/moonshotai/kimi-k2-0905	128000	t	2026-09-16 22:22:53.298218
novita/qwen/qwen3-coder-480b-a35b-instruct	Novita	novita/qwen/qwen3-coder-480b-a35b-instruct	128000	t	2026-09-16 22:22:53.298584
novita/qwen/qwen3-coder-30b-a3b-instruct	Novita	novita/qwen/qwen3-coder-30b-a3b-instruct	128000	t	2026-09-16 22:22:53.298946
novita/moonshotai/kimi-k2-instruct	Novita	novita/moonshotai/kimi-k2-instruct	128000	t	2026-09-16 22:22:53.299304
novita/deepseek/deepseek-v3-0324	Novita	novita/deepseek/deepseek-v3-0324	128000	t	2026-09-16 22:22:53.299664
novita/zai-org/glm-4.5	Novita	novita/zai-org/glm-4.5	128000	t	2026-09-16 22:22:53.300015
novita/qwen/qwen3-235b-a22b-thinking-2507	Novita	novita/qwen/qwen3-235b-a22b-thinking-2507	128000	t	2026-09-16 22:22:53.300366
novita/zai-org/glm-4.5v	Novita	novita/zai-org/glm-4.5v	128000	t	2026-09-16 22:22:53.300724
novita/qwen/qwen3-235b-a22b-instruct-2507	Novita	novita/qwen/qwen3-235b-a22b-instruct-2507	128000	t	2026-09-16 22:22:53.301056
novita/deepseek/deepseek-r1-distill-qwen-14b	Novita	novita/deepseek/deepseek-r1-distill-qwen-14b	128000	t	2026-09-16 22:22:53.3014
novita/qwen/qwen-2.5-72b-instruct	Novita	novita/qwen/qwen-2.5-72b-instruct	128000	t	2026-09-16 22:22:53.301744
novita/minimaxai/minimax-m1-80k	Novita	novita/minimaxai/minimax-m1-80k	128000	t	2026-09-16 22:22:53.302098
novita/deepseek/deepseek-r1-0528	Novita	novita/deepseek/deepseek-r1-0528	128000	t	2026-09-16 22:22:53.302434
novita/deepseek/deepseek-r1-0528-qwen3-8b	Novita	novita/deepseek/deepseek-r1-0528-qwen3-8b	128000	t	2026-09-16 22:22:53.30309
novita/deepseek/deepseek-r1-distill-llama-70b	Novita	novita/deepseek/deepseek-r1-distill-llama-70b	128000	t	2026-09-16 22:22:53.303572
novita/qwen/qwen3-235b-a22b-fp8	Novita	novita/qwen/qwen3-235b-a22b-fp8	128000	t	2026-09-16 22:22:53.303894
novita/qwen/qwen2.5-vl-72b-instruct	Novita	novita/qwen/qwen2.5-vl-72b-instruct	128000	t	2026-09-16 22:22:53.30423
novita/deepseek/deepseek-prover-v2-671b	Novita	novita/deepseek/deepseek-prover-v2-671b	128000	t	2026-09-16 22:22:53.304535
novita/qwen/qwen3-32b-fp8	Novita	novita/qwen/qwen3-32b-fp8	128000	t	2026-09-16 22:22:53.304841
novita/qwen/qwen3-30b-a3b-fp8	Novita	novita/qwen/qwen3-30b-a3b-fp8	128000	t	2026-09-16 22:22:53.305133
novita/deepseek/deepseek-v3-turbo	Novita	novita/deepseek/deepseek-v3-turbo	128000	t	2026-09-16 22:22:53.305427
novita/deepseek/deepseek-r1-turbo	Novita	novita/deepseek/deepseek-r1-turbo	128000	t	2026-09-16 22:22:53.305721
novita/qwen/qwen3-vl-8b-instruct	Novita	novita/qwen/qwen3-vl-8b-instruct	128000	t	2026-09-16 22:22:53.306032
novita/zai-org/glm-4.5-air	Novita	novita/zai-org/glm-4.5-air	128000	t	2026-09-16 22:22:53.306335
novita/qwen/qwen3-vl-30b-a3b-instruct	Novita	novita/qwen/qwen3-vl-30b-a3b-instruct	128000	t	2026-09-16 22:22:53.30664
novita/qwen/qwen3-vl-30b-a3b-thinking	Novita	novita/qwen/qwen3-vl-30b-a3b-thinking	128000	t	2026-09-16 22:22:53.306936
novita/qwen/qwen3-omni-30b-a3b-thinking	Novita	novita/qwen/qwen3-omni-30b-a3b-thinking	128000	t	2026-09-16 22:22:53.307229
novita/qwen/qwen3-omni-30b-a3b-instruct	Novita	novita/qwen/qwen3-omni-30b-a3b-instruct	128000	t	2026-09-16 22:22:53.307525
novita/qwen/qwen-mt-plus	Novita	novita/qwen/qwen-mt-plus	128000	t	2026-09-16 22:22:53.307847
novita/qwen/qwen3-8b-fp8	Novita	novita/qwen/qwen3-8b-fp8	128000	t	2026-09-16 22:22:53.308367
novita/qwen/qwen3-4b-fp8	Novita	novita/qwen/qwen3-4b-fp8	128000	t	2026-09-16 22:22:53.308704
novita/qwen/qwen2.5-7b-instruct	Novita	novita/qwen/qwen2.5-7b-instruct	128000	t	2026-09-16 22:22:53.30906
novita/qwen/qwen3-embedding-0.6b	Novita	novita/qwen/qwen3-embedding-0.6b	128000	t	2026-09-16 22:22:53.309421
novita/qwen/qwen3-embedding-8b	Novita	novita/qwen/qwen3-embedding-8b	128000	t	2026-09-16 22:22:53.309734
novita/qwen/qwen3-reranker-8b	Novita	novita/qwen/qwen3-reranker-8b	128000	t	2026-09-16 22:22:53.310077
llamagate/qwen3-8b	Llamagate	llamagate/qwen3-8b	128000	t	2026-09-16 22:22:53.310407
llamagate/deepseek-r1-8b	Llamagate	llamagate/deepseek-r1-8b	128000	t	2026-09-16 22:22:53.310752
llamagate/deepseek-r1-7b-qwen	Llamagate	llamagate/deepseek-r1-7b-qwen	128000	t	2026-09-16 22:22:53.311077
llamagate/qwen2.5-coder-7b	Llamagate	llamagate/qwen2.5-coder-7b	128000	t	2026-09-16 22:22:53.311409
llamagate/deepseek-coder-6.7b	Llamagate	llamagate/deepseek-coder-6.7b	128000	t	2026-09-16 22:22:53.311742
llamagate/qwen3-vl-8b	Llamagate	llamagate/qwen3-vl-8b	128000	t	2026-09-16 22:22:53.312075
llamagate/qwen3-embedding-8b	Llamagate	llamagate/qwen3-embedding-8b	128000	t	2026-09-16 22:22:53.312403
libertai/qwen3.6-27b	Libertai	libertai/qwen3.6-27b	128000	t	2026-09-16 22:22:53.312737
libertai/qwen3.6-27b-thinking	Libertai	libertai/qwen3.6-27b-thinking	128000	t	2026-09-16 22:22:53.31307
libertai/qwen3.6-35b-a3b	Libertai	libertai/qwen3.6-35b-a3b	128000	t	2026-09-16 22:22:53.3136
libertai/qwen3.6-35b-a3b-thinking	Libertai	libertai/qwen3.6-35b-a3b-thinking	128000	t	2026-09-16 22:22:53.313931
libertai/qwen3.5-122b-a10b	Libertai	libertai/qwen3.5-122b-a10b	128000	t	2026-09-16 22:22:53.314284
libertai/qwen3.5-122b-a10b-thinking	Libertai	libertai/qwen3.5-122b-a10b-thinking	128000	t	2026-09-16 22:22:53.314622
libertai/deepseek-v4-flash	Libertai	libertai/deepseek-v4-flash	128000	t	2026-09-16 22:22:53.31497
libertai/deepseek-v4-flash-thinking	Libertai	libertai/deepseek-v4-flash-thinking	128000	t	2026-09-16 22:22:53.315312
bedrock/us-east-1/zai.glm-5	Bedrock	bedrock/us-east-1/zai.glm-5	128000	t	2026-09-16 22:22:53.315712
bedrock/us-west-2/zai.glm-5	Bedrock	bedrock/us-west-2/zai.glm-5	128000	t	2026-09-16 22:22:53.316077
tensormesh/Qwen/Qwen3.5-397B-A17B-FP8	Tensormesh	tensormesh/Qwen/Qwen3.5-397B-A17B-FP8	128000	t	2026-09-16 22:22:53.316436
tensormesh/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	Tensormesh	tensormesh/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	128000	t	2026-09-16 22:22:53.316768
tensormesh/Qwen/Qwen3.6-27B-FP8	Tensormesh	tensormesh/Qwen/Qwen3.6-27B-FP8	128000	t	2026-09-16 22:22:53.317277
tensormesh/lukealonso/GLM-5.1-NVFP4-MTP	Tensormesh	tensormesh/lukealonso/GLM-5.1-NVFP4-MTP	128000	t	2026-09-16 22:22:53.317611
tensormesh/deepseek-ai/DeepSeek-V4-Flash	Tensormesh	tensormesh/deepseek-ai/DeepSeek-V4-Flash	128000	t	2026-09-16 22:22:53.317934
tensormesh/moonshotai/Kimi-K2.6	Tensormesh	tensormesh/moonshotai/Kimi-K2.6	128000	t	2026-09-16 22:22:53.318303
tensormesh/MiniMaxAI/MiniMax-M2.5	Tensormesh	tensormesh/MiniMaxAI/MiniMax-M2.5	128000	t	2026-09-16 22:22:53.318659
deepseek-flash	Chinese AI	deepseek-flash	128000	t	2026-09-16 22:22:53.319008
deepseek-v4-flash	Chinese AI	deepseek-v4-flash	128000	t	2026-09-16 22:22:53.319361
deepseek-v4-flash-vision-exp	Chinese AI	deepseek-v4-flash-vision-exp	128000	t	2026-09-16 22:22:53.31969
deepseek-v4-pro	Chinese AI	deepseek-v4-pro	128000	t	2026-09-16 22:22:53.320013
deepseek/deepseek-flash	Deepseek	deepseek/deepseek-flash	128000	t	2026-09-16 22:22:53.320311
deepseek/deepseek-v4-flash	Deepseek	deepseek/deepseek-v4-flash	128000	t	2026-09-16 22:22:53.32062
deepseek/deepseek-v4-flash-vision-exp	Deepseek	deepseek/deepseek-v4-flash-vision-exp	128000	t	2026-09-16 22:22:53.320934
deepseek/deepseek-v4-pro	Deepseek	deepseek/deepseek-v4-pro	128000	t	2026-09-16 22:22:53.321242
tencent/deepseek-v4-pro	Tencent	tencent/deepseek-v4-pro	128000	t	2026-09-16 22:22:53.321533
tencent/deepseek-v4-flash	Tencent	tencent/deepseek-v4-flash	128000	t	2026-09-16 22:22:53.321833
tencent/minimax-m3	Tencent	tencent/minimax-m3	128000	t	2026-09-16 22:22:53.322166
pinstripes/ps/glm-4.5-air	Pinstripes	pinstripes/ps/glm-4.5-air	128000	t	2026-09-16 22:22:53.322469
pinstripes/ps/qwen3.6-35b-a3b	Pinstripes	pinstripes/ps/qwen3.6-35b-a3b	128000	t	2026-09-16 22:22:53.322761
pinstripes/ps/qwen3-30b-a3b	Pinstripes	pinstripes/ps/qwen3-30b-a3b	128000	t	2026-09-16 22:22:53.323217
pinstripes/ps/qwen3-coder-30b-a3b	Pinstripes	pinstripes/ps/qwen3-coder-30b-a3b	128000	t	2026-09-16 22:22:53.323517
pinstripes/ps/deepseek-v4-flash	Pinstripes	pinstripes/ps/deepseek-v4-flash	128000	t	2026-09-16 22:22:53.323819
pinstripes/ps/minimax-m2.7	Pinstripes	pinstripes/ps/minimax-m2.7	128000	t	2026-09-16 22:22:53.324133
fireworks_ai/accounts/fireworks/models/deepseek-v4-flash-0731	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v4-flash-0731	128000	t	2026-09-16 22:22:53.324499
fireworks_ai/accounts/fireworks/models/deepseek-v4p1-flash	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v4p1-flash	128000	t	2026-09-16 22:22:53.324883
fireworks_ai/accounts/fireworks/models/deepseek-v4-flash-vision-exp	Fireworks_ai	fireworks_ai/accounts/fireworks/models/deepseek-v4-flash-vision-exp	128000	t	2026-09-16 22:22:53.325263
fireworks_ai/accounts/fireworks/models/kimi-k3	Fireworks_ai	fireworks_ai/accounts/fireworks/models/kimi-k3	128000	t	2026-09-16 22:22:53.32563
fireworks_ai/deepseek-v4-flash-0731	Fireworks_ai	fireworks_ai/deepseek-v4-flash-0731	128000	t	2026-09-16 22:22:53.326003
fireworks_ai/deepseek-v4p1-flash	Fireworks_ai	fireworks_ai/deepseek-v4p1-flash	128000	t	2026-09-16 22:22:53.326404
fireworks_ai/deepseek-v4-flash-vision-exp	Fireworks_ai	fireworks_ai/deepseek-v4-flash-vision-exp	128000	t	2026-09-16 22:22:53.326771
fireworks_ai/glm-5p2-fast	Fireworks_ai	fireworks_ai/glm-5p2-fast	128000	t	2026-09-16 22:22:53.327152
fireworks_ai/glm-5p2-fast-us	Fireworks_ai	fireworks_ai/glm-5p2-fast-us	128000	t	2026-09-16 22:22:53.327497
fireworks_ai/kimi-k3	Fireworks_ai	fireworks_ai/kimi-k3	128000	t	2026-09-16 22:22:53.327848
fireworks_ai/kimi-k3-fast	Fireworks_ai	fireworks_ai/kimi-k3-fast	128000	t	2026-09-16 22:22:53.328191
fireworks_ai/kimi-k3-us	Fireworks_ai	fireworks_ai/kimi-k3-us	128000	t	2026-09-16 22:22:53.328532
fireworks_ai/qwen3p8-max	Fireworks_ai	fireworks_ai/qwen3p8-max	128000	t	2026-09-16 22:22:53.328863
fireworks_ai/accounts/fireworks/models/qwen3p8-max	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3p8-max	128000	t	2026-09-16 22:22:53.329217
fireworks_ai/accounts/fireworks/routers/glm-5p2-fast	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast	128000	t	2026-09-16 22:22:53.329573
fireworks_ai/accounts/fireworks/routers/glm-5p2-fast-us	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast-us	128000	t	2026-09-16 22:22:53.329952
fireworks_ai/accounts/fireworks/routers/kimi-k3-fast	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/kimi-k3-fast	128000	t	2026-09-16 22:22:53.330347
fireworks_ai/accounts/fireworks/routers/kimi-k3-us	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/kimi-k3-us	128000	t	2026-09-16 22:22:53.330711
novita/zai-org/glm-5.3	Novita	novita/zai-org/glm-5.3	128000	t	2026-09-16 22:22:53.331422
novita/deepseek/deepseek-v4-pro-0813	Novita	novita/deepseek/deepseek-v4-pro-0813	128000	t	2026-09-16 22:22:53.331786
novita/moonshotai/kimi-k3	Novita	novita/moonshotai/kimi-k3	128000	t	2026-09-16 22:22:53.332157
novita/zai-org/glm-5.2	Novita	novita/zai-org/glm-5.2	128000	t	2026-09-16 22:22:53.332472
novita/moonshotai/kimi-k2.7-code	Novita	novita/moonshotai/kimi-k2.7-code	128000	t	2026-09-16 22:22:53.332791
novita/deepseek/deepseek-v4-flash-vision-exp	Novita	novita/deepseek/deepseek-v4-flash-vision-exp	128000	t	2026-09-16 22:22:53.333128
novita/deepseek/deepseek-v4-flash-0731	Novita	novita/deepseek/deepseek-v4-flash-0731	128000	t	2026-09-16 22:22:53.333492
novita/minimax/minimax-m3	Novita	novita/minimax/minimax-m3	128000	t	2026-09-16 22:22:53.333854
novita/deepseek/deepseek-v4-flash	Novita	novita/deepseek/deepseek-v4-flash	128000	t	2026-09-16 22:22:53.334201
novita/deepseek/deepseek-v4-pro	Novita	novita/deepseek/deepseek-v4-pro	128000	t	2026-09-16 22:22:53.334541
novita/qwen/qwen3.8-max	Novita	novita/qwen/qwen3.8-max	128000	t	2026-09-16 22:22:53.334883
novita/qwen/qwen3.7-max	Novita	novita/qwen/qwen3.7-max	128000	t	2026-09-16 22:22:53.335248
novita/qwen/qwen3.6-27b	Novita	novita/qwen/qwen3.6-27b	128000	t	2026-09-16 22:22:53.335593
novita/moonshotai/kimi-k2.6	Novita	novita/moonshotai/kimi-k2.6	128000	t	2026-09-16 22:22:53.335938
novita/zai-org/glm-5.1	Novita	novita/zai-org/glm-5.1	128000	t	2026-09-16 22:22:53.336252
novita/minimax/minimax-m2.7-highspeed	Novita	novita/minimax/minimax-m2.7-highspeed	128000	t	2026-09-16 22:22:53.336551
novita/zai-org/glm-5v-turbo	Novita	novita/zai-org/glm-5v-turbo	128000	t	2026-09-16 22:22:53.336859
novita/zai-org/glm-5-turbo	Novita	novita/zai-org/glm-5-turbo	128000	t	2026-09-16 22:22:53.33736
novita/minimax/minimax-m2.7	Novita	novita/minimax/minimax-m2.7	128000	t	2026-09-16 22:22:53.337668
novita/minimax/minimax-m2.5-highspeed	Novita	novita/minimax/minimax-m2.5-highspeed	128000	t	2026-09-16 22:22:53.33797
novita/qwen/qwen3.5-27b	Novita	novita/qwen/qwen3.5-27b	128000	t	2026-09-16 22:22:53.338273
novita/qwen/qwen3.5-122b-a10b	Novita	novita/qwen/qwen3.5-122b-a10b	128000	t	2026-09-16 22:22:53.338576
novita/qwen/qwen3.5-35b-a3b	Novita	novita/qwen/qwen3.5-35b-a3b	128000	t	2026-09-16 22:22:53.33888
novita/qwen/qwen3.5-397b-a17b	Novita	novita/qwen/qwen3.5-397b-a17b	128000	t	2026-09-16 22:22:53.339183
novita/minimax/minimax-m2.5	Novita	novita/minimax/minimax-m2.5	128000	t	2026-09-16 22:22:53.33948
novita/zai-org/glm-5	Novita	novita/zai-org/glm-5	128000	t	2026-09-16 22:22:53.339777
novita/qwen/qwen3-coder-next	Novita	novita/qwen/qwen3-coder-next	128000	t	2026-09-16 22:22:53.340099
novita/deepseek/deepseek-ocr-2	Novita	novita/deepseek/deepseek-ocr-2	128000	t	2026-09-16 22:22:53.340435
novita/moonshotai/kimi-k2.5	Novita	novita/moonshotai/kimi-k2.5	128000	t	2026-09-16 22:22:53.340774
novita/zai-org/glm-4.7-h	Novita	novita/zai-org/glm-4.7-h	128000	t	2026-09-16 22:22:53.341128
novita/zai-org/glm-4.7-flash	Novita	novita/zai-org/glm-4.7-flash	128000	t	2026-09-16 22:22:53.341483
novita/qwen/qwen3.6-35b-a3b	Novita	novita/qwen/qwen3.6-35b-a3b	128000	t	2026-09-16 22:22:53.341837
novita/deepseek/deepseek_v3	Novita	novita/deepseek/deepseek_v3	128000	t	2026-09-16 22:22:53.34219
novita/deepseek/deepseek-r1	Novita	novita/deepseek/deepseek-r1	128000	t	2026-09-16 22:22:53.342544
novita/deepseek/deepseek-v3/community	Novita	novita/deepseek/deepseek-v3/community	128000	t	2026-09-16 22:22:53.342896
novita/deepseek/deepseek-r1/community	Novita	novita/deepseek/deepseek-r1/community	128000	t	2026-09-16 22:22:53.343256
novita/thudm/glm-4-32b-0414	Novita	novita/thudm/glm-4-32b-0414	128000	t	2026-09-16 22:22:53.343639
wandb/deepseek-ai/DeepSeek-V4-Flash	Wandb	wandb/deepseek-ai/DeepSeek-V4-Flash	128000	t	2026-09-16 22:22:53.343999
wandb/deepseek-ai/DeepSeek-V4-Flash-0731	Wandb	wandb/deepseek-ai/DeepSeek-V4-Flash-0731	128000	t	2026-09-16 22:22:53.344333
wandb/deepseek-ai/DeepSeek-V4-Pro	Wandb	wandb/deepseek-ai/DeepSeek-V4-Pro	128000	t	2026-09-16 22:22:53.344684
wandb/MiniMaxAI/MiniMax-M3	Wandb	wandb/MiniMaxAI/MiniMax-M3	128000	t	2026-09-16 22:22:53.3452
wandb/moonshotai/Kimi-K2.7-Code	Wandb	wandb/moonshotai/Kimi-K2.7-Code	128000	t	2026-09-16 22:22:53.345544
wandb/moonshotai/Kimi-K2.6	Wandb	wandb/moonshotai/Kimi-K2.6	128000	t	2026-09-16 22:22:53.345898
wandb/OpenPipe/Qwen3-14B-Instruct	Wandb	wandb/OpenPipe/Qwen3-14B-Instruct	128000	t	2026-09-16 22:22:53.346232
wandb/Qwen/Qwen3.8-27B	Wandb	wandb/Qwen/Qwen3.8-27B	128000	t	2026-09-16 22:22:53.346564
wandb/Qwen/Qwen3.6-35B-A3B	Wandb	wandb/Qwen/Qwen3.6-35B-A3B	128000	t	2026-09-16 22:22:53.346906
wandb/Qwen/Qwen3.6-27B	Wandb	wandb/Qwen/Qwen3.6-27B	128000	t	2026-09-16 22:22:53.347289
wandb/Qwen/Qwen3.5-35B-A3B	Wandb	wandb/Qwen/Qwen3.5-35B-A3B	128000	t	2026-09-16 22:22:53.347648
wandb/Qwen/Qwen3-30B-A3B-Instruct-2507	Wandb	wandb/Qwen/Qwen3-30B-A3B-Instruct-2507	128000	t	2026-09-16 22:22:53.347975
wandb/deepseek-ai/DeepSeek-V4-Pro-0813	Wandb	wandb/deepseek-ai/DeepSeek-V4-Pro-0813	128000	t	2026-09-16 22:22:53.348326
wandb/zai-org/GLM-5.2	Wandb	wandb/zai-org/GLM-5.2	128000	t	2026-09-16 22:22:53.34868
deepinfra/MiniMaxAI/MiniMax-M2.7	Deepinfra	deepinfra/MiniMaxAI/MiniMax-M2.7	128000	t	2026-09-16 22:22:53.349034
deepinfra/Qwen/Qwen3.8-27B	Deepinfra	deepinfra/Qwen/Qwen3.8-27B	128000	t	2026-09-16 22:22:53.349393
deepinfra/moonshotai/Kimi-K2.5	Deepinfra	deepinfra/moonshotai/Kimi-K2.5	128000	t	2026-09-16 22:22:53.349775
xiaomi/mimo-v2.6-flash	Xiaomi	xiaomi/mimo-v2.6-flash	128000	t	2026-09-30 17:12:45.375589
deepinfra/zai-org/GLM-4.7-Flash	Deepinfra	deepinfra/zai-org/GLM-4.7-Flash	128000	t	2026-09-16 22:22:53.350134
deepinfra/zai-org/GLM-4.6	Deepinfra	deepinfra/zai-org/GLM-4.6	128000	t	2026-09-16 22:22:53.350496
deepinfra/Qwen/Qwen3-Max	Deepinfra	deepinfra/Qwen/Qwen3-Max	128000	t	2026-09-16 22:22:53.35084
deepinfra/Qwen/Qwen3-Max-Thinking	Deepinfra	deepinfra/Qwen/Qwen3-Max-Thinking	128000	t	2026-09-16 22:22:53.351171
deepinfra/Qwen/Qwen3-VL-235B-A22B-Instruct	Deepinfra	deepinfra/Qwen/Qwen3-VL-235B-A22B-Instruct	128000	t	2026-09-16 22:22:53.351711
deepinfra/Qwen/Qwen3-VL-30B-A3B-Instruct	Deepinfra	deepinfra/Qwen/Qwen3-VL-30B-A3B-Instruct	128000	t	2026-09-16 22:22:53.352057
deepinfra/Qwen/Qwen3.5-27B	Deepinfra	deepinfra/Qwen/Qwen3.5-27B	128000	t	2026-09-16 22:22:53.352401
deepinfra/Qwen/Qwen3.6-35B-A3B	Deepinfra	deepinfra/Qwen/Qwen3.6-35B-A3B	128000	t	2026-09-16 22:22:53.352737
deepinfra/moonshotai/Kimi-K2.6	Deepinfra	deepinfra/moonshotai/Kimi-K2.6	128000	t	2026-09-16 22:22:53.353046
deepinfra/deepseek-ai/DeepSeek-V4-Pro-0813	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V4-Pro-0813	128000	t	2026-09-16 22:22:53.35335
deepinfra/Qwen/Qwen3.7-Max	Deepinfra	deepinfra/Qwen/Qwen3.7-Max	128000	t	2026-09-16 22:22:53.353647
deepinfra/Qwen/Qwen3.8-2.4T-A95B	Deepinfra	deepinfra/Qwen/Qwen3.8-2.4T-A95B	128000	t	2026-09-16 22:22:53.353978
deepinfra/MiniMaxAI/MiniMax-M3	Deepinfra	deepinfra/MiniMaxAI/MiniMax-M3	128000	t	2026-09-16 22:22:53.354287
deepinfra/Qwen/Qwen3.5-35B-A3B	Deepinfra	deepinfra/Qwen/Qwen3.5-35B-A3B	128000	t	2026-09-16 22:22:53.354587
deepinfra/zai-org/GLM-5	Deepinfra	deepinfra/zai-org/GLM-5	128000	t	2026-09-16 22:22:53.354892
deepinfra/moonshotai/Kimi-K2.7-Code	Deepinfra	deepinfra/moonshotai/Kimi-K2.7-Code	128000	t	2026-09-16 22:22:53.355186
deepinfra/Qwen/Qwen3.5-397B-A17B	Deepinfra	deepinfra/Qwen/Qwen3.5-397B-A17B	128000	t	2026-09-16 22:22:53.355498
deepinfra/deepseek-ai/DeepSeek-V4-Flash-0731	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V4-Flash-0731	128000	t	2026-09-16 22:22:53.355803
deepinfra/deepseek-ai/DeepSeek-V3.2	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V3.2	128000	t	2026-09-16 22:22:53.356126
deepinfra/Qwen/Qwen3.8-Max	Deepinfra	deepinfra/Qwen/Qwen3.8-Max	128000	t	2026-09-16 22:22:53.356417
deepinfra/Qwen/Qwen3.5-122B-A10B	Deepinfra	deepinfra/Qwen/Qwen3.5-122B-A10B	128000	t	2026-09-16 22:22:53.356723
deepinfra/zai-org/GLM-5.1	Deepinfra	deepinfra/zai-org/GLM-5.1	128000	t	2026-09-16 22:22:53.357017
deepinfra/deepseek-ai/DeepSeek-V4-Pro	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V4-Pro	128000	t	2026-09-16 22:22:53.357314
deepinfra/zai-org/GLM-5.2	Deepinfra	deepinfra/zai-org/GLM-5.2	128000	t	2026-09-16 22:22:53.357641
deepinfra/moonshotai/Kimi-K3	Deepinfra	deepinfra/moonshotai/Kimi-K3	128000	t	2026-09-16 22:22:53.357976
deepinfra/Qwen/Qwen3.6-27B	Deepinfra	deepinfra/Qwen/Qwen3.6-27B	128000	t	2026-09-16 22:22:53.358305
deepinfra/deepseek-ai/DeepSeek-V4-Flash	Deepinfra	deepinfra/deepseek-ai/DeepSeek-V4-Flash	128000	t	2026-09-16 22:22:53.358655
deepinfra/Qwen/Qwen3.5-9B	Deepinfra	deepinfra/Qwen/Qwen3.5-9B	128000	t	2026-09-16 22:22:53.35923
deepinfra/MiniMaxAI/MiniMax-M2.7-Turbo	Deepinfra	deepinfra/MiniMaxAI/MiniMax-M2.7-Turbo	128000	t	2026-09-16 22:22:53.359597
deepinfra/zai-org/GLM-4.7	Deepinfra	deepinfra/zai-org/GLM-4.7	128000	t	2026-09-16 22:22:53.359965
groq/qwen/qwen3.8-27b	Groq	groq/qwen/qwen3.8-27b	128000	t	2026-09-16 22:22:53.360357
fireworks_ai/accounts/fireworks/models/glm-5p3	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-5p3	128000	t	2026-09-16 22:22:53.360724
fireworks_ai/accounts/fireworks/models/glm-5p3-flash	Fireworks_ai	fireworks_ai/accounts/fireworks/models/glm-5p3-flash	128000	t	2026-09-16 22:22:53.361106
fireworks_ai/accounts/fireworks/models/qwen3-embedding-8b	Fireworks_ai	fireworks_ai/accounts/fireworks/models/qwen3-embedding-8b	128000	t	2026-09-16 22:22:53.361474
zai/glm-5.2	Zai	zai/glm-5.2	128000	t	2026-09-16 22:22:53.361826
together_ai/Qwen/Qwen3.8-Flash	Together_ai	together_ai/Qwen/Qwen3.8-Flash	128000	t	2026-09-16 22:22:53.362155
together_ai/moonshotai/Kimi-K2.6	Together_ai	together_ai/moonshotai/Kimi-K2.6	128000	t	2026-09-16 22:22:53.362494
together_ai/moonshotai/Kimi-K2.5-fp4	Together_ai	together_ai/moonshotai/Kimi-K2.5-fp4	128000	t	2026-09-16 22:22:53.362835
together_ai/MiniMaxAI/MiniMax-M2.7	Together_ai	together_ai/MiniMaxAI/MiniMax-M2.7	128000	t	2026-09-16 22:22:53.363183
together_ai/zai-org/GLM-5	Together_ai	together_ai/zai-org/GLM-5	128000	t	2026-09-16 22:22:53.363535
together_ai/zai-org/GLM-5.1	Together_ai	together_ai/zai-org/GLM-5.1	128000	t	2026-09-16 22:22:53.363897
together_ai/deepseek-ai/DeepSeek-R1-0528	Together_ai	together_ai/deepseek-ai/DeepSeek-R1-0528	128000	t	2026-09-16 22:22:53.364248
together_ai/Qwen/Qwen3-Coder-Next-FP8	Together_ai	together_ai/Qwen/Qwen3-Coder-Next-FP8	128000	t	2026-09-16 22:22:53.364577
together_ai/Qwen/Qwen3-VL-32B-Instruct	Together_ai	together_ai/Qwen/Qwen3-VL-32B-Instruct	128000	t	2026-09-16 22:22:53.364933
together_ai/Qwen/Qwen3-VL-8B-Instruct	Together_ai	together_ai/Qwen/Qwen3-VL-8B-Instruct	128000	t	2026-09-16 22:22:53.365265
together_ai/Qwen/QwQ-32B	Together_ai	together_ai/Qwen/QwQ-32B	128000	t	2026-09-16 22:22:53.365632
scaleway/glm-5.2	Scaleway	scaleway/glm-5.2	128000	t	2026-09-16 22:22:53.365983
scaleway/deepseek-v4-flash-0731	Scaleway	scaleway/deepseek-v4-flash-0731	128000	t	2026-09-16 22:22:53.366329
azure_ai/kimi-k2.7-code	Azure_ai	azure_ai/kimi-k2.7-code	128000	t	2026-09-16 22:22:53.366674
perplexity/perplexity/glm-5.3	Perplexity	perplexity/perplexity/glm-5.3	128000	t	2026-09-16 22:22:53.367253
perplexity/perplexity/glm-5.3-flash	Perplexity	perplexity/perplexity/glm-5.3-flash	128000	t	2026-09-16 22:22:53.367599
baseten/zai-org/GLM-5.3	Baseten	baseten/zai-org/GLM-5.3	128000	t	2026-09-16 22:22:53.367963
openrouter/minimax/minimax-m3	Openrouter	openrouter/minimax/minimax-m3	128000	t	2026-09-16 22:22:53.368299
openrouter/qwen/qwen3.7-plus	Openrouter	openrouter/qwen/qwen3.7-plus	128000	t	2026-09-16 22:22:53.368635
openrouter/qwen/qwen3.8-flash	Openrouter	openrouter/qwen/qwen3.8-flash	128000	t	2026-09-16 22:22:53.368979
openrouter/z-ai/glm-5.3-flash	Openrouter	openrouter/z-ai/glm-5.3-flash	128000	t	2026-09-16 22:22:53.369337
openrouter/deepseek/deepseek-v4-flash-vision-exp	Openrouter	openrouter/deepseek/deepseek-v4-flash-vision-exp	128000	t	2026-09-16 22:22:53.369687
openrouter/z-ai/glm-5.3	Openrouter	openrouter/z-ai/glm-5.3	128000	t	2026-09-16 22:22:53.370006
openrouter/qwen/qwen3.8-27b	Openrouter	openrouter/qwen/qwen3.8-27b	128000	t	2026-09-16 22:22:53.370321
openrouter/qwen/qwen3.8-2.4t-a95b	Openrouter	openrouter/qwen/qwen3.8-2.4t-a95b	128000	t	2026-09-16 22:22:53.370638
openrouter/qwen/qwen3.8-max	Openrouter	openrouter/qwen/qwen3.8-max	128000	t	2026-09-16 22:22:53.370957
openrouter/qwen/qwen3.8-max-0902	Openrouter	openrouter/qwen/qwen3.8-max-0902	128000	t	2026-09-16 22:22:53.371253
openrouter/deepseek/deepseek-v4-flash-0731	Openrouter	openrouter/deepseek/deepseek-v4-flash-0731	128000	t	2026-09-16 22:22:53.371554
openrouter/qwen/qwen3.7-flash	Openrouter	openrouter/qwen/qwen3.7-flash	128000	t	2026-09-16 22:22:53.37187
openrouter/moonshotai/kimi-k3	Openrouter	openrouter/moonshotai/kimi-k3	128000	t	2026-09-16 22:22:53.37218
openrouter/z-ai/glm-5.2	Openrouter	openrouter/z-ai/glm-5.2	128000	t	2026-09-16 22:22:53.372481
openrouter/z-ai/glm-5.2:free	Openrouter	openrouter/z-ai/glm-5.2:free	128000	t	2026-09-16 22:22:53.372778
openrouter/moonshotai/kimi-k2.7-code	Openrouter	openrouter/moonshotai/kimi-k2.7-code	128000	t	2026-09-16 22:22:53.373083
openrouter/minimax/minimax-m3:free	Openrouter	openrouter/minimax/minimax-m3:free	128000	t	2026-09-16 22:22:53.373385
openrouter/qwen/qwen3.7-max	Openrouter	openrouter/qwen/qwen3.7-max	128000	t	2026-09-16 22:22:53.373718
openrouter/qwen/qwen3.5-plus-20260420	Openrouter	openrouter/qwen/qwen3.5-plus-20260420	128000	t	2026-09-16 22:22:53.374065
openrouter/qwen/qwen3.6-flash	Openrouter	openrouter/qwen/qwen3.6-flash	128000	t	2026-09-16 22:22:53.374422
openrouter/qwen/qwen3.6-35b-a3b	Openrouter	openrouter/qwen/qwen3.6-35b-a3b	128000	t	2026-09-16 22:22:53.374981
openrouter/qwen/qwen3.6-max-preview	Openrouter	openrouter/qwen/qwen3.6-max-preview	128000	t	2026-09-16 22:22:53.375354
openrouter/qwen/qwen3.6-27b	Openrouter	openrouter/qwen/qwen3.6-27b	128000	t	2026-09-16 22:22:53.375716
openrouter/deepseek/deepseek-v4-flash	Openrouter	openrouter/deepseek/deepseek-v4-flash	128000	t	2026-09-16 22:22:53.376069
openrouter/moonshotai/kimi-k2.6	Openrouter	openrouter/moonshotai/kimi-k2.6	128000	t	2026-09-16 22:22:53.376419
openrouter/z-ai/glm-5v-turbo	Openrouter	openrouter/z-ai/glm-5v-turbo	128000	t	2026-09-16 22:22:53.376776
openrouter/minimax/minimax-m2.7	Openrouter	openrouter/minimax/minimax-m2.7	128000	t	2026-09-16 22:22:53.377133
openrouter/minimax/minimax-m2.7:free	Openrouter	openrouter/minimax/minimax-m2.7:free	128000	t	2026-09-16 22:22:53.377499
openrouter/z-ai/glm-5-turbo	Openrouter	openrouter/z-ai/glm-5-turbo	128000	t	2026-09-16 22:22:53.377839
openrouter/qwen/qwen3.5-9b	Openrouter	openrouter/qwen/qwen3.5-9b	128000	t	2026-09-16 22:22:53.378182
openrouter/qwen/qwen3-max-thinking	Openrouter	openrouter/qwen/qwen3-max-thinking	128000	t	2026-09-16 22:22:53.378527
openrouter/qwen/qwen3-coder-next	Openrouter	openrouter/qwen/qwen3-coder-next	128000	t	2026-09-16 22:22:53.378879
openrouter/minimax/minimax-m2-her	Openrouter	openrouter/minimax/minimax-m2-her	128000	t	2026-09-16 22:22:53.379237
openrouter/z-ai/glm-4.6v	Openrouter	openrouter/z-ai/glm-4.6v	128000	t	2026-09-16 22:22:53.379602
openrouter/moonshotai/kimi-k2-thinking	Openrouter	openrouter/moonshotai/kimi-k2-thinking	128000	t	2026-09-16 22:22:53.379956
openrouter/qwen/qwen3-vl-32b-instruct	Openrouter	openrouter/qwen/qwen3-vl-32b-instruct	128000	t	2026-09-16 22:22:53.38032
openrouter/qwen/qwen3-vl-8b-thinking	Openrouter	openrouter/qwen/qwen3-vl-8b-thinking	128000	t	2026-09-16 22:22:53.380701
openrouter/qwen/qwen3-vl-8b-instruct	Openrouter	openrouter/qwen/qwen3-vl-8b-instruct	128000	t	2026-09-16 22:22:53.381069
openrouter/qwen/qwen3-vl-30b-a3b-thinking	Openrouter	openrouter/qwen/qwen3-vl-30b-a3b-thinking	128000	t	2026-09-16 22:22:53.381418
openrouter/qwen/qwen3-vl-30b-a3b-instruct	Openrouter	openrouter/qwen/qwen3-vl-30b-a3b-instruct	128000	t	2026-09-16 22:22:53.381774
openrouter/qwen/qwen3-vl-235b-a22b-thinking	Openrouter	openrouter/qwen/qwen3-vl-235b-a22b-thinking	128000	t	2026-09-16 22:22:53.38211
openrouter/qwen/qwen3-vl-235b-a22b-instruct	Openrouter	openrouter/qwen/qwen3-vl-235b-a22b-instruct	128000	t	2026-09-16 22:22:53.382449
openrouter/qwen/qwen3-max	Openrouter	openrouter/qwen/qwen3-max	128000	t	2026-09-16 22:22:53.38299
openrouter/deepseek/deepseek-v3.1-terminus	Openrouter	openrouter/deepseek/deepseek-v3.1-terminus	128000	t	2026-09-16 22:22:53.383346
openrouter/qwen/qwen3-coder-flash	Openrouter	openrouter/qwen/qwen3-coder-flash	128000	t	2026-09-16 22:22:53.383701
openrouter/qwen/qwen3-next-80b-a3b-thinking	Openrouter	openrouter/qwen/qwen3-next-80b-a3b-thinking	128000	t	2026-09-16 22:22:53.384058
openrouter/qwen/qwen3-next-80b-a3b-instruct	Openrouter	openrouter/qwen/qwen3-next-80b-a3b-instruct	128000	t	2026-09-16 22:22:53.384415
openrouter/qwen/qwen-plus-2025-07-28	Openrouter	openrouter/qwen/qwen-plus-2025-07-28	128000	t	2026-09-16 22:22:53.38477
openrouter/moonshotai/kimi-k2-0905	Openrouter	openrouter/moonshotai/kimi-k2-0905	128000	t	2026-09-16 22:22:53.385099
openrouter/qwen/qwen3-30b-a3b-thinking-2507	Openrouter	openrouter/qwen/qwen3-30b-a3b-thinking-2507	128000	t	2026-09-16 22:22:53.385427
openrouter/z-ai/glm-4.5v	Openrouter	openrouter/z-ai/glm-4.5v	128000	t	2026-09-16 22:22:53.385779
openrouter/qwen/qwen3-coder-30b-a3b-instruct	Openrouter	openrouter/qwen/qwen3-coder-30b-a3b-instruct	128000	t	2026-09-16 22:22:53.386115
openrouter/qwen/qwen3-30b-a3b-instruct-2507	Openrouter	openrouter/qwen/qwen3-30b-a3b-instruct-2507	128000	t	2026-09-16 22:22:53.386439
openrouter/z-ai/glm-4.5	Openrouter	openrouter/z-ai/glm-4.5	128000	t	2026-09-16 22:22:53.386935
openrouter/z-ai/glm-4.5-air	Openrouter	openrouter/z-ai/glm-4.5-air	128000	t	2026-09-16 22:22:53.387256
openrouter/moonshotai/kimi-k2	Openrouter	openrouter/moonshotai/kimi-k2	128000	t	2026-09-16 22:22:53.38757
openrouter/minimax/minimax-m1	Openrouter	openrouter/minimax/minimax-m1	128000	t	2026-09-16 22:22:53.387894
openrouter/qwen/qwen3-30b-a3b	Openrouter	openrouter/qwen/qwen3-30b-a3b	128000	t	2026-09-16 22:22:53.388226
openrouter/qwen/qwen3-8b	Openrouter	openrouter/qwen/qwen3-8b	128000	t	2026-09-16 22:22:53.388569
openrouter/qwen/qwen3-14b	Openrouter	openrouter/qwen/qwen3-14b	128000	t	2026-09-16 22:22:53.388933
openrouter/qwen/qwen3-32b	Openrouter	openrouter/qwen/qwen3-32b	128000	t	2026-09-16 22:22:53.389296
openrouter/qwen/qwen3-235b-a22b	Openrouter	openrouter/qwen/qwen3-235b-a22b	128000	t	2026-09-16 22:22:53.389653
openrouter/qwen/qwen2.5-vl-72b-instruct	Openrouter	openrouter/qwen/qwen2.5-vl-72b-instruct	128000	t	2026-09-16 22:22:53.390027
openrouter/qwen/qwen-plus	Openrouter	openrouter/qwen/qwen-plus	128000	t	2026-09-16 22:22:53.390392
openrouter/deepseek/deepseek-r1-distill-llama-70b	Openrouter	openrouter/deepseek/deepseek-r1-distill-llama-70b	128000	t	2026-09-16 22:22:53.390739
openrouter/minimax/minimax-01	Openrouter	openrouter/minimax/minimax-01	128000	t	2026-09-16 22:22:53.391115
openrouter/qwen/qwen-2.5-7b-instruct	Openrouter	openrouter/qwen/qwen-2.5-7b-instruct	128000	t	2026-09-16 22:22:53.391482
openrouter/qwen/qwen-2.5-72b-instruct	Openrouter	openrouter/qwen/qwen-2.5-72b-instruct	128000	t	2026-09-16 22:22:53.39184
fireworks_ai/accounts/fireworks/routers/glm-5p3-fast	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/glm-5p3-fast	128000	t	2026-09-16 22:22:53.392215
together_ai/deepseek-ai/deepseek-coder-33b-instruct	Together_ai	together_ai/deepseek-ai/deepseek-coder-33b-instruct	128000	t	2026-09-16 22:22:53.392578
together_ai/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	Together_ai	together_ai/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	128000	t	2026-09-16 22:22:53.392957
together_ai/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B	Together_ai	together_ai/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B	128000	t	2026-09-16 22:22:53.393334
together_ai/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B	Together_ai	together_ai/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B	128000	t	2026-09-16 22:22:53.393726
together_ai/deepseek-ai/DeepSeek-V4.1-Flash	Together_ai	together_ai/deepseek-ai/DeepSeek-V4.1-Flash	128000	t	2026-09-16 22:22:53.394092
together_ai/Qwen/Qwen2-1.5B-Instruct	Together_ai	together_ai/Qwen/Qwen2-1.5B-Instruct	128000	t	2026-09-16 22:22:53.394682
together_ai/Qwen/Qwen2-72B-Instruct	Together_ai	together_ai/Qwen/Qwen2-72B-Instruct	128000	t	2026-09-16 22:22:53.395034
together_ai/Qwen/Qwen2-VL-72B-Instruct	Together_ai	together_ai/Qwen/Qwen2-VL-72B-Instruct	128000	t	2026-09-16 22:22:53.395371
together_ai/Qwen/Qwen2.5-14B-Instruct	Together_ai	together_ai/Qwen/Qwen2.5-14B-Instruct	128000	t	2026-09-16 22:22:53.395743
together_ai/Qwen/Qwen2.5-72B-Instruct	Together_ai	together_ai/Qwen/Qwen2.5-72B-Instruct	128000	t	2026-09-16 22:22:53.396086
together_ai/Qwen/Qwen2.5-Coder-32B-Instruct	Together_ai	together_ai/Qwen/Qwen2.5-Coder-32B-Instruct	128000	t	2026-09-16 22:22:53.396427
together_ai/Qwen/Qwen2.5-VL-72B-Instruct	Together_ai	together_ai/Qwen/Qwen2.5-VL-72B-Instruct	128000	t	2026-09-16 22:22:53.396815
aihubmix/cc-glm-5.1	Aihubmix	aihubmix/cc-glm-5.1	128000	t	2026-09-16 22:22:53.397216
aihubmix/coding-glm-5.3	Aihubmix	aihubmix/coding-glm-5.3	128000	t	2026-09-16 22:22:53.397576
aihubmix/coding-kimi-k3	Aihubmix	aihubmix/coding-kimi-k3	128000	t	2026-09-16 22:22:53.397908
aihubmix/deepseek-v4-flash	Aihubmix	aihubmix/deepseek-v4-flash	128000	t	2026-09-16 22:22:53.39826
aihubmix/deepseek-v4-pro	Aihubmix	aihubmix/deepseek-v4-pro	128000	t	2026-09-16 22:22:53.398623
aihubmix/glm-5.2-fast-preview	Aihubmix	aihubmix/glm-5.2-fast-preview	128000	t	2026-09-16 22:22:53.398978
aihubmix/glm-5.3	Aihubmix	aihubmix/glm-5.3	128000	t	2026-09-16 22:22:53.399326
aihubmix/glm-5.3-flash	Aihubmix	aihubmix/glm-5.3-flash	128000	t	2026-09-16 22:22:53.399673
aihubmix/glm-5v-turbo	Aihubmix	aihubmix/glm-5v-turbo	128000	t	2026-09-16 22:22:53.400025
aihubmix/kimi-k2.6	Aihubmix	aihubmix/kimi-k2.6	128000	t	2026-09-16 22:22:53.400371
aihubmix/kimi-k2.7-code-highspeed	Aihubmix	aihubmix/kimi-k2.7-code-highspeed	128000	t	2026-09-16 22:22:53.400723
aihubmix/kimi-k3	Aihubmix	aihubmix/kimi-k3	128000	t	2026-09-16 22:22:53.401082
aihubmix/minimax-m2.7	Aihubmix	aihubmix/minimax-m2.7	128000	t	2026-09-16 22:22:53.401405
aihubmix/minimax-m3	Aihubmix	aihubmix/minimax-m3	128000	t	2026-09-16 22:22:53.40175
aihubmix/qwen3-coder-next	Aihubmix	aihubmix/qwen3-coder-next	128000	t	2026-09-16 22:22:53.402092
aihubmix/qwen3.5-122b-a10b	Aihubmix	aihubmix/qwen3.5-122b-a10b	128000	t	2026-09-16 22:22:53.402448
aihubmix/qwen3.5-397b-a17b	Aihubmix	aihubmix/qwen3.5-397b-a17b	128000	t	2026-09-16 22:22:53.403379
aihubmix/qwen3.6-27b	Aihubmix	aihubmix/qwen3.6-27b	128000	t	2026-09-16 22:22:53.403694
aihubmix/qwen3.6-35b-a3b	Aihubmix	aihubmix/qwen3.6-35b-a3b	128000	t	2026-09-16 22:22:53.403999
aihubmix/qwen3.6-max-preview	Aihubmix	aihubmix/qwen3.6-max-preview	128000	t	2026-09-16 22:22:53.404306
aihubmix/qwen3.7-plus	Aihubmix	aihubmix/qwen3.7-plus	128000	t	2026-09-16 22:22:53.404615
aihubmix/qwen3.8-2.4t-a95b	Aihubmix	aihubmix/qwen3.8-2.4t-a95b	128000	t	2026-09-16 22:22:53.404938
aihubmix/qwen3.8-flash	Aihubmix	aihubmix/qwen3.8-flash	128000	t	2026-09-16 22:22:53.405226
aihubmix/qwen3.8-max	Aihubmix	aihubmix/qwen3.8-max	128000	t	2026-09-16 22:22:53.405522
qwen/qwen-max	Alibaba	qwen/qwen-max	128000	t	2026-09-22 16:20:47.218208
zhipu/glm-5.3-flash	Zhipu	zhipu/glm-5.3-flash	128000	t	2026-09-23 06:46:08.716808
xiaomi/mimo-v2.6-pro	Xiaomi	xiaomi/mimo-v2.6-pro	128000	t	2026-09-23 23:13:13.462424
dashscope/qwen3.8-flash	Dashscope	dashscope/qwen3.8-flash	128000	t	2026-09-23 23:40:11.769166
dashscope/qwen3.8-omni-flash	Dashscope	dashscope/qwen3.8-omni-flash	128000	t	2026-09-23 23:40:11.770142
qwen_ai_platform/qwen3.8-flash	Qwen_ai_platform	qwen_ai_platform/qwen3.8-flash	128000	t	2026-09-23 23:40:11.789333
qwen_ai_platform/qwen3.8-omni-flash	Qwen_ai_platform	qwen_ai_platform/qwen3.8-omni-flash	128000	t	2026-09-23 23:40:11.789644
fal_ai/minimax/h3/text-to-video	Fal_ai	fal_ai/minimax/h3/text-to-video	128000	t	2026-09-23 23:40:11.800667
fal_ai/minimax/h3/reference-to-video	Fal_ai	fal_ai/minimax/h3/reference-to-video	128000	t	2026-09-23 23:40:11.800969
fireworks_ai/deepseek-v4-pro-0813	Fireworks_ai	fireworks_ai/deepseek-v4-pro-0813	128000	t	2026-09-23 23:40:11.803697
mistral/zai-glm-5-3	Mistral	mistral/zai-glm-5-3	128000	t	2026-09-23 23:40:11.819169
mistral/zai-glm-5	Mistral	mistral/zai-glm-5	128000	t	2026-09-23 23:40:11.819522
mistral/zai-glm-latest	Mistral	mistral/zai-glm-latest	128000	t	2026-09-23 23:40:11.819888
nebius/deepseek-ai/DeepSeek-V4-Pro-0813	Nebius	nebius/deepseek-ai/DeepSeek-V4-Pro-0813	128000	t	2026-09-23 23:40:11.829487
nebius/zai-org/GLM-5.3	Nebius	nebius/zai-org/GLM-5.3	128000	t	2026-09-23 23:40:11.831769
openrouter/xiaomi/mimo-v2-flash	Openrouter	openrouter/xiaomi/mimo-v2-flash	128000	t	2026-09-23 23:40:11.839014
openrouter/xiaomi/mimo-v2.5-pro	Openrouter	openrouter/xiaomi/mimo-v2.5-pro	128000	t	2026-09-23 23:40:11.839226
openrouter/xiaomi/mimo-v2.5	Openrouter	openrouter/xiaomi/mimo-v2.5	128000	t	2026-09-23 23:40:11.839434
bedrock/ap-northeast-1/qwen.qwen3-next-80b-a3b	Bedrock	bedrock/ap-northeast-1/qwen.qwen3-next-80b-a3b	128000	t	2026-09-23 23:40:11.842346
bedrock/ap-south-1/qwen.qwen3-next-80b-a3b	Bedrock	bedrock/ap-south-1/qwen.qwen3-next-80b-a3b	128000	t	2026-09-23 23:40:11.842562
bedrock/ap-southeast-2/qwen.qwen3-next-80b-a3b	Bedrock	bedrock/ap-southeast-2/qwen.qwen3-next-80b-a3b	128000	t	2026-09-23 23:40:11.84278
bedrock/eu-west-1/qwen.qwen3-next-80b-a3b	Bedrock	bedrock/eu-west-1/qwen.qwen3-next-80b-a3b	128000	t	2026-09-23 23:40:11.843
bedrock/eu-west-2/qwen.qwen3-next-80b-a3b	Bedrock	bedrock/eu-west-2/qwen.qwen3-next-80b-a3b	128000	t	2026-09-23 23:40:11.843217
bedrock/sa-east-1/qwen.qwen3-next-80b-a3b	Bedrock	bedrock/sa-east-1/qwen.qwen3-next-80b-a3b	128000	t	2026-09-23 23:40:11.843428
novita/xiaomimimo/mimo-v2-flash	Novita	novita/xiaomimimo/mimo-v2-flash	128000	t	2026-09-23 23:40:11.899884
novita/xiaomimimo/mimo-v2.5	Novita	novita/xiaomimimo/mimo-v2.5	128000	t	2026-09-23 23:40:11.923286
novita/xiaomimimo/mimo-v2.5-pro	Novita	novita/xiaomimimo/mimo-v2.5-pro	128000	t	2026-09-23 23:40:11.925431
deepinfra/XiaomiMiMo/MiMo-V2.5	Deepinfra	deepinfra/XiaomiMiMo/MiMo-V2.5	128000	t	2026-09-23 23:40:11.933626
deepinfra/XiaomiMiMo/MiMo-V2.5-Pro	Deepinfra	deepinfra/XiaomiMiMo/MiMo-V2.5-Pro	128000	t	2026-09-23 23:40:11.938734
fireworks_ai/glm-5p3	Fireworks_ai	fireworks_ai/glm-5p3	128000	t	2026-09-23 23:40:11.940226
fireworks_ai/glm-5p3-fast	Fireworks_ai	fireworks_ai/glm-5p3-fast	128000	t	2026-09-23 23:40:11.941119
fireworks_ai/glm-5p3-flash	Fireworks_ai	fireworks_ai/glm-5p3-flash	128000	t	2026-09-23 23:40:11.941572
aihubmix/coding-xiaomi-mimo-v2-omni	Aihubmix	aihubmix/coding-xiaomi-mimo-v2-omni	128000	t	2026-09-23 23:40:11.958784
aihubmix/coding-xiaomi-mimo-v2.5	Aihubmix	aihubmix/coding-xiaomi-mimo-v2.5	128000	t	2026-09-23 23:40:11.959108
aihubmix/coding-xiaomi-mimo-v2.5-pro	Aihubmix	aihubmix/coding-xiaomi-mimo-v2.5-pro	128000	t	2026-09-23 23:40:11.959523
aihubmix/mimo-v2-omni	Aihubmix	aihubmix/mimo-v2-omni	128000	t	2026-09-23 23:40:11.961742
aihubmix/mimo-v2-pro	Aihubmix	aihubmix/mimo-v2-pro	128000	t	2026-09-23 23:40:11.962045
wandb/zai-org/GLM-5.3-Flash	Wandb	wandb/zai-org/GLM-5.3-Flash	128000	t	2026-09-23 23:40:11.964473
openrouter/~deepseek/deepseek-flash-latest	Openrouter	openrouter/~deepseek/deepseek-flash-latest	128000	t	2026-09-23 23:40:11.964798
openrouter/~deepseek/deepseek-pro-latest	Openrouter	openrouter/~deepseek/deepseek-pro-latest	128000	t	2026-09-23 23:40:11.965128
openrouter/~deepseek/deepseek-v4-flash-latest	Openrouter	openrouter/~deepseek/deepseek-v4-flash-latest	128000	t	2026-09-23 23:40:11.965433
openrouter/~moonshotai/kimi-latest	Openrouter	openrouter/~moonshotai/kimi-latest	128000	t	2026-09-23 23:40:11.965749
openrouter/~z-ai/glm-flash-latest	Openrouter	openrouter/~z-ai/glm-flash-latest	128000	t	2026-09-23 23:40:11.966465
openrouter/~z-ai/glm-latest	Openrouter	openrouter/~z-ai/glm-latest	128000	t	2026-09-23 23:40:11.966753
openrouter/moonshotai/kimi-k3:batch	Openrouter	openrouter/moonshotai/kimi-k3:batch	128000	t	2026-09-23 23:40:11.967124
openrouter/qwen/qwen3.8-27b:free	Openrouter	openrouter/qwen/qwen3.8-27b:free	128000	t	2026-09-23 23:40:11.967676
openrouter/z-ai/glm-5.3-flash:batch	Openrouter	openrouter/z-ai/glm-5.3-flash:batch	128000	t	2026-09-23 23:40:11.96803
openrouter/z-ai/glm-5.3:batch	Openrouter	openrouter/z-ai/glm-5.3:batch	128000	t	2026-09-23 23:40:11.968368
openrouter/z-ai/glm-5.3-flashx	Openrouter	openrouter/z-ai/glm-5.3-flashx	128000	t	2026-09-23 23:40:11.968714
moonshotai.kimi-k3	Chinese AI	moonshotai.kimi-k3	128000	t	2026-09-23 23:40:11.969067
global.moonshotai.kimi-k3	Chinese AI	global.moonshotai.kimi-k3	128000	t	2026-09-23 23:40:11.969401
us.moonshotai.kimi-k3	Chinese AI	us.moonshotai.kimi-k3	128000	t	2026-09-23 23:40:11.969723
openrouter/xiaomi/mimo-v2.6-flash	Openrouter	openrouter/xiaomi/mimo-v2.6-flash	128000	t	2026-09-23 23:40:11.970039
openrouter/xiaomi/mimo-v2.6-pro	Openrouter	openrouter/xiaomi/mimo-v2.6-pro	128000	t	2026-09-23 23:40:11.970381
openrouter/xiaomi/mimo-v2.6-pro-ultraspeed	Openrouter	openrouter/xiaomi/mimo-v2.6-pro-ultraspeed	128000	t	2026-09-23 23:40:11.970708
xiaomi_mimo/mimo-v2.6-pro	Xiaomi_mimo	xiaomi_mimo/mimo-v2.6-pro	128000	t	2026-09-23 23:40:11.971064
xiaomi_mimo/mimo-v2.6-flash	Xiaomi_mimo	xiaomi_mimo/mimo-v2.6-flash	128000	t	2026-09-23 23:40:11.971558
baseten/deepseek-ai/DeepSeek-V4.1-Flash	Baseten	baseten/deepseek-ai/DeepSeek-V4.1-Flash	128000	t	2026-09-23 23:40:11.971887
baseten/moonshotai/Kimi-K2.6	Baseten	baseten/moonshotai/Kimi-K2.6	128000	t	2026-09-23 23:40:11.972196
baseten/moonshotai/Kimi-K2.7-Code	Baseten	baseten/moonshotai/Kimi-K2.7-Code	128000	t	2026-09-23 23:40:11.972494
baseten/moonshotai/Kimi-K3	Baseten	baseten/moonshotai/Kimi-K3	128000	t	2026-09-23 23:40:11.972804
baseten/zai-org/GLM-5.2	Baseten	baseten/zai-org/GLM-5.2	128000	t	2026-09-23 23:40:11.973129
baseten/zai-org/GLM-5.3-Flash	Baseten	baseten/zai-org/GLM-5.3-Flash	128000	t	2026-09-23 23:40:11.973441
baseten/deepseek-ai/DeepSeek-V4-Flash-0731	Baseten	baseten/deepseek-ai/DeepSeek-V4-Flash-0731	128000	t	2026-09-23 23:40:11.973749
baseten/deepseek-ai/DeepSeek-V4-Pro	Baseten	baseten/deepseek-ai/DeepSeek-V4-Pro	128000	t	2026-09-23 23:40:11.974159
baseten/deepseek-ai/DeepSeek-V4-Pro-0813	Baseten	baseten/deepseek-ai/DeepSeek-V4-Pro-0813	128000	t	2026-09-23 23:40:11.974483
baseten/zai-org/GLM-5.2-Fast	Baseten	baseten/zai-org/GLM-5.2-Fast	128000	t	2026-09-23 23:40:11.974808
openrouter/deepseek/deepseek-v4.1-flash:batch	Openrouter	openrouter/deepseek/deepseek-v4.1-flash:batch	128000	t	2026-09-23 23:40:11.975139
openrouter/qwen/qwen3.8-omni-flash	Openrouter	openrouter/qwen/qwen3.8-omni-flash	128000	t	2026-09-23 23:40:11.975478
vertex_ai/zai-org/glm-5.2-maas	Vertex_ai	vertex_ai/zai-org/glm-5.2-maas	128000	t	2026-09-23 23:40:11.975808
sail/moonshotai/Kimi-K3	Sail	sail/moonshotai/Kimi-K3	128000	t	2026-09-30 15:21:13.131088
sail/zai-org/GLM-5.3	Sail	sail/zai-org/GLM-5.3	128000	t	2026-09-30 15:21:13.13275
sail/zai-org/GLM-5.3-Flash	Sail	sail/zai-org/GLM-5.3-Flash	128000	t	2026-09-30 15:21:13.133104
sail/deepseek-ai/DeepSeek-V4-Pro-0813	Sail	sail/deepseek-ai/DeepSeek-V4-Pro-0813	128000	t	2026-09-30 15:21:13.133466
sail/deepseek-ai/DeepSeek-V4-Flash-0731	Sail	sail/deepseek-ai/DeepSeek-V4-Flash-0731	128000	t	2026-09-30 15:21:13.133832
sail/deepseek-ai/DeepSeek-V4.1-Flash	Sail	sail/deepseek-ai/DeepSeek-V4.1-Flash	128000	t	2026-09-30 15:21:13.134509
sail/moonshotai/Kimi-K2.6	Sail	sail/moonshotai/Kimi-K2.6	128000	t	2026-09-30 15:21:13.134982
sail/Qwen/Qwen3.6-35B-A3B	Sail	sail/Qwen/Qwen3.6-35B-A3B	128000	t	2026-09-30 15:21:13.135406
nebius/deepseek-ai/DeepSeek-V4.1-Flash	Nebius	nebius/deepseek-ai/DeepSeek-V4.1-Flash	128000	t	2026-09-30 15:21:13.163387
fireworks_ai/accounts/fireworks/routers/deepseek-v4p1-flash-us	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/deepseek-v4p1-flash-us	128000	t	2026-09-30 15:21:13.233691
fireworks_ai/deepseek-v4p1-flash-us	Fireworks_ai	fireworks_ai/deepseek-v4p1-flash-us	128000	t	2026-09-30 15:21:13.234555
fireworks_ai/accounts/fireworks/routers/glm-5p3-us	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/glm-5p3-us	128000	t	2026-09-30 15:21:13.252833
fireworks_ai/glm-5p3-us	Fireworks_ai	fireworks_ai/glm-5p3-us	128000	t	2026-09-30 15:21:13.253307
fireworks_ai/accounts/fireworks/routers/glm-5p3-flash-us	Fireworks_ai	fireworks_ai/accounts/fireworks/routers/glm-5p3-flash-us	128000	t	2026-09-30 15:21:13.254479
fireworks_ai/glm-5p3-flash-us	Fireworks_ai	fireworks_ai/glm-5p3-flash-us	128000	t	2026-09-30 15:21:13.254963
azure_ai/deepseek-v4.1-flash	Azure_ai	azure_ai/deepseek-v4.1-flash	128000	t	2026-09-30 15:21:13.256928
azure_ai/FW-DeepSeek-V4.1-Flash	Azure_ai	azure_ai/FW-DeepSeek-V4.1-Flash	128000	t	2026-09-30 15:21:13.257227
azure_ai/FW-DeepSeek-V4-Flash	Azure_ai	azure_ai/FW-DeepSeek-V4-Flash	128000	t	2026-09-30 15:21:13.257531
azure_ai/FW-GLM-5.3	Azure_ai	azure_ai/FW-GLM-5.3	128000	t	2026-09-30 15:21:13.257828
azure_ai/FW-GLM-5.3-Flash	Azure_ai	azure_ai/FW-GLM-5.3-Flash	128000	t	2026-09-30 15:21:13.258123
bedrock_mantle/deepseek.v3.1	Bedrock_mantle	bedrock_mantle/deepseek.v3.1	128000	t	2026-09-30 15:21:13.258915
bedrock_mantle/moonshotai.kimi-k2-thinking	Bedrock_mantle	bedrock_mantle/moonshotai.kimi-k2-thinking	128000	t	2026-09-30 15:21:13.259559
bedrock_mantle/qwen.qwen3-235b-a22b-2507	Bedrock_mantle	bedrock_mantle/qwen.qwen3-235b-a22b-2507	128000	t	2026-09-30 15:21:13.259871
bedrock_mantle/qwen.qwen3-32b	Bedrock_mantle	bedrock_mantle/qwen.qwen3-32b	128000	t	2026-09-30 15:21:13.260169
bedrock_mantle/qwen.qwen3-coder-30b-a3b-instruct	Bedrock_mantle	bedrock_mantle/qwen.qwen3-coder-30b-a3b-instruct	128000	t	2026-09-30 15:21:13.260468
bedrock_mantle/qwen.qwen3-coder-480b-a35b-instruct	Bedrock_mantle	bedrock_mantle/qwen.qwen3-coder-480b-a35b-instruct	128000	t	2026-09-30 15:21:13.260752
bedrock_mantle/qwen.qwen3-next-80b-a3b-instruct	Bedrock_mantle	bedrock_mantle/qwen.qwen3-next-80b-a3b-instruct	128000	t	2026-09-30 15:21:13.261053
bedrock_mantle/qwen.qwen3-vl-235b-a22b-instruct	Bedrock_mantle	bedrock_mantle/qwen.qwen3-vl-235b-a22b-instruct	128000	t	2026-09-30 15:21:13.261355
baseten/zai-org/GLM-5.3-Fast	Baseten	baseten/zai-org/GLM-5.3-Fast	128000	t	2026-09-30 15:21:13.262049
openrouter/qwen/qwen3.8-max-prime	Openrouter	openrouter/qwen/qwen3.8-max-prime	128000	t	2026-09-30 15:21:13.263992
wandb/deepseek-ai/DeepSeek-V4.1-Flash	Wandb	wandb/deepseek-ai/DeepSeek-V4.1-Flash	128000	t	2026-09-30 15:21:13.286072
openrouter/z-ai/glm-5.3-prime	Openrouter	openrouter/z-ai/glm-5.3-prime	128000	t	2026-09-30 15:21:13.288126
deepseek.r1-v1:0	Chinese AI	deepseek.r1-v1:0	128000	t	2026-09-30 15:21:13.291295
prism/deepseek-v4.1-flash	Prism	prism/deepseek-v4.1-flash	128000	t	2026-09-30 15:21:13.291527
prism/deepseek-v4-flash	Prism	prism/deepseek-v4-flash	128000	t	2026-09-30 15:21:13.291753
baseten/deepseek-ai/DeepSeek-V4.1-Flash-Fast	Baseten	baseten/deepseek-ai/DeepSeek-V4.1-Flash-Fast	128000	t	2026-09-30 15:21:13.291953
\.


--
-- Data for Name: llm_prices; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.llm_prices (id, model_id, input_price_per_1m, output_price_per_1m, cached_price_per_1m, recorded_at) FROM stdin;
1	azure_ai/FW-DeepSeek-V3.2	0.620000	1.850000	0.310000	2026-09-16 22:14:42.883674+08
2	azure_ai/FW-DeepSeek-V4-Pro	1.925000	3.828000	0.165000	2026-09-16 22:14:42.890478+08
3	azure_ai/FW-GLM-5	1.100000	3.520000	0.220000	2026-09-16 22:14:42.891426+08
4	azure_ai/FW-GLM-5.1	1.540000	4.840000	0.286000	2026-09-16 22:14:42.894051+08
5	azure_ai/FW-GLM-5.2	1.540000	4.840000	0.150000	2026-09-16 22:14:42.894992+08
6	azure_ai/FW-GLM-5.2-Fast	2.100000	6.600000	0.210000	2026-09-16 22:14:42.896295+08
7	azure_ai/FW-Kimi-K2.5	0.660000	3.300000	0.110000	2026-09-16 22:14:42.897101+08
8	azure_ai/FW-Kimi-K2.6	1.045000	4.400000	0.176000	2026-09-16 22:14:42.898109+08
9	azure_ai/FW-Kimi-K2.7-Code	1.050000	4.400000	0.210000	2026-09-16 22:14:42.898806+08
10	azure_ai/FW-Kimi-K3	3.300000	16.500000	0.330000	2026-09-16 22:14:42.89954+08
11	azure_ai/FW-MiniMax-M2.5	0.330000	1.320000	0.033000	2026-09-16 22:14:42.900212+08
12	azure_ai/FW-MiniMax-M3	0.330000	1.320000	0.066000	2026-09-16 22:14:42.900909+08
13	azure_ai/deepseek-v3.2	0.580000	1.680000	0.000000	2026-09-16 22:14:42.901712+08
14	azure_ai/deepseek-v3.2-speciale	0.580000	1.680000	0.000000	2026-09-16 22:14:42.902433+08
15	azure_ai/deepseek-r1	1.350000	5.400000	0.000000	2026-09-16 22:14:42.903193+08
16	azure_ai/deepseek-v3	1.140000	4.560000	0.000000	2026-09-16 22:14:42.903971+08
17	azure_ai/deepseek-v3-0324	1.140000	4.560000	0.000000	2026-09-16 22:14:42.90478+08
18	azure_ai/deepseek-v3.1	1.230000	4.940000	0.000000	2026-09-16 22:14:42.905528+08
19	azure_ai/deepseek-v4-pro	1.740000	3.480000	0.145000	2026-09-16 22:14:42.906272+08
20	azure_ai/deepseek-v4-flash	0.190000	0.510000	0.028000	2026-09-16 22:14:42.906955+08
21	azure_ai/DeepSeek-V4-Flash-0731	0.440000	1.320000	0.014000	2026-09-16 22:14:42.907685+08
22	azure_ai/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-16 22:14:42.908426+08
23	azure_ai/kimi-k2.6	0.950000	4.000000	0.160000	2026-09-16 22:14:42.909732+08
24	bedrock/ap-northeast-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:14:42.910706+08
25	bedrock/ap-northeast-1/minimax.minimax-m2.1	0.360000	1.440000	0.000000	2026-09-16 22:14:42.911579+08
26	bedrock/ap-northeast-1/minimax.minimax-m2.5	0.360000	1.440000	0.000000	2026-09-16 22:14:42.91223+08
27	bedrock/ap-northeast-1/moonshotai.kimi-k2-thinking	0.730000	3.030000	0.000000	2026-09-16 22:14:42.912842+08
28	bedrock/ap-northeast-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:14:42.91342+08
29	bedrock/ap-northeast-1/qwen.qwen3-coder-next	0.600000	1.440000	0.000000	2026-09-16 22:14:42.914235+08
30	bedrock/moonshotai.kimi-k2-thinking	0.730000	3.030000	0.000000	2026-09-16 22:14:42.914929+08
31	bedrock/moonshotai.kimi-k2.5	0.600000	3.030000	0.000000	2026-09-16 22:14:42.915571+08
32	bedrock/ap-south-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:14:42.916192+08
33	bedrock/ap-south-1/minimax.minimax-m2.1	0.360000	1.440000	0.000000	2026-09-16 22:14:42.91682+08
34	bedrock/ap-south-1/minimax.minimax-m2.5	0.360000	1.440000	0.000000	2026-09-16 22:14:42.917454+08
35	bedrock/ap-south-1/moonshotai.kimi-k2-thinking	0.710000	2.940000	0.000000	2026-09-16 22:14:42.918085+08
36	bedrock/ap-south-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:14:42.918828+08
37	bedrock/ap-south-1/qwen.qwen3-coder-next	0.600000	1.440000	0.000000	2026-09-16 22:14:42.919501+08
38	bedrock/ap-southeast-2/minimax.minimax-m2.5	0.309000	1.236000	0.000000	2026-09-16 22:14:42.920165+08
39	bedrock/ap-southeast-3/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:14:42.920842+08
40	bedrock/ap-southeast-3/minimax.minimax-m2.1	0.360000	1.440000	0.000000	2026-09-16 22:14:42.921364+08
41	bedrock/ap-southeast-3/minimax.minimax-m2.5	0.360000	1.440000	0.000000	2026-09-16 22:14:42.921831+08
42	bedrock/ap-southeast-3/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:14:42.922347+08
43	bedrock/ap-southeast-3/qwen.qwen3-coder-next	0.600000	1.440000	0.000000	2026-09-16 22:14:42.922803+08
44	bedrock/eu-north-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:14:42.923269+08
45	bedrock/eu-north-1/minimax.minimax-m2.1	0.360000	1.440000	0.000000	2026-09-16 22:14:42.923786+08
46	bedrock/eu-north-1/minimax.minimax-m2.5	0.360000	1.440000	0.000000	2026-09-16 22:14:42.924276+08
47	bedrock/eu-north-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:14:42.92501+08
48	bedrock/eu-central-1/minimax.minimax-m2.1	0.360000	1.440000	0.000000	2026-09-16 22:14:42.925485+08
49	bedrock/eu-central-1/minimax.minimax-m2.5	0.360000	1.440000	0.000000	2026-09-16 22:14:42.926416+08
50	bedrock/eu-central-1/qwen.qwen3-coder-next	0.600000	1.440000	0.000000	2026-09-16 22:14:42.927009+08
51	bedrock/eu-west-1/minimax.minimax-m2.1	0.360000	1.440000	0.000000	2026-09-16 22:14:42.927792+08
52	bedrock/eu-west-1/minimax.minimax-m2.5	0.360000	1.440000	0.000000	2026-09-16 22:14:42.928275+08
53	bedrock/eu-west-1/qwen.qwen3-coder-next	0.600000	1.440000	0.000000	2026-09-16 22:14:42.928707+08
54	bedrock/eu-west-2/minimax.minimax-m2.1	0.470000	1.860000	0.000000	2026-09-16 22:14:42.929132+08
55	bedrock/eu-west-2/minimax.minimax-m2.5	0.470000	1.860000	0.000000	2026-09-16 22:14:42.929543+08
56	bedrock/eu-west-2/qwen.qwen3-coder-next	0.780000	1.860000	0.000000	2026-09-16 22:14:42.929942+08
57	bedrock/eu-south-1/minimax.minimax-m2.1	0.360000	1.440000	0.000000	2026-09-16 22:14:42.930445+08
58	bedrock/eu-south-1/minimax.minimax-m2.5	0.360000	1.440000	0.000000	2026-09-16 22:14:42.930894+08
59	bedrock/eu-south-1/qwen.qwen3-coder-next	0.600000	1.440000	0.000000	2026-09-16 22:14:42.931339+08
60	bedrock/sa-east-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:14:42.931784+08
61	bedrock/sa-east-1/minimax.minimax-m2.1	0.360000	1.440000	0.000000	2026-09-16 22:14:42.932232+08
62	bedrock/sa-east-1/minimax.minimax-m2.5	0.360000	1.440000	0.000000	2026-09-16 22:14:42.932613+08
63	bedrock/sa-east-1/moonshotai.kimi-k2-thinking	0.730000	3.030000	0.000000	2026-09-16 22:14:42.932938+08
64	bedrock/sa-east-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:14:42.933281+08
65	bedrock/sa-east-1/qwen.qwen3-coder-next	0.600000	1.440000	0.000000	2026-09-16 22:14:42.933642+08
66	bedrock/us-east-1/deepseek.v3.2	0.620000	1.850000	0.000000	2026-09-16 22:14:42.934948+08
67	bedrock/us-east-1/minimax.minimax-m2.1	0.300000	1.200000	0.000000	2026-09-16 22:14:42.935322+08
68	bedrock/us-east-1/minimax.minimax-m2.5	0.300000	1.200000	0.000000	2026-09-16 22:14:42.935738+08
69	bedrock/us-east-1/moonshotai.kimi-k2-thinking	0.600000	2.500000	0.000000	2026-09-16 22:14:42.936226+08
70	bedrock/us-east-1/moonshotai.kimi-k2.5	0.600000	3.000000	0.000000	2026-09-16 22:14:42.936562+08
71	bedrock/us-east-1/qwen.qwen3-coder-next	0.500000	1.200000	0.000000	2026-09-16 22:14:42.93693+08
72	bedrock/us-east-2/deepseek.v3.2	0.620000	1.850000	0.000000	2026-09-16 22:14:42.937258+08
73	bedrock/us-east-2/minimax.minimax-m2.1	0.300000	1.200000	0.000000	2026-09-16 22:14:42.937587+08
74	bedrock/us-east-2/minimax.minimax-m2.5	0.300000	1.200000	0.000000	2026-09-16 22:14:42.93792+08
75	bedrock/us-east-2/moonshotai.kimi-k2-thinking	0.600000	2.500000	0.000000	2026-09-16 22:14:42.938264+08
76	bedrock/us-east-2/moonshotai.kimi-k2.5	0.600000	3.000000	0.000000	2026-09-16 22:14:42.938618+08
77	bedrock/us-east-2/qwen.qwen3-coder-next	0.500000	1.200000	0.000000	2026-09-16 22:14:42.938944+08
78	bedrock/us-west-2/deepseek.v3.2	0.620000	1.850000	0.000000	2026-09-16 22:14:42.939305+08
79	bedrock/us-west-2/minimax.minimax-m2.1	0.300000	1.200000	0.000000	2026-09-16 22:14:42.939635+08
80	bedrock/us-west-2/minimax.minimax-m2.5	0.300000	1.200000	0.000000	2026-09-16 22:14:42.939984+08
81	bedrock/us-west-2/moonshotai.kimi-k2-thinking	0.600000	2.500000	0.000000	2026-09-16 22:14:42.940284+08
82	bedrock/us-west-2/moonshotai.kimi-k2.5	0.600000	3.000000	0.000000	2026-09-16 22:14:42.940593+08
83	bedrock/us-west-2/qwen.qwen3-coder-next	0.500000	1.200000	0.000000	2026-09-16 22:14:42.94089+08
84	cerebras/qwen-3-32b	0.400000	0.800000	0.000000	2026-09-16 22:14:42.941218+08
85	cerebras/zai-glm-4.6	2.250000	2.750000	0.000000	2026-09-16 22:14:42.94185+08
86	cerebras/zai-glm-4.7	2.250000	2.750000	0.000000	2026-09-16 22:14:42.942154+08
87	cerebras/qwen-3.8-27b	0.990000	1.490000	0.000000	2026-09-16 22:14:42.942439+08
88	cloudflare/@cf/moonshotai/kimi-k2.7-code	0.950000	4.000000	0.190000	2026-09-16 22:14:42.942761+08
89	cloudflare/@cf/deepseek-ai/deepseek-r1-distill-qwen-32b	0.497000	4.881000	0.000000	2026-09-16 22:14:42.943047+08
90	cloudflare/@cf/moonshotai/kimi-k2.6	0.950000	4.000000	0.160000	2026-09-16 22:14:42.94334+08
91	cloudflare/@cf/zai-org/glm-4.7-flash	0.060500	0.400000	0.000000	2026-09-16 22:14:42.943783+08
92	cloudflare/@cf/qwen/qwen2.5-coder-32b-instruct	0.660000	1.000000	0.000000	2026-09-16 22:14:42.944165+08
93	cloudflare/@cf/zai-org/glm-5.2	1.400000	4.400000	0.260000	2026-09-16 22:14:42.944465+08
94	cloudflare/@cf/qwen/qwen3-30b-a3b-fp8	0.050900	0.335000	0.000000	2026-09-16 22:14:42.944766+08
95	cloudflare/@cf/qwen/qwq-32b	0.660000	1.000000	0.000000	2026-09-16 22:14:42.945072+08
96	deepseek-chat	0.280000	0.420000	0.028000	2026-09-16 22:14:42.945393+08
97	deepseek-reasoner	0.280000	0.420000	0.028000	2026-09-16 22:14:42.945732+08
98	dashscope/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-16 22:14:42.946059+08
99	dashscope/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-16 22:14:42.946372+08
100	dashscope/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-16 22:14:42.946677+08
101	dashscope/glm-5.1	1.400000	4.400000	0.260000	2026-09-16 22:14:42.947014+08
102	dashscope/glm-5.2	1.400000	4.400000	0.280000	2026-09-16 22:14:42.947358+08
103	dashscope/kimi-k2.7-code	0.950000	4.000000	0.190000	2026-09-16 22:14:42.947691+08
104	dashscope/qwen-coder	0.300000	1.500000	0.000000	2026-09-16 22:14:42.948082+08
105	dashscope/qwen-flash	0.000000	0.000000	0.000000	2026-09-16 22:14:42.948358+08
106	dashscope/qwen-flash-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.948651+08
107	dashscope/qwen-max	1.600000	6.400000	0.000000	2026-09-16 22:14:42.948941+08
108	dashscope/qwen-plus	0.400000	1.200000	0.000000	2026-09-16 22:14:42.949226+08
109	dashscope/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-16 22:14:42.949507+08
110	dashscope/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-16 22:14:42.949809+08
111	dashscope/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-16 22:14:42.950098+08
112	dashscope/qwen-plus-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.950378+08
113	dashscope/qwen-plus-2025-09-11	0.000000	0.000000	0.000000	2026-09-16 22:14:42.950706+08
114	dashscope/qwen-plus-latest	0.000000	0.000000	0.000000	2026-09-16 22:14:42.95103+08
115	dashscope/qwen-turbo	0.050000	0.200000	0.000000	2026-09-16 22:14:42.951524+08
116	dashscope/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-16 22:14:42.951853+08
117	dashscope/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-16 22:14:42.952244+08
118	dashscope/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-16 22:14:42.952571+08
119	dashscope/qwen3-30b-a3b	0.000000	0.000000	0.000000	2026-09-16 22:14:42.952888+08
120	dashscope/qwen3-coder-flash	0.000000	0.000000	0.000000	2026-09-16 22:14:42.953211+08
121	dashscope/qwen3-coder-flash-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.953535+08
122	dashscope/qwen3-coder-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.953872+08
123	dashscope/qwen3-coder-plus-2025-07-22	0.000000	0.000000	0.000000	2026-09-16 22:14:42.954214+08
124	dashscope/qwen3-max-preview	0.000000	0.000000	0.000000	2026-09-16 22:14:42.954537+08
125	dashscope/qwen3-max	0.000000	0.000000	0.000000	2026-09-16 22:14:42.954858+08
126	dashscope/qwen3-max-2026-01-23	0.000000	0.000000	0.000000	2026-09-16 22:14:42.955199+08
127	dashscope/qwen3-next-80b-a3b-instruct	0.150000	1.200000	0.000000	2026-09-16 22:14:42.955566+08
128	dashscope/qwen3-next-80b-a3b-thinking	0.150000	1.200000	0.000000	2026-09-16 22:14:42.955895+08
129	dashscope/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-16 22:14:42.956223+08
130	dashscope/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-16 22:14:42.956548+08
131	dashscope/qwen3-vl-32b-instruct	0.160000	0.640000	0.000000	2026-09-16 22:14:42.95691+08
132	dashscope/qwen3-vl-32b-thinking	0.160000	2.870000	0.000000	2026-09-16 22:14:42.957191+08
133	dashscope/qwen3-vl-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.957806+08
134	dashscope/qwen3.5-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.958836+08
135	dashscope/qwen3.7-max	2.500000	7.500000	0.500000	2026-09-16 22:14:42.959122+08
136	dashscope/qwen3.7-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.95941+08
137	dashscope/qwen3.8-max	2.000000	6.000000	0.250000	2026-09-16 22:14:42.959703+08
138	dashscope/qwen-image-2.0	0.000000	0.000000	0.000000	2026-09-16 22:14:42.960201+08
139	dashscope/qwen-image-2.0-pro	0.000000	0.000000	0.000000	2026-09-16 22:14:42.960518+08
140	dashscope/qwen-image-3.0	0.000000	0.000000	0.000000	2026-09-16 22:14:42.960812+08
141	dashscope/qwen-image-3.0-pro	0.000000	0.000000	0.000000	2026-09-16 22:14:42.961105+08
142	qwencloud/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-16 22:14:42.961395+08
143	qwencloud/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-16 22:14:42.96169+08
144	qwencloud/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-16 22:14:42.961976+08
145	qwencloud/glm-5.1	1.400000	4.400000	0.260000	2026-09-16 22:14:42.962267+08
146	qwencloud/glm-5.2	1.400000	4.400000	0.280000	2026-09-16 22:14:42.962551+08
147	qwencloud/kimi-k2.7-code	0.950000	4.000000	0.190000	2026-09-16 22:14:42.962833+08
148	qwencloud/qwen-coder	0.300000	1.500000	0.000000	2026-09-16 22:14:42.963128+08
149	qwencloud/qwen-flash	0.000000	0.000000	0.000000	2026-09-16 22:14:42.963421+08
150	qwencloud/qwen-flash-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.964108+08
151	qwencloud/qwen-max	1.600000	6.400000	0.000000	2026-09-16 22:14:42.964396+08
152	qwencloud/qwen-plus	0.400000	1.200000	0.000000	2026-09-16 22:14:42.964674+08
153	qwencloud/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-16 22:14:42.964992+08
154	qwencloud/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-16 22:14:42.965321+08
155	qwencloud/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-16 22:14:42.965651+08
156	qwencloud/qwen-plus-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.965978+08
157	qwencloud/qwen-plus-2025-09-11	0.000000	0.000000	0.000000	2026-09-16 22:14:42.966297+08
158	qwencloud/qwen-plus-latest	0.000000	0.000000	0.000000	2026-09-16 22:14:42.966639+08
159	qwencloud/qwen-turbo	0.050000	0.200000	0.000000	2026-09-16 22:14:42.966965+08
160	qwencloud/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-16 22:14:42.967284+08
161	qwencloud/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-16 22:14:42.967767+08
162	qwencloud/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-16 22:14:42.968096+08
163	qwencloud/qwen3-30b-a3b	0.000000	0.000000	0.000000	2026-09-16 22:14:42.968422+08
164	qwencloud/qwen3-coder-flash	0.000000	0.000000	0.000000	2026-09-16 22:14:42.968741+08
165	qwencloud/qwen3-coder-flash-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.969059+08
166	qwencloud/qwen3-coder-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.969368+08
167	qwencloud/qwen3-coder-plus-2025-07-22	0.000000	0.000000	0.000000	2026-09-16 22:14:42.96969+08
168	qwencloud/qwen3-max-preview	0.000000	0.000000	0.000000	2026-09-16 22:14:42.97001+08
169	qwencloud/qwen3-max	0.000000	0.000000	0.000000	2026-09-16 22:14:42.97033+08
170	qwencloud/qwen3-max-2026-01-23	0.000000	0.000000	0.000000	2026-09-16 22:14:42.970642+08
171	qwencloud/qwen3-next-80b-a3b-instruct	0.150000	1.200000	0.000000	2026-09-16 22:14:42.970955+08
172	qwencloud/qwen3-next-80b-a3b-thinking	0.150000	1.200000	0.000000	2026-09-16 22:14:42.971277+08
173	qwencloud/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-16 22:14:42.971598+08
174	qwencloud/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-16 22:14:42.971932+08
175	qwencloud/qwen3-vl-32b-instruct	0.160000	0.640000	0.000000	2026-09-16 22:14:42.972302+08
176	qwencloud/qwen3-vl-32b-thinking	0.160000	2.870000	0.000000	2026-09-16 22:14:42.97261+08
177	qwencloud/qwen3-vl-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.972901+08
178	qwencloud/qwen3.5-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.973184+08
179	qwencloud/qwen3.7-max	2.500000	7.500000	0.500000	2026-09-16 22:14:42.973453+08
180	qwencloud/qwen3.7-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.973787+08
181	qwencloud/qwen3.8-max	2.000000	6.000000	0.250000	2026-09-16 22:14:42.974114+08
182	qwencloud/qwq-plus	0.800000	2.400000	0.000000	2026-09-16 22:14:42.974452+08
183	qwencloud/qwen-image-2.0	0.000000	0.000000	0.000000	2026-09-16 22:14:42.974919+08
184	qwencloud/qwen-image-2.0-pro	0.000000	0.000000	0.000000	2026-09-16 22:14:42.975241+08
185	qwencloud/qwen-image-3.0	0.000000	0.000000	0.000000	2026-09-16 22:14:42.975534+08
186	qwencloud/qwen-image-3.0-pro	0.000000	0.000000	0.000000	2026-09-16 22:14:42.975837+08
187	qwen_ai_platform/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-16 22:14:42.976148+08
188	qwen_ai_platform/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-16 22:14:42.976454+08
189	qwen_ai_platform/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-16 22:14:42.976766+08
190	qwen_ai_platform/glm-5.1	1.400000	4.400000	0.260000	2026-09-16 22:14:42.977104+08
191	qwen_ai_platform/glm-5.2	1.400000	4.400000	0.280000	2026-09-16 22:14:42.977415+08
192	qwen_ai_platform/kimi-k2.7-code	0.950000	4.000000	0.190000	2026-09-16 22:14:42.977746+08
193	qwen_ai_platform/qwen-coder	0.300000	1.500000	0.000000	2026-09-16 22:14:42.978042+08
194	qwen_ai_platform/qwen-flash	0.000000	0.000000	0.000000	2026-09-16 22:14:42.978342+08
195	qwen_ai_platform/qwen-flash-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.978634+08
196	qwen_ai_platform/qwen-max	1.600000	6.400000	0.000000	2026-09-16 22:14:42.978935+08
197	qwen_ai_platform/qwen-plus	0.400000	1.200000	0.000000	2026-09-16 22:14:42.979231+08
198	qwen_ai_platform/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-16 22:14:42.979526+08
199	qwen_ai_platform/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-16 22:14:42.97987+08
200	qwen_ai_platform/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-16 22:14:42.980599+08
201	qwen_ai_platform/qwen-plus-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.98093+08
202	qwen_ai_platform/qwen-plus-2025-09-11	0.000000	0.000000	0.000000	2026-09-16 22:14:42.981252+08
203	qwen_ai_platform/qwen-plus-latest	0.000000	0.000000	0.000000	2026-09-16 22:14:42.981584+08
204	qwen_ai_platform/qwen-turbo	0.050000	0.200000	0.000000	2026-09-16 22:14:42.981905+08
205	qwen_ai_platform/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-16 22:14:42.982224+08
206	qwen_ai_platform/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-16 22:14:42.982581+08
207	qwen_ai_platform/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-16 22:14:42.982927+08
208	qwen_ai_platform/qwen3-30b-a3b	0.000000	0.000000	0.000000	2026-09-16 22:14:42.983263+08
209	qwen_ai_platform/qwen3-coder-flash	0.000000	0.000000	0.000000	2026-09-16 22:14:42.983613+08
210	qwen_ai_platform/qwen3-coder-flash-2025-07-28	0.000000	0.000000	0.000000	2026-09-16 22:14:42.983947+08
211	qwen_ai_platform/qwen3-coder-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.984319+08
212	qwen_ai_platform/qwen3-coder-plus-2025-07-22	0.000000	0.000000	0.000000	2026-09-16 22:14:42.984676+08
213	qwen_ai_platform/qwen3-max-preview	0.000000	0.000000	0.000000	2026-09-16 22:14:42.985002+08
214	qwen_ai_platform/qwen3-max	0.000000	0.000000	0.000000	2026-09-16 22:14:42.985334+08
215	qwen_ai_platform/qwen3-max-2026-01-23	0.000000	0.000000	0.000000	2026-09-16 22:14:42.985697+08
216	qwen_ai_platform/qwen3-next-80b-a3b-instruct	0.150000	1.200000	0.000000	2026-09-16 22:14:42.98606+08
217	qwen_ai_platform/qwen3-next-80b-a3b-thinking	0.150000	1.200000	0.000000	2026-09-16 22:14:42.986403+08
218	qwen_ai_platform/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-16 22:14:42.986748+08
219	qwen_ai_platform/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-16 22:14:42.98709+08
220	qwen_ai_platform/qwen3-vl-32b-instruct	0.160000	0.640000	0.000000	2026-09-16 22:14:42.987444+08
221	qwen_ai_platform/qwen3-vl-32b-thinking	0.160000	2.870000	0.000000	2026-09-16 22:14:42.98778+08
222	qwen_ai_platform/qwen3-vl-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.988307+08
223	qwen_ai_platform/qwen3.5-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.98863+08
224	qwen_ai_platform/qwen3.7-max	2.500000	7.500000	0.500000	2026-09-16 22:14:42.988982+08
225	qwen_ai_platform/qwen3.7-plus	0.000000	0.000000	0.000000	2026-09-16 22:14:42.98931+08
226	qwen_ai_platform/qwen3.8-max	2.000000	6.000000	0.250000	2026-09-16 22:14:42.989635+08
227	qwen_ai_platform/qwq-plus	0.800000	2.400000	0.000000	2026-09-16 22:14:42.989957+08
228	qwen_ai_platform/qwen-image-2.0	0.000000	0.000000	0.000000	2026-09-16 22:14:42.990291+08
229	qwen_ai_platform/qwen-image-2.0-pro	0.000000	0.000000	0.000000	2026-09-16 22:14:42.990613+08
230	qwen_ai_platform/qwen-image-3.0	0.000000	0.000000	0.000000	2026-09-16 22:14:42.990941+08
231	qwen_ai_platform/qwen-image-3.0-pro	0.000000	0.000000	0.000000	2026-09-16 22:14:42.991275+08
232	databricks/databricks-deepseek-v4-flash-0731	0.140000	0.280000	0.028000	2026-09-16 22:14:42.991622+08
233	databricks/databricks-deepseek-v4-pro-0813	1.319990	3.959970	0.132020	2026-09-16 22:14:42.991936+08
234	databricks/databricks-glm-5-2	1.400000	4.399990	0.259980	2026-09-16 22:14:42.992266+08
235	databricks/databricks-glm-5-3	1.400000	4.399990	0.259980	2026-09-16 22:14:42.992575+08
236	databricks/databricks-glm-5-3-flash	0.150010	0.500010	0.030030	2026-09-16 22:14:42.992909+08
237	databricks/databricks-kimi-k3	2.999990	15.000020	0.300020	2026-09-16 22:14:42.993237+08
238	databricks/databricks-qwen35-122b-a10b	0.220010	2.200030	0.220010	2026-09-16 22:14:42.993576+08
239	databricks/databricks-qwen3-next-80b-a3b-instruct	0.150010	1.200010	0.150010	2026-09-16 22:14:42.993897+08
240	databricks/databricks-qwen3-embedding-0-6b	0.020020	0.000000	0.020020	2026-09-16 22:14:42.994223+08
241	deepinfra/Qwen/QwQ-32B	0.150000	0.400000	0.000000	2026-09-16 22:14:42.994588+08
242	deepinfra/Qwen/Qwen2.5-72B-Instruct	0.360000	0.400000	0.000000	2026-09-16 22:14:42.995015+08
243	deepinfra/Qwen/Qwen2.5-7B-Instruct	0.040000	0.100000	0.000000	2026-09-16 22:14:42.995346+08
244	deepinfra/Qwen/Qwen2.5-VL-32B-Instruct	0.200000	0.600000	0.000000	2026-09-16 22:14:42.99571+08
245	deepinfra/Qwen/Qwen3-14B	0.120000	0.240000	0.000000	2026-09-16 22:14:42.996235+08
246	deepinfra/Qwen/Qwen3-235B-A22B	0.180000	0.540000	0.000000	2026-09-16 22:14:42.99657+08
247	deepinfra/Qwen/Qwen3-235B-A22B-Instruct-2507	0.090000	0.550000	0.000000	2026-09-16 22:14:42.996916+08
248	deepinfra/Qwen/Qwen3-235B-A22B-Thinking-2507	0.300000	2.900000	0.000000	2026-09-16 22:14:42.997326+08
249	deepinfra/Qwen/Qwen3-30B-A3B	0.120000	0.500000	0.000000	2026-09-16 22:14:42.997652+08
250	deepinfra/Qwen/Qwen3-32B	0.080000	0.280000	0.000000	2026-09-16 22:14:42.997967+08
251	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct	0.400000	1.600000	0.000000	2026-09-16 22:14:42.998267+08
252	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct-Turbo	0.300000	1.000000	0.100000	2026-09-16 22:14:42.998587+08
253	deepinfra/Qwen/Qwen3-Next-80B-A3B-Instruct	0.090000	1.100000	0.000000	2026-09-16 22:14:42.998941+08
254	deepinfra/Qwen/Qwen3-Next-80B-A3B-Thinking	0.140000	1.400000	0.000000	2026-09-16 22:14:42.999265+08
255	deepinfra/deepseek-ai/DeepSeek-R1	0.700000	2.400000	0.000000	2026-09-16 22:14:42.999597+08
256	deepinfra/deepseek-ai/DeepSeek-R1-0528	0.500000	2.150000	0.400000	2026-09-16 22:14:42.999899+08
257	deepinfra/deepseek-ai/DeepSeek-R1-0528-Turbo	1.000000	3.000000	0.000000	2026-09-16 22:14:43.000213+08
258	deepinfra/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	0.200000	0.600000	0.000000	2026-09-16 22:14:43.000537+08
259	deepinfra/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B	0.270000	0.270000	0.000000	2026-09-16 22:14:43.000857+08
260	deepinfra/deepseek-ai/DeepSeek-R1-Turbo	1.000000	3.000000	0.000000	2026-09-16 22:14:43.001182+08
261	deepinfra/deepseek-ai/DeepSeek-V3	0.320000	0.890000	0.000000	2026-09-16 22:14:43.001515+08
262	deepinfra/deepseek-ai/DeepSeek-V3-0324	0.240000	0.900000	0.135000	2026-09-16 22:14:43.001875+08
263	deepinfra/deepseek-ai/DeepSeek-V3.1	0.250000	0.950000	0.216000	2026-09-16 22:14:43.002211+08
264	deepinfra/deepseek-ai/DeepSeek-V3.1-Terminus	0.270000	1.000000	0.216000	2026-09-16 22:14:43.002541+08
265	deepinfra/moonshotai/Kimi-K2-Instruct	0.500000	2.000000	0.000000	2026-09-16 22:14:43.002897+08
266	deepinfra/moonshotai/Kimi-K2-Instruct-0905	0.500000	2.000000	0.400000	2026-09-16 22:14:43.0034+08
267	deepinfra/zai-org/GLM-4.5	0.400000	1.600000	0.000000	2026-09-16 22:14:43.003747+08
268	deepseek/deepseek-chat	0.280000	0.420000	0.028000	2026-09-16 22:14:43.00409+08
269	deepseek/deepseek-coder	0.140000	0.280000	0.000000	2026-09-16 22:14:43.004419+08
270	deepseek/deepseek-r1	0.550000	2.190000	0.000000	2026-09-16 22:14:43.004738+08
271	deepseek/deepseek-reasoner	0.280000	0.420000	0.028000	2026-09-16 22:14:43.005072+08
272	deepseek/deepseek-v3	0.270000	1.100000	0.070000	2026-09-16 22:14:43.005473+08
273	deepseek/deepseek-v3.2	0.280000	0.400000	0.000000	2026-09-16 22:14:43.005814+08
274	deepseek.v3-v1:0	0.580000	1.680000	0.000000	2026-09-16 22:14:43.006162+08
275	deepseek.v3.2	0.620000	1.850000	0.000000	2026-09-16 22:14:43.006495+08
276	deepseek-v3-2-251201	0.000000	0.000000	0.000000	2026-09-16 22:14:43.006827+08
277	glm-4-7-251222	0.000000	0.000000	0.000000	2026-09-16 22:14:43.007143+08
278	kimi-k2-thinking-251104	0.000000	0.000000	0.000000	2026-09-16 22:14:43.007481+08
279	fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-instruct	1.200000	1.200000	0.000000	2026-09-16 22:14:43.007909+08
280	fireworks_ai/accounts/fireworks/models/deepseek-r1	3.000000	8.000000	0.000000	2026-09-16 22:14:43.008295+08
281	fireworks_ai/accounts/fireworks/models/deepseek-r1-0528	3.000000	8.000000	0.000000	2026-09-16 22:14:43.008595+08
282	fireworks_ai/accounts/fireworks/models/deepseek-r1-basic	0.550000	2.190000	0.000000	2026-09-16 22:14:43.008908+08
283	fireworks_ai/accounts/fireworks/models/deepseek-v3	0.900000	0.900000	0.000000	2026-09-16 22:14:43.009385+08
284	fireworks_ai/accounts/fireworks/models/deepseek-v3-0324	0.900000	0.900000	0.000000	2026-09-16 22:14:43.009699+08
285	fireworks_ai/accounts/fireworks/models/deepseek-v3p1	0.560000	1.680000	0.000000	2026-09-16 22:14:43.010022+08
286	fireworks_ai/accounts/fireworks/models/deepseek-v3p1-terminus	0.560000	1.680000	0.000000	2026-09-16 22:14:43.010335+08
287	fireworks_ai/accounts/fireworks/models/deepseek-v3p2	0.560000	1.680000	0.000000	2026-09-16 22:14:43.01064+08
288	fireworks_ai/accounts/fireworks/models/deepseek-v4-flash	0.140000	0.280000	0.028000	2026-09-16 22:14:43.010978+08
289	fireworks_ai/accounts/fireworks/models/deepseek-v4-pro	1.200000	1.200000	0.600000	2026-09-16 22:14:43.011311+08
290	fireworks_ai/accounts/fireworks/models/deepseek-v4-pro-0813	1.320000	3.960000	0.044000	2026-09-16 22:14:43.011626+08
291	fireworks_ai/accounts/fireworks/models/glm-4p5	0.550000	2.190000	0.000000	2026-09-16 22:14:43.011959+08
292	fireworks_ai/accounts/fireworks/models/glm-4p5-air	0.220000	0.880000	0.000000	2026-09-16 22:14:43.012271+08
293	fireworks_ai/accounts/fireworks/models/glm-4p6	0.550000	2.190000	0.000000	2026-09-16 22:14:43.012577+08
294	fireworks_ai/accounts/fireworks/models/glm-4p7	0.600000	2.200000	0.300000	2026-09-16 22:14:43.012892+08
295	fireworks_ai/accounts/fireworks/models/glm-5p1	1.400000	4.400000	0.260000	2026-09-16 22:14:43.013192+08
296	fireworks_ai/accounts/fireworks/models/glm-5p2	1.400000	4.400000	0.140000	2026-09-16 22:14:43.014098+08
297	fireworks_ai/accounts/fireworks/models/kimi-k2-instruct	0.600000	2.500000	0.000000	2026-09-16 22:14:43.014492+08
298	fireworks_ai/accounts/fireworks/models/kimi-k2-instruct-0905	0.600000	2.500000	0.000000	2026-09-16 22:14:43.015012+08
299	fireworks_ai/accounts/fireworks/models/kimi-k2-thinking	0.600000	2.500000	0.000000	2026-09-16 22:14:43.015357+08
300	fireworks_ai/accounts/fireworks/models/kimi-k2p5	0.600000	3.000000	0.100000	2026-09-16 22:14:43.015696+08
301	fireworks_ai/accounts/fireworks/models/kimi-k2p6	0.950000	4.000000	0.160000	2026-09-16 22:14:43.016027+08
302	fireworks_ai/accounts/fireworks/models/kimi-k2p7-code	0.950000	4.000000	0.190000	2026-09-16 22:14:43.016378+08
303	fireworks_ai/accounts/fireworks/models/minimax-m2p1	0.300000	1.200000	0.030000	2026-09-16 22:14:43.016728+08
304	fireworks_ai/accounts/fireworks/models/minimax-m2p7	0.300000	1.200000	0.060000	2026-09-16 22:14:43.017074+08
305	fireworks_ai/accounts/fireworks/models/minimax-m3	0.300000	1.200000	0.060000	2026-09-16 22:14:43.017404+08
306	fireworks_ai/accounts/fireworks/models/qwen2-72b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:14:43.017747+08
307	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:14:43.018079+08
308	fireworks_ai/deepseek-v4-flash	0.140000	0.280000	0.028000	2026-09-16 22:14:43.01842+08
309	fireworks_ai/deepseek-v4-pro	1.200000	1.200000	0.600000	2026-09-16 22:14:43.018755+08
310	fireworks_ai/glm-4p7	0.600000	2.200000	0.300000	2026-09-16 22:14:43.019089+08
311	fireworks_ai/glm-5p1	1.400000	4.400000	0.260000	2026-09-16 22:14:43.019479+08
312	fireworks_ai/glm-5p1-fast	2.800000	8.800000	0.520000	2026-09-16 22:14:43.019813+08
313	fireworks_ai/glm-5p2	1.400000	4.400000	0.140000	2026-09-16 22:14:43.020132+08
314	fireworks_ai/kimi-k2p5	0.600000	3.000000	0.100000	2026-09-16 22:14:43.020467+08
315	fireworks_ai/kimi-k2p6	0.950000	4.000000	0.160000	2026-09-16 22:14:43.020806+08
316	fireworks_ai/kimi-k2p6-fast	2.000000	8.000000	0.300000	2026-09-16 22:14:43.021112+08
317	fireworks_ai/kimi-k2p7-code	0.950000	4.000000	0.190000	2026-09-16 22:14:43.021405+08
318	fireworks_ai/kimi-k2p7-code-fast	1.900000	8.000000	0.380000	2026-09-16 22:14:43.021706+08
319	fireworks_ai/minimax-m2p1	0.300000	1.200000	0.030000	2026-09-16 22:14:43.022225+08
320	fireworks_ai/minimax-m2p7	0.300000	1.200000	0.060000	2026-09-16 22:14:43.022551+08
321	fireworks_ai/minimax-m3	0.300000	1.200000	0.060000	2026-09-16 22:14:43.022907+08
322	fireworks_ai/qwen3p7-plus	0.400000	1.600000	0.080000	2026-09-16 22:14:43.023233+08
323	friendliai/zai-org/GLM-5.3-Flash	0.150000	0.500000	0.030000	2026-09-16 22:14:43.023524+08
324	friendliai/zai-org/GLM-5.3	1.260000	3.960000	0.234000	2026-09-16 22:14:43.023826+08
325	friendliai/zai-org/GLM-5.2	1.400000	4.400000	0.260000	2026-09-16 22:14:43.024134+08
326	friendliai/deepseek-ai/DeepSeek-V3.2	0.500000	1.500000	0.250000	2026-09-16 22:14:43.024456+08
327	friendliai/MiniMaxAI/MiniMax-M2.5	0.300000	1.200000	0.060000	2026-09-16 22:14:43.024783+08
328	friendliai/zai-org/GLM-5.1	1.400000	4.400000	0.260000	2026-09-16 22:14:43.025142+08
329	gmi/deepseek-ai/DeepSeek-V3.2	0.280000	0.400000	0.000000	2026-09-16 22:14:43.025555+08
330	gmi/deepseek-ai/DeepSeek-V3-0324	0.280000	0.880000	0.000000	2026-09-16 22:14:43.025854+08
331	gmi/moonshotai/Kimi-K2-Thinking	0.800000	1.200000	0.000000	2026-09-16 22:14:43.026162+08
332	gmi/MiniMaxAI/MiniMax-M2.1	0.300000	1.200000	0.000000	2026-09-16 22:14:43.026458+08
333	baseten/MiniMaxAI/MiniMax-M2.5	0.300000	1.200000	0.000000	2026-09-16 22:14:43.02678+08
334	baseten/zai-org/GLM-5	0.950000	3.150000	0.000000	2026-09-16 22:14:43.027088+08
335	baseten/zai-org/GLM-4.7	0.600000	2.200000	0.000000	2026-09-16 22:14:43.027392+08
336	baseten/zai-org/GLM-4.6	0.600000	2.200000	0.000000	2026-09-16 22:14:43.027685+08
337	baseten/moonshotai/Kimi-K2.5	0.600000	3.000000	0.000000	2026-09-16 22:14:43.027995+08
338	baseten/moonshotai/Kimi-K2-Thinking	0.600000	2.500000	0.000000	2026-09-16 22:14:43.028316+08
339	baseten/moonshotai/Kimi-K2-Instruct-0905	0.600000	2.500000	0.000000	2026-09-16 22:14:43.028655+08
340	baseten/deepseek-ai/DeepSeek-V3.1	0.500000	1.500000	0.000000	2026-09-16 22:14:43.028985+08
341	baseten/deepseek-ai/DeepSeek-V3-0324	0.770000	0.770000	0.000000	2026-09-16 22:14:43.029299+08
342	gmi/Qwen/Qwen3-VL-235B-A22B-Instruct-FP8	0.300000	1.400000	0.000000	2026-09-16 22:14:43.029805+08
343	gmi/zai-org/GLM-4.7-FP8	0.400000	2.000000	0.000000	2026-09-16 22:14:43.030129+08
344	gradient_ai/alibaba-qwen3-32b	0.000000	0.000000	0.000000	2026-09-16 22:14:43.03056+08
345	gradient_ai/deepseek-r1-distill-llama-70b	0.990000	0.990000	0.000000	2026-09-16 22:14:43.030926+08
346	lemonade/Qwen3-Coder-30B-A3B-Instruct-GGUF	0.000000	0.000000	0.000000	2026-09-16 22:14:43.031269+08
347	lemonade/Qwen3-4B-Instruct-2507-GGUF	0.000000	0.000000	0.000000	2026-09-16 22:14:43.031594+08
348	groq/moonshotai/kimi-k2-instruct-0905	1.000000	3.000000	0.500000	2026-09-16 22:14:43.031924+08
349	groq/qwen/qwen3.6-27b	0.600000	3.000000	0.000000	2026-09-16 22:14:43.032252+08
350	groq/qwen/qwen3-32b	0.290000	0.590000	0.000000	2026-09-16 22:14:43.032586+08
351	hyperbolic/Qwen/QwQ-32B	0.200000	0.200000	0.000000	2026-09-16 22:14:43.032905+08
352	hyperbolic/Qwen/Qwen2.5-72B-Instruct	0.120000	0.300000	0.000000	2026-09-16 22:14:43.033234+08
353	hyperbolic/Qwen/Qwen2.5-Coder-32B-Instruct	0.120000	0.300000	0.000000	2026-09-16 22:14:43.033558+08
354	hyperbolic/Qwen/Qwen3-235B-A22B	2.000000	2.000000	0.000000	2026-09-16 22:14:43.033841+08
355	hyperbolic/deepseek-ai/DeepSeek-R1	0.400000	0.400000	0.000000	2026-09-16 22:14:43.034152+08
356	hyperbolic/deepseek-ai/DeepSeek-R1-0528	0.250000	0.250000	0.000000	2026-09-16 22:14:43.03444+08
357	hyperbolic/deepseek-ai/DeepSeek-V3	0.200000	0.200000	0.000000	2026-09-16 22:14:43.034733+08
358	hyperbolic/deepseek-ai/DeepSeek-V3-0324	0.400000	0.400000	0.000000	2026-09-16 22:14:43.035024+08
359	hyperbolic/moonshotai/Kimi-K2-Instruct	2.000000	2.000000	0.000000	2026-09-16 22:14:43.035376+08
360	crusoe/deepseek-ai/DeepSeek-R1-0528	3.000000	7.000000	0.000000	2026-09-16 22:14:43.035716+08
361	crusoe/deepseek-ai/DeepSeek-V3-0324	1.500000	1.500000	0.000000	2026-09-16 22:14:43.036042+08
362	crusoe/moonshotai/Kimi-K2-Thinking	2.500000	2.500000	0.000000	2026-09-16 22:14:43.036379+08
363	crusoe/Qwen/Qwen3-235B-A22B-Instruct-2507	3.000000	3.000000	0.000000	2026-09-16 22:14:43.036702+08
364	lambda_ai/deepseek-llama3.3-70b	0.200000	0.600000	0.000000	2026-09-16 22:14:43.037054+08
365	lambda_ai/deepseek-r1-0528	0.200000	0.600000	0.000000	2026-09-16 22:14:43.037559+08
366	lambda_ai/deepseek-r1-671b	0.800000	0.800000	0.000000	2026-09-16 22:14:43.037897+08
367	lambda_ai/deepseek-v3-0324	0.200000	0.600000	0.000000	2026-09-16 22:14:43.038231+08
368	lambda_ai/qwen25-coder-32b-instruct	0.050000	0.100000	0.000000	2026-09-16 22:14:43.038602+08
369	lambda_ai/qwen3-32b-fp8	0.050000	0.100000	0.000000	2026-09-16 22:14:43.038915+08
370	minimax.minimax-m2	0.300000	1.200000	0.000000	2026-09-16 22:14:43.039255+08
371	minimax.minimax-m2.1	0.300000	1.200000	0.000000	2026-09-16 22:14:43.039593+08
372	minimax.minimax-m2.5	0.300000	1.200000	0.000000	2026-09-16 22:14:43.03997+08
373	minimax/speech-02-hd	0.000000	0.000000	0.000000	2026-09-16 22:14:43.040301+08
374	minimax/speech-02-turbo	0.000000	0.000000	0.000000	2026-09-16 22:14:43.040613+08
375	minimax/speech-2.6-hd	0.000000	0.000000	0.000000	2026-09-16 22:14:43.040948+08
376	minimax/speech-2.6-turbo	0.000000	0.000000	0.000000	2026-09-16 22:14:43.041272+08
377	minimax/MiniMax-M2.1	0.300000	1.200000	0.030000	2026-09-16 22:14:43.041596+08
378	minimax/MiniMax-M2.1-lightning	0.300000	2.400000	0.030000	2026-09-16 22:14:43.042098+08
379	minimax/MiniMax-M2.5	0.300000	1.200000	0.030000	2026-09-16 22:14:43.042396+08
380	minimax/MiniMax-M2.5-lightning	0.300000	2.400000	0.030000	2026-09-16 22:14:43.042705+08
381	minimax/MiniMax-M2	0.300000	1.200000	0.030000	2026-09-16 22:14:43.043016+08
382	minimax/MiniMax-M3	0.300000	1.200000	0.060000	2026-09-16 22:14:43.043315+08
383	mistral/zai-glm-5-2	1.400000	4.400000	0.140000	2026-09-16 22:14:43.043649+08
384	mistral/glm-5-2	1.400000	4.400000	0.140000	2026-09-16 22:14:43.043966+08
385	moonshot.kimi-k2-thinking	0.600000	2.500000	0.000000	2026-09-16 22:14:43.044296+08
386	moonshotai.kimi-k2.5	0.600000	3.000000	0.000000	2026-09-16 22:14:43.044593+08
387	moonshot/kimi-k2-0711-preview	0.600000	2.500000	0.150000	2026-09-16 22:14:43.044897+08
388	moonshot/kimi-k2-0905-preview	0.600000	2.500000	0.150000	2026-09-16 22:14:43.045194+08
389	moonshot/kimi-k2.7-code	0.950000	4.000000	0.190000	2026-09-16 22:14:43.045496+08
390	moonshot/kimi-k2-turbo-preview	1.150000	8.000000	0.150000	2026-09-16 22:14:43.045798+08
391	moonshot/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-16 22:14:43.0461+08
392	moonshot/kimi-k2.6	0.950000	4.000000	0.160000	2026-09-16 22:14:43.046393+08
393	moonshot/kimi-k3	3.000000	15.000000	0.300000	2026-09-16 22:14:43.046708+08
394	moonshot/kimi-latest	2.000000	5.000000	0.150000	2026-09-16 22:14:43.047025+08
395	moonshot/kimi-latest-128k	2.000000	5.000000	0.150000	2026-09-16 22:14:43.04731+08
396	moonshot/kimi-latest-32k	1.000000	3.000000	0.150000	2026-09-16 22:14:43.047597+08
397	moonshot/kimi-latest-8k	0.200000	2.000000	0.150000	2026-09-16 22:14:43.047885+08
398	moonshot/kimi-thinking-preview	0.600000	2.500000	0.150000	2026-09-16 22:14:43.04818+08
399	moonshot/kimi-k2-thinking	0.600000	2.500000	0.150000	2026-09-16 22:14:43.048478+08
400	moonshot/kimi-k2-thinking-turbo	1.150000	8.000000	0.150000	2026-09-16 22:14:43.048779+08
401	moonshot/moonshot-v1-128k	2.000000	5.000000	0.000000	2026-09-16 22:14:43.05022+08
402	moonshot/moonshot-v1-128k-0430	2.000000	5.000000	0.000000	2026-09-16 22:14:43.050719+08
403	moonshot/moonshot-v1-128k-vision-preview	2.000000	5.000000	0.000000	2026-09-16 22:14:43.051026+08
404	moonshot/moonshot-v1-32k	1.000000	3.000000	0.000000	2026-09-16 22:14:43.051346+08
405	moonshot/moonshot-v1-32k-0430	1.000000	3.000000	0.000000	2026-09-16 22:14:43.051674+08
406	moonshot/moonshot-v1-32k-vision-preview	1.000000	3.000000	0.000000	2026-09-16 22:14:43.051992+08
407	moonshot/moonshot-v1-8k	0.200000	2.000000	0.000000	2026-09-16 22:14:43.052325+08
408	moonshot/moonshot-v1-8k-0430	0.200000	2.000000	0.000000	2026-09-16 22:14:43.052708+08
409	moonshot/moonshot-v1-8k-vision-preview	0.200000	2.000000	0.000000	2026-09-16 22:14:43.0531+08
410	moonshot/moonshot-v1-auto	2.000000	5.000000	0.000000	2026-09-16 22:14:43.053436+08
411	nscale/Qwen/QwQ-32B	0.180000	0.200000	0.000000	2026-09-16 22:14:43.05376+08
412	nscale/Qwen/Qwen2.5-Coder-32B-Instruct	0.060000	0.200000	0.000000	2026-09-16 22:14:43.05409+08
413	nscale/Qwen/Qwen2.5-Coder-3B-Instruct	0.010000	0.030000	0.000000	2026-09-16 22:14:43.054414+08
414	nscale/Qwen/Qwen2.5-Coder-7B-Instruct	0.010000	0.030000	0.000000	2026-09-16 22:14:43.054752+08
415	nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	0.375000	0.375000	0.000000	2026-09-16 22:14:43.055089+08
416	nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-8B	0.025000	0.025000	0.000000	2026-09-16 22:14:43.055438+08
417	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B	0.090000	0.090000	0.000000	2026-09-16 22:14:43.055799+08
418	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B	0.070000	0.070000	0.000000	2026-09-16 22:14:43.056136+08
419	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B	0.150000	0.150000	0.000000	2026-09-16 22:14:43.056474+08
420	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B	0.200000	0.200000	0.000000	2026-09-16 22:14:43.056808+08
421	nebius/deepseek-ai/DeepSeek-R1	0.800000	2.400000	0.000000	2026-09-16 22:14:43.057144+08
422	nebius/deepseek-ai/DeepSeek-R1-0528	0.800000	2.400000	0.000000	2026-09-16 22:14:43.05746+08
423	nebius/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	0.250000	0.750000	0.000000	2026-09-16 22:14:43.057957+08
424	nebius/deepseek-ai/DeepSeek-V3	0.500000	1.500000	0.000000	2026-09-16 22:14:43.058289+08
425	nebius/deepseek-ai/DeepSeek-V3-0324	0.500000	1.500000	0.000000	2026-09-16 22:14:43.05861+08
426	nebius/Qwen/Qwen3-235B-A22B	0.200000	0.600000	0.000000	2026-09-16 22:14:43.058985+08
427	nebius/Qwen/Qwen3-32B	0.100000	0.300000	0.000000	2026-09-16 22:14:43.059298+08
428	nebius/Qwen/Qwen3-30B-A3B	0.100000	0.300000	0.000000	2026-09-16 22:14:43.059605+08
429	nebius/Qwen/Qwen3-14B	0.080000	0.240000	0.000000	2026-09-16 22:14:43.059914+08
430	nebius/Qwen/Qwen3-4B	0.080000	0.240000	0.000000	2026-09-16 22:14:43.060226+08
431	nebius/Qwen/QwQ-32B	0.150000	0.450000	0.000000	2026-09-16 22:14:43.060525+08
432	nebius/Qwen/Qwen2.5-72B-Instruct	0.130000	0.400000	0.000000	2026-09-16 22:14:43.06082+08
433	nebius/Qwen/Qwen2.5-32B-Instruct	0.060000	0.200000	0.000000	2026-09-16 22:14:43.061138+08
434	nebius/Qwen/Qwen2.5-Coder-7B	0.010000	0.030000	0.000000	2026-09-16 22:14:43.061446+08
435	nebius/Qwen/Qwen2.5-VL-72B-Instruct	0.250000	0.750000	0.000000	2026-09-16 22:14:43.061766+08
436	nebius/Qwen/Qwen2-VL-72B-Instruct	0.130000	0.400000	0.000000	2026-09-16 22:14:43.062117+08
437	nebius/Qwen/Qwen2-VL-7B-Instruct	0.020000	0.060000	0.000000	2026-09-16 22:14:43.062487+08
438	nebius/deepseek-ai/DeepSeek-V4-Flash	0.140000	0.280000	0.000000	2026-09-16 22:14:43.062817+08
439	nebius/deepseek-ai/DeepSeek-V4-Flash-0731	0.140000	0.280000	0.000000	2026-09-16 22:14:43.063146+08
440	nebius/deepseek-ai/DeepSeek-V4-Pro	1.750000	3.500000	0.000000	2026-09-16 22:14:43.063504+08
441	nebius/MiniMaxAI/MiniMax-M2.5	0.300000	1.200000	0.000000	2026-09-16 22:14:43.063861+08
442	nebius/MiniMaxAI/MiniMax-M3	0.300000	1.200000	0.000000	2026-09-16 22:14:43.064248+08
443	nebius/moonshotai/Kimi-K2.6	0.950000	4.000000	0.000000	2026-09-16 22:14:43.064574+08
444	nebius/moonshotai/Kimi-K2.7-Code	0.950000	4.000000	0.000000	2026-09-16 22:14:43.064907+08
445	nebius/moonshotai/Kimi-K3	3.000000	15.000000	0.000000	2026-09-16 22:14:43.065239+08
446	nebius/Qwen/Qwen3-235B-A22B-Instruct-2507	0.200000	0.600000	0.000000	2026-09-16 22:14:43.065914+08
447	nebius/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-09-16 22:14:43.066242+08
448	nebius/Qwen/Qwen3-Next-80B-A3B-Thinking	0.150000	1.200000	0.000000	2026-09-16 22:14:43.066611+08
449	nebius/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.000000	2026-09-16 22:14:43.066949+08
450	nebius/zai-org/GLM-5.1	1.400000	4.400000	0.000000	2026-09-16 22:14:43.06727+08
451	nebius/zai-org/GLM-5.2	1.400000	4.400000	0.000000	2026-09-16 22:14:43.06759+08
452	nebius/zai-org/GLM-5.3-Flash	0.150000	0.500000	0.000000	2026-09-16 22:14:43.067911+08
453	nebius/Qwen/Qwen3-Embedding-8B	0.010000	0.000000	0.000000	2026-09-16 22:14:43.068234+08
454	ollama/deepseek-coder-v2-base	0.000000	0.000000	0.000000	2026-09-16 22:14:43.068589+08
455	ollama/deepseek-coder-v2-instruct	0.000000	0.000000	0.000000	2026-09-16 22:14:43.068913+08
456	ollama/deepseek-coder-v2-lite-base	0.000000	0.000000	0.000000	2026-09-16 22:14:43.069244+08
457	ollama/deepseek-coder-v2-lite-instruct	0.000000	0.000000	0.000000	2026-09-16 22:14:43.069607+08
458	ollama/deepseek-v3.1:671b-cloud	0.000000	0.000000	0.000000	2026-09-16 22:14:43.070112+08
459	ollama/qwen3-coder:480b-cloud	0.000000	0.000000	0.000000	2026-09-16 22:14:43.070437+08
460	openrouter/deepseek/deepseek-chat	0.320000	0.890000	0.000000	2026-09-16 22:14:43.070807+08
461	openrouter/deepseek/deepseek-chat-v3-0324	0.250000	1.000000	0.000000	2026-09-16 22:14:43.071152+08
462	openrouter/deepseek/deepseek-chat-v3.1	0.250000	0.950000	0.130000	2026-09-16 22:14:43.07152+08
463	openrouter/deepseek/deepseek-v3.2	0.269000	0.400000	0.000000	2026-09-16 22:14:43.071857+08
464	openrouter/deepseek/deepseek-v3.2-exp	0.270000	0.410000	0.000000	2026-09-16 22:14:43.072151+08
465	openrouter/deepseek/deepseek-r1	0.700000	2.500000	0.000000	2026-09-16 22:14:43.072441+08
466	openrouter/deepseek/deepseek-r1-0528	0.500000	2.150000	0.000000	2026-09-16 22:14:43.072771+08
467	openrouter/deepseek/deepseek-v4-pro	0.859908	1.719816	0.071659	2026-09-16 22:14:43.073111+08
468	openrouter/deepseek/deepseek-v4.1-flash	0.150000	0.600000	0.003000	2026-09-16 22:14:43.073446+08
469	openrouter/deepseek/deepseek-v4-pro-0813	0.579480	1.738440	0.019316	2026-09-16 22:14:43.073783+08
470	openrouter/minimax/minimax-m2	0.255000	1.020000	0.000000	2026-09-16 22:14:43.074127+08
471	openrouter/moonshotai/kimi-k2.5	0.450000	2.250000	0.070000	2026-09-16 22:14:43.074464+08
472	openrouter/qwen/qwen-2.5-coder-32b-instruct	0.660000	1.000000	0.000000	2026-09-16 22:14:43.074825+08
473	openrouter/qwen/qwen-vl-plus	0.210000	0.630000	0.000000	2026-09-16 22:14:43.075124+08
474	openrouter/qwen/qwen3-coder	0.300000	1.000000	0.000000	2026-09-16 22:14:43.075436+08
475	openrouter/qwen/qwen3-coder-plus	0.650000	3.250000	0.000000	2026-09-16 22:14:43.075741+08
476	openrouter/qwen/qwen3-235b-a22b-2507	0.220000	0.880000	0.000000	2026-09-16 22:14:43.076045+08
477	openrouter/qwen/qwen3-235b-a22b-thinking-2507	0.230000	2.300000	0.000000	2026-09-16 22:14:43.076347+08
478	openrouter/qwen/qwen3.6-plus	0.325000	1.950000	0.000000	2026-09-16 22:14:43.076645+08
479	openrouter/qwen/qwen3.5-35b-a3b	0.312500	1.250000	0.156250	2026-09-16 22:14:43.076952+08
480	openrouter/qwen/qwen3.5-27b	0.195000	1.560000	0.000000	2026-09-16 22:14:43.07741+08
481	openrouter/qwen/qwen3.5-122b-a10b	0.260000	2.080000	0.000000	2026-09-16 22:14:43.077723+08
482	openrouter/qwen/qwen3.5-flash-02-23	0.065000	0.260000	0.000000	2026-09-16 22:14:43.07803+08
483	openrouter/qwen/qwen3.5-plus-02-15	0.260000	1.560000	0.000000	2026-09-16 22:14:43.078347+08
484	openrouter/qwen/qwen3.5-397b-a17b	0.550000	3.500000	0.000000	2026-09-16 22:14:43.078672+08
485	openrouter/z-ai/glm-4.6	0.430000	1.750000	0.080000	2026-09-16 22:14:43.079008+08
486	openrouter/z-ai/glm-4.6:exacto	0.450000	1.900000	0.000000	2026-09-16 22:14:43.079392+08
487	openrouter/z-ai/glm-4.7	0.400000	1.750000	0.080000	2026-09-16 22:14:43.079741+08
488	openrouter/z-ai/glm-4.7-flash	0.060000	0.400000	0.010000	2026-09-16 22:14:43.080078+08
489	openrouter/z-ai/glm-5	0.600000	1.920000	0.000000	2026-09-16 22:14:43.080474+08
490	openrouter/z-ai/glm-5.1	0.966000	3.036000	0.179400	2026-09-16 22:14:43.080805+08
491	openrouter/minimax/minimax-m2.1	0.300000	1.200000	0.030000	2026-09-16 22:14:43.081394+08
492	openrouter/minimax/minimax-m2.5	0.270000	1.080000	0.027000	2026-09-16 22:14:43.081742+08
493	ovhcloud/DeepSeek-R1-Distill-Llama-70B	0.670000	0.670000	0.000000	2026-09-16 22:14:43.082079+08
494	ovhcloud/Qwen2.5-Coder-32B-Instruct	0.870000	0.870000	0.000000	2026-09-16 22:14:43.082421+08
495	ovhcloud/Qwen2.5-VL-72B-Instruct	0.910000	0.910000	0.000000	2026-09-16 22:14:43.083279+08
496	ovhcloud/Qwen3-32B	0.080000	0.230000	0.000000	2026-09-16 22:14:43.083631+08
497	perplexity/perplexity/deepseek-v4-flash-0731	0.130000	0.260000	0.028000	2026-09-16 22:14:43.084164+08
498	perplexity/perplexity/glm-5.2	1.400000	4.400000	0.140000	2026-09-16 22:14:43.084473+08
499	perplexity/perplexity/kimi-k3	3.000000	15.000000	0.300000	2026-09-16 22:14:43.084913+08
500	perplexity/perplexity/kimi-k2.7-code	0.950000	4.000000	0.190000	2026-09-16 22:14:43.086956+08
501	publicai/aisingapore/Qwen-SEA-LION-v4-32B-IT	0.000000	0.000000	0.000000	2026-09-16 22:14:43.087381+08
502	qwen.qwen3-coder-480b-a35b-v1:0	0.450000	1.800000	0.000000	2026-09-16 22:14:43.087697+08
503	qwen.qwen3-235b-a22b-2507-v1:0	0.220000	0.880000	0.000000	2026-09-16 22:14:43.088305+08
504	qwen.qwen3-coder-30b-a3b-v1:0	0.150000	0.600000	0.000000	2026-09-16 22:14:43.088738+08
505	qwen.qwen3-32b-v1:0	0.150000	0.600000	0.000000	2026-09-16 22:14:43.089148+08
506	qwen.qwen3-next-80b-a3b	0.150000	1.200000	0.000000	2026-09-16 22:14:43.089585+08
507	qwen.qwen3-vl-235b-a22b	0.530000	2.660000	0.000000	2026-09-16 22:14:43.089913+08
508	qwen.qwen3-coder-next	0.500000	1.200000	0.000000	2026-09-16 22:14:43.090221+08
509	replicate/qwen/qwen3-235b-a22b-instruct-2507	0.264000	1.060000	0.000000	2026-09-16 22:14:43.090648+08
510	replicate/deepseek-ai/deepseek-v3	1.450000	1.450000	0.000000	2026-09-16 22:14:43.090948+08
511	replicate/deepseek-ai/deepseek-v3.1	0.672000	2.016000	0.000000	2026-09-16 22:14:43.091276+08
512	replicate/deepseek-ai/deepseek-r1	3.750000	10.000000	0.000000	2026-09-16 22:14:43.091653+08
513	sambanova/MiniMax-M2.7	0.600000	2.400000	0.000000	2026-09-16 22:14:43.092392+08
514	sambanova/DeepSeek-R1	5.000000	7.000000	0.000000	2026-09-16 22:14:43.092698+08
515	sambanova/DeepSeek-R1-Distill-Llama-70B	0.700000	1.400000	0.000000	2026-09-16 22:14:43.092987+08
516	sambanova/DeepSeek-V3-0324	3.000000	4.500000	0.000000	2026-09-16 22:14:43.093267+08
517	sambanova/Qwen2-Audio-7B-Instruct	0.500000	100.000000	0.000000	2026-09-16 22:14:43.093558+08
518	sambanova/Qwen3-32B	0.400000	0.800000	0.000000	2026-09-16 22:14:43.093849+08
519	sambanova/DeepSeek-V3.1	3.000000	4.500000	0.000000	2026-09-16 22:14:43.094218+08
520	sambanova/DeepSeek-V3.2	3.000000	4.500000	0.000000	2026-09-16 22:14:43.094562+08
521	scx-ai/GLM-5.2	0.610000	1.980000	0.220000	2026-09-16 22:14:43.09489+08
522	scx-ai/Qwen3.8-Max	1.650000	4.990000	0.210000	2026-09-16 22:14:43.095191+08
523	snowflake/deepseek-r1	1.350000	5.400000	0.000000	2026-09-16 22:14:43.095482+08
524	together_ai/Qwen/Qwen2.5-72B-Instruct-Turbo	1.200000	1.200000	0.000000	2026-09-16 22:14:43.095887+08
525	together_ai/Qwen/Qwen2.5-7B-Instruct-Turbo	0.300000	0.300000	0.000000	2026-09-16 22:14:43.096198+08
526	together_ai/Qwen/Qwen3-235B-A22B-Instruct-2507-tput	0.200000	6.000000	0.000000	2026-09-16 22:14:43.096498+08
527	together_ai/Qwen/Qwen3-235B-A22B-Thinking-2507	0.650000	3.000000	0.000000	2026-09-16 22:14:43.097642+08
528	together_ai/Qwen/Qwen3-235B-A22B-fp8-tput	0.200000	0.600000	0.000000	2026-09-16 22:14:43.097935+08
529	together_ai/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	2.000000	2.000000	0.000000	2026-09-16 22:14:43.098249+08
530	together_ai/deepseek-ai/DeepSeek-R1	3.000000	7.000000	0.000000	2026-09-16 22:14:43.098538+08
531	together_ai/deepseek-ai/DeepSeek-R1-0528-tput	0.550000	2.190000	0.000000	2026-09-16 22:14:43.098835+08
532	together_ai/deepseek-ai/DeepSeek-V3	1.250000	1.250000	0.000000	2026-09-16 22:14:43.099123+08
533	together_ai/deepseek-ai/DeepSeek-V3.1	0.600000	1.700000	0.000000	2026-09-16 22:14:43.099414+08
534	together_ai/moonshotai/Kimi-K2-Instruct	1.000000	3.000000	0.000000	2026-09-16 22:14:43.099734+08
535	together_ai/zai-org/GLM-4.5-Air-FP8	0.200000	1.100000	0.000000	2026-09-16 22:14:43.100044+08
536	together_ai/zai-org/GLM-4.6	0.600000	2.200000	0.000000	2026-09-16 22:14:43.100337+08
537	together_ai/zai-org/GLM-4.7	0.450000	2.000000	0.000000	2026-09-16 22:14:43.100629+08
538	together_ai/moonshotai/Kimi-K2.5	0.500000	2.800000	0.000000	2026-09-16 22:14:43.100927+08
539	together_ai/moonshotai/Kimi-K2-Instruct-0905	1.000000	3.000000	0.000000	2026-09-16 22:14:43.101223+08
540	together_ai/Qwen/Qwen3-Next-80B-A3B-Instruct	0.150000	1.500000	0.000000	2026-09-16 22:14:43.101528+08
541	together_ai/Qwen/Qwen3-Next-80B-A3B-Thinking	0.150000	1.500000	0.000000	2026-09-16 22:14:43.101825+08
542	together_ai/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.350000	2026-09-16 22:14:43.102126+08
543	together_ai/MiniMaxAI/MiniMax-M3	0.300000	1.200000	0.060000	2026-09-16 22:14:43.102429+08
544	together_ai/Qwen/Qwen3.5-9B	0.170000	0.250000	0.000000	2026-09-16 22:14:43.102747+08
545	together_ai/Qwen/Qwen3.6-Plus	0.500000	3.000000	0.000000	2026-09-16 22:14:43.103057+08
546	together_ai/Qwen/Qwen3.7-Max	2.500000	7.500000	0.500000	2026-09-16 22:14:43.103387+08
547	together_ai/Qwen/Qwen3.7-Plus	0.320000	1.280000	0.000000	2026-09-16 22:14:43.1037+08
548	together_ai/Qwen/Qwen3.8-2.4T-A95B	2.000000	6.000000	0.250000	2026-09-16 22:14:43.103997+08
549	together_ai/arize-ai/qwen-2-1.5b-instruct	0.100000	0.100000	0.000000	2026-09-16 22:14:43.104458+08
550	together_ai/deepseek-ai/DeepSeek-V4-Flash-0731	0.140000	0.280000	0.030000	2026-09-16 22:14:43.10476+08
551	together_ai/deepseek-ai/DeepSeek-V4-Pro	1.740000	3.480000	0.200000	2026-09-16 22:14:43.105077+08
552	together_ai/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.130000	2026-09-16 22:14:43.105386+08
553	together_ai/moonshotai/Kimi-K2.7-Code	0.950000	4.000000	0.190000	2026-09-16 22:14:43.105688+08
554	together_ai/moonshotai/Kimi-K3	3.000000	15.000000	0.300000	2026-09-16 22:14:43.105987+08
555	together_ai/zai-org/GLM-5.2	1.400000	4.400000	0.260000	2026-09-16 22:14:43.106305+08
556	together_ai/zai-org/GLM-5.3	1.400000	4.400000	0.260000	2026-09-16 22:14:43.106609+08
557	together_ai/zai-org/GLM-5.3-Flash	0.150000	0.500000	0.030000	2026-09-16 22:14:43.106921+08
558	us.deepseek.r1-v1:0	1.350000	5.400000	0.000000	2026-09-16 22:14:43.10727+08
559	us.deepseek.v3.2	0.620000	1.850000	0.000000	2026-09-16 22:14:43.107575+08
560	eu.deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:14:43.10789+08
561	vercel_ai_gateway/alibaba/qwen-3-14b	0.080000	0.240000	0.000000	2026-09-16 22:14:43.10821+08
562	vercel_ai_gateway/alibaba/qwen-3-235b	0.200000	0.600000	0.000000	2026-09-16 22:14:43.108508+08
563	vercel_ai_gateway/alibaba/qwen-3-30b	0.100000	0.300000	0.000000	2026-09-16 22:14:43.108813+08
564	vercel_ai_gateway/alibaba/qwen-3-32b	0.100000	0.300000	0.000000	2026-09-16 22:14:43.109163+08
565	vercel_ai_gateway/alibaba/qwen3-coder	0.400000	1.600000	0.000000	2026-09-16 22:14:43.109576+08
566	vercel_ai_gateway/deepseek/deepseek-r1	0.550000	2.190000	0.000000	2026-09-16 22:14:43.109914+08
567	vercel_ai_gateway/deepseek/deepseek-r1-distill-llama-70b	0.750000	0.990000	0.000000	2026-09-16 22:14:43.110218+08
568	vercel_ai_gateway/deepseek/deepseek-v3	0.900000	0.900000	0.000000	2026-09-16 22:14:43.110528+08
569	vercel_ai_gateway/moonshotai/kimi-k2	0.550000	2.200000	0.000000	2026-09-16 22:14:43.11087+08
570	vercel_ai_gateway/zai/glm-4.5	0.600000	2.200000	0.000000	2026-09-16 22:14:43.111221+08
571	vercel_ai_gateway/zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-09-16 22:14:43.111722+08
572	vercel_ai_gateway/zai/glm-4.6	0.450000	1.800000	0.110000	2026-09-16 22:14:43.11206+08
573	vertex_ai/deepseek-ai/deepseek-v3.1-maas	0.600000	1.700000	0.000000	2026-09-16 22:14:43.112427+08
574	vertex_ai/deepseek-ai/deepseek-v3.2-maas	0.560000	1.680000	0.000000	2026-09-16 22:14:43.112744+08
575	vertex_ai/deepseek-ai/deepseek-r1-0528-maas	1.350000	5.400000	0.000000	2026-09-16 22:14:43.113071+08
576	vertex_ai/minimaxai/minimax-m2-maas	0.300000	1.200000	0.000000	2026-09-16 22:14:43.113402+08
577	vertex_ai/moonshotai/kimi-k2-thinking-maas	0.600000	2.500000	0.000000	2026-09-16 22:14:43.113716+08
578	vertex_ai/zai-org/glm-4.7-maas	0.600000	2.200000	0.000000	2026-09-16 22:14:43.11403+08
579	vertex_ai/zai-org/glm-5-maas	1.000000	3.200000	0.100000	2026-09-16 22:14:43.114336+08
580	vertex_ai/deepseek-ai/deepseek-ocr-maas	0.300000	1.200000	0.000000	2026-09-16 22:14:43.114644+08
581	vertex_ai/qwen/qwen3-235b-a22b-instruct-2507-maas	0.220000	0.880000	0.000000	2026-09-16 22:14:43.114957+08
582	vertex_ai/qwen/qwen3-coder-480b-a35b-instruct-maas	0.220000	1.800000	0.000000	2026-09-16 22:14:43.115264+08
583	vertex_ai/qwen/qwen3-next-80b-a3b-instruct-maas	0.150000	1.200000	0.000000	2026-09-16 22:14:43.115567+08
584	vertex_ai/qwen/qwen3-next-80b-a3b-thinking-maas	0.150000	1.200000	0.000000	2026-09-16 22:14:43.11589+08
586	azure_ai/FW-DeepSeek-V4-Pro	1.925000	3.828000	0.165000	2026-09-16 22:22:53.135827+08
587	azure_ai/FW-GLM-5.2-Fast	2.100000	6.600000	0.210000	2026-09-16 22:22:53.139045+08
588	azure_ai/FW-Kimi-K2.5	0.660000	3.300000	0.110000	2026-09-16 22:22:53.140454+08
589	azure_ai/FW-Kimi-K2.7-Code	1.050000	4.400000	0.210000	2026-09-16 22:22:53.141506+08
590	azure_ai/FW-Kimi-K3	3.300000	16.500000	0.330000	2026-09-16 22:22:53.142231+08
591	azure_ai/FW-MiniMax-M2.5	0.330000	1.320000	0.033000	2026-09-16 22:22:53.14283+08
592	azure_ai/FW-MiniMax-M3	0.330000	1.320000	0.066000	2026-09-16 22:22:53.143383+08
593	azure_ai/deepseek-v3	1.140000	4.560000	0.000000	2026-09-16 22:22:53.144768+08
594	azure_ai/deepseek-v3-0324	1.140000	4.560000	0.000000	2026-09-16 22:22:53.14531+08
595	azure_ai/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-16 22:22:53.146822+08
596	bedrock/ap-northeast-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:22:53.147568+08
597	bedrock/ap-northeast-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:22:53.148734+08
598	bedrock/ap-south-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:22:53.149913+08
599	bedrock/ap-south-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:22:53.151041+08
600	bedrock/ap-southeast-3/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:22:53.151964+08
601	bedrock/ap-southeast-3/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:22:53.153154+08
602	bedrock/eu-north-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:22:53.15417+08
603	bedrock/eu-north-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:22:53.155565+08
604	bedrock/eu-west-2/minimax.minimax-m2.1	0.470000	1.860000	0.000000	2026-09-16 22:22:53.157257+08
605	bedrock/eu-west-2/minimax.minimax-m2.5	0.470000	1.860000	0.000000	2026-09-16 22:22:53.157713+08
606	bedrock/eu-west-2/qwen.qwen3-coder-next	0.780000	1.860000	0.000000	2026-09-16 22:22:53.158156+08
607	bedrock/sa-east-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:22:53.158835+08
608	bedrock/sa-east-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-16 22:22:53.159513+08
609	cerebras/qwen-3-32b	0.400000	0.800000	0.000000	2026-09-16 22:22:53.162185+08
610	cerebras/qwen-3.8-27b	0.990000	1.490000	0.000000	2026-09-16 22:22:53.16266+08
611	cloudflare/@cf/deepseek-ai/deepseek-r1-distill-qwen-32b	0.497000	4.881000	0.000000	2026-09-16 22:22:53.163069+08
612	cloudflare/@cf/zai-org/glm-4.7-flash	0.060500	0.400000	0.000000	2026-09-16 22:22:53.163465+08
613	dashscope/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-16 22:22:53.164562+08
614	dashscope/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-16 22:22:53.164817+08
615	dashscope/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-16 22:22:53.165073+08
616	dashscope/qwen-max	1.600000	6.400000	0.000000	2026-09-16 22:22:53.166035+08
617	dashscope/qwen-plus	0.400000	1.200000	0.000000	2026-09-16 22:22:53.166279+08
618	dashscope/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-16 22:22:53.166526+08
619	dashscope/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-16 22:22:53.166803+08
620	dashscope/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-16 22:22:53.167103+08
621	dashscope/qwen-turbo	0.050000	0.200000	0.000000	2026-09-16 22:22:53.167706+08
622	dashscope/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-16 22:22:53.168132+08
623	dashscope/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-16 22:22:53.168379+08
624	dashscope/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-16 22:22:53.168613+08
625	dashscope/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-16 22:22:53.170051+08
626	dashscope/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-16 22:22:53.170301+08
627	qwencloud/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-16 22:22:53.171884+08
628	qwencloud/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-16 22:22:53.172289+08
629	qwencloud/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-16 22:22:53.172527+08
630	qwencloud/qwen-max	1.600000	6.400000	0.000000	2026-09-16 22:22:53.173457+08
631	qwencloud/qwen-plus	0.400000	1.200000	0.000000	2026-09-16 22:22:53.17369+08
632	qwencloud/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-16 22:22:53.173932+08
633	qwencloud/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-16 22:22:53.174194+08
634	qwencloud/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-16 22:22:53.174467+08
635	qwencloud/qwen-turbo	0.050000	0.200000	0.000000	2026-09-16 22:22:53.175058+08
636	qwencloud/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-16 22:22:53.175305+08
637	qwencloud/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-16 22:22:53.175549+08
638	qwencloud/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-16 22:22:53.175796+08
639	qwencloud/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-16 22:22:53.177235+08
640	qwencloud/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-16 22:22:53.177481+08
641	qwencloud/qwq-plus	0.800000	2.400000	0.000000	2026-09-16 22:22:53.178535+08
642	qwen_ai_platform/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-16 22:22:53.179244+08
643	qwen_ai_platform/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-16 22:22:53.179486+08
644	qwen_ai_platform/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-16 22:22:53.179725+08
645	qwen_ai_platform/qwen-max	1.600000	6.400000	0.000000	2026-09-16 22:22:53.180724+08
646	qwen_ai_platform/qwen-plus	0.400000	1.200000	0.000000	2026-09-16 22:22:53.180972+08
647	qwen_ai_platform/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-16 22:22:53.181268+08
648	qwen_ai_platform/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-16 22:22:53.181508+08
649	qwen_ai_platform/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-16 22:22:53.181991+08
650	qwen_ai_platform/qwen-turbo	0.050000	0.200000	0.000000	2026-09-16 22:22:53.182592+08
651	qwen_ai_platform/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-16 22:22:53.182853+08
652	qwen_ai_platform/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-16 22:22:53.183112+08
653	qwen_ai_platform/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-16 22:22:53.183379+08
654	qwen_ai_platform/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-16 22:22:53.184796+08
655	qwen_ai_platform/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-16 22:22:53.185044+08
656	qwen_ai_platform/qwq-plus	0.800000	2.400000	0.000000	2026-09-16 22:22:53.186122+08
657	databricks/databricks-deepseek-v4-pro-0813	1.319990	3.959970	0.132020	2026-09-16 22:22:53.18708+08
658	databricks/databricks-glm-5-2	1.400000	4.399990	0.259980	2026-09-16 22:22:53.18735+08
659	databricks/databricks-glm-5-3	1.400000	4.399990	0.259980	2026-09-16 22:22:53.187589+08
660	databricks/databricks-glm-5-3-flash	0.150010	0.500010	0.030030	2026-09-16 22:22:53.187821+08
661	databricks/databricks-qwen35-122b-a10b	0.220010	2.200030	0.220010	2026-09-16 22:22:53.188266+08
662	deepinfra/Qwen/QwQ-32B	0.150000	0.400000	0.000000	2026-09-16 22:22:53.188765+08
663	deepinfra/Qwen/Qwen2.5-72B-Instruct	0.360000	0.400000	0.000000	2026-09-16 22:22:53.188994+08
664	deepinfra/Qwen/Qwen2.5-7B-Instruct	0.040000	0.100000	0.000000	2026-09-16 22:22:53.189422+08
665	deepinfra/Qwen/Qwen2.5-VL-32B-Instruct	0.200000	0.600000	0.000000	2026-09-16 22:22:53.189699+08
666	deepinfra/Qwen/Qwen3-235B-A22B-Thinking-2507	0.300000	2.900000	0.000000	2026-09-16 22:22:53.190326+08
667	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct	0.400000	1.600000	0.000000	2026-09-16 22:22:53.190851+08
668	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct-Turbo	0.300000	1.000000	0.100000	2026-09-16 22:22:53.191124+08
669	deepinfra/deepseek-ai/DeepSeek-R1-0528	0.500000	2.150000	0.400000	2026-09-16 22:22:53.191757+08
670	deepinfra/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	0.200000	0.600000	0.000000	2026-09-16 22:22:53.192147+08
671	deepinfra/deepseek-ai/DeepSeek-V3	0.320000	0.890000	0.000000	2026-09-16 22:22:53.192651+08
672	deepinfra/deepseek-ai/DeepSeek-V3-0324	0.240000	0.900000	0.135000	2026-09-16 22:22:53.192924+08
673	deepinfra/moonshotai/Kimi-K2-Instruct-0905	0.500000	2.000000	0.400000	2026-09-16 22:22:53.193587+08
674	deepinfra/zai-org/GLM-4.5	0.400000	1.600000	0.000000	2026-09-16 22:22:53.193857+08
675	deepseek/deepseek-r1	0.550000	2.190000	0.000000	2026-09-16 22:22:53.194352+08
676	deepseek/deepseek-v3.2	0.280000	0.400000	0.000000	2026-09-16 22:22:53.194838+08
677	fireworks_ai/accounts/fireworks/models/deepseek-r1-basic	0.550000	2.190000	0.000000	2026-09-16 22:22:53.196106+08
678	fireworks_ai/accounts/fireworks/models/deepseek-v3	0.900000	0.900000	0.000000	2026-09-16 22:22:53.196377+08
679	fireworks_ai/accounts/fireworks/models/deepseek-v3-0324	0.900000	0.900000	0.000000	2026-09-16 22:22:53.196684+08
680	fireworks_ai/accounts/fireworks/models/deepseek-v4-pro-0813	1.320000	3.960000	0.044000	2026-09-16 22:22:53.197625+08
681	fireworks_ai/accounts/fireworks/models/glm-4p5	0.550000	2.190000	0.000000	2026-09-16 22:22:53.198099+08
682	fireworks_ai/accounts/fireworks/models/glm-4p6	0.550000	2.190000	0.000000	2026-09-16 22:22:53.198474+08
683	fireworks_ai/accounts/fireworks/models/kimi-k2p5	0.600000	3.000000	0.100000	2026-09-16 22:22:53.199506+08
684	fireworks_ai/accounts/fireworks/models/qwen2-72b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.200387+08
685	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.200663+08
686	fireworks_ai/kimi-k2p5	0.600000	3.000000	0.100000	2026-09-16 22:22:53.201649+08
687	fireworks_ai/qwen3p7-plus	0.400000	1.600000	0.080000	2026-09-16 22:22:53.202749+08
688	friendliai/zai-org/GLM-5.3	1.260000	3.960000	0.234000	2026-09-16 22:22:53.20312+08
689	gmi/deepseek-ai/DeepSeek-V3.2	0.280000	0.400000	0.000000	2026-09-16 22:22:53.203998+08
690	gmi/moonshotai/Kimi-K2-Thinking	0.800000	1.200000	0.000000	2026-09-16 22:22:53.204376+08
691	gmi/zai-org/GLM-4.7-FP8	0.400000	2.000000	0.000000	2026-09-16 22:22:53.205923+08
692	gradient_ai/deepseek-r1-distill-llama-70b	0.990000	0.990000	0.000000	2026-09-16 22:22:53.206372+08
693	hyperbolic/Qwen/QwQ-32B	0.200000	0.200000	0.000000	2026-09-16 22:22:53.2072+08
694	hyperbolic/deepseek-ai/DeepSeek-R1	0.400000	0.400000	0.000000	2026-09-16 22:22:53.207958+08
695	hyperbolic/deepseek-ai/DeepSeek-V3	0.200000	0.200000	0.000000	2026-09-16 22:22:53.208355+08
696	hyperbolic/deepseek-ai/DeepSeek-V3-0324	0.400000	0.400000	0.000000	2026-09-16 22:22:53.208626+08
697	lambda_ai/deepseek-llama3.3-70b	0.200000	0.600000	0.000000	2026-09-16 22:22:53.209494+08
698	lambda_ai/deepseek-r1-0528	0.200000	0.600000	0.000000	2026-09-16 22:22:53.209768+08
699	lambda_ai/deepseek-r1-671b	0.800000	0.800000	0.000000	2026-09-16 22:22:53.210034+08
700	lambda_ai/deepseek-v3-0324	0.200000	0.600000	0.000000	2026-09-16 22:22:53.210312+08
701	lambda_ai/qwen25-coder-32b-instruct	0.050000	0.100000	0.000000	2026-09-16 22:22:53.21059+08
702	lambda_ai/qwen3-32b-fp8	0.050000	0.100000	0.000000	2026-09-16 22:22:53.210853+08
703	moonshot/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-16 22:22:53.213731+08
704	moonshot/kimi-latest-8k	0.200000	2.000000	0.150000	2026-09-16 22:22:53.21458+08
705	moonshot/moonshot-v1-8k	0.200000	2.000000	0.000000	2026-09-16 22:22:53.216055+08
706	moonshot/moonshot-v1-8k-0430	0.200000	2.000000	0.000000	2026-09-16 22:22:53.216329+08
707	moonshot/moonshot-v1-8k-vision-preview	0.200000	2.000000	0.000000	2026-09-16 22:22:53.216597+08
708	nscale/Qwen/QwQ-32B	0.180000	0.200000	0.000000	2026-09-16 22:22:53.216994+08
709	nscale/Qwen/Qwen2.5-Coder-32B-Instruct	0.060000	0.200000	0.000000	2026-09-16 22:22:53.217251+08
710	nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-8B	0.025000	0.025000	0.000000	2026-09-16 22:22:53.217857+08
711	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B	0.200000	0.200000	0.000000	2026-09-16 22:22:53.218488+08
712	nebius/deepseek-ai/DeepSeek-R1	0.800000	2.400000	0.000000	2026-09-16 22:22:53.218777+08
713	nebius/deepseek-ai/DeepSeek-R1-0528	0.800000	2.400000	0.000000	2026-09-16 22:22:53.219017+08
714	nebius/Qwen/Qwen3-235B-A22B	0.200000	0.600000	0.000000	2026-09-16 22:22:53.219623+08
715	nebius/Qwen/Qwen3-32B	0.100000	0.300000	0.000000	2026-09-16 22:22:53.219881+08
716	nebius/Qwen/Qwen3-30B-A3B	0.100000	0.300000	0.000000	2026-09-16 22:22:53.220132+08
717	nebius/Qwen/QwQ-32B	0.150000	0.450000	0.000000	2026-09-16 22:22:53.220599+08
718	nebius/Qwen/Qwen2.5-72B-Instruct	0.130000	0.400000	0.000000	2026-09-16 22:22:53.220847+08
719	nebius/Qwen/Qwen2.5-32B-Instruct	0.060000	0.200000	0.000000	2026-09-16 22:22:53.221087+08
720	nebius/Qwen/Qwen2-VL-72B-Instruct	0.130000	0.400000	0.000000	2026-09-16 22:22:53.221564+08
721	nebius/Qwen/Qwen3-235B-A22B-Instruct-2507	0.200000	0.600000	0.000000	2026-09-16 22:22:53.222839+08
722	nebius/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-09-16 22:22:53.223078+08
723	nebius/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.000000	2026-09-16 22:22:53.223452+08
724	openrouter/deepseek/deepseek-chat	0.320000	0.890000	0.000000	2026-09-16 22:22:53.224917+08
725	openrouter/deepseek/deepseek-v3.2	0.269000	0.400000	0.000000	2026-09-16 22:22:53.225427+08
726	openrouter/deepseek/deepseek-r1-0528	0.500000	2.150000	0.000000	2026-09-16 22:22:53.226124+08
727	openrouter/moonshotai/kimi-k2.5	0.450000	2.250000	0.070000	2026-09-16 22:22:53.226884+08
728	openrouter/qwen/qwen3-235b-a22b-thinking-2507	0.230000	2.300000	0.000000	2026-09-16 22:22:53.227759+08
729	openrouter/z-ai/glm-4.6:exacto	0.450000	1.900000	0.000000	2026-09-16 22:22:53.228942+08
730	openrouter/z-ai/glm-4.7	0.400000	1.750000	0.080000	2026-09-16 22:22:53.229207+08
731	openrouter/z-ai/glm-4.7-flash	0.060000	0.400000	0.010000	2026-09-16 22:22:53.229474+08
732	ovhcloud/Qwen2.5-VL-72B-Instruct	0.910000	0.910000	0.000000	2026-09-16 22:22:53.230473+08
733	ovhcloud/Qwen3-32B	0.080000	0.230000	0.000000	2026-09-16 22:22:53.23074+08
734	qwen.qwen3-coder-480b-a35b-v1:0	0.450000	1.800000	0.000000	2026-09-16 22:22:53.231634+08
735	replicate/qwen/qwen3-235b-a22b-instruct-2507	0.264000	1.060000	0.000000	2026-09-16 22:22:53.232603+08
736	replicate/deepseek-ai/deepseek-v3	1.450000	1.450000	0.000000	2026-09-16 22:22:53.23286+08
737	replicate/deepseek-ai/deepseek-v3.1	0.672000	2.016000	0.000000	2026-09-16 22:22:53.233133+08
738	sambanova/Qwen3-32B	0.400000	0.800000	0.000000	2026-09-16 22:22:53.23409+08
739	scx-ai/GLM-5.2	0.610000	1.980000	0.220000	2026-09-16 22:22:53.234562+08
740	scx-ai/Qwen3.8-Max	1.650000	4.990000	0.210000	2026-09-16 22:22:53.234821+08
741	together_ai/Qwen/Qwen3-235B-A22B-Instruct-2507-tput	0.200000	6.000000	0.000000	2026-09-16 22:22:53.235508+08
742	together_ai/Qwen/Qwen3-235B-A22B-fp8-tput	0.200000	0.600000	0.000000	2026-09-16 22:22:53.235898+08
743	together_ai/deepseek-ai/DeepSeek-R1-0528-tput	0.550000	2.190000	0.000000	2026-09-16 22:22:53.236437+08
744	together_ai/zai-org/GLM-4.5-Air-FP8	0.200000	1.100000	0.000000	2026-09-16 22:22:53.237048+08
745	together_ai/zai-org/GLM-4.7	0.450000	2.000000	0.000000	2026-09-16 22:22:53.237435+08
746	together_ai/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.350000	2026-09-16 22:22:53.238134+08
747	together_ai/Qwen/Qwen3.5-9B	0.170000	0.250000	0.000000	2026-09-16 22:22:53.238822+08
748	together_ai/arize-ai/qwen-2-1.5b-instruct	0.100000	0.100000	0.000000	2026-09-16 22:22:53.239538+08
749	together_ai/deepseek-ai/DeepSeek-V4-Pro	1.740000	3.480000	0.200000	2026-09-16 22:22:53.239902+08
750	together_ai/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.130000	2026-09-16 22:22:53.240149+08
751	eu.deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-16 22:22:53.241228+08
752	vercel_ai_gateway/alibaba/qwen-3-235b	0.200000	0.600000	0.000000	2026-09-16 22:22:53.241612+08
753	vercel_ai_gateway/alibaba/qwen-3-30b	0.100000	0.300000	0.000000	2026-09-16 22:22:53.241871+08
754	vercel_ai_gateway/alibaba/qwen-3-32b	0.100000	0.300000	0.000000	2026-09-16 22:22:53.242146+08
755	vercel_ai_gateway/alibaba/qwen3-coder	0.400000	1.600000	0.000000	2026-09-16 22:22:53.242418+08
756	vercel_ai_gateway/deepseek/deepseek-r1	0.550000	2.190000	0.000000	2026-09-16 22:22:53.242705+08
757	vercel_ai_gateway/deepseek/deepseek-r1-distill-llama-70b	0.750000	0.990000	0.000000	2026-09-16 22:22:53.242978+08
758	vercel_ai_gateway/deepseek/deepseek-v3	0.900000	0.900000	0.000000	2026-09-16 22:22:53.243247+08
759	vercel_ai_gateway/zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-09-16 22:22:53.243823+08
760	vercel_ai_gateway/zai/glm-4.6	0.450000	1.800000	0.110000	2026-09-16 22:22:53.244097+08
761	vertex_ai/zai-org/glm-5-maas	1.000000	3.200000	0.100000	2026-09-16 22:22:53.245116+08
762	vertex_ai/qwen/qwen3-coder-480b-a35b-instruct-maas	0.220000	1.800000	0.000000	2026-09-16 22:22:53.245621+08
763	wandb/zai-org/GLM-4.5	55000.000000	200000.000000	0.000000	2026-09-16 22:22:53.246109+08
764	wandb/Qwen/Qwen3-235B-A22B-Instruct-2507	0.100000	0.100000	0.000000	2026-09-16 22:22:53.24682+08
765	wandb/Qwen/Qwen3-Coder-480B-A35B-Instruct	1.000000	1.500000	0.000000	2026-09-16 22:22:53.247179+08
766	wandb/Qwen/Qwen3-235B-A22B-Thinking-2507	0.100000	0.100000	0.000000	2026-09-16 22:22:53.247518+08
767	wandb/moonshotai/Kimi-K2-Instruct	0.600000	2.500000	0.000000	2026-09-16 22:22:53.247866+08
768	wandb/moonshotai/Kimi-K2.5	0.600000	3.000000	0.100000	2026-09-16 22:22:53.248222+08
769	wandb/MiniMaxAI/MiniMax-M2.5	0.300000	1.200000	0.000000	2026-09-16 22:22:53.248575+08
770	wandb/deepseek-ai/DeepSeek-V3.1	0.550000	1.650000	0.000000	2026-09-16 22:22:53.249099+08
771	wandb/deepseek-ai/DeepSeek-R1-0528	1.350000	5.400000	0.000000	2026-09-16 22:22:53.249465+08
772	wandb/deepseek-ai/DeepSeek-V3-0324	1.140000	2.750000	0.000000	2026-09-16 22:22:53.249827+08
773	zai.glm-4.7	0.600000	2.200000	0.000000	2026-09-16 22:22:53.250231+08
774	zai.glm-5	1.000000	3.200000	0.000000	2026-09-16 22:22:53.250563+08
775	zai.glm-4.7-flash	0.070000	0.400000	0.000000	2026-09-16 22:22:53.250899+08
776	zai/glm-5	1.000000	3.200000	0.200000	2026-09-16 22:22:53.251269+08
777	zai/glm-5.3	1.400000	4.400000	0.260000	2026-09-16 22:22:53.251597+08
778	zai/glm-5.3-flash	0.150000	0.500000	0.030000	2026-09-16 22:22:53.251951+08
779	zai/glm-5.1	1.400000	4.400000	0.260000	2026-09-16 22:22:53.252298+08
780	zai/glm-5-code	1.200000	5.000000	0.300000	2026-09-16 22:22:53.25264+08
781	zai/glm-4.7	0.600000	2.200000	0.110000	2026-09-16 22:22:53.252973+08
782	zai/glm-4.7-flash	0.000000	0.000000	0.000000	2026-09-16 22:22:53.253272+08
783	zai/glm-4.6	0.600000	2.200000	0.110000	2026-09-16 22:22:53.253567+08
784	zai/glm-4.5	0.600000	2.200000	0.000000	2026-09-16 22:22:53.253898+08
785	zai/glm-4.5v	0.600000	1.800000	0.000000	2026-09-16 22:22:53.254188+08
786	zai/glm-4.5-x	2.200000	8.900000	0.000000	2026-09-16 22:22:53.25448+08
787	zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-09-16 22:22:53.254784+08
788	zai/glm-4.5-airx	1.100000	4.500000	0.000000	2026-09-16 22:22:53.255087+08
789	zai/glm-4-32b-0414-128k	0.100000	0.100000	0.000000	2026-09-16 22:22:53.2554+08
790	zai/glm-4.5-flash	0.000000	0.000000	0.000000	2026-09-16 22:22:53.255711+08
791	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-a35b-instruct	0.450000	1.800000	0.000000	2026-09-16 22:22:53.256233+08
792	fireworks_ai/accounts/fireworks/models/code-qwen-1p5-7b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.256619+08
793	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-14b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.257003+08
794	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-32b	0.900000	0.900000	0.000000	2026-09-16 22:22:53.257373+08
795	fireworks_ai/accounts/fireworks/models/deepseek-coder-1b-base	0.100000	0.100000	0.000000	2026-09-16 22:22:53.257728+08
796	fireworks_ai/accounts/fireworks/models/deepseek-coder-33b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.258073+08
797	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base	0.200000	0.200000	0.000000	2026-09-16 22:22:53.258428+08
798	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base-v1p5	0.200000	0.200000	0.000000	2026-09-16 22:22:53.25879+08
799	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-instruct-v1p5	0.200000	0.200000	0.000000	2026-09-16 22:22:53.25915+08
800	fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-lite-base	0.500000	0.500000	0.000000	2026-09-16 22:22:53.259509+08
801	fireworks_ai/accounts/fireworks/models/deepseek-coder-v2-lite-instruct	0.500000	0.500000	0.000000	2026-09-16 22:22:53.259884+08
802	fireworks_ai/accounts/fireworks/models/deepseek-prover-v2	1.200000	1.200000	0.000000	2026-09-16 22:22:53.260305+08
803	fireworks_ai/accounts/fireworks/models/deepseek-r1-0528-distill-qwen3-8b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.26066+08
804	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-70b	0.900000	0.900000	0.000000	2026-09-16 22:22:53.26103+08
805	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-8b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.261383+08
806	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-14b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.2619+08
807	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-1p5b	0.100000	0.100000	0.000000	2026-09-16 22:22:53.262264+08
808	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-32b	0.900000	0.900000	0.000000	2026-09-16 22:22:53.262621+08
809	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-7b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.262959+08
810	fireworks_ai/accounts/fireworks/models/deepseek-v2-lite-chat	0.500000	0.500000	0.000000	2026-09-16 22:22:53.263308+08
811	fireworks_ai/accounts/fireworks/models/deepseek-v2p5	1.200000	1.200000	0.000000	2026-09-16 22:22:53.263676+08
812	fireworks_ai/accounts/fireworks/models/dolphin-2-9-2-qwen2-72b	0.900000	0.900000	0.000000	2026-09-16 22:22:53.264072+08
813	fireworks_ai/accounts/fireworks/models/glm-4p5v	1.200000	1.200000	0.000000	2026-09-16 22:22:53.264481+08
814	fireworks_ai/accounts/fireworks/models/minimax-m1-80k	0.100000	0.100000	0.000000	2026-09-16 22:22:53.264877+08
815	fireworks_ai/accounts/fireworks/models/minimax-m2	0.300000	1.200000	0.000000	2026-09-16 22:22:53.265253+08
816	fireworks_ai/accounts/fireworks/models/qwen-qwq-32b-preview	0.900000	0.900000	0.000000	2026-09-16 22:22:53.26565+08
817	fireworks_ai/accounts/fireworks/models/qwen-v2p5-14b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.266018+08
818	fireworks_ai/accounts/fireworks/models/qwen-v2p5-7b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.266383+08
819	fireworks_ai/accounts/fireworks/models/qwen1p5-72b-chat	0.900000	0.900000	0.000000	2026-09-16 22:22:53.266746+08
820	fireworks_ai/accounts/fireworks/models/qwen2-7b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.267107+08
821	fireworks_ai/accounts/fireworks/models/qwen2-vl-2b-instruct	0.100000	0.100000	0.000000	2026-09-16 22:22:53.267474+08
822	fireworks_ai/accounts/fireworks/models/qwen2-vl-72b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.26783+08
823	fireworks_ai/accounts/fireworks/models/qwen2-vl-7b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.268193+08
824	fireworks_ai/accounts/fireworks/models/qwen2p5-0p5b-instruct	0.100000	0.100000	0.000000	2026-09-16 22:22:53.268547+08
825	fireworks_ai/accounts/fireworks/models/qwen2p5-14b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.269048+08
826	fireworks_ai/accounts/fireworks/models/qwen2p5-1p5b-instruct	0.100000	0.100000	0.000000	2026-09-16 22:22:53.269394+08
827	fireworks_ai/accounts/fireworks/models/qwen2p5-32b	0.900000	0.900000	0.000000	2026-09-16 22:22:53.269709+08
828	fireworks_ai/accounts/fireworks/models/qwen2p5-32b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.270031+08
829	fireworks_ai/accounts/fireworks/models/qwen2p5-72b	0.900000	0.900000	0.000000	2026-09-16 22:22:53.270356+08
830	fireworks_ai/accounts/fireworks/models/qwen2p5-72b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.270689+08
831	fireworks_ai/accounts/fireworks/models/qwen2p5-7b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.271015+08
832	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b	0.100000	0.100000	0.000000	2026-09-16 22:22:53.271339+08
833	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b-instruct	0.100000	0.100000	0.000000	2026-09-16 22:22:53.271669+08
834	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.271977+08
835	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.272307+08
836	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b	0.100000	0.100000	0.000000	2026-09-16 22:22:53.272624+08
837	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b-instruct	0.100000	0.100000	0.000000	2026-09-16 22:22:53.272946+08
838	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b	0.900000	0.900000	0.000000	2026-09-16 22:22:53.273256+08
839	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-128k	0.900000	0.900000	0.000000	2026-09-16 22:22:53.273581+08
840	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-32k-rope	0.900000	0.900000	0.000000	2026-09-16 22:22:53.273901+08
841	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-64k	0.900000	0.900000	0.000000	2026-09-16 22:22:53.274223+08
842	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b	0.100000	0.100000	0.000000	2026-09-16 22:22:53.27473+08
843	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b-instruct	0.100000	0.100000	0.000000	2026-09-16 22:22:53.275107+08
844	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.27546+08
845	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.275843+08
846	fireworks_ai/accounts/fireworks/models/qwen2p5-math-72b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.276213+08
847	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-32b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.276578+08
848	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-3b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.276999+08
849	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-72b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.277538+08
850	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-7b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.277903+08
851	fireworks_ai/accounts/fireworks/models/qwen3-0p6b	0.100000	0.100000	0.000000	2026-09-16 22:22:53.278252+08
852	fireworks_ai/accounts/fireworks/models/qwen3-14b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.278603+08
853	fireworks_ai/accounts/fireworks/models/qwen3-1p7b	0.100000	0.100000	0.000000	2026-09-16 22:22:53.278957+08
854	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft	0.100000	0.100000	0.000000	2026-09-16 22:22:53.279305+08
855	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-131072	0.100000	0.100000	0.000000	2026-09-16 22:22:53.279666+08
856	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-40960	0.100000	0.100000	0.000000	2026-09-16 22:22:53.280036+08
857	fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b	0.220000	0.880000	0.000000	2026-09-16 22:22:53.280393+08
858	fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b-instruct-2507	0.220000	0.880000	0.000000	2026-09-16 22:22:53.280812+08
859	fireworks_ai/accounts/fireworks/models/qwen3-235b-a22b-thinking-2507	0.220000	0.880000	0.000000	2026-09-16 22:22:53.281207+08
860	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b	0.150000	0.600000	0.000000	2026-09-16 22:22:53.281564+08
861	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-instruct-2507	0.500000	0.500000	0.000000	2026-09-16 22:22:53.281921+08
862	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-thinking-2507	0.900000	0.900000	0.000000	2026-09-16 22:22:53.282278+08
863	fireworks_ai/accounts/fireworks/models/qwen3-32b	0.900000	0.900000	0.000000	2026-09-16 22:22:53.282584+08
864	fireworks_ai/accounts/fireworks/models/qwen3-4b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.282922+08
865	fireworks_ai/accounts/fireworks/models/qwen3-4b-instruct-2507	0.200000	0.200000	0.000000	2026-09-16 22:22:53.283281+08
866	fireworks_ai/accounts/fireworks/models/qwen3-8b	0.200000	0.200000	0.000000	2026-09-16 22:22:53.283659+08
867	fireworks_ai/accounts/fireworks/models/qwen3-coder-30b-a3b-instruct	0.150000	0.600000	0.000000	2026-09-16 22:22:53.284018+08
868	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-instruct-bf16	0.900000	0.900000	0.000000	2026-09-16 22:22:53.284535+08
869	fireworks_ai/accounts/fireworks/models/qwen3-embedding-0p6b	0.000000	0.000000	0.000000	2026-09-16 22:22:53.284887+08
870	fireworks_ai/accounts/fireworks/models/qwen3-embedding-4b	0.000000	0.000000	0.000000	2026-09-16 22:22:53.285197+08
871	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.285533+08
872	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-thinking	0.900000	0.900000	0.000000	2026-09-16 22:22:53.285909+08
873	fireworks_ai/accounts/fireworks/models/qwen3-reranker-0p6b	0.000000	0.000000	0.000000	2026-09-16 22:22:53.286262+08
874	fireworks_ai/accounts/fireworks/models/qwen3-reranker-4b	0.000000	0.000000	0.000000	2026-09-16 22:22:53.286581+08
875	fireworks_ai/accounts/fireworks/models/qwen3-reranker-8b	0.200000	0.000000	0.000000	2026-09-16 22:22:53.286906+08
876	fireworks_ai/accounts/fireworks/models/qwen3-vl-235b-a22b-instruct	0.220000	0.880000	0.000000	2026-09-16 22:22:53.287252+08
877	fireworks_ai/accounts/fireworks/models/qwen3-vl-235b-a22b-thinking	0.220000	0.880000	0.000000	2026-09-16 22:22:53.287567+08
878	fireworks_ai/accounts/fireworks/models/qwen3-vl-30b-a3b-instruct	0.150000	0.600000	0.000000	2026-09-16 22:22:53.287896+08
879	fireworks_ai/accounts/fireworks/models/qwen3-vl-30b-a3b-thinking	0.150000	0.600000	0.000000	2026-09-16 22:22:53.288217+08
880	fireworks_ai/accounts/fireworks/models/qwen3-vl-32b-instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.288517+08
881	fireworks_ai/accounts/fireworks/models/qwen3-vl-8b-instruct	0.200000	0.200000	0.000000	2026-09-16 22:22:53.288841+08
882	fireworks_ai/accounts/fireworks/models/qwen3p7-plus	0.400000	1.600000	0.080000	2026-09-16 22:22:53.289162+08
883	fireworks_ai/accounts/fireworks/routers/glm-5p1-fast	2.800000	8.800000	0.520000	2026-09-16 22:22:53.289499+08
884	fireworks_ai/accounts/fireworks/routers/kimi-k2p6-fast	2.000000	8.000000	0.300000	2026-09-16 22:22:53.289811+08
885	fireworks_ai/accounts/fireworks/routers/kimi-k2p7-code-fast	1.900000	8.000000	0.380000	2026-09-16 22:22:53.290109+08
886	scaleway/qwen/qwen3.5-397b-a17b	0.600000	3.600000	0.000000	2026-09-16 22:22:53.290437+08
887	scaleway/qwen/qwen3.6-35b-a3b	0.250000	1.500000	0.000000	2026-09-16 22:22:53.290914+08
888	scaleway/qwen/qwen3-235b-a22b-instruct-2507	0.750000	2.250000	0.000000	2026-09-16 22:22:53.291256+08
889	scaleway/qwen/qwen3-embedding-8b	0.100000	0.000000	0.000000	2026-09-16 22:22:53.291596+08
890	scaleway/qwen/qwen3-coder-30b-a3b-instruct	0.200000	0.800000	0.000000	2026-09-16 22:22:53.291962+08
891	novita/deepseek/deepseek-v3.2	0.269000	0.400000	0.134500	2026-09-16 22:22:53.292333+08
892	novita/minimax/minimax-m2.1	0.300000	1.200000	0.030000	2026-09-16 22:22:53.292682+08
893	novita/zai-org/glm-4.7	0.600000	2.200000	0.110000	2026-09-16 22:22:53.293043+08
894	novita/zai-org/autoglm-phone-9b-multilingual	0.035000	0.138000	0.000000	2026-09-16 22:22:53.293414+08
895	novita/moonshotai/kimi-k2-thinking	0.600000	2.500000	0.150000	2026-09-16 22:22:53.293764+08
896	novita/minimax/minimax-m2	0.300000	1.200000	0.030000	2026-09-16 22:22:53.294114+08
897	novita/deepseek/deepseek-v3.2-exp	0.270000	0.410000	0.000000	2026-09-16 22:22:53.294454+08
898	novita/qwen/qwen3-vl-235b-a22b-thinking	0.980000	3.950000	0.000000	2026-09-16 22:22:53.294793+08
899	novita/zai-org/glm-4.6v	0.300000	0.900000	0.055000	2026-09-16 22:22:53.295125+08
900	novita/zai-org/glm-4.6	0.550000	2.200000	0.110000	2026-09-16 22:22:53.295466+08
901	novita/qwen/qwen3-next-80b-a3b-instruct	0.150000	1.500000	0.000000	2026-09-16 22:22:53.295951+08
902	novita/qwen/qwen3-next-80b-a3b-thinking	0.150000	1.500000	0.000000	2026-09-16 22:22:53.296286+08
903	novita/deepseek/deepseek-ocr	0.030000	0.030000	0.000000	2026-09-16 22:22:53.296634+08
904	novita/deepseek/deepseek-v3.1-terminus	0.270000	1.000000	0.135000	2026-09-16 22:22:53.296994+08
905	novita/qwen/qwen3-vl-235b-a22b-instruct	0.300000	1.500000	0.000000	2026-09-16 22:22:53.297367+08
906	novita/qwen/qwen3-max	2.110000	8.450000	0.000000	2026-09-16 22:22:53.297733+08
907	novita/deepseek/deepseek-v3.1	0.270000	1.000000	0.135000	2026-09-16 22:22:53.298083+08
908	novita/moonshotai/kimi-k2-0905	0.600000	2.500000	0.000000	2026-09-16 22:22:53.298431+08
909	novita/qwen/qwen3-coder-480b-a35b-instruct	0.380000	1.550000	0.000000	2026-09-16 22:22:53.298797+08
910	novita/qwen/qwen3-coder-30b-a3b-instruct	0.070000	0.270000	0.000000	2026-09-16 22:22:53.299151+08
911	novita/moonshotai/kimi-k2-instruct	0.570000	2.300000	0.000000	2026-09-16 22:22:53.299517+08
912	novita/deepseek/deepseek-v3-0324	0.270000	1.120000	0.135000	2026-09-16 22:22:53.299862+08
913	novita/zai-org/glm-4.5	0.600000	2.200000	0.110000	2026-09-16 22:22:53.300226+08
914	novita/qwen/qwen3-235b-a22b-thinking-2507	0.300000	3.000000	0.000000	2026-09-16 22:22:53.300573+08
915	novita/zai-org/glm-4.5v	0.600000	1.800000	0.110000	2026-09-16 22:22:53.30092+08
916	novita/qwen/qwen3-235b-a22b-instruct-2507	0.090000	0.580000	0.000000	2026-09-16 22:22:53.301256+08
917	novita/deepseek/deepseek-r1-distill-qwen-14b	0.150000	0.150000	0.000000	2026-09-16 22:22:53.301598+08
918	novita/qwen/qwen-2.5-72b-instruct	0.380000	0.400000	0.000000	2026-09-16 22:22:53.301939+08
919	novita/minimaxai/minimax-m1-80k	0.550000	2.200000	0.000000	2026-09-16 22:22:53.302296+08
920	novita/deepseek/deepseek-r1-0528	0.700000	2.500000	0.350000	2026-09-16 22:22:53.302628+08
921	novita/deepseek/deepseek-r1-distill-qwen-32b	0.300000	0.300000	0.000000	2026-09-16 22:22:53.302952+08
922	novita/deepseek/deepseek-r1-0528-qwen3-8b	0.060000	0.090000	0.000000	2026-09-16 22:22:53.303297+08
923	novita/deepseek/deepseek-r1-distill-llama-70b	0.800000	0.800000	0.000000	2026-09-16 22:22:53.30377+08
924	novita/qwen/qwen3-235b-a22b-fp8	0.200000	0.800000	0.000000	2026-09-16 22:22:53.304108+08
925	novita/qwen/qwen2.5-vl-72b-instruct	0.800000	0.800000	0.000000	2026-09-16 22:22:53.304411+08
926	novita/deepseek/deepseek-prover-v2-671b	0.700000	2.500000	0.000000	2026-09-16 22:22:53.304712+08
927	novita/qwen/qwen3-32b-fp8	0.100000	0.450000	0.000000	2026-09-16 22:22:53.305017+08
928	novita/qwen/qwen3-30b-a3b-fp8	0.090000	0.450000	0.000000	2026-09-16 22:22:53.305308+08
929	novita/deepseek/deepseek-v3-turbo	0.400000	1.300000	0.000000	2026-09-16 22:22:53.305603+08
930	novita/deepseek/deepseek-r1-turbo	0.700000	2.500000	0.000000	2026-09-16 22:22:53.305897+08
931	novita/qwen/qwen3-vl-8b-instruct	0.080000	0.500000	0.000000	2026-09-16 22:22:53.306212+08
932	novita/zai-org/glm-4.5-air	0.130000	0.850000	0.025000	2026-09-16 22:22:53.306522+08
933	novita/qwen/qwen3-vl-30b-a3b-instruct	0.200000	0.700000	0.000000	2026-09-16 22:22:53.30682+08
934	novita/qwen/qwen3-vl-30b-a3b-thinking	0.200000	1.000000	0.000000	2026-09-16 22:22:53.307113+08
935	novita/qwen/qwen3-omni-30b-a3b-thinking	0.250000	0.970000	0.000000	2026-09-16 22:22:53.307408+08
936	novita/qwen/qwen3-omni-30b-a3b-instruct	0.250000	0.970000	0.000000	2026-09-16 22:22:53.30771+08
937	novita/qwen/qwen-mt-plus	0.250000	0.750000	0.000000	2026-09-16 22:22:53.30803+08
938	novita/qwen/qwen3-8b-fp8	0.035000	0.138000	0.000000	2026-09-16 22:22:53.308551+08
939	novita/qwen/qwen3-4b-fp8	0.030000	0.030000	0.000000	2026-09-16 22:22:53.308916+08
940	novita/qwen/qwen2.5-7b-instruct	0.070000	0.070000	0.000000	2026-09-16 22:22:53.309264+08
941	novita/qwen/qwen3-embedding-0.6b	0.070000	0.000000	0.000000	2026-09-16 22:22:53.309605+08
942	novita/qwen/qwen3-embedding-8b	0.070000	0.000000	0.000000	2026-09-16 22:22:53.309932+08
943	novita/qwen/qwen3-reranker-8b	0.050000	0.050000	0.000000	2026-09-16 22:22:53.310272+08
944	llamagate/qwen3-8b	0.040000	0.140000	0.000000	2026-09-16 22:22:53.31061+08
945	llamagate/deepseek-r1-8b	0.100000	0.200000	0.000000	2026-09-16 22:22:53.310936+08
946	llamagate/deepseek-r1-7b-qwen	0.080000	0.150000	0.000000	2026-09-16 22:22:53.311271+08
947	llamagate/qwen2.5-coder-7b	0.060000	0.120000	0.000000	2026-09-16 22:22:53.311602+08
948	llamagate/deepseek-coder-6.7b	0.060000	0.120000	0.000000	2026-09-16 22:22:53.311933+08
949	llamagate/qwen3-vl-8b	0.150000	0.550000	0.000000	2026-09-16 22:22:53.31226+08
950	llamagate/qwen3-embedding-8b	0.020000	0.000000	0.000000	2026-09-16 22:22:53.312597+08
951	libertai/qwen3.6-27b	0.150000	0.500000	0.000000	2026-09-16 22:22:53.312929+08
952	libertai/qwen3.6-27b-thinking	0.150000	0.500000	0.000000	2026-09-16 22:22:53.31326+08
953	libertai/qwen3.6-35b-a3b	0.150000	0.500000	0.000000	2026-09-16 22:22:53.313795+08
954	libertai/qwen3.6-35b-a3b-thinking	0.150000	0.500000	0.000000	2026-09-16 22:22:53.314116+08
955	libertai/qwen3.5-122b-a10b	0.250000	1.750000	0.000000	2026-09-16 22:22:53.314476+08
956	libertai/qwen3.5-122b-a10b-thinking	0.250000	1.750000	0.000000	2026-09-16 22:22:53.314817+08
957	libertai/deepseek-v4-flash	0.250000	1.750000	0.000000	2026-09-16 22:22:53.315169+08
958	libertai/deepseek-v4-flash-thinking	0.250000	1.750000	0.000000	2026-09-16 22:22:53.315517+08
959	bedrock/us-east-1/zai.glm-5	1.000000	3.200000	0.000000	2026-09-16 22:22:53.315922+08
960	bedrock/us-west-2/zai.glm-5	1.000000	3.200000	0.000000	2026-09-16 22:22:53.316285+08
961	tensormesh/Qwen/Qwen3.5-397B-A17B-FP8	0.600000	3.600000	0.000000	2026-09-16 22:22:53.316626+08
962	tensormesh/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	0.450000	1.800000	0.000000	2026-09-16 22:22:53.316962+08
963	tensormesh/Qwen/Qwen3.6-27B-FP8	0.320000	3.200000	0.000000	2026-09-16 22:22:53.31747+08
964	tensormesh/lukealonso/GLM-5.1-NVFP4-MTP	1.400000	4.400000	0.000000	2026-09-16 22:22:53.317802+08
965	tensormesh/deepseek-ai/DeepSeek-V4-Flash	0.140000	0.280000	0.000000	2026-09-16 22:22:53.318153+08
966	tensormesh/moonshotai/Kimi-K2.6	0.960000	4.000000	0.000000	2026-09-16 22:22:53.31851+08
967	tensormesh/MiniMaxAI/MiniMax-M2.5	0.300000	1.200000	0.000000	2026-09-16 22:22:53.318858+08
968	deepseek-flash	0.300000	1.200000	0.006000	2026-09-16 22:22:53.319217+08
969	deepseek-v4-flash	0.300000	1.200000	0.006000	2026-09-16 22:22:53.319565+08
970	deepseek-v4-flash-vision-exp	0.300000	1.200000	0.006000	2026-09-16 22:22:53.319887+08
971	deepseek-v4-pro	1.320000	3.960000	0.044000	2026-09-16 22:22:53.320189+08
972	deepseek/deepseek-flash	0.300000	1.200000	0.006000	2026-09-16 22:22:53.3205+08
973	deepseek/deepseek-v4-flash	0.300000	1.200000	0.006000	2026-09-16 22:22:53.32081+08
974	deepseek/deepseek-v4-flash-vision-exp	0.300000	1.200000	0.006000	2026-09-16 22:22:53.321117+08
975	deepseek/deepseek-v4-pro	1.320000	3.960000	0.044000	2026-09-16 22:22:53.321416+08
976	tencent/deepseek-v4-pro	0.435000	0.870000	0.003625	2026-09-16 22:22:53.321712+08
977	tencent/deepseek-v4-flash	0.140000	0.280000	0.002800	2026-09-16 22:22:53.322023+08
978	tencent/minimax-m3	0.300000	1.200000	0.060000	2026-09-16 22:22:53.322342+08
979	pinstripes/ps/glm-4.5-air	0.125000	0.450000	0.000000	2026-09-16 22:22:53.322643+08
980	pinstripes/ps/qwen3.6-35b-a3b	0.140000	0.450000	0.000000	2026-09-16 22:22:53.322936+08
981	pinstripes/ps/qwen3-30b-a3b	0.090000	0.200000	0.000000	2026-09-16 22:22:53.323393+08
982	pinstripes/ps/qwen3-coder-30b-a3b	0.300000	0.600000	0.000000	2026-09-16 22:22:53.323695+08
983	pinstripes/ps/deepseek-v4-flash	0.100000	0.200000	0.000000	2026-09-16 22:22:53.324008+08
984	pinstripes/ps/minimax-m2.7	0.255000	0.550000	0.000000	2026-09-16 22:22:53.324334+08
985	fireworks_ai/accounts/fireworks/models/deepseek-v4-flash-0731	0.220000	0.660000	0.007000	2026-09-16 22:22:53.32472+08
986	fireworks_ai/accounts/fireworks/models/deepseek-v4p1-flash	0.220000	0.660000	0.007000	2026-09-16 22:22:53.325106+08
987	fireworks_ai/accounts/fireworks/models/deepseek-v4-flash-vision-exp	0.220000	0.660000	0.007000	2026-09-16 22:22:53.325483+08
988	fireworks_ai/accounts/fireworks/models/kimi-k3	3.000000	15.000000	0.300000	2026-09-16 22:22:53.325845+08
989	fireworks_ai/deepseek-v4-flash-0731	0.220000	0.660000	0.007000	2026-09-16 22:22:53.326245+08
990	fireworks_ai/deepseek-v4p1-flash	0.220000	0.660000	0.007000	2026-09-16 22:22:53.326626+08
991	fireworks_ai/deepseek-v4-flash-vision-exp	0.220000	0.660000	0.007000	2026-09-16 22:22:53.326997+08
992	fireworks_ai/glm-5p2-fast	2.100000	6.600000	0.210000	2026-09-16 22:22:53.327357+08
993	fireworks_ai/glm-5p2-fast-us	2.100000	6.600000	0.210000	2026-09-16 22:22:53.327706+08
994	fireworks_ai/kimi-k3	3.000000	15.000000	0.300000	2026-09-16 22:22:53.328048+08
995	fireworks_ai/kimi-k3-fast	4.500000	22.500000	0.450000	2026-09-16 22:22:53.328389+08
996	fireworks_ai/kimi-k3-us	3.300000	16.500000	0.330000	2026-09-16 22:22:53.328727+08
997	fireworks_ai/qwen3p8-max	2.000000	6.000000	0.250000	2026-09-16 22:22:53.329053+08
998	fireworks_ai/accounts/fireworks/models/qwen3p8-max	2.000000	6.000000	0.250000	2026-09-16 22:22:53.329422+08
999	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast	2.100000	6.600000	0.210000	2026-09-16 22:22:53.329798+08
1000	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast-us	2.100000	6.600000	0.210000	2026-09-16 22:22:53.330168+08
1001	fireworks_ai/accounts/fireworks/routers/kimi-k3-fast	4.500000	22.500000	0.450000	2026-09-16 22:22:53.330548+08
1002	fireworks_ai/accounts/fireworks/routers/kimi-k3-us	3.300000	16.500000	0.330000	2026-09-16 22:22:53.331271+08
1003	novita/zai-org/glm-5.3	1.400000	4.400000	0.260000	2026-09-16 22:22:53.331624+08
1004	novita/deepseek/deepseek-v4-pro-0813	1.320000	3.960000	0.132000	2026-09-16 22:22:53.331995+08
1005	novita/moonshotai/kimi-k3	3.000000	15.000000	0.300000	2026-09-16 22:22:53.332325+08
1006	novita/zai-org/glm-5.2	1.400000	4.400000	0.260000	2026-09-16 22:22:53.332656+08
1007	novita/moonshotai/kimi-k2.7-code	0.950000	4.000000	0.190000	2026-09-16 22:22:53.332984+08
1008	novita/deepseek/deepseek-v4-flash-vision-exp	0.440000	1.320000	0.028000	2026-09-16 22:22:53.333341+08
1009	novita/deepseek/deepseek-v4-flash-0731	0.440000	1.320000	0.028000	2026-09-16 22:22:53.333706+08
1010	novita/minimax/minimax-m3	0.300000	1.200000	0.060000	2026-09-16 22:22:53.334057+08
1011	novita/deepseek/deepseek-v4-flash	0.140000	0.280000	0.028000	2026-09-16 22:22:53.334397+08
1012	novita/deepseek/deepseek-v4-pro	1.600000	3.200000	0.135000	2026-09-16 22:22:53.33474+08
1013	novita/qwen/qwen3.8-max	2.000000	6.000000	0.250000	2026-09-16 22:22:53.335093+08
1014	novita/qwen/qwen3.7-max	1.250000	3.750000	0.250000	2026-09-16 22:22:53.335444+08
1015	novita/qwen/qwen3.6-27b	0.600000	3.600000	0.000000	2026-09-16 22:22:53.335796+08
1016	novita/moonshotai/kimi-k2.6	0.800000	3.400000	0.160000	2026-09-16 22:22:53.336119+08
1017	novita/zai-org/glm-5.1	1.380000	4.400000	0.260000	2026-09-16 22:22:53.33643+08
1018	novita/minimax/minimax-m2.7-highspeed	0.600000	2.400000	0.060000	2026-09-16 22:22:53.336739+08
1019	novita/zai-org/glm-5v-turbo	1.200000	4.000000	0.240000	2026-09-16 22:22:53.337066+08
1020	novita/zai-org/glm-5-turbo	1.200000	4.000000	0.240000	2026-09-16 22:22:53.337544+08
1021	novita/minimax/minimax-m2.7	0.300000	1.200000	0.060000	2026-09-16 22:22:53.337847+08
1022	novita/minimax/minimax-m2.5-highspeed	0.600000	2.400000	0.030000	2026-09-16 22:22:53.338146+08
1023	novita/qwen/qwen3.5-27b	0.300000	2.400000	0.000000	2026-09-16 22:22:53.33845+08
1024	novita/qwen/qwen3.5-122b-a10b	0.400000	3.200000	0.000000	2026-09-16 22:22:53.338754+08
1025	novita/qwen/qwen3.5-35b-a3b	0.250000	2.000000	0.000000	2026-09-16 22:22:53.339054+08
1026	novita/qwen/qwen3.5-397b-a17b	0.600000	3.600000	0.000000	2026-09-16 22:22:53.339363+08
1027	novita/minimax/minimax-m2.5	0.300000	1.200000	0.030000	2026-09-16 22:22:53.339662+08
1028	novita/zai-org/glm-5	1.000000	3.200000	0.200000	2026-09-16 22:22:53.339972+08
1029	novita/qwen/qwen3-coder-next	0.200000	1.500000	0.000000	2026-09-16 22:22:53.340293+08
1030	novita/deepseek/deepseek-ocr-2	0.030000	0.030000	0.000000	2026-09-16 22:22:53.340619+08
1031	novita/moonshotai/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-16 22:22:53.340978+08
1032	novita/zai-org/glm-4.7-h	0.600000	2.200000	0.110000	2026-09-16 22:22:53.341335+08
1033	novita/zai-org/glm-4.7-flash	0.070000	0.400000	0.010000	2026-09-16 22:22:53.341692+08
1034	novita/qwen/qwen3.6-35b-a3b	0.248000	1.485000	0.000000	2026-09-16 22:22:53.34204+08
1035	novita/deepseek/deepseek_v3	0.890000	0.890000	0.000000	2026-09-16 22:22:53.342398+08
1036	novita/deepseek/deepseek-r1	4.000000	4.000000	0.000000	2026-09-16 22:22:53.342746+08
1037	novita/deepseek/deepseek-v3/community	0.890000	0.890000	0.000000	2026-09-16 22:22:53.343104+08
1038	novita/deepseek/deepseek-r1/community	4.000000	4.000000	0.000000	2026-09-16 22:22:53.343477+08
1039	novita/thudm/glm-4-32b-0414	0.550000	1.660000	0.000000	2026-09-16 22:22:53.343854+08
1040	wandb/deepseek-ai/DeepSeek-V4-Flash	0.140000	0.280000	0.070000	2026-09-16 22:22:53.344195+08
1041	wandb/deepseek-ai/DeepSeek-V4-Flash-0731	0.130000	0.280000	0.070000	2026-09-16 22:22:53.344543+08
1042	wandb/deepseek-ai/DeepSeek-V4-Pro	1.150000	2.550000	0.200000	2026-09-16 22:22:53.344874+08
1043	wandb/MiniMaxAI/MiniMax-M3	0.230000	0.960000	0.050000	2026-09-16 22:22:53.345399+08
1044	wandb/moonshotai/Kimi-K2.7-Code	0.710000	3.500000	0.150000	2026-09-16 22:22:53.345754+08
1045	wandb/moonshotai/Kimi-K2.6	0.650000	3.410000	0.150000	2026-09-16 22:22:53.346088+08
1046	wandb/OpenPipe/Qwen3-14B-Instruct	0.050000	0.220000	0.000000	2026-09-16 22:22:53.346432+08
1047	wandb/Qwen/Qwen3.8-27B	0.400000	3.000000	0.150000	2026-09-16 22:22:53.346756+08
1048	wandb/Qwen/Qwen3.6-35B-A3B	0.250000	1.250000	0.000000	2026-09-16 22:22:53.347148+08
1049	wandb/Qwen/Qwen3.6-27B	0.600000	3.600000	0.120000	2026-09-16 22:22:53.347507+08
1050	wandb/Qwen/Qwen3.5-35B-A3B	0.250000	1.250000	0.000000	2026-09-16 22:22:53.347844+08
1051	wandb/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-09-16 22:22:53.348178+08
1052	wandb/deepseek-ai/DeepSeek-V4-Pro-0813	1.310000	3.960000	0.044000	2026-09-16 22:22:53.348535+08
1053	wandb/zai-org/GLM-5.2	0.760000	2.420000	0.140000	2026-09-16 22:22:53.348885+08
1054	deepinfra/MiniMaxAI/MiniMax-M2.7	0.250000	1.000000	0.050000	2026-09-16 22:22:53.349242+08
1055	deepinfra/Qwen/Qwen3.8-27B	0.400000	3.000000	0.040000	2026-09-16 22:22:53.349602+08
1056	deepinfra/moonshotai/Kimi-K2.5	0.450000	2.250000	0.070000	2026-09-16 22:22:53.349985+08
1057	deepinfra/zai-org/GLM-4.7-Flash	0.060000	0.400000	0.010000	2026-09-16 22:22:53.350352+08
1058	deepinfra/zai-org/GLM-4.6	0.500000	2.000000	0.100000	2026-09-16 22:22:53.350694+08
1059	deepinfra/Qwen/Qwen3-Max	1.200000	6.000000	0.240000	2026-09-16 22:22:53.351034+08
1060	deepinfra/Qwen/Qwen3-Max-Thinking	1.200000	6.000000	0.240000	2026-09-16 22:22:53.351561+08
1061	deepinfra/Qwen/Qwen3-VL-235B-A22B-Instruct	0.200000	0.880000	0.110000	2026-09-16 22:22:53.351912+08
1062	deepinfra/Qwen/Qwen3-VL-30B-A3B-Instruct	0.150000	0.600000	0.000000	2026-09-16 22:22:53.352258+08
1063	deepinfra/Qwen/Qwen3.5-27B	0.260000	2.600000	0.000000	2026-09-16 22:22:53.352589+08
1064	deepinfra/Qwen/Qwen3.6-35B-A3B	0.100000	0.950000	0.000000	2026-09-16 22:22:53.352922+08
1065	deepinfra/moonshotai/Kimi-K2.6	0.750000	3.500000	0.150000	2026-09-16 22:22:53.353224+08
1066	deepinfra/deepseek-ai/DeepSeek-V4-Pro-0813	1.300000	2.600000	0.100000	2026-09-16 22:22:53.353531+08
1067	deepinfra/Qwen/Qwen3.7-Max	2.500000	7.500000	0.500000	2026-09-16 22:22:53.353834+08
1068	deepinfra/Qwen/Qwen3.8-2.4T-A95B	2.000000	6.000000	0.200000	2026-09-16 22:22:53.354163+08
1069	deepinfra/MiniMaxAI/MiniMax-M3	0.280000	1.100000	0.056000	2026-09-16 22:22:53.354467+08
1070	deepinfra/Qwen/Qwen3.5-35B-A3B	0.140000	1.000000	0.050000	2026-09-16 22:22:53.35477+08
1071	deepinfra/zai-org/GLM-5	0.600000	2.080000	0.120000	2026-09-16 22:22:53.355067+08
1072	deepinfra/moonshotai/Kimi-K2.7-Code	0.680000	3.400000	0.136000	2026-09-16 22:22:53.355366+08
1073	deepinfra/Qwen/Qwen3.5-397B-A17B	0.450000	3.000000	0.220000	2026-09-16 22:22:53.355684+08
1074	deepinfra/deepseek-ai/DeepSeek-V4-Flash-0731	0.080000	0.180000	0.016000	2026-09-16 22:22:53.355997+08
1075	deepinfra/deepseek-ai/DeepSeek-V3.2	0.260000	0.380000	0.130000	2026-09-16 22:22:53.3563+08
1076	deepinfra/Qwen/Qwen3.8-Max	1.650000	4.951000	0.206000	2026-09-16 22:22:53.356598+08
1077	deepinfra/Qwen/Qwen3.5-122B-A10B	0.290000	2.400000	0.000000	2026-09-16 22:22:53.356897+08
1078	deepinfra/zai-org/GLM-5.1	1.050000	3.500000	0.205000	2026-09-16 22:22:53.357195+08
1079	deepinfra/deepseek-ai/DeepSeek-V4-Pro	1.300000	2.600000	0.100000	2026-09-16 22:22:53.357495+08
1080	deepinfra/zai-org/GLM-5.2	0.750000	2.400000	0.140000	2026-09-16 22:22:53.357827+08
1081	deepinfra/moonshotai/Kimi-K3	2.850000	14.250000	0.285000	2026-09-16 22:22:53.358163+08
1082	deepinfra/Qwen/Qwen3.6-27B	0.320000	3.200000	0.000000	2026-09-16 22:22:53.3585+08
1083	deepinfra/deepseek-ai/DeepSeek-V4-Flash	0.090000	0.180000	0.018000	2026-09-16 22:22:53.359068+08
1084	deepinfra/Qwen/Qwen3.5-9B	0.100000	0.150000	0.000000	2026-09-16 22:22:53.359446+08
1085	deepinfra/MiniMaxAI/MiniMax-M2.7-Turbo	0.380000	1.700000	0.070000	2026-09-16 22:22:53.359813+08
1086	deepinfra/zai-org/GLM-4.7	0.400000	1.750000	0.080000	2026-09-16 22:22:53.360174+08
1087	groq/qwen/qwen3.8-27b	0.800000	4.000000	0.000000	2026-09-16 22:22:53.360564+08
1088	fireworks_ai/accounts/fireworks/models/glm-5p3	1.400000	4.400000	0.260000	2026-09-16 22:22:53.360953+08
1089	fireworks_ai/accounts/fireworks/models/glm-5p3-flash	0.150000	0.500000	0.030000	2026-09-16 22:22:53.361319+08
1090	fireworks_ai/accounts/fireworks/models/qwen3-embedding-8b	0.100000	0.000000	0.000000	2026-09-16 22:22:53.361676+08
1091	zai/glm-5.2	1.400000	4.400000	0.260000	2026-09-16 22:22:53.362024+08
1092	together_ai/Qwen/Qwen3.8-Flash	0.150000	0.470000	0.000000	2026-09-16 22:22:53.36235+08
1093	together_ai/moonshotai/Kimi-K2.6	1.200000	4.500000	0.200000	2026-09-16 22:22:53.362695+08
1094	together_ai/moonshotai/Kimi-K2.5-fp4	0.500000	2.800000	0.000000	2026-09-16 22:22:53.363038+08
1095	together_ai/MiniMaxAI/MiniMax-M2.7	0.300000	1.200000	0.060000	2026-09-16 22:22:53.363392+08
1096	together_ai/zai-org/GLM-5	1.000000	3.200000	0.000000	2026-09-16 22:22:53.363754+08
1097	together_ai/zai-org/GLM-5.1	1.400000	4.400000	0.260000	2026-09-16 22:22:53.364092+08
1098	together_ai/deepseek-ai/DeepSeek-R1-0528	3.000000	7.000000	0.000000	2026-09-16 22:22:53.364442+08
1099	together_ai/Qwen/Qwen3-Coder-Next-FP8	0.500000	1.200000	0.000000	2026-09-16 22:22:53.364788+08
1100	together_ai/Qwen/Qwen3-VL-32B-Instruct	0.500000	1.500000	0.000000	2026-09-16 22:22:53.365129+08
1101	together_ai/Qwen/Qwen3-VL-8B-Instruct	0.180000	0.680000	0.000000	2026-09-16 22:22:53.365478+08
1102	together_ai/Qwen/QwQ-32B	1.200000	1.200000	0.000000	2026-09-16 22:22:53.36583+08
1103	scaleway/glm-5.2	1.800000	5.500000	0.000000	2026-09-16 22:22:53.366192+08
1104	scaleway/deepseek-v4-flash-0731	0.400000	0.800000	0.080000	2026-09-16 22:22:53.36653+08
1105	azure_ai/kimi-k2.7-code	0.950000	4.000000	0.190000	2026-09-16 22:22:53.366879+08
1106	perplexity/perplexity/glm-5.3	1.400000	4.400000	0.260000	2026-09-16 22:22:53.367452+08
1107	perplexity/perplexity/glm-5.3-flash	0.150000	0.500000	0.030000	2026-09-16 22:22:53.367798+08
1108	baseten/zai-org/GLM-5.3	1.400000	4.400000	0.140000	2026-09-16 22:22:53.368157+08
1109	openrouter/minimax/minimax-m3	0.300000	1.200000	0.060000	2026-09-16 22:22:53.368504+08
1110	openrouter/qwen/qwen3.7-plus	0.320000	1.280000	0.064000	2026-09-16 22:22:53.368833+08
1111	openrouter/qwen/qwen3.8-flash	0.150000	0.470000	0.016000	2026-09-16 22:22:53.369188+08
1112	openrouter/z-ai/glm-5.3-flash	0.150000	0.500000	0.030000	2026-09-16 22:22:53.369565+08
1113	openrouter/deepseek/deepseek-v4-flash-vision-exp	0.220000	0.660000	0.007000	2026-09-16 22:22:53.36988+08
1114	openrouter/z-ai/glm-5.3	1.400000	4.400000	0.140000	2026-09-16 22:22:53.37019+08
1115	openrouter/qwen/qwen3.8-27b	0.420000	3.000000	0.085000	2026-09-16 22:22:53.370513+08
1116	openrouter/qwen/qwen3.8-2.4t-a95b	2.000000	6.000000	0.250000	2026-09-16 22:22:53.370828+08
1117	openrouter/qwen/qwen3.8-max	2.000000	6.000000	0.250000	2026-09-16 22:22:53.371129+08
1118	openrouter/qwen/qwen3.8-max-0902	2.000000	6.000000	0.250000	2026-09-16 22:22:53.371431+08
1119	openrouter/deepseek/deepseek-v4-flash-0731	0.065000	0.180000	0.016000	2026-09-16 22:22:53.371749+08
1120	openrouter/qwen/qwen3.7-flash	0.030000	0.130000	0.006000	2026-09-16 22:22:53.372052+08
1121	openrouter/moonshotai/kimi-k3	2.100000	10.530000	0.235000	2026-09-16 22:22:53.372359+08
1122	openrouter/z-ai/glm-5.2	0.600000	2.000000	0.150000	2026-09-16 22:22:53.372656+08
1123	openrouter/z-ai/glm-5.2:free	0.000000	0.000000	0.000000	2026-09-16 22:22:53.372962+08
1124	openrouter/moonshotai/kimi-k2.7-code	0.710000	3.500000	0.150000	2026-09-16 22:22:53.373261+08
1125	openrouter/minimax/minimax-m3:free	0.000000	0.000000	0.000000	2026-09-16 22:22:53.373585+08
1126	openrouter/qwen/qwen3.7-max	1.475000	4.425000	0.295000	2026-09-16 22:22:53.373926+08
1127	openrouter/qwen/qwen3.5-plus-20260420	0.300000	1.800000	0.000000	2026-09-16 22:22:53.374269+08
1128	openrouter/qwen/qwen3.6-flash	0.187500	1.125000	0.000000	2026-09-16 22:22:53.374633+08
1129	openrouter/qwen/qwen3.6-35b-a3b	0.100000	0.900000	0.050000	2026-09-16 22:22:53.375197+08
1130	openrouter/qwen/qwen3.6-max-preview	1.027000	6.162000	0.000000	2026-09-16 22:22:53.375562+08
1131	openrouter/qwen/qwen3.6-27b	0.300000	2.000000	0.030000	2026-09-16 22:22:53.375916+08
1132	openrouter/deepseek/deepseek-v4-flash	0.085400	0.170800	0.017080	2026-09-16 22:22:53.376275+08
1133	openrouter/moonshotai/kimi-k2.6	0.950000	4.000000	0.160000	2026-09-16 22:22:53.376623+08
1134	openrouter/z-ai/glm-5v-turbo	1.200000	4.000000	0.240000	2026-09-16 22:22:53.376991+08
1135	openrouter/minimax/minimax-m2.7	0.300000	1.200000	0.060000	2026-09-16 22:22:53.377356+08
1136	openrouter/minimax/minimax-m2.7:free	0.000000	0.000000	0.000000	2026-09-16 22:22:53.377701+08
1137	openrouter/z-ai/glm-5-turbo	1.200000	4.000000	0.240000	2026-09-16 22:22:53.378037+08
1138	openrouter/qwen/qwen3.5-9b	0.100000	0.150000	0.000000	2026-09-16 22:22:53.378379+08
1139	openrouter/qwen/qwen3-max-thinking	0.780000	3.900000	0.000000	2026-09-16 22:22:53.378738+08
1140	openrouter/qwen/qwen3-coder-next	0.120000	0.800000	0.070000	2026-09-16 22:22:53.379084+08
1141	openrouter/minimax/minimax-m2-her	0.300000	1.200000	0.030000	2026-09-16 22:22:53.379435+08
1142	openrouter/z-ai/glm-4.6v	0.300000	0.900000	0.055000	2026-09-16 22:22:53.379809+08
1143	openrouter/moonshotai/kimi-k2-thinking	0.600000	2.500000	0.150000	2026-09-16 22:22:53.380171+08
1144	openrouter/qwen/qwen3-vl-32b-instruct	0.104000	0.416000	0.000000	2026-09-16 22:22:53.380552+08
1145	openrouter/qwen/qwen3-vl-8b-thinking	0.180000	2.100000	0.000000	2026-09-16 22:22:53.380923+08
1146	openrouter/qwen/qwen3-vl-8b-instruct	0.117000	0.455000	0.000000	2026-09-16 22:22:53.381268+08
1147	openrouter/qwen/qwen3-vl-30b-a3b-thinking	0.200000	2.400000	0.000000	2026-09-16 22:22:53.381623+08
1148	openrouter/qwen/qwen3-vl-30b-a3b-instruct	0.150000	0.600000	0.000000	2026-09-16 22:22:53.381976+08
1149	openrouter/qwen/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-16 22:22:53.382304+08
1150	openrouter/qwen/qwen3-vl-235b-a22b-instruct	0.210000	1.900000	0.100000	2026-09-16 22:22:53.382835+08
1151	openrouter/qwen/qwen3-max	0.780000	3.900000	0.156000	2026-09-16 22:22:53.3832+08
1152	openrouter/deepseek/deepseek-v3.1-terminus	0.270000	1.000000	0.135000	2026-09-16 22:22:53.383571+08
1153	openrouter/qwen/qwen3-coder-flash	0.195000	0.975000	0.039000	2026-09-16 22:22:53.383911+08
1154	openrouter/qwen/qwen3-next-80b-a3b-thinking	0.150000	1.200000	0.000000	2026-09-16 22:22:53.38427+08
1155	openrouter/qwen/qwen3-next-80b-a3b-instruct	0.090000	1.100000	0.070000	2026-09-16 22:22:53.384624+08
1156	openrouter/qwen/qwen-plus-2025-07-28	0.260000	0.780000	0.000000	2026-09-16 22:22:53.384962+08
1157	openrouter/moonshotai/kimi-k2-0905	0.600000	2.500000	0.000000	2026-09-16 22:22:53.385308+08
1158	openrouter/qwen/qwen3-30b-a3b-thinking-2507	0.200000	2.400000	0.000000	2026-09-16 22:22:53.385621+08
1159	openrouter/z-ai/glm-4.5v	0.600000	1.800000	0.110000	2026-09-16 22:22:53.385955+08
1160	openrouter/qwen/qwen3-coder-30b-a3b-instruct	0.070000	0.280000	0.000000	2026-09-16 22:22:53.386318+08
1161	openrouter/qwen/qwen3-30b-a3b-instruct-2507	0.090000	0.300000	0.000000	2026-09-16 22:22:53.386802+08
1162	openrouter/z-ai/glm-4.5	0.600000	2.200000	0.110000	2026-09-16 22:22:53.387118+08
1163	openrouter/z-ai/glm-4.5-air	0.130000	0.850000	0.025000	2026-09-16 22:22:53.387441+08
1164	openrouter/moonshotai/kimi-k2	0.570000	2.300000	0.000000	2026-09-16 22:22:53.387761+08
1165	openrouter/minimax/minimax-m1	0.550000	2.200000	0.000000	2026-09-16 22:22:53.388088+08
1166	openrouter/qwen/qwen3-30b-a3b	0.120000	0.500000	0.000000	2026-09-16 22:22:53.388431+08
1167	openrouter/qwen/qwen3-8b	0.117000	0.455000	0.000000	2026-09-16 22:22:53.388782+08
1168	openrouter/qwen/qwen3-14b	0.227500	0.910000	0.000000	2026-09-16 22:22:53.389147+08
1169	openrouter/qwen/qwen3-32b	0.080000	0.280000	0.000000	2026-09-16 22:22:53.3895+08
1170	openrouter/qwen/qwen3-235b-a22b	0.455000	1.820000	0.000000	2026-09-16 22:22:53.389855+08
1171	openrouter/qwen/qwen2.5-vl-72b-instruct	0.800000	1.000000	0.400000	2026-09-16 22:22:53.390238+08
1172	openrouter/qwen/qwen-plus	0.260000	0.780000	0.052000	2026-09-16 22:22:53.390601+08
1173	openrouter/deepseek/deepseek-r1-distill-llama-70b	0.800000	0.800000	0.000000	2026-09-16 22:22:53.390949+08
1174	openrouter/minimax/minimax-01	0.200000	1.100000	0.000000	2026-09-16 22:22:53.391326+08
1175	openrouter/qwen/qwen-2.5-7b-instruct	0.100000	0.200000	0.000000	2026-09-16 22:22:53.391685+08
1176	openrouter/qwen/qwen-2.5-72b-instruct	0.360000	0.400000	0.000000	2026-09-16 22:22:53.392054+08
1177	fireworks_ai/accounts/fireworks/routers/glm-5p3-fast	2.100000	6.600000	0.390000	2026-09-16 22:22:53.392429+08
1178	together_ai/deepseek-ai/deepseek-coder-33b-instruct	0.800000	0.800000	0.000000	2026-09-16 22:22:53.392796+08
1179	together_ai/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	2.000000	2.000000	0.000000	2026-09-16 22:22:53.393184+08
1180	together_ai/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B	0.180000	0.180000	0.000000	2026-09-16 22:22:53.393562+08
1181	together_ai/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B	1.600000	1.600000	0.000000	2026-09-16 22:22:53.393949+08
1182	together_ai/deepseek-ai/DeepSeek-V4.1-Flash	0.300000	1.200000	0.006000	2026-09-16 22:22:53.394522+08
1183	together_ai/Qwen/Qwen2-1.5B-Instruct	0.020000	0.020000	0.000000	2026-09-16 22:22:53.394887+08
1184	together_ai/Qwen/Qwen2-72B-Instruct	0.900000	0.900000	0.000000	2026-09-16 22:22:53.395227+08
1185	together_ai/Qwen/Qwen2-VL-72B-Instruct	1.200000	1.200000	0.000000	2026-09-16 22:22:53.395598+08
1186	together_ai/Qwen/Qwen2.5-14B-Instruct	0.800000	0.800000	0.000000	2026-09-16 22:22:53.395941+08
1187	together_ai/Qwen/Qwen2.5-72B-Instruct	1.200000	1.200000	0.000000	2026-09-16 22:22:53.39628+08
1188	together_ai/Qwen/Qwen2.5-Coder-32B-Instruct	0.800000	0.800000	0.000000	2026-09-16 22:22:53.396638+08
1189	together_ai/Qwen/Qwen2.5-VL-72B-Instruct	1.950000	8.000000	0.000000	2026-09-16 22:22:53.397041+08
1190	aihubmix/cc-glm-5.1	0.060000	0.220000	0.000000	2026-09-16 22:22:53.397411+08
1191	aihubmix/coding-glm-5.3	0.060000	0.220000	0.015000	2026-09-16 22:22:53.397774+08
1192	aihubmix/coding-kimi-k3	0.440000	1.613330	0.066000	2026-09-16 22:22:53.398114+08
1193	aihubmix/deepseek-v4-flash	0.142000	0.284000	0.028400	2026-09-16 22:22:53.398474+08
1194	aihubmix/deepseek-v4-pro	1.690000	3.380000	0.140270	2026-09-16 22:22:53.398824+08
1195	aihubmix/glm-5.2-fast-preview	2.254000	7.889000	0.563500	2026-09-16 22:22:53.399179+08
1196	aihubmix/glm-5.3	1.126800	3.943800	0.281700	2026-09-16 22:22:53.399528+08
1197	aihubmix/glm-5.3-flash	0.112680	0.394380	0.028170	2026-09-16 22:22:53.399877+08
1198	aihubmix/glm-5v-turbo	0.704200	3.098480	0.169008	2026-09-16 22:22:53.400225+08
1199	aihubmix/kimi-k2.6	0.950000	3.999500	0.160835	2026-09-16 22:22:53.40058+08
1200	aihubmix/kimi-k2.7-code-highspeed	1.900000	7.999000	0.321670	2026-09-16 22:22:53.400937+08
1201	aihubmix/kimi-k3	3.000000	15.000000	0.300000	2026-09-16 22:22:53.401271+08
1202	aihubmix/minimax-m2.7	0.295800	1.183200	0.059160	2026-09-16 22:22:53.401598+08
1203	aihubmix/minimax-m3	0.288000	1.152000	0.000000	2026-09-16 22:22:53.401946+08
1204	aihubmix/qwen3-coder-next	0.137000	0.548000	0.000000	2026-09-16 22:22:53.402295+08
1205	aihubmix/qwen3.5-122b-a10b	0.112600	0.900800	0.000000	2026-09-16 22:22:53.402646+08
1206	aihubmix/qwen3.5-397b-a17b	0.164400	0.986400	0.000000	2026-09-16 22:22:53.40356+08
1207	aihubmix/qwen3.6-27b	0.422000	2.532000	0.000000	2026-09-16 22:22:53.403874+08
1208	aihubmix/qwen3.6-35b-a3b	0.254000	1.524000	0.000000	2026-09-16 22:22:53.404177+08
1209	aihubmix/qwen3.6-max-preview	1.268000	7.608000	0.126800	2026-09-16 22:22:53.404489+08
1210	aihubmix/qwen3.7-plus	0.282000	1.128000	0.056400	2026-09-16 22:22:53.404812+08
1211	aihubmix/qwen3.8-2.4t-a95b	2.000000	6.000000	0.500000	2026-09-16 22:22:53.405109+08
1212	aihubmix/qwen3.8-flash	0.112600	0.380025	0.014075	2026-09-16 22:22:53.405404+08
1213	aihubmix/qwen3.8-max	1.690000	5.070000	0.169000	2026-09-16 22:22:53.405698+08
1214	azure_ai/FW-DeepSeek-V4-Pro	1.925000	3.828000	0.165000	2026-09-23 23:40:11.712645+08
1215	azure_ai/FW-GLM-5.2-Fast	2.310000	7.260000	0.231000	2026-09-23 23:40:11.721287+08
1216	azure_ai/FW-Kimi-K2.5	0.660000	3.300000	0.110000	2026-09-23 23:40:11.722433+08
1217	azure_ai/FW-Kimi-K2.7-Code	1.050000	4.400000	0.210000	2026-09-23 23:40:11.724291+08
1218	azure_ai/FW-Kimi-K3	3.000000	15.000000	0.300000	2026-09-23 23:40:11.725509+08
1219	azure_ai/FW-MiniMax-M2.5	0.330000	1.320000	0.033000	2026-09-23 23:40:11.727593+08
1220	azure_ai/FW-MiniMax-M3	0.330000	1.320000	0.066000	2026-09-23 23:40:11.730892+08
1221	azure_ai/deepseek-v3	1.140000	4.560000	0.000000	2026-09-23 23:40:11.732695+08
1222	azure_ai/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-23 23:40:11.734519+08
1223	bedrock/ap-northeast-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-23 23:40:11.735425+08
1224	bedrock/ap-northeast-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-23 23:40:11.737141+08
1225	bedrock/ap-south-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-23 23:40:11.738841+08
1226	bedrock/ap-south-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-23 23:40:11.740224+08
1227	bedrock/ap-southeast-3/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-23 23:40:11.7413+08
1228	bedrock/ap-southeast-3/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-23 23:40:11.742367+08
1229	bedrock/eu-north-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-23 23:40:11.743209+08
1230	bedrock/eu-north-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-23 23:40:11.744338+08
1231	bedrock/eu-west-2/minimax.minimax-m2.1	0.470000	1.860000	0.000000	2026-09-23 23:40:11.746414+08
1232	bedrock/eu-west-2/minimax.minimax-m2.5	0.470000	1.860000	0.000000	2026-09-23 23:40:11.747095+08
1233	bedrock/eu-west-2/qwen.qwen3-coder-next	0.780000	1.860000	0.000000	2026-09-23 23:40:11.747781+08
1234	bedrock/sa-east-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-23 23:40:11.749395+08
1235	bedrock/sa-east-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-23 23:40:11.751062+08
1236	cerebras/qwen-3-32b	0.400000	0.800000	0.000000	2026-09-23 23:40:11.756713+08
1237	cerebras/qwen-3.8-27b	0.990000	1.490000	0.000000	2026-09-23 23:40:11.75735+08
1238	cloudflare/@cf/deepseek-ai/deepseek-r1-distill-qwen-32b	0.497000	4.881000	0.000000	2026-09-23 23:40:11.7584+08
1239	cloudflare/@cf/zai-org/glm-4.7-flash	0.060500	0.400000	0.000000	2026-09-23 23:40:11.758831+08
1240	dashscope/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-23 23:40:11.760554+08
1241	dashscope/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-23 23:40:11.761467+08
1242	dashscope/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-23 23:40:11.761882+08
1243	dashscope/qwen-max	1.600000	6.400000	0.000000	2026-09-23 23:40:11.762847+08
1244	dashscope/qwen-plus	0.400000	1.200000	0.000000	2026-09-23 23:40:11.763095+08
1245	dashscope/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-23 23:40:11.763629+08
1246	dashscope/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-23 23:40:11.764259+08
1247	dashscope/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-23 23:40:11.764496+08
1248	dashscope/qwen-turbo	0.050000	0.200000	0.000000	2026-09-23 23:40:11.765142+08
1249	dashscope/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-23 23:40:11.765427+08
1250	dashscope/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-23 23:40:11.765675+08
1251	dashscope/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-23 23:40:11.765921+08
1252	dashscope/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-23 23:40:11.767456+08
1253	dashscope/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-23 23:40:11.76784+08
1254	dashscope/qwen3.8-flash	0.150000	0.470000	0.016000	2026-09-23 23:40:11.770023+08
1255	dashscope/qwen3.8-omni-flash	0.150000	0.470000	0.016000	2026-09-23 23:40:11.770321+08
1256	qwencloud/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-23 23:40:11.771127+08
1257	qwencloud/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-23 23:40:11.772615+08
1258	qwencloud/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-23 23:40:11.773058+08
1259	qwencloud/qwen-max	1.600000	6.400000	0.000000	2026-09-23 23:40:11.774303+08
1260	qwencloud/qwen-plus	0.400000	1.200000	0.000000	2026-09-23 23:40:11.774761+08
1261	qwencloud/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-23 23:40:11.775088+08
1262	qwencloud/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-23 23:40:11.775358+08
1263	qwencloud/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-23 23:40:11.775871+08
1264	qwencloud/qwen-turbo	0.050000	0.200000	0.000000	2026-09-23 23:40:11.776659+08
1265	qwencloud/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-23 23:40:11.776937+08
1266	qwencloud/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-23 23:40:11.777201+08
1267	qwencloud/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-23 23:40:11.777457+08
1268	qwencloud/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-23 23:40:11.779269+08
1269	qwencloud/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-23 23:40:11.779657+08
1270	qwencloud/qwq-plus	0.800000	2.400000	0.000000	2026-09-23 23:40:11.780768+08
1271	qwen_ai_platform/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-23 23:40:11.781684+08
1272	qwen_ai_platform/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-23 23:40:11.781926+08
1273	qwen_ai_platform/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-23 23:40:11.782164+08
1274	qwen_ai_platform/qwen-max	1.600000	6.400000	0.000000	2026-09-23 23:40:11.783311+08
1275	qwen_ai_platform/qwen-plus	0.400000	1.200000	0.000000	2026-09-23 23:40:11.783589+08
1276	qwen_ai_platform/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-23 23:40:11.783847+08
1277	qwen_ai_platform/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-23 23:40:11.784109+08
1278	qwen_ai_platform/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-23 23:40:11.784393+08
1279	qwen_ai_platform/qwen-turbo	0.050000	0.200000	0.000000	2026-09-23 23:40:11.785442+08
1280	qwen_ai_platform/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-23 23:40:11.785867+08
1281	qwen_ai_platform/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-23 23:40:11.786328+08
1282	qwen_ai_platform/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-23 23:40:11.786681+08
1283	qwen_ai_platform/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-23 23:40:11.78812+08
1284	qwen_ai_platform/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-23 23:40:11.788361+08
1285	qwen_ai_platform/qwen3.8-flash	0.150000	0.470000	0.016000	2026-09-23 23:40:11.789529+08
1286	qwen_ai_platform/qwen3.8-omni-flash	0.150000	0.470000	0.016000	2026-09-23 23:40:11.789823+08
1287	qwen_ai_platform/qwq-plus	0.800000	2.400000	0.000000	2026-09-23 23:40:11.790077+08
1288	databricks/databricks-deepseek-v4-pro-0813	1.319990	3.959970	0.132020	2026-09-23 23:40:11.790957+08
1289	databricks/databricks-glm-5-2	1.400000	4.399990	0.259980	2026-09-23 23:40:11.791226+08
1290	databricks/databricks-glm-5-3	1.400000	4.399990	0.259980	2026-09-23 23:40:11.791467+08
1291	databricks/databricks-glm-5-3-flash	0.150010	0.500010	0.030030	2026-09-23 23:40:11.791717+08
1292	databricks/databricks-qwen35-122b-a10b	0.220010	2.200030	0.220010	2026-09-23 23:40:11.792116+08
1293	deepinfra/Qwen/QwQ-32B	0.150000	0.400000	0.000000	2026-09-23 23:40:11.792693+08
1294	deepinfra/Qwen/Qwen2.5-72B-Instruct	0.360000	0.400000	0.000000	2026-09-23 23:40:11.792932+08
1295	deepinfra/Qwen/Qwen2.5-7B-Instruct	0.040000	0.100000	0.000000	2026-09-23 23:40:11.793179+08
1296	deepinfra/Qwen/Qwen2.5-VL-32B-Instruct	0.200000	0.600000	0.000000	2026-09-23 23:40:11.79343+08
1297	deepinfra/Qwen/Qwen3-235B-A22B-Thinking-2507	0.300000	2.900000	0.000000	2026-09-23 23:40:11.794009+08
1298	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct	0.400000	1.600000	0.000000	2026-09-23 23:40:11.79455+08
1299	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct-Turbo	0.300000	1.000000	0.100000	2026-09-23 23:40:11.794815+08
1300	deepinfra/deepseek-ai/DeepSeek-R1-0528	0.500000	2.150000	0.400000	2026-09-23 23:40:11.795467+08
1301	deepinfra/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	0.200000	0.600000	0.000000	2026-09-23 23:40:11.795844+08
1302	deepinfra/deepseek-ai/DeepSeek-V3	0.320000	0.890000	0.000000	2026-09-23 23:40:11.796318+08
1303	deepinfra/deepseek-ai/DeepSeek-V3-0324	0.240000	0.900000	0.135000	2026-09-23 23:40:11.796991+08
1304	deepinfra/moonshotai/Kimi-K2-Instruct-0905	0.500000	2.000000	0.400000	2026-09-23 23:40:11.797668+08
1305	deepinfra/zai-org/GLM-4.5	0.400000	1.600000	0.000000	2026-09-23 23:40:11.798135+08
1306	deepseek/deepseek-coder	0.140000	0.280000	0.014000	2026-09-23 23:40:11.79854+08
1307	deepseek/deepseek-r1	0.550000	2.190000	0.140000	2026-09-23 23:40:11.798815+08
1308	deepseek/deepseek-v3.2	0.280000	0.400000	0.028000	2026-09-23 23:40:11.799342+08
1309	fal_ai/minimax/h3/text-to-video	0.000000	0.000000	0.000000	2026-09-23 23:40:11.800844+08
1310	fal_ai/minimax/h3/reference-to-video	0.000000	0.000000	0.000000	2026-09-23 23:40:11.80116+08
1311	fireworks_ai/accounts/fireworks/models/deepseek-r1-basic	0.550000	2.190000	0.000000	2026-09-23 23:40:11.802066+08
1312	fireworks_ai/accounts/fireworks/models/deepseek-v3	0.900000	0.900000	0.000000	2026-09-23 23:40:11.802335+08
1313	fireworks_ai/accounts/fireworks/models/deepseek-v3-0324	0.900000	0.900000	0.000000	2026-09-23 23:40:11.802601+08
1314	fireworks_ai/accounts/fireworks/models/deepseek-v4-pro-0813	1.320000	3.960000	0.044000	2026-09-23 23:40:11.803367+08
1315	fireworks_ai/deepseek-v4-pro-0813	1.320000	3.960000	0.044000	2026-09-23 23:40:11.803911+08
1316	fireworks_ai/accounts/fireworks/models/glm-4p5	0.550000	2.190000	0.000000	2026-09-23 23:40:11.804196+08
1317	fireworks_ai/accounts/fireworks/models/glm-4p6	0.550000	2.190000	0.000000	2026-09-23 23:40:11.804602+08
1318	fireworks_ai/accounts/fireworks/models/kimi-k2p5	0.600000	3.000000	0.100000	2026-09-23 23:40:11.805871+08
1319	fireworks_ai/accounts/fireworks/models/qwen2-72b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.806658+08
1320	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.807142+08
1321	fireworks_ai/kimi-k2p5	0.600000	3.000000	0.100000	2026-09-23 23:40:11.808033+08
1322	fireworks_ai/qwen3p7-plus	0.400000	1.600000	0.080000	2026-09-23 23:40:11.809003+08
1323	friendliai/zai-org/GLM-5.3	1.260000	3.960000	0.234000	2026-09-23 23:40:11.809389+08
1324	gmi/deepseek-ai/DeepSeek-V3.2	0.280000	0.400000	0.000000	2026-09-23 23:40:11.810252+08
1325	gmi/moonshotai/Kimi-K2-Thinking	0.800000	1.200000	0.000000	2026-09-23 23:40:11.810839+08
1326	baseten/zai-org/GLM-4.7	0.600000	2.200000	0.120000	2026-09-23 23:40:11.811552+08
1327	gmi/zai-org/GLM-4.7-FP8	0.400000	2.000000	0.000000	2026-09-23 23:40:11.812663+08
1328	gradient_ai/deepseek-r1-distill-llama-70b	0.990000	0.990000	0.000000	2026-09-23 23:40:11.813177+08
1329	hyperbolic/Qwen/QwQ-32B	0.200000	0.200000	0.000000	2026-09-23 23:40:11.813716+08
1330	hyperbolic/deepseek-ai/DeepSeek-R1	0.400000	0.400000	0.000000	2026-09-23 23:40:11.814348+08
1331	hyperbolic/deepseek-ai/DeepSeek-V3	0.200000	0.200000	0.000000	2026-09-23 23:40:11.814726+08
1332	hyperbolic/deepseek-ai/DeepSeek-V3-0324	0.400000	0.400000	0.000000	2026-09-23 23:40:11.814986+08
1333	lambda_ai/deepseek-llama3.3-70b	0.200000	0.600000	0.000000	2026-09-23 23:40:11.815853+08
1334	lambda_ai/deepseek-r1-0528	0.200000	0.600000	0.000000	2026-09-23 23:40:11.816103+08
1335	lambda_ai/deepseek-r1-671b	0.800000	0.800000	0.000000	2026-09-23 23:40:11.816366+08
1336	lambda_ai/deepseek-v3-0324	0.200000	0.600000	0.000000	2026-09-23 23:40:11.816614+08
1337	lambda_ai/qwen25-coder-32b-instruct	0.050000	0.100000	0.000000	2026-09-23 23:40:11.816886+08
1338	lambda_ai/qwen3-32b-fp8	0.050000	0.100000	0.000000	2026-09-23 23:40:11.817147+08
1339	mistral/zai-glm-5-3	1.400000	4.400000	0.140000	2026-09-23 23:40:11.819377+08
1340	mistral/zai-glm-5	1.400000	4.400000	0.140000	2026-09-23 23:40:11.819718+08
1341	mistral/zai-glm-latest	1.400000	4.400000	0.140000	2026-09-23 23:40:11.820082+08
1342	moonshot/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-23 23:40:11.821007+08
1343	moonshot/moonshot-v1-8k	0.200000	2.000000	0.000000	2026-09-23 23:40:11.822203+08
1344	moonshot/moonshot-v1-8k-vision-preview	0.200000	2.000000	0.000000	2026-09-23 23:40:11.822567+08
1345	nscale/Qwen/QwQ-32B	0.180000	0.200000	0.000000	2026-09-23 23:40:11.822967+08
1346	nscale/Qwen/Qwen2.5-Coder-32B-Instruct	0.060000	0.200000	0.000000	2026-09-23 23:40:11.823228+08
1347	nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-8B	0.025000	0.025000	0.000000	2026-09-23 23:40:11.823998+08
1348	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B	0.200000	0.200000	0.000000	2026-09-23 23:40:11.824623+08
1349	nebius/deepseek-ai/DeepSeek-R1	0.800000	2.400000	0.000000	2026-09-23 23:40:11.824904+08
1350	nebius/deepseek-ai/DeepSeek-R1-0528	0.800000	2.400000	0.000000	2026-09-23 23:40:11.82518+08
1351	nebius/Qwen/Qwen3-235B-A22B	0.200000	0.600000	0.000000	2026-09-23 23:40:11.82581+08
1352	nebius/Qwen/Qwen3-32B	0.100000	0.300000	0.000000	2026-09-23 23:40:11.826072+08
1353	nebius/Qwen/Qwen3-30B-A3B	0.100000	0.300000	0.000000	2026-09-23 23:40:11.826752+08
1354	nebius/Qwen/QwQ-32B	0.150000	0.450000	0.000000	2026-09-23 23:40:11.827861+08
1355	nebius/Qwen/Qwen2.5-72B-Instruct	0.130000	0.400000	0.000000	2026-09-23 23:40:11.82812+08
1356	nebius/Qwen/Qwen2.5-32B-Instruct	0.060000	0.200000	0.000000	2026-09-23 23:40:11.828384+08
1357	nebius/Qwen/Qwen2-VL-72B-Instruct	0.130000	0.400000	0.000000	2026-09-23 23:40:11.828878+08
1358	nebius/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.000000	2026-09-23 23:40:11.829689+08
1359	nebius/Qwen/Qwen3-235B-A22B-Instruct-2507	0.200000	0.600000	0.000000	2026-09-23 23:40:11.830616+08
1360	nebius/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-09-23 23:40:11.830885+08
1361	nebius/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.000000	2026-09-23 23:40:11.83134+08
1362	nebius/zai-org/GLM-5.3	1.400000	4.400000	0.000000	2026-09-23 23:40:11.831986+08
1363	openrouter/deepseek/deepseek-chat	0.320000	0.890000	0.000000	2026-09-23 23:40:11.834433+08
1364	openrouter/deepseek/deepseek-v3.2	0.269000	0.400000	0.134500	2026-09-23 23:40:11.834994+08
1365	openrouter/deepseek/deepseek-v3.2-exp	0.270000	0.410000	0.020000	2026-09-23 23:40:11.835272+08
1366	openrouter/deepseek/deepseek-r1	0.700000	2.500000	0.140000	2026-09-23 23:40:11.83557+08
1367	openrouter/deepseek/deepseek-r1-0528	0.500000	2.150000	0.350000	2026-09-23 23:40:11.835827+08
1368	openrouter/deepseek/deepseek-v4-pro	0.880440	1.760880	0.073370	2026-09-23 23:40:11.836101+08
1369	openrouter/deepseek/deepseek-v4.1-flash	0.300000	1.200000	0.006000	2026-09-23 23:40:11.83637+08
1370	openrouter/deepseek/deepseek-v4-pro-0813	1.320000	3.960000	0.044000	2026-09-23 23:40:11.836618+08
1371	openrouter/moonshotai/kimi-k2.5	0.450000	2.250000	0.070000	2026-09-23 23:40:11.836931+08
1372	openrouter/qwen/qwen3-coder	0.300000	1.000000	0.100000	2026-09-23 23:40:11.837345+08
1373	openrouter/qwen/qwen3-coder-plus	0.650000	3.250000	0.130000	2026-09-23 23:40:11.837529+08
1374	openrouter/qwen/qwen3-235b-a22b-2507	0.087500	0.350000	0.017500	2026-09-23 23:40:11.83772+08
1375	openrouter/qwen/qwen3-235b-a22b-thinking-2507	0.230000	2.300000	0.000000	2026-09-23 23:40:11.837905+08
1376	openrouter/qwen/qwen3.5-397b-a17b	0.550000	3.500000	0.225000	2026-09-23 23:40:11.838648+08
1377	openrouter/z-ai/glm-4.6:exacto	0.450000	1.900000	0.000000	2026-09-23 23:40:11.838932+08
1378	openrouter/xiaomi/mimo-v2-flash	0.100000	0.300000	0.010000	2026-09-23 23:40:11.839144+08
1379	openrouter/xiaomi/mimo-v2.5-pro	0.435000	0.870000	0.003600	2026-09-23 23:40:11.839353+08
1380	openrouter/xiaomi/mimo-v2.5	0.140000	0.280000	0.002800	2026-09-23 23:40:11.839561+08
1381	openrouter/z-ai/glm-4.7	0.400000	1.750000	0.080000	2026-09-23 23:40:11.839916+08
1382	openrouter/z-ai/glm-4.7-flash	0.060500	0.400000	0.010000	2026-09-23 23:40:11.840126+08
1383	openrouter/z-ai/glm-5	0.600000	1.920000	0.120000	2026-09-23 23:40:11.840324+08
1384	ovhcloud/Qwen2.5-VL-72B-Instruct	0.910000	0.910000	0.000000	2026-09-23 23:40:11.840966+08
1385	ovhcloud/Qwen3-32B	0.080000	0.230000	0.000000	2026-09-23 23:40:11.84114+08
1386	qwen.qwen3-coder-480b-a35b-v1:0	0.450000	1.800000	0.000000	2026-09-23 23:40:11.841856+08
1387	bedrock/ap-northeast-1/qwen.qwen3-next-80b-a3b	0.180000	1.450000	0.000000	2026-09-23 23:40:11.842479+08
1388	bedrock/ap-south-1/qwen.qwen3-next-80b-a3b	0.180000	1.410000	0.000000	2026-09-23 23:40:11.842693+08
1389	bedrock/ap-southeast-2/qwen.qwen3-next-80b-a3b	0.154500	1.236000	0.000000	2026-09-23 23:40:11.84291+08
1390	bedrock/eu-west-1/qwen.qwen3-next-80b-a3b	0.180000	1.410000	0.000000	2026-09-23 23:40:11.843134+08
1391	bedrock/eu-west-2/qwen.qwen3-next-80b-a3b	0.230000	1.860000	0.000000	2026-09-23 23:40:11.843346+08
1392	bedrock/sa-east-1/qwen.qwen3-next-80b-a3b	0.180000	1.450000	0.000000	2026-09-23 23:40:11.843553+08
1393	replicate/qwen/qwen3-235b-a22b-instruct-2507	0.264000	1.060000	0.000000	2026-09-23 23:40:11.843932+08
1394	replicate/deepseek-ai/deepseek-v3	1.450000	1.450000	0.000000	2026-09-23 23:40:11.844123+08
1395	replicate/deepseek-ai/deepseek-v3.1	0.672000	2.016000	0.000000	2026-09-23 23:40:11.844338+08
1396	scx-ai/GLM-5.2	0.610000	1.980000	0.220000	2026-09-23 23:40:11.845197+08
1397	scx-ai/Qwen3.8-Max	1.650000	4.990000	0.210000	2026-09-23 23:40:11.845425+08
1398	together_ai/Qwen/Qwen3.5-9B	0.170000	0.250000	0.000000	2026-09-23 23:40:11.846701+08
1399	together_ai/Qwen/Qwen3.7-Max	1.500000	4.500000	0.300000	2026-09-23 23:40:11.847237+08
1400	together_ai/arize-ai/qwen-2-1.5b-instruct	0.100000	0.100000	0.000000	2026-09-23 23:40:11.847702+08
1401	together_ai/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.130000	2026-09-23 23:40:11.848552+08
1402	eu.deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-23 23:40:11.849535+08
1403	vercel_ai_gateway/alibaba/qwen-3-235b	0.200000	0.600000	0.000000	2026-09-23 23:40:11.849894+08
1404	vercel_ai_gateway/alibaba/qwen-3-30b	0.100000	0.300000	0.000000	2026-09-23 23:40:11.850134+08
1405	vercel_ai_gateway/alibaba/qwen-3-32b	0.100000	0.300000	0.000000	2026-09-23 23:40:11.850369+08
1406	vercel_ai_gateway/alibaba/qwen3-coder	0.400000	1.600000	0.000000	2026-09-23 23:40:11.850619+08
1407	vercel_ai_gateway/deepseek/deepseek-r1	0.550000	2.190000	0.000000	2026-09-23 23:40:11.850893+08
1408	vercel_ai_gateway/deepseek/deepseek-r1-distill-llama-70b	0.750000	0.990000	0.000000	2026-09-23 23:40:11.851157+08
1409	vercel_ai_gateway/deepseek/deepseek-v3	0.900000	0.900000	0.000000	2026-09-23 23:40:11.851432+08
1410	vercel_ai_gateway/zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-09-23 23:40:11.851976+08
1411	vercel_ai_gateway/zai/glm-4.6	0.450000	1.800000	0.110000	2026-09-23 23:40:11.85242+08
1412	vertex_ai/deepseek-ai/deepseek-v3.1-maas	0.600000	1.700000	0.060000	2026-09-23 23:40:11.852697+08
1413	vertex_ai/deepseek-ai/deepseek-v3.2-maas	0.560000	1.680000	0.056000	2026-09-23 23:40:11.852972+08
1414	vertex_ai/minimaxai/minimax-m2-maas	0.300000	1.200000	0.030000	2026-09-23 23:40:11.856166+08
1415	vertex_ai/moonshotai/kimi-k2-thinking-maas	0.600000	2.500000	0.060000	2026-09-23 23:40:11.856509+08
1416	vertex_ai/zai-org/glm-4.7-maas	0.600000	2.200000	0.060000	2026-09-23 23:40:11.856792+08
1417	vertex_ai/zai-org/glm-5-maas	1.000000	3.200000	0.100000	2026-09-23 23:40:11.868107+08
1418	vertex_ai/qwen/qwen3-coder-480b-a35b-instruct-maas	0.220000	1.800000	0.022000	2026-09-23 23:40:11.86874+08
1419	wandb/moonshotai/Kimi-K2.5	0.600000	3.000000	0.100000	2026-09-23 23:40:11.869605+08
1420	wandb/deepseek-ai/DeepSeek-V3.1	0.550000	1.650000	0.000000	2026-09-23 23:40:11.869881+08
1421	zai.glm-5	1.000000	3.200000	0.000000	2026-09-23 23:40:11.870294+08
1422	zai.glm-4.7-flash	0.070000	0.400000	0.000000	2026-09-23 23:40:11.870524+08
1423	zai/glm-5	1.000000	3.200000	0.200000	2026-09-23 23:40:11.87076+08
1424	zai/glm-4.5v	0.600000	1.800000	0.000000	2026-09-23 23:40:11.871892+08
1425	zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-09-23 23:40:11.872229+08
1426	zai/glm-4-32b-0414-128k	0.100000	0.100000	0.000000	2026-09-23 23:40:11.872586+08
1748	deepinfra/Qwen/Qwen2.5-VL-32B-Instruct	0.200000	0.600000	0.000000	2026-09-30 15:21:13.123678+08
1427	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-a35b-instruct	0.450000	1.800000	0.000000	2026-09-23 23:40:11.872968+08
1428	fireworks_ai/accounts/fireworks/models/code-qwen-1p5-7b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.873467+08
1429	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-14b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.873727+08
1430	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-32b	0.900000	0.900000	0.000000	2026-09-23 23:40:11.873975+08
1431	fireworks_ai/accounts/fireworks/models/deepseek-coder-1b-base	0.100000	0.100000	0.000000	2026-09-23 23:40:11.874226+08
1432	fireworks_ai/accounts/fireworks/models/deepseek-coder-33b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.874475+08
1433	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base	0.200000	0.200000	0.000000	2026-09-23 23:40:11.87473+08
1434	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base-v1p5	0.200000	0.200000	0.000000	2026-09-23 23:40:11.875002+08
1435	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-instruct-v1p5	0.200000	0.200000	0.000000	2026-09-23 23:40:11.875253+08
1436	fireworks_ai/accounts/fireworks/models/deepseek-r1-0528-distill-qwen3-8b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.875941+08
1437	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-70b	0.900000	0.900000	0.000000	2026-09-23 23:40:11.876192+08
1438	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-8b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.876455+08
1439	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-14b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.876709+08
1440	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-1p5b	0.100000	0.100000	0.000000	2026-09-23 23:40:11.876979+08
1441	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-32b	0.900000	0.900000	0.000000	2026-09-23 23:40:11.877233+08
1442	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-7b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.877491+08
1443	fireworks_ai/accounts/fireworks/models/dolphin-2-9-2-qwen2-72b	0.900000	0.900000	0.000000	2026-09-23 23:40:11.878013+08
1444	fireworks_ai/accounts/fireworks/models/minimax-m1-80k	0.100000	0.100000	0.000000	2026-09-23 23:40:11.87849+08
1445	fireworks_ai/accounts/fireworks/models/qwen-qwq-32b-preview	0.900000	0.900000	0.000000	2026-09-23 23:40:11.878935+08
1446	fireworks_ai/accounts/fireworks/models/qwen-v2p5-14b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.879183+08
1447	fireworks_ai/accounts/fireworks/models/qwen-v2p5-7b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.879445+08
1448	fireworks_ai/accounts/fireworks/models/qwen1p5-72b-chat	0.900000	0.900000	0.000000	2026-09-23 23:40:11.879738+08
1449	fireworks_ai/accounts/fireworks/models/qwen2-7b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.879994+08
1450	fireworks_ai/accounts/fireworks/models/qwen2-vl-2b-instruct	0.100000	0.100000	0.000000	2026-09-23 23:40:11.880249+08
1451	fireworks_ai/accounts/fireworks/models/qwen2-vl-72b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.880671+08
1452	fireworks_ai/accounts/fireworks/models/qwen2-vl-7b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.880928+08
1453	fireworks_ai/accounts/fireworks/models/qwen2p5-0p5b-instruct	0.100000	0.100000	0.000000	2026-09-23 23:40:11.881212+08
1454	fireworks_ai/accounts/fireworks/models/qwen2p5-14b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.881474+08
1455	fireworks_ai/accounts/fireworks/models/qwen2p5-1p5b-instruct	0.100000	0.100000	0.000000	2026-09-23 23:40:11.881741+08
1456	fireworks_ai/accounts/fireworks/models/qwen2p5-32b	0.900000	0.900000	0.000000	2026-09-23 23:40:11.88199+08
1457	fireworks_ai/accounts/fireworks/models/qwen2p5-32b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.882247+08
1458	fireworks_ai/accounts/fireworks/models/qwen2p5-72b	0.900000	0.900000	0.000000	2026-09-23 23:40:11.882488+08
1459	fireworks_ai/accounts/fireworks/models/qwen2p5-72b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.882737+08
1460	fireworks_ai/accounts/fireworks/models/qwen2p5-7b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.883003+08
1461	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b	0.100000	0.100000	0.000000	2026-09-23 23:40:11.883275+08
1462	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b-instruct	0.100000	0.100000	0.000000	2026-09-23 23:40:11.883561+08
1463	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.883842+08
1464	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.884156+08
1465	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b	0.100000	0.100000	0.000000	2026-09-23 23:40:11.884432+08
1466	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b-instruct	0.100000	0.100000	0.000000	2026-09-23 23:40:11.884716+08
1467	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b	0.900000	0.900000	0.000000	2026-09-23 23:40:11.884991+08
1468	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-128k	0.900000	0.900000	0.000000	2026-09-23 23:40:11.885272+08
1469	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-32k-rope	0.900000	0.900000	0.000000	2026-09-23 23:40:11.885558+08
1470	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-64k	0.900000	0.900000	0.000000	2026-09-23 23:40:11.885834+08
1471	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b	0.100000	0.100000	0.000000	2026-09-23 23:40:11.886119+08
1472	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b-instruct	0.100000	0.100000	0.000000	2026-09-23 23:40:11.886618+08
1473	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.887112+08
1474	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.887399+08
1475	fireworks_ai/accounts/fireworks/models/qwen2p5-math-72b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.88768+08
1476	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-32b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.887965+08
1477	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-3b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.888263+08
1478	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-72b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.888544+08
1479	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-7b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.888829+08
1480	fireworks_ai/accounts/fireworks/models/qwen3-0p6b	0.100000	0.100000	0.000000	2026-09-23 23:40:11.88911+08
1481	fireworks_ai/accounts/fireworks/models/qwen3-14b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.889385+08
1482	fireworks_ai/accounts/fireworks/models/qwen3-1p7b	0.100000	0.100000	0.000000	2026-09-23 23:40:11.889664+08
1483	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft	0.100000	0.100000	0.000000	2026-09-23 23:40:11.889945+08
1484	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-131072	0.100000	0.100000	0.000000	2026-09-23 23:40:11.890239+08
1485	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-40960	0.100000	0.100000	0.000000	2026-09-23 23:40:11.890519+08
1486	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-thinking-2507	0.900000	0.900000	0.000000	2026-09-23 23:40:11.89141+08
1487	fireworks_ai/accounts/fireworks/models/qwen3-32b	0.900000	0.900000	0.000000	2026-09-23 23:40:11.891692+08
1488	fireworks_ai/accounts/fireworks/models/qwen3-4b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.891964+08
1489	fireworks_ai/accounts/fireworks/models/qwen3-4b-instruct-2507	0.200000	0.200000	0.000000	2026-09-23 23:40:11.892245+08
1490	fireworks_ai/accounts/fireworks/models/qwen3-8b	0.200000	0.200000	0.000000	2026-09-23 23:40:11.892527+08
1491	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-instruct-bf16	0.900000	0.900000	0.000000	2026-09-23 23:40:11.894776+08
1492	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.895513+08
1493	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-thinking	0.900000	0.900000	0.000000	2026-09-23 23:40:11.895804+08
1494	fireworks_ai/accounts/fireworks/models/qwen3-reranker-8b	0.200000	0.000000	0.000000	2026-09-23 23:40:11.896351+08
1495	fireworks_ai/accounts/fireworks/models/qwen3-vl-32b-instruct	0.900000	0.900000	0.000000	2026-09-23 23:40:11.897244+08
1496	fireworks_ai/accounts/fireworks/models/qwen3-vl-8b-instruct	0.200000	0.200000	0.000000	2026-09-23 23:40:11.897546+08
1497	fireworks_ai/accounts/fireworks/models/qwen3p7-plus	0.400000	1.600000	0.080000	2026-09-23 23:40:11.897829+08
1498	scaleway/qwen/qwen3.5-397b-a17b	0.600000	3.600000	0.000000	2026-09-23 23:40:11.898475+08
1499	scaleway/qwen/qwen3-embedding-8b	0.100000	0.000000	0.000000	2026-09-23 23:40:11.898963+08
1500	scaleway/qwen/qwen3-coder-30b-a3b-instruct	0.200000	0.800000	0.000000	2026-09-23 23:40:11.899228+08
1501	novita/deepseek/deepseek-v3.2	0.269000	0.400000	0.134500	2026-09-23 23:40:11.899515+08
1502	novita/xiaomimimo/mimo-v2-flash	0.110000	0.330000	0.024000	2026-09-23 23:40:11.900092+08
1503	novita/zai-org/autoglm-phone-9b-multilingual	0.035000	0.138000	0.000000	2026-09-23 23:40:11.900352+08
1504	novita/zai-org/glm-4.6v	0.300000	0.900000	0.055000	2026-09-23 23:40:11.901132+08
1505	novita/qwen/qwen3-max	2.110000	8.450000	0.000000	2026-09-23 23:40:11.90211+08
1506	novita/moonshotai/kimi-k2-instruct	0.570000	2.300000	0.000000	2026-09-23 23:40:11.902851+08
1507	novita/zai-org/glm-4.5v	0.600000	1.800000	0.110000	2026-09-23 23:40:11.90346+08
1508	novita/qwen/qwen-2.5-72b-instruct	0.380000	0.400000	0.000000	2026-09-23 23:40:11.905781+08
1509	novita/deepseek/deepseek-r1-distill-llama-70b	0.800000	0.800000	0.000000	2026-09-23 23:40:11.906955+08
1510	novita/qwen/qwen3-235b-a22b-fp8	0.200000	0.800000	0.000000	2026-09-23 23:40:11.907452+08
1511	novita/qwen/qwen2.5-vl-72b-instruct	0.800000	0.800000	0.000000	2026-09-23 23:40:11.907726+08
1512	novita/qwen/qwen3-32b-fp8	0.100000	0.450000	0.000000	2026-09-23 23:40:11.908116+08
1513	novita/qwen/qwen3-30b-a3b-fp8	0.090000	0.450000	0.000000	2026-09-23 23:40:11.908356+08
1514	novita/deepseek/deepseek-v3-turbo	0.400000	1.300000	0.000000	2026-09-23 23:40:11.908612+08
1515	novita/zai-org/glm-4.5-air	0.130000	0.850000	0.025000	2026-09-23 23:40:11.909104+08
1516	novita/qwen/qwen3-vl-30b-a3b-instruct	0.200000	0.700000	0.000000	2026-09-23 23:40:11.909373+08
1517	novita/qwen/qwen3-vl-30b-a3b-thinking	0.200000	1.000000	0.000000	2026-09-23 23:40:11.909616+08
1518	novita/qwen/qwen3-omni-30b-a3b-thinking	0.250000	0.970000	0.000000	2026-09-23 23:40:11.909856+08
1519	novita/qwen/qwen3-omni-30b-a3b-instruct	0.250000	0.970000	0.000000	2026-09-23 23:40:11.910087+08
1520	novita/qwen/qwen3-8b-fp8	0.035000	0.138000	0.000000	2026-09-23 23:40:11.910494+08
1521	novita/qwen/qwen3-reranker-8b	0.050000	0.050000	0.000000	2026-09-23 23:40:11.911219+08
1522	llamagate/deepseek-r1-8b	0.100000	0.200000	0.000000	2026-09-23 23:40:11.911624+08
1523	bedrock/us-east-1/zai.glm-5	1.000000	3.200000	0.000000	2026-09-23 23:40:11.913481+08
1524	bedrock/us-west-2/zai.glm-5	1.000000	3.200000	0.000000	2026-09-23 23:40:11.913717+08
1525	tensormesh/Qwen/Qwen3.5-397B-A17B-FP8	0.600000	3.600000	0.000000	2026-09-23 23:40:11.913989+08
1526	tensormesh/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	0.450000	1.800000	0.000000	2026-09-23 23:40:11.914244+08
1527	tensormesh/Qwen/Qwen3.6-27B-FP8	0.320000	3.200000	0.000000	2026-09-23 23:40:11.914503+08
1528	deepseek-v4-pro	1.320000	3.960000	0.044000	2026-09-23 23:40:11.915604+08
1529	deepseek/deepseek-v4-pro	1.320000	3.960000	0.044000	2026-09-23 23:40:11.916223+08
1530	pinstripes/ps/glm-4.5-air	0.125000	0.450000	0.000000	2026-09-23 23:40:11.916815+08
1531	pinstripes/ps/qwen3.6-35b-a3b	0.140000	0.450000	0.000000	2026-09-23 23:40:11.917119+08
1532	pinstripes/ps/qwen3-30b-a3b	0.090000	0.200000	0.000000	2026-09-23 23:40:11.917376+08
1533	pinstripes/ps/deepseek-v4-flash	0.100000	0.200000	0.000000	2026-09-23 23:40:11.917743+08
1534	fireworks_ai/glm-5p2-fast	2.100000	6.600000	0.210000	2026-09-23 23:40:11.919123+08
1535	fireworks_ai/glm-5p2-fast-us	2.100000	6.600000	0.210000	2026-09-23 23:40:11.919576+08
1536	fireworks_ai/kimi-k3-fast	4.500000	22.500000	0.450000	2026-09-23 23:40:11.91997+08
1537	fireworks_ai/kimi-k3-us	3.300000	16.500000	0.330000	2026-09-23 23:40:11.920221+08
1538	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast	2.100000	6.600000	0.210000	2026-09-23 23:40:11.920741+08
1539	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast-us	2.100000	6.600000	0.210000	2026-09-23 23:40:11.921013+08
1540	fireworks_ai/accounts/fireworks/routers/kimi-k3-fast	4.500000	22.500000	0.450000	2026-09-23 23:40:11.921267+08
1541	fireworks_ai/accounts/fireworks/routers/kimi-k3-us	3.300000	16.500000	0.330000	2026-09-23 23:40:11.921518+08
1542	novita/deepseek/deepseek-v4-pro-0813	1.320000	3.960000	0.132000	2026-09-23 23:40:11.92188+08
1543	novita/xiaomimimo/mimo-v2.5	0.168000	0.336000	0.003400	2026-09-23 23:40:11.923898+08
1544	novita/xiaomimimo/mimo-v2.5-pro	0.522000	1.044000	0.004300	2026-09-23 23:40:11.926085+08
1545	wandb/deepseek-ai/DeepSeek-V4-Pro	1.150000	2.550000	0.200000	2026-09-23 23:40:11.929685+08
1546	wandb/MiniMaxAI/MiniMax-M3	0.230000	0.960000	0.050000	2026-09-23 23:40:11.929975+08
1547	wandb/OpenPipe/Qwen3-14B-Instruct	0.050000	0.220000	0.000000	2026-09-23 23:40:11.930476+08
1548	wandb/Qwen/Qwen3.8-27B	0.400000	3.000000	0.150000	2026-09-23 23:40:11.930754+08
1549	wandb/Qwen/Qwen3.6-27B	0.600000	3.600000	0.120000	2026-09-23 23:40:11.931147+08
1550	wandb/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-09-23 23:40:11.931529+08
1551	wandb/deepseek-ai/DeepSeek-V4-Pro-0813	1.310000	3.960000	0.044000	2026-09-23 23:40:11.931786+08
1552	deepinfra/MiniMaxAI/MiniMax-M2.7	0.250000	1.000000	0.050000	2026-09-23 23:40:11.932199+08
1553	deepinfra/Qwen/Qwen3.8-27B	0.400000	3.000000	0.040000	2026-09-23 23:40:11.932471+08
1554	deepinfra/moonshotai/Kimi-K2.5	0.450000	2.250000	0.070000	2026-09-23 23:40:11.932745+08
1555	deepinfra/zai-org/GLM-4.7-Flash	0.060000	0.400000	0.010000	2026-09-23 23:40:11.933036+08
1556	deepinfra/zai-org/GLM-4.6	0.500000	2.000000	0.100000	2026-09-23 23:40:11.933488+08
1557	deepinfra/XiaomiMiMo/MiMo-V2.5	0.400000	2.000000	0.080000	2026-09-23 23:40:11.933815+08
1558	deepinfra/Qwen/Qwen3-VL-235B-A22B-Instruct	0.200000	0.880000	0.110000	2026-09-23 23:40:11.934408+08
1559	deepinfra/Qwen/Qwen3.6-35B-A3B	0.100000	0.950000	0.000000	2026-09-23 23:40:11.934884+08
1560	deepinfra/deepseek-ai/DeepSeek-V4-Pro-0813	1.300000	2.600000	0.100000	2026-09-23 23:40:11.93525+08
1561	deepinfra/Qwen/Qwen3.8-2.4T-A95B	2.000000	6.000000	0.200000	2026-09-23 23:40:11.935639+08
1562	deepinfra/Qwen/Qwen3.5-35B-A3B	0.140000	1.000000	0.050000	2026-09-23 23:40:11.936016+08
1563	deepinfra/moonshotai/Kimi-K2.7-Code	0.680000	3.400000	0.136000	2026-09-23 23:40:11.936394+08
1564	deepinfra/Qwen/Qwen3.5-397B-A17B	0.450000	3.000000	0.220000	2026-09-23 23:40:11.936655+08
1565	deepinfra/Qwen/Qwen3.8-Max	1.650000	4.951000	0.206000	2026-09-23 23:40:11.937155+08
1566	deepinfra/zai-org/GLM-5.1	1.050000	3.500000	0.205000	2026-09-23 23:40:11.937555+08
1567	deepinfra/deepseek-ai/DeepSeek-V4-Pro	1.300000	2.600000	0.100000	2026-09-23 23:40:11.937804+08
1568	deepinfra/moonshotai/Kimi-K3	2.850000	14.250000	0.285000	2026-09-23 23:40:11.938181+08
1569	deepinfra/Qwen/Qwen3.6-27B	0.320000	3.200000	0.000000	2026-09-23 23:40:11.938462+08
1570	deepinfra/XiaomiMiMo/MiMo-V2.5-Pro	1.000000	3.000000	0.200000	2026-09-23 23:40:11.938924+08
1571	deepinfra/Qwen/Qwen3.5-9B	0.100000	0.150000	0.000000	2026-09-23 23:40:11.939302+08
1572	deepinfra/zai-org/GLM-4.7	0.400000	1.750000	0.080000	2026-09-23 23:40:11.939679+08
1573	groq/qwen/qwen3.8-27b	0.800000	4.000000	0.000000	2026-09-23 23:40:11.939951+08
1574	fireworks_ai/glm-5p3	1.400000	4.400000	0.260000	2026-09-23 23:40:11.940403+08
1575	fireworks_ai/accounts/fireworks/routers/glm-5p3-fast	2.100000	6.600000	0.390000	2026-09-23 23:40:11.940651+08
1576	fireworks_ai/glm-5p3-fast	2.100000	6.600000	0.390000	2026-09-23 23:40:11.94131+08
1577	fireworks_ai/glm-5p3-flash	0.150000	0.500000	0.030000	2026-09-23 23:40:11.941764+08
1578	fireworks_ai/accounts/fireworks/models/qwen3-embedding-8b	0.100000	0.000000	0.000000	2026-09-23 23:40:11.942026+08
1579	together_ai/Qwen/Qwen3.8-Flash	0.090000	0.282000	0.000000	2026-09-23 23:40:11.942477+08
1580	scaleway/glm-5.2	1.800000	5.500000	0.000000	2026-09-23 23:40:11.943128+08
1581	scaleway/deepseek-v4-flash-0731	0.400000	0.800000	0.080000	2026-09-23 23:40:11.943387+08
1582	openrouter/z-ai/glm-5.3-flash	0.150000	0.500000	0.050000	2026-09-23 23:40:11.944601+08
1583	openrouter/z-ai/glm-5.3	0.653800	2.054800	0.121420	2026-09-23 23:40:11.944953+08
1584	openrouter/qwen/qwen3.8-27b	0.420000	3.000000	0.085000	2026-09-23 23:40:11.945229+08
1585	openrouter/deepseek/deepseek-v4-flash-0731	0.040000	0.640000	0.016000	2026-09-23 23:40:11.945826+08
1586	openrouter/moonshotai/kimi-k3	3.000000	15.000000	0.300000	2026-09-23 23:40:11.946219+08
1587	openrouter/z-ai/glm-5.2	0.649600	2.041600	0.120640	2026-09-23 23:40:11.946496+08
1588	openrouter/moonshotai/kimi-k2.7-code	0.706200	3.300000	0.180000	2026-09-23 23:40:11.946857+08
1589	openrouter/qwen/qwen3.5-plus-20260420	0.300000	1.800000	0.000000	2026-09-23 23:40:11.947344+08
1590	openrouter/qwen/qwen3.6-35b-a3b	0.150000	1.000000	0.050000	2026-09-23 23:40:11.947719+08
1591	openrouter/qwen/qwen3.6-max-preview	1.027000	6.162000	0.000000	2026-09-23 23:40:11.948006+08
1592	openrouter/qwen/qwen3.6-27b	0.320000	2.700000	0.150000	2026-09-23 23:40:11.948265+08
1593	openrouter/deepseek/deepseek-v4-flash	0.049000	0.098000	0.009800	2026-09-23 23:40:11.948531+08
1594	openrouter/qwen/qwen3.5-9b	0.100000	0.150000	0.000000	2026-09-23 23:40:11.94938+08
1595	openrouter/qwen/qwen3-coder-next	0.120000	0.800000	0.070000	2026-09-23 23:40:11.949762+08
1596	openrouter/z-ai/glm-4.6v	0.300000	0.900000	0.055000	2026-09-23 23:40:11.950343+08
1597	openrouter/qwen/qwen3-vl-32b-instruct	0.104000	0.416000	0.000000	2026-09-23 23:40:11.950754+08
1598	openrouter/qwen/qwen3-vl-8b-thinking	0.180000	2.100000	0.000000	2026-09-23 23:40:11.950996+08
1599	openrouter/qwen/qwen3-vl-8b-instruct	0.117000	0.455000	0.000000	2026-09-23 23:40:11.951235+08
1600	openrouter/qwen/qwen3-vl-30b-a3b-thinking	0.200000	2.400000	0.000000	2026-09-23 23:40:11.951497+08
1601	openrouter/qwen/qwen3-vl-30b-a3b-instruct	0.130000	0.520000	0.000000	2026-09-23 23:40:11.951755+08
1602	openrouter/qwen/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-23 23:40:11.952015+08
1603	openrouter/qwen/qwen3-vl-235b-a22b-instruct	0.210000	1.900000	0.100000	2026-09-23 23:40:11.952279+08
1604	openrouter/qwen/qwen-plus-2025-07-28	0.260000	0.780000	0.052000	2026-09-23 23:40:11.953137+08
1605	openrouter/qwen/qwen3-30b-a3b-thinking-2507	0.200000	2.400000	0.000000	2026-09-23 23:40:11.953546+08
1606	openrouter/z-ai/glm-4.5v	0.600000	1.800000	0.110000	2026-09-23 23:40:11.953793+08
1607	openrouter/qwen/qwen3-30b-a3b-instruct-2507	0.048150	0.193050	0.000000	2026-09-23 23:40:11.954153+08
1608	openrouter/z-ai/glm-4.5-air	0.130000	0.850000	0.025000	2026-09-23 23:40:11.954526+08
1609	openrouter/moonshotai/kimi-k2	0.570000	2.300000	0.000000	2026-09-23 23:40:11.954781+08
1610	openrouter/minimax/minimax-m1	0.400000	2.200000	0.000000	2026-09-23 23:40:11.955032+08
1611	openrouter/qwen/qwen3-8b	0.117000	0.455000	0.000000	2026-09-23 23:40:11.955403+08
1612	openrouter/qwen/qwen3-14b	0.120000	0.240000	0.000000	2026-09-23 23:40:11.955663+08
1613	openrouter/qwen/qwen3-235b-a22b	0.455000	1.820000	0.000000	2026-09-23 23:40:11.956039+08
1614	openrouter/qwen/qwen2.5-vl-72b-instruct	0.800000	1.000000	0.400000	2026-09-23 23:40:11.95629+08
1615	openrouter/qwen/qwen-plus	0.260000	0.780000	0.052000	2026-09-23 23:40:11.956532+08
1616	openrouter/deepseek/deepseek-r1-distill-llama-70b	0.800000	0.800000	0.000000	2026-09-23 23:40:11.956791+08
1617	openrouter/minimax/minimax-01	0.200000	1.100000	0.000000	2026-09-23 23:40:11.957071+08
1618	openrouter/qwen/qwen-2.5-7b-instruct	0.100000	0.200000	0.000000	2026-09-23 23:40:11.957333+08
1619	openrouter/qwen/qwen-2.5-72b-instruct	0.360000	0.400000	0.000000	2026-09-23 23:40:11.957598+08
1620	together_ai/Qwen/Qwen2.5-14B-Instruct	0.800000	0.800000	0.000000	2026-09-23 23:40:11.958+08
1621	aihubmix/coding-kimi-k3	0.440000	1.613330	0.066000	2026-09-23 23:40:11.958653+08
1622	aihubmix/coding-xiaomi-mimo-v2-omni	0.080000	0.400000	0.016000	2026-09-23 23:40:11.958973+08
1623	aihubmix/coding-xiaomi-mimo-v2.5	0.080000	0.160000	0.001600	2026-09-23 23:40:11.959296+08
1624	aihubmix/coding-xiaomi-mimo-v2.5-pro	0.200000	0.400000	0.001600	2026-09-23 23:40:11.959728+08
1625	aihubmix/deepseek-v4-flash	0.142000	0.284000	0.028400	2026-09-23 23:40:11.960151+08
1626	aihubmix/glm-5.3	1.126800	3.943800	0.281700	2026-09-23 23:40:11.960649+08
1627	aihubmix/glm-5v-turbo	0.704200	3.098480	0.169008	2026-09-23 23:40:11.961008+08
1628	aihubmix/kimi-k2.6	0.950000	3.999500	0.160835	2026-09-23 23:40:11.961265+08
1629	aihubmix/kimi-k2.7-code-highspeed	1.900000	7.999000	0.321670	2026-09-23 23:40:11.961503+08
1630	aihubmix/mimo-v2-omni	0.440000	2.200000	0.088000	2026-09-23 23:40:11.961921+08
1631	aihubmix/mimo-v2-pro	1.100000	3.300000	0.220000	2026-09-23 23:40:11.96223+08
1632	aihubmix/minimax-m2.7	0.295800	1.183200	0.059160	2026-09-23 23:40:11.962483+08
1633	aihubmix/qwen3-coder-next	0.137000	0.548000	0.000000	2026-09-23 23:40:11.962853+08
1634	aihubmix/qwen3.5-397b-a17b	0.164400	0.986400	0.000000	2026-09-23 23:40:11.963231+08
1635	aihubmix/qwen3.7-plus	0.282000	1.128000	0.056400	2026-09-23 23:40:11.96384+08
1636	aihubmix/qwen3.8-max	1.690000	5.070000	0.169000	2026-09-23 23:40:11.964332+08
1637	wandb/zai-org/GLM-5.3-Flash	0.150000	0.500000	0.050000	2026-09-23 23:40:11.964662+08
1638	openrouter/~deepseek/deepseek-flash-latest	0.300000	1.200000	0.006000	2026-09-23 23:40:11.965015+08
1639	openrouter/~deepseek/deepseek-pro-latest	1.320000	3.960000	0.044000	2026-09-23 23:40:11.965312+08
1640	openrouter/~deepseek/deepseek-v4-flash-latest	0.040000	0.640000	0.016000	2026-09-23 23:40:11.965622+08
1641	openrouter/~moonshotai/kimi-latest	3.000000	15.000000	0.300000	2026-09-23 23:40:11.966333+08
1642	openrouter/~z-ai/glm-flash-latest	0.150000	0.500000	0.050000	2026-09-23 23:40:11.966637+08
1643	openrouter/~z-ai/glm-latest	0.653800	2.054800	0.121420	2026-09-23 23:40:11.966936+08
1644	openrouter/moonshotai/kimi-k3:batch	2.280000	11.400000	0.228000	2026-09-23 23:40:11.967494+08
1645	openrouter/qwen/qwen3.8-27b:free	0.000000	0.000000	0.000000	2026-09-23 23:40:11.967868+08
1646	openrouter/z-ai/glm-5.3-flash:batch	0.060000	0.200000	0.012000	2026-09-23 23:40:11.968229+08
1647	openrouter/z-ai/glm-5.3:batch	0.720000	2.400000	0.120000	2026-09-23 23:40:11.968566+08
1648	openrouter/z-ai/glm-5.3-flashx	0.370000	1.250000	0.075000	2026-09-23 23:40:11.968918+08
1649	moonshotai.kimi-k3	3.000000	15.000000	0.300000	2026-09-23 23:40:11.969266+08
1650	global.moonshotai.kimi-k3	3.000000	15.000000	0.300000	2026-09-23 23:40:11.969591+08
1651	us.moonshotai.kimi-k3	3.300000	16.500000	0.330000	2026-09-23 23:40:11.96991+08
1652	openrouter/xiaomi/mimo-v2.6-flash	0.140000	0.280000	0.002800	2026-09-23 23:40:11.970247+08
1653	openrouter/xiaomi/mimo-v2.6-pro	0.435000	0.870000	0.003600	2026-09-23 23:40:11.970573+08
1654	openrouter/xiaomi/mimo-v2.6-pro-ultraspeed	4.350000	8.700000	0.036000	2026-09-23 23:40:11.970915+08
1655	xiaomi_mimo/mimo-v2.6-pro	0.435000	0.870000	0.003600	2026-09-23 23:40:11.971257+08
1656	xiaomi_mimo/mimo-v2.6-flash	0.140000	0.280000	0.002800	2026-09-23 23:40:11.971739+08
1657	baseten/deepseek-ai/DeepSeek-V4.1-Flash	0.300000	1.200000	0.007000	2026-09-23 23:40:11.972068+08
1658	baseten/moonshotai/Kimi-K2.6	0.950000	4.000000	0.160000	2026-09-23 23:40:11.972374+08
1659	baseten/moonshotai/Kimi-K2.7-Code	0.950000	4.000000	0.160000	2026-09-23 23:40:11.972671+08
1660	baseten/moonshotai/Kimi-K3	3.000000	15.000000	0.300000	2026-09-23 23:40:11.972993+08
1661	baseten/zai-org/GLM-5.2	1.400000	4.400000	0.140000	2026-09-23 23:40:11.973319+08
1662	baseten/zai-org/GLM-5.3-Flash	0.150000	0.500000	0.030000	2026-09-23 23:40:11.973628+08
1663	baseten/deepseek-ai/DeepSeek-V4-Flash-0731	0.130000	0.260000	0.028000	2026-09-23 23:40:11.973958+08
1664	baseten/deepseek-ai/DeepSeek-V4-Pro	1.740000	3.480000	0.145000	2026-09-23 23:40:11.974346+08
1665	baseten/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.132000	2026-09-23 23:40:11.974678+08
1666	baseten/zai-org/GLM-5.2-Fast	2.100000	6.600000	0.210000	2026-09-23 23:40:11.975005+08
1667	openrouter/deepseek/deepseek-v4.1-flash:batch	0.112000	0.336000	0.003360	2026-09-23 23:40:11.975339+08
1668	openrouter/qwen/qwen3.8-omni-flash	0.150000	0.470000	0.016000	2026-09-23 23:40:11.975678+08
1669	vertex_ai/zai-org/glm-5.2-maas	1.400000	4.400000	0.140000	2026-09-23 23:40:11.976017+08
1670	azure_ai/FW-DeepSeek-V4-Pro	1.925000	3.828000	0.165000	2026-09-30 15:21:13.03028+08
1671	azure_ai/FW-GLM-5.2-Fast	2.310000	7.260000	0.231000	2026-09-30 15:21:13.037429+08
1672	azure_ai/FW-Kimi-K2.5	0.660000	3.300000	0.110000	2026-09-30 15:21:13.038825+08
1673	azure_ai/FW-Kimi-K2.7-Code	1.050000	4.400000	0.210000	2026-09-30 15:21:13.040779+08
1674	azure_ai/FW-MiniMax-M2.5	0.330000	1.320000	0.033000	2026-09-30 15:21:13.042161+08
1675	azure_ai/FW-MiniMax-M3	0.330000	1.320000	0.066000	2026-09-30 15:21:13.042943+08
1676	azure_ai/deepseek-v3	1.140000	4.560000	0.000000	2026-09-30 15:21:13.044588+08
1677	azure_ai/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-30 15:21:13.04725+08
1678	bedrock/ap-northeast-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-30 15:21:13.048374+08
1679	bedrock/ap-northeast-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-30 15:21:13.050268+08
1680	bedrock/ap-south-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-30 15:21:13.052426+08
1681	bedrock/ap-south-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-30 15:21:13.054294+08
1682	bedrock/ap-southeast-2/minimax.minimax-m2.5	0.310000	1.240000	0.000000	2026-09-30 15:21:13.055256+08
1683	bedrock/ap-southeast-3/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-30 15:21:13.055788+08
1684	bedrock/ap-southeast-3/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-30 15:21:13.056829+08
1685	bedrock/eu-north-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-30 15:21:13.057665+08
1686	bedrock/eu-north-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-30 15:21:13.058719+08
1687	bedrock/eu-west-2/minimax.minimax-m2.1	0.470000	1.860000	0.000000	2026-09-30 15:21:13.06141+08
1688	bedrock/eu-west-2/minimax.minimax-m2.5	0.470000	1.860000	0.000000	2026-09-30 15:21:13.062144+08
1689	bedrock/eu-west-2/qwen.qwen3-coder-next	0.780000	1.860000	0.000000	2026-09-30 15:21:13.062773+08
1690	bedrock/sa-east-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-30 15:21:13.064306+08
1691	bedrock/sa-east-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-09-30 15:21:13.066053+08
1692	cerebras/qwen-3-32b	0.400000	0.800000	0.000000	2026-09-30 15:21:13.072427+08
1693	cerebras/qwen-3.8-27b	0.990000	1.490000	0.000000	2026-09-30 15:21:13.0733+08
1694	cloudflare/@cf/deepseek-ai/deepseek-r1-distill-qwen-32b	0.497000	4.881000	0.000000	2026-09-30 15:21:13.074178+08
1695	cloudflare/@cf/zai-org/glm-4.7-flash	0.060500	0.400000	0.000000	2026-09-30 15:21:13.074979+08
1696	dashscope/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-30 15:21:13.077648+08
1697	dashscope/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-30 15:21:13.078191+08
1698	dashscope/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-30 15:21:13.078725+08
1699	dashscope/qwen-max	1.600000	6.400000	0.000000	2026-09-30 15:21:13.080868+08
1700	dashscope/qwen-plus	0.400000	1.200000	0.000000	2026-09-30 15:21:13.081405+08
1701	dashscope/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-30 15:21:13.081943+08
1702	dashscope/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-30 15:21:13.082478+08
1703	dashscope/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-30 15:21:13.082969+08
1704	dashscope/qwen-turbo	0.050000	0.200000	0.000000	2026-09-30 15:21:13.084289+08
1705	dashscope/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-30 15:21:13.084799+08
1706	dashscope/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-30 15:21:13.085307+08
1707	dashscope/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-30 15:21:13.085809+08
1708	dashscope/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-30 15:21:13.088978+08
1709	dashscope/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-30 15:21:13.089496+08
1710	qwencloud/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-30 15:21:13.093814+08
1711	qwencloud/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-30 15:21:13.094319+08
1712	qwencloud/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-30 15:21:13.094771+08
1713	qwencloud/qwen-max	1.600000	6.400000	0.000000	2026-09-30 15:21:13.096669+08
1714	qwencloud/qwen-plus	0.400000	1.200000	0.000000	2026-09-30 15:21:13.097129+08
1715	qwencloud/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-30 15:21:13.097594+08
1716	qwencloud/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-30 15:21:13.098887+08
1717	qwencloud/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-30 15:21:13.099342+08
1718	qwencloud/qwen-turbo	0.050000	0.200000	0.000000	2026-09-30 15:21:13.100696+08
1719	qwencloud/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-30 15:21:13.101164+08
1720	qwencloud/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-30 15:21:13.10161+08
1721	qwencloud/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-30 15:21:13.102063+08
1722	qwencloud/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-30 15:21:13.105185+08
1723	qwencloud/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-30 15:21:13.105654+08
1724	qwencloud/qwq-plus	0.800000	2.400000	0.000000	2026-09-30 15:21:13.107886+08
1725	qwen_ai_platform/deepseek-v4-flash	0.200000	0.400000	0.040000	2026-09-30 15:21:13.109315+08
1726	qwen_ai_platform/deepseek-v4-flash-0731	0.200000	0.400000	0.040000	2026-09-30 15:21:13.110078+08
1727	qwen_ai_platform/deepseek-v4-pro	2.400000	4.800000	0.200000	2026-09-30 15:21:13.110498+08
1728	qwen_ai_platform/qwen-max	1.600000	6.400000	0.000000	2026-09-30 15:21:13.112315+08
1729	qwen_ai_platform/qwen-plus	0.400000	1.200000	0.000000	2026-09-30 15:21:13.112736+08
1730	qwen_ai_platform/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-09-30 15:21:13.113165+08
1731	qwen_ai_platform/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-09-30 15:21:13.113591+08
1732	qwen_ai_platform/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-09-30 15:21:13.114011+08
1733	qwen_ai_platform/qwen-turbo	0.050000	0.200000	0.000000	2026-09-30 15:21:13.114926+08
1734	qwen_ai_platform/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-09-30 15:21:13.115277+08
1735	qwen_ai_platform/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-09-30 15:21:13.115631+08
1736	qwen_ai_platform/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-09-30 15:21:13.115952+08
1737	qwen_ai_platform/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-09-30 15:21:13.117724+08
1738	qwen_ai_platform/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-30 15:21:13.118053+08
1739	qwen_ai_platform/qwq-plus	0.800000	2.400000	0.000000	2026-09-30 15:21:13.119513+08
1740	databricks/databricks-deepseek-v4-pro-0813	1.319990	3.959970	0.132020	2026-09-30 15:21:13.120479+08
1741	databricks/databricks-glm-5-2	1.400000	4.399990	0.259980	2026-09-30 15:21:13.120802+08
1742	databricks/databricks-glm-5-3	1.400000	4.399990	0.259980	2026-09-30 15:21:13.121106+08
1743	databricks/databricks-glm-5-3-flash	0.150010	0.500010	0.030030	2026-09-30 15:21:13.121397+08
1744	databricks/databricks-qwen35-122b-a10b	0.220010	2.200030	0.220010	2026-09-30 15:21:13.121851+08
1745	deepinfra/Qwen/QwQ-32B	0.150000	0.400000	0.000000	2026-09-30 15:21:13.122499+08
1746	deepinfra/Qwen/Qwen2.5-72B-Instruct	0.360000	0.400000	0.000000	2026-09-30 15:21:13.123111+08
1747	deepinfra/Qwen/Qwen2.5-7B-Instruct	0.040000	0.100000	0.000000	2026-09-30 15:21:13.123389+08
1749	deepinfra/Qwen/Qwen3-235B-A22B-Thinking-2507	0.300000	2.900000	0.000000	2026-09-30 15:21:13.124748+08
1750	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct	0.400000	1.600000	0.000000	2026-09-30 15:21:13.125335+08
1751	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct-Turbo	0.300000	1.000000	0.100000	2026-09-30 15:21:13.125628+08
1752	deepinfra/deepseek-ai/DeepSeek-R1-0528	0.500000	2.150000	0.400000	2026-09-30 15:21:13.126365+08
1753	deepinfra/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	0.200000	0.600000	0.000000	2026-09-30 15:21:13.126803+08
1754	deepinfra/deepseek-ai/DeepSeek-V3	0.320000	0.890000	0.000000	2026-09-30 15:21:13.127345+08
1755	deepinfra/deepseek-ai/DeepSeek-V3-0324	0.240000	0.900000	0.135000	2026-09-30 15:21:13.127646+08
1756	deepinfra/moonshotai/Kimi-K2-Instruct-0905	0.500000	2.000000	0.400000	2026-09-30 15:21:13.128512+08
1757	deepinfra/zai-org/GLM-4.5	0.400000	1.600000	0.000000	2026-09-30 15:21:13.128801+08
1758	deepseek/deepseek-r1	0.550000	2.190000	0.140000	2026-09-30 15:21:13.12933+08
1759	deepseek/deepseek-v3.2	0.280000	0.400000	0.028000	2026-09-30 15:21:13.129875+08
1760	sail/moonshotai/Kimi-K3	2.500000	12.500000	0.250000	2026-09-30 15:21:13.132612+08
1761	sail/zai-org/GLM-5.3	0.980000	3.080000	0.180000	2026-09-30 15:21:13.132959+08
1762	sail/zai-org/GLM-5.3-Flash	0.110000	0.350000	0.020000	2026-09-30 15:21:13.133317+08
1763	sail/deepseek-ai/DeepSeek-V4-Pro-0813	0.920000	2.770000	0.040000	2026-09-30 15:21:13.133681+08
1764	sail/deepseek-ai/DeepSeek-V4-Flash-0731	0.090000	0.180000	0.020000	2026-09-30 15:21:13.134362+08
1765	sail/deepseek-ai/DeepSeek-V4.1-Flash	0.150000	0.600000	0.006000	2026-09-30 15:21:13.134729+08
1766	sail/moonshotai/Kimi-K2.6	1.000000	4.000000	0.200000	2026-09-30 15:21:13.135254+08
1767	sail/Qwen/Qwen3.6-35B-A3B	0.050000	0.400000	0.020000	2026-09-30 15:21:13.13562+08
1768	fireworks_ai/accounts/fireworks/models/deepseek-r1-basic	0.550000	2.190000	0.000000	2026-09-30 15:21:13.136868+08
1769	fireworks_ai/accounts/fireworks/models/deepseek-v3	0.900000	0.900000	0.000000	2026-09-30 15:21:13.137274+08
1770	fireworks_ai/accounts/fireworks/models/deepseek-v3-0324	0.900000	0.900000	0.000000	2026-09-30 15:21:13.137562+08
1771	fireworks_ai/accounts/fireworks/models/deepseek-v4-pro-0813	1.320000	3.960000	0.044000	2026-09-30 15:21:13.138404+08
1772	fireworks_ai/deepseek-v4-pro-0813	1.320000	3.960000	0.044000	2026-09-30 15:21:13.138854+08
1773	fireworks_ai/accounts/fireworks/models/glm-4p5	0.550000	2.190000	0.000000	2026-09-30 15:21:13.13914+08
1774	fireworks_ai/accounts/fireworks/models/glm-4p6	0.550000	2.190000	0.000000	2026-09-30 15:21:13.139573+08
1775	fireworks_ai/accounts/fireworks/models/kimi-k2p5	0.600000	3.000000	0.100000	2026-09-30 15:21:13.141047+08
1776	fireworks_ai/accounts/fireworks/models/qwen2-72b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.141851+08
1777	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.142145+08
1778	fireworks_ai/kimi-k2p5	0.600000	3.000000	0.100000	2026-09-30 15:21:13.143063+08
1779	fireworks_ai/qwen3p7-plus	0.400000	1.600000	0.080000	2026-09-30 15:21:13.144122+08
1780	friendliai/zai-org/GLM-5.3	1.260000	3.960000	0.234000	2026-09-30 15:21:13.144665+08
1781	gmi/deepseek-ai/DeepSeek-V3.2	0.280000	0.400000	0.000000	2026-09-30 15:21:13.145671+08
1782	gmi/moonshotai/Kimi-K2-Thinking	0.800000	1.200000	0.000000	2026-09-30 15:21:13.146063+08
1783	gmi/zai-org/GLM-4.7-FP8	0.400000	2.000000	0.000000	2026-09-30 15:21:13.147666+08
1784	gradient_ai/deepseek-r1-distill-llama-70b	0.990000	0.990000	0.000000	2026-09-30 15:21:13.148412+08
1785	hyperbolic/Qwen/QwQ-32B	0.200000	0.200000	0.000000	2026-09-30 15:21:13.148958+08
1786	hyperbolic/deepseek-ai/DeepSeek-R1	0.400000	0.400000	0.000000	2026-09-30 15:21:13.149594+08
1787	hyperbolic/deepseek-ai/DeepSeek-V3	0.200000	0.200000	0.000000	2026-09-30 15:21:13.149972+08
1788	hyperbolic/deepseek-ai/DeepSeek-V3-0324	0.400000	0.400000	0.000000	2026-09-30 15:21:13.15023+08
1789	lambda_ai/deepseek-llama3.3-70b	0.200000	0.600000	0.000000	2026-09-30 15:21:13.15112+08
1790	lambda_ai/deepseek-r1-0528	0.200000	0.600000	0.000000	2026-09-30 15:21:13.151401+08
1791	lambda_ai/deepseek-r1-671b	0.800000	0.800000	0.000000	2026-09-30 15:21:13.151661+08
1792	lambda_ai/deepseek-v3-0324	0.200000	0.600000	0.000000	2026-09-30 15:21:13.151933+08
1793	lambda_ai/qwen25-coder-32b-instruct	0.050000	0.100000	0.000000	2026-09-30 15:21:13.152206+08
1794	lambda_ai/qwen3-32b-fp8	0.050000	0.100000	0.000000	2026-09-30 15:21:13.152459+08
1795	moonshot/kimi-k2.5	0.600000	3.000000	0.100000	2026-09-30 15:21:13.155543+08
1796	moonshot/moonshot-v1-8k	0.200000	2.000000	0.000000	2026-09-30 15:21:13.156733+08
1797	moonshot/moonshot-v1-8k-vision-preview	0.200000	2.000000	0.000000	2026-09-30 15:21:13.157265+08
1798	nscale/Qwen/QwQ-32B	0.180000	0.200000	0.000000	2026-09-30 15:21:13.157664+08
1799	nscale/Qwen/Qwen2.5-Coder-32B-Instruct	0.060000	0.200000	0.000000	2026-09-30 15:21:13.15793+08
1800	nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-8B	0.025000	0.025000	0.000000	2026-09-30 15:21:13.158568+08
1801	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B	0.200000	0.200000	0.000000	2026-09-30 15:21:13.159364+08
1802	nebius/deepseek-ai/DeepSeek-R1	0.800000	2.400000	0.000000	2026-09-30 15:21:13.159632+08
1803	nebius/deepseek-ai/DeepSeek-R1-0528	0.800000	2.400000	0.000000	2026-09-30 15:21:13.159891+08
1804	nebius/Qwen/Qwen3-235B-A22B	0.200000	0.600000	0.000000	2026-09-30 15:21:13.160497+08
1805	nebius/Qwen/Qwen3-32B	0.100000	0.300000	0.000000	2026-09-30 15:21:13.160755+08
1806	nebius/Qwen/Qwen3-30B-A3B	0.100000	0.300000	0.000000	2026-09-30 15:21:13.161009+08
1807	nebius/Qwen/QwQ-32B	0.150000	0.450000	0.000000	2026-09-30 15:21:13.161495+08
1808	nebius/Qwen/Qwen2.5-72B-Instruct	0.130000	0.400000	0.000000	2026-09-30 15:21:13.161759+08
1809	nebius/Qwen/Qwen2.5-32B-Instruct	0.060000	0.200000	0.000000	2026-09-30 15:21:13.162008+08
1810	nebius/Qwen/Qwen2-VL-72B-Instruct	0.130000	0.400000	0.000000	2026-09-30 15:21:13.162528+08
1811	nebius/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.000000	2026-09-30 15:21:13.163248+08
1812	nebius/deepseek-ai/DeepSeek-V4.1-Flash	0.300000	1.200000	0.000000	2026-09-30 15:21:13.163825+08
1813	nebius/Qwen/Qwen3-235B-A22B-Instruct-2507	0.200000	0.600000	0.000000	2026-09-30 15:21:13.164635+08
1814	nebius/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-09-30 15:21:13.164888+08
1815	nebius/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.000000	2026-09-30 15:21:13.165263+08
1816	openrouter/deepseek/deepseek-chat	0.257400	1.028700	0.000000	2026-09-30 15:21:13.166775+08
1817	openrouter/deepseek/deepseek-chat-v3-0324	0.290000	1.140000	0.110000	2026-09-30 15:21:13.167024+08
1818	openrouter/deepseek/deepseek-v3.2	0.280000	0.420000	0.028000	2026-09-30 15:21:13.167374+08
1819	openrouter/deepseek/deepseek-r1-0528	0.500000	2.150000	0.350000	2026-09-30 15:21:13.167821+08
1820	openrouter/deepseek/deepseek-v4-pro	0.948300	1.896600	0.079025	2026-09-30 15:21:13.168065+08
1821	openrouter/deepseek/deepseek-v4-pro-0813	0.242980	4.200000	0.172000	2026-09-30 15:21:13.168422+08
1822	openrouter/minimax/minimax-m2	0.300000	1.200000	0.000000	2026-09-30 15:21:13.168691+08
1823	openrouter/moonshotai/kimi-k2.5	0.450000	2.250000	0.070000	2026-09-30 15:21:13.168956+08
1824	openrouter/qwen/qwen3-coder	0.300000	1.000000	0.100000	2026-09-30 15:21:13.169715+08
1825	openrouter/qwen/qwen3-235b-a22b-thinking-2507	0.230000	2.300000	0.000000	2026-09-30 15:21:13.170151+08
1826	openrouter/qwen/qwen3.5-35b-a3b	0.162500	1.300000	0.156250	2026-09-30 15:21:13.170511+08
1827	openrouter/qwen/qwen3.5-397b-a17b	0.550000	3.500000	0.225000	2026-09-30 15:21:13.171224+08
1828	openrouter/z-ai/glm-4.6:exacto	0.450000	1.900000	0.000000	2026-09-30 15:21:13.171595+08
1829	openrouter/xiaomi/mimo-v2-flash	0.100000	0.300000	0.010000	2026-09-30 15:21:13.171864+08
1830	openrouter/z-ai/glm-4.7	0.600000	2.200000	0.110000	2026-09-30 15:21:13.172345+08
1831	openrouter/z-ai/glm-4.7-flash	0.060500	0.400000	0.010000	2026-09-30 15:21:13.172605+08
1832	openrouter/z-ai/glm-5.1	1.400000	4.400000	0.260000	2026-09-30 15:21:13.172953+08
1833	ovhcloud/Qwen2.5-VL-72B-Instruct	0.910000	0.910000	0.000000	2026-09-30 15:21:13.173669+08
1834	ovhcloud/Qwen3-32B	0.080000	0.230000	0.000000	2026-09-30 15:21:13.173941+08
1835	qwen.qwen3-coder-480b-a35b-v1:0	0.450000	1.800000	0.000000	2026-09-30 15:21:13.174818+08
1836	bedrock/ap-northeast-1/qwen.qwen3-next-80b-a3b	0.180000	1.450000	0.000000	2026-09-30 15:21:13.175548+08
1837	bedrock/ap-south-1/qwen.qwen3-next-80b-a3b	0.180000	1.410000	0.000000	2026-09-30 15:21:13.175799+08
1838	bedrock/eu-west-1/qwen.qwen3-next-80b-a3b	0.180000	1.410000	0.000000	2026-09-30 15:21:13.176179+08
1839	bedrock/eu-west-2/qwen.qwen3-next-80b-a3b	0.230000	1.860000	0.000000	2026-09-30 15:21:13.176458+08
1840	bedrock/sa-east-1/qwen.qwen3-next-80b-a3b	0.180000	1.450000	0.000000	2026-09-30 15:21:13.176722+08
1841	replicate/qwen/qwen3-235b-a22b-instruct-2507	0.264000	1.060000	0.000000	2026-09-30 15:21:13.177263+08
1842	replicate/deepseek-ai/deepseek-v3	1.450000	1.450000	0.000000	2026-09-30 15:21:13.177521+08
1843	replicate/deepseek-ai/deepseek-v3.1	0.672000	2.016000	0.000000	2026-09-30 15:21:13.177798+08
1844	scx-ai/GLM-5.2	0.610000	1.980000	0.220000	2026-09-30 15:21:13.178704+08
1845	scx-ai/Qwen3.8-Max	1.650000	4.990000	0.210000	2026-09-30 15:21:13.178982+08
1846	together_ai/Qwen/Qwen3.5-9B	0.170000	0.250000	0.000000	2026-09-30 15:21:13.180218+08
1847	together_ai/arize-ai/qwen-2-1.5b-instruct	0.100000	0.100000	0.000000	2026-09-30 15:21:13.18105+08
1848	together_ai/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.130000	2026-09-30 15:21:13.181761+08
1849	eu.deepseek.v3.2	0.740000	2.220000	0.000000	2026-09-30 15:21:13.182787+08
1850	vercel_ai_gateway/alibaba/qwen-3-235b	0.200000	0.600000	0.000000	2026-09-30 15:21:13.183186+08
1851	vercel_ai_gateway/alibaba/qwen-3-30b	0.100000	0.300000	0.000000	2026-09-30 15:21:13.183456+08
1852	vercel_ai_gateway/alibaba/qwen-3-32b	0.100000	0.300000	0.000000	2026-09-30 15:21:13.183724+08
1853	vercel_ai_gateway/alibaba/qwen3-coder	0.400000	1.600000	0.000000	2026-09-30 15:21:13.183981+08
1854	vercel_ai_gateway/deepseek/deepseek-r1	0.550000	2.190000	0.000000	2026-09-30 15:21:13.184269+08
1855	vercel_ai_gateway/deepseek/deepseek-r1-distill-llama-70b	0.750000	0.990000	0.000000	2026-09-30 15:21:13.184546+08
1856	vercel_ai_gateway/deepseek/deepseek-v3	0.900000	0.900000	0.000000	2026-09-30 15:21:13.184817+08
1857	vercel_ai_gateway/zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-09-30 15:21:13.185401+08
1858	vercel_ai_gateway/zai/glm-4.6	0.450000	1.800000	0.110000	2026-09-30 15:21:13.185685+08
1859	vertex_ai/zai-org/glm-5-maas	1.000000	3.200000	0.100000	2026-09-30 15:21:13.186721+08
1860	vertex_ai/qwen/qwen3-coder-480b-a35b-instruct-maas	0.220000	1.800000	0.022000	2026-09-30 15:21:13.187239+08
1861	wandb/moonshotai/Kimi-K2.5	0.600000	3.000000	0.100000	2026-09-30 15:21:13.18798+08
1862	wandb/deepseek-ai/DeepSeek-V3.1	0.550000	1.650000	0.000000	2026-09-30 15:21:13.188284+08
1863	zai.glm-5	1.000000	3.200000	0.000000	2026-09-30 15:21:13.189053+08
1864	zai.glm-4.7-flash	0.070000	0.400000	0.000000	2026-09-30 15:21:13.189311+08
1865	zai/glm-5	1.000000	3.200000	0.200000	2026-09-30 15:21:13.189563+08
1866	zai/glm-4.5v	0.600000	1.800000	0.000000	2026-09-30 15:21:13.190724+08
1867	zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-09-30 15:21:13.191092+08
1868	zai/glm-4-32b-0414-128k	0.100000	0.100000	0.000000	2026-09-30 15:21:13.191468+08
1869	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-a35b-instruct	0.450000	1.800000	0.000000	2026-09-30 15:21:13.191909+08
1870	fireworks_ai/accounts/fireworks/models/code-qwen-1p5-7b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.192364+08
1871	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-14b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.192655+08
1872	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-32b	0.900000	0.900000	0.000000	2026-09-30 15:21:13.19297+08
1873	fireworks_ai/accounts/fireworks/models/deepseek-coder-1b-base	0.100000	0.100000	0.000000	2026-09-30 15:21:13.193269+08
1874	fireworks_ai/accounts/fireworks/models/deepseek-coder-33b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.193605+08
1875	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base	0.200000	0.200000	0.000000	2026-09-30 15:21:13.193882+08
1876	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base-v1p5	0.200000	0.200000	0.000000	2026-09-30 15:21:13.194169+08
1877	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-instruct-v1p5	0.200000	0.200000	0.000000	2026-09-30 15:21:13.194453+08
1878	fireworks_ai/accounts/fireworks/models/deepseek-r1-0528-distill-qwen3-8b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.195141+08
1879	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-70b	0.900000	0.900000	0.000000	2026-09-30 15:21:13.195444+08
1880	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-8b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.195734+08
1881	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-14b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.196017+08
1882	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-1p5b	0.100000	0.100000	0.000000	2026-09-30 15:21:13.196303+08
1883	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-32b	0.900000	0.900000	0.000000	2026-09-30 15:21:13.196587+08
1884	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-7b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.196867+08
1885	fireworks_ai/accounts/fireworks/models/dolphin-2-9-2-qwen2-72b	0.900000	0.900000	0.000000	2026-09-30 15:21:13.197426+08
1886	fireworks_ai/accounts/fireworks/models/minimax-m1-80k	0.100000	0.100000	0.000000	2026-09-30 15:21:13.197897+08
1887	fireworks_ai/accounts/fireworks/models/qwen-qwq-32b-preview	0.900000	0.900000	0.000000	2026-09-30 15:21:13.198348+08
1888	fireworks_ai/accounts/fireworks/models/qwen-v2p5-14b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.198622+08
1889	fireworks_ai/accounts/fireworks/models/qwen-v2p5-7b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.198904+08
1890	fireworks_ai/accounts/fireworks/models/qwen1p5-72b-chat	0.900000	0.900000	0.000000	2026-09-30 15:21:13.199195+08
1891	fireworks_ai/accounts/fireworks/models/qwen2-7b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.199476+08
1892	fireworks_ai/accounts/fireworks/models/qwen2-vl-2b-instruct	0.100000	0.100000	0.000000	2026-09-30 15:21:13.199839+08
1893	fireworks_ai/accounts/fireworks/models/qwen2-vl-72b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.200242+08
1894	fireworks_ai/accounts/fireworks/models/qwen2-vl-7b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.20055+08
1895	fireworks_ai/accounts/fireworks/models/qwen2p5-0p5b-instruct	0.100000	0.100000	0.000000	2026-09-30 15:21:13.20082+08
1896	fireworks_ai/accounts/fireworks/models/qwen2p5-14b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.201097+08
1897	fireworks_ai/accounts/fireworks/models/qwen2p5-1p5b-instruct	0.100000	0.100000	0.000000	2026-09-30 15:21:13.201376+08
1898	fireworks_ai/accounts/fireworks/models/qwen2p5-32b	0.900000	0.900000	0.000000	2026-09-30 15:21:13.201653+08
1899	fireworks_ai/accounts/fireworks/models/qwen2p5-32b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.20193+08
1900	fireworks_ai/accounts/fireworks/models/qwen2p5-72b	0.900000	0.900000	0.000000	2026-09-30 15:21:13.202211+08
1901	fireworks_ai/accounts/fireworks/models/qwen2p5-72b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.202489+08
1902	fireworks_ai/accounts/fireworks/models/qwen2p5-7b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.20276+08
1903	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b	0.100000	0.100000	0.000000	2026-09-30 15:21:13.203141+08
1904	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b-instruct	0.100000	0.100000	0.000000	2026-09-30 15:21:13.203416+08
1905	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.203696+08
1906	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.203979+08
1907	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b	0.100000	0.100000	0.000000	2026-09-30 15:21:13.204257+08
1908	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b-instruct	0.100000	0.100000	0.000000	2026-09-30 15:21:13.204555+08
1909	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b	0.900000	0.900000	0.000000	2026-09-30 15:21:13.204839+08
1910	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-128k	0.900000	0.900000	0.000000	2026-09-30 15:21:13.205117+08
1911	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-32k-rope	0.900000	0.900000	0.000000	2026-09-30 15:21:13.205392+08
1912	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-64k	0.900000	0.900000	0.000000	2026-09-30 15:21:13.205673+08
1913	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b	0.100000	0.100000	0.000000	2026-09-30 15:21:13.205957+08
1914	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b-instruct	0.100000	0.100000	0.000000	2026-09-30 15:21:13.206276+08
1915	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.206561+08
1916	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.206834+08
1917	fireworks_ai/accounts/fireworks/models/qwen2p5-math-72b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.207101+08
1918	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-32b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.20736+08
1919	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-3b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.207627+08
1920	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-72b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.207896+08
1921	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-7b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.208166+08
1922	fireworks_ai/accounts/fireworks/models/qwen3-0p6b	0.100000	0.100000	0.000000	2026-09-30 15:21:13.208432+08
1923	fireworks_ai/accounts/fireworks/models/qwen3-14b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.208694+08
1924	fireworks_ai/accounts/fireworks/models/qwen3-1p7b	0.100000	0.100000	0.000000	2026-09-30 15:21:13.208949+08
1925	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft	0.100000	0.100000	0.000000	2026-09-30 15:21:13.209223+08
1926	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-131072	0.100000	0.100000	0.000000	2026-09-30 15:21:13.209507+08
1927	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-40960	0.100000	0.100000	0.000000	2026-09-30 15:21:13.209798+08
1928	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-thinking-2507	0.900000	0.900000	0.000000	2026-09-30 15:21:13.211064+08
1929	fireworks_ai/accounts/fireworks/models/qwen3-32b	0.900000	0.900000	0.000000	2026-09-30 15:21:13.211336+08
1930	fireworks_ai/accounts/fireworks/models/qwen3-4b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.211611+08
1931	fireworks_ai/accounts/fireworks/models/qwen3-4b-instruct-2507	0.200000	0.200000	0.000000	2026-09-30 15:21:13.212038+08
1932	fireworks_ai/accounts/fireworks/models/qwen3-8b	0.200000	0.200000	0.000000	2026-09-30 15:21:13.212305+08
1933	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-instruct-bf16	0.900000	0.900000	0.000000	2026-09-30 15:21:13.21271+08
1934	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.213231+08
1935	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-thinking	0.900000	0.900000	0.000000	2026-09-30 15:21:13.213517+08
1936	fireworks_ai/accounts/fireworks/models/qwen3-reranker-8b	0.200000	0.000000	0.000000	2026-09-30 15:21:13.214307+08
1937	fireworks_ai/accounts/fireworks/models/qwen3-vl-32b-instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.215065+08
1938	fireworks_ai/accounts/fireworks/models/qwen3-vl-8b-instruct	0.200000	0.200000	0.000000	2026-09-30 15:21:13.215336+08
1939	fireworks_ai/accounts/fireworks/models/qwen3p7-plus	0.400000	1.600000	0.080000	2026-09-30 15:21:13.215619+08
1940	scaleway/qwen/qwen3.5-397b-a17b	0.600000	3.600000	0.000000	2026-09-30 15:21:13.216273+08
1941	scaleway/qwen/qwen3-embedding-8b	0.100000	0.000000	0.000000	2026-09-30 15:21:13.216782+08
1942	scaleway/qwen/qwen3-coder-30b-a3b-instruct	0.200000	0.800000	0.000000	2026-09-30 15:21:13.217042+08
1943	novita/deepseek/deepseek-v3.2	0.269000	0.400000	0.134500	2026-09-30 15:21:13.217318+08
1944	novita/zai-org/autoglm-phone-9b-multilingual	0.035000	0.138000	0.000000	2026-09-30 15:21:13.217951+08
1945	novita/zai-org/glm-4.6v	0.300000	0.900000	0.055000	2026-09-30 15:21:13.218734+08
1946	novita/qwen/qwen3-max	2.110000	8.450000	0.000000	2026-09-30 15:21:13.219723+08
1947	novita/moonshotai/kimi-k2-instruct	0.570000	2.300000	0.000000	2026-09-30 15:21:13.220475+08
1948	novita/zai-org/glm-4.5v	0.600000	1.800000	0.110000	2026-09-30 15:21:13.221093+08
1949	novita/qwen/qwen-2.5-72b-instruct	0.380000	0.400000	0.000000	2026-09-30 15:21:13.22158+08
1950	novita/deepseek/deepseek-r1-distill-llama-70b	0.800000	0.800000	0.000000	2026-09-30 15:21:13.222434+08
1951	novita/qwen/qwen3-235b-a22b-fp8	0.200000	0.800000	0.000000	2026-09-30 15:21:13.222706+08
1952	novita/qwen/qwen2.5-vl-72b-instruct	0.800000	0.800000	0.000000	2026-09-30 15:21:13.222966+08
1953	novita/qwen/qwen3-32b-fp8	0.100000	0.450000	0.000000	2026-09-30 15:21:13.223344+08
1954	novita/qwen/qwen3-30b-a3b-fp8	0.090000	0.450000	0.000000	2026-09-30 15:21:13.223615+08
1955	novita/deepseek/deepseek-v3-turbo	0.400000	1.300000	0.000000	2026-09-30 15:21:13.223877+08
1956	novita/zai-org/glm-4.5-air	0.130000	0.850000	0.025000	2026-09-30 15:21:13.224398+08
1957	novita/qwen/qwen3-vl-30b-a3b-instruct	0.200000	0.700000	0.000000	2026-09-30 15:21:13.22467+08
1958	novita/qwen/qwen3-vl-30b-a3b-thinking	0.200000	1.000000	0.000000	2026-09-30 15:21:13.224938+08
1959	novita/qwen/qwen3-omni-30b-a3b-thinking	0.250000	0.970000	0.000000	2026-09-30 15:21:13.225211+08
1960	novita/qwen/qwen3-omni-30b-a3b-instruct	0.250000	0.970000	0.000000	2026-09-30 15:21:13.225473+08
1961	novita/qwen/qwen3-8b-fp8	0.035000	0.138000	0.000000	2026-09-30 15:21:13.225873+08
1962	novita/qwen/qwen3-reranker-8b	0.050000	0.050000	0.000000	2026-09-30 15:21:13.226598+08
1963	llamagate/deepseek-r1-8b	0.100000	0.200000	0.000000	2026-09-30 15:21:13.226961+08
1964	bedrock/us-east-1/zai.glm-5	1.000000	3.200000	0.000000	2026-09-30 15:21:13.22878+08
1965	bedrock/us-west-2/zai.glm-5	1.000000	3.200000	0.000000	2026-09-30 15:21:13.229036+08
1966	tensormesh/Qwen/Qwen3.5-397B-A17B-FP8	0.600000	3.600000	0.000000	2026-09-30 15:21:13.229307+08
1967	tensormesh/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	0.450000	1.800000	0.000000	2026-09-30 15:21:13.229552+08
1968	tensormesh/Qwen/Qwen3.6-27B-FP8	0.320000	3.200000	0.000000	2026-09-30 15:21:13.229805+08
1969	deepseek-v4-pro	1.320000	3.960000	0.044000	2026-09-30 15:21:13.230875+08
1970	deepseek/deepseek-v4-pro	1.320000	3.960000	0.044000	2026-09-30 15:21:13.23152+08
1971	pinstripes/ps/glm-4.5-air	0.125000	0.450000	0.000000	2026-09-30 15:21:13.232111+08
1972	pinstripes/ps/qwen3.6-35b-a3b	0.140000	0.450000	0.000000	2026-09-30 15:21:13.232502+08
1973	pinstripes/ps/qwen3-30b-a3b	0.090000	0.200000	0.000000	2026-09-30 15:21:13.23276+08
1974	pinstripes/ps/deepseek-v4-flash	0.100000	0.200000	0.000000	2026-09-30 15:21:13.23315+08
1975	fireworks_ai/accounts/fireworks/routers/deepseek-v4p1-flash-us	0.450000	1.800000	0.009000	2026-09-30 15:21:13.233908+08
1976	fireworks_ai/deepseek-v4p1-flash-us	0.450000	1.800000	0.009000	2026-09-30 15:21:13.234761+08
1977	fireworks_ai/glm-5p2-fast	2.100000	6.600000	0.210000	2026-09-30 15:21:13.235145+08
1978	fireworks_ai/glm-5p2-fast-us	2.100000	6.600000	0.210000	2026-09-30 15:21:13.23541+08
1979	fireworks_ai/kimi-k3-fast	4.500000	22.500000	0.450000	2026-09-30 15:21:13.235916+08
1980	fireworks_ai/kimi-k3-us	4.500000	22.500000	0.450000	2026-09-30 15:21:13.236186+08
1981	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast	2.100000	6.600000	0.210000	2026-09-30 15:21:13.2367+08
1982	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast-us	2.100000	6.600000	0.210000	2026-09-30 15:21:13.236979+08
1983	fireworks_ai/accounts/fireworks/routers/kimi-k3-fast	4.500000	22.500000	0.450000	2026-09-30 15:21:13.23726+08
1984	fireworks_ai/accounts/fireworks/routers/kimi-k3-us	4.500000	22.500000	0.450000	2026-09-30 15:21:13.237533+08
1985	novita/deepseek/deepseek-v4-pro-0813	1.320000	3.960000	0.132000	2026-09-30 15:21:13.238013+08
1986	wandb/deepseek-ai/DeepSeek-V4-Pro	1.150000	2.550000	0.200000	2026-09-30 15:21:13.24283+08
1987	wandb/MiniMaxAI/MiniMax-M3	0.230000	0.960000	0.050000	2026-09-30 15:21:13.243091+08
1988	wandb/OpenPipe/Qwen3-14B-Instruct	0.050000	0.220000	0.000000	2026-09-30 15:21:13.243583+08
1989	wandb/Qwen/Qwen3.8-27B	0.400000	3.000000	0.150000	2026-09-30 15:21:13.243845+08
1990	wandb/Qwen/Qwen3.6-27B	0.600000	3.600000	0.120000	2026-09-30 15:21:13.244198+08
1991	wandb/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-09-30 15:21:13.244579+08
1992	wandb/deepseek-ai/DeepSeek-V4-Pro-0813	1.310000	3.960000	0.044000	2026-09-30 15:21:13.244843+08
1993	deepinfra/MiniMaxAI/MiniMax-M2.7	0.250000	1.000000	0.050000	2026-09-30 15:21:13.24522+08
1994	deepinfra/Qwen/Qwen3.8-27B	0.400000	3.000000	0.040000	2026-09-30 15:21:13.245487+08
1995	deepinfra/moonshotai/Kimi-K2.5	0.450000	2.250000	0.070000	2026-09-30 15:21:13.24576+08
1996	deepinfra/zai-org/GLM-4.7-Flash	0.060000	0.400000	0.010000	2026-09-30 15:21:13.246038+08
1997	deepinfra/zai-org/GLM-4.6	0.500000	2.000000	0.100000	2026-09-30 15:21:13.246318+08
1998	deepinfra/XiaomiMiMo/MiMo-V2.5	0.400000	2.000000	0.080000	2026-09-30 15:21:13.24657+08
1999	deepinfra/Qwen/Qwen3-VL-235B-A22B-Instruct	0.200000	0.880000	0.110000	2026-09-30 15:21:13.247062+08
2000	deepinfra/Qwen/Qwen3.6-35B-A3B	0.100000	0.950000	0.000000	2026-09-30 15:21:13.247682+08
2001	deepinfra/deepseek-ai/DeepSeek-V4-Pro-0813	1.300000	2.600000	0.100000	2026-09-30 15:21:13.248078+08
2002	deepinfra/Qwen/Qwen3.8-2.4T-A95B	2.000000	6.000000	0.200000	2026-09-30 15:21:13.248462+08
2003	deepinfra/Qwen/Qwen3.5-35B-A3B	0.140000	1.000000	0.050000	2026-09-30 15:21:13.24886+08
2004	deepinfra/moonshotai/Kimi-K2.7-Code	0.680000	3.400000	0.136000	2026-09-30 15:21:13.249239+08
2005	deepinfra/Qwen/Qwen3.5-397B-A17B	0.450000	3.000000	0.220000	2026-09-30 15:21:13.249494+08
2006	deepinfra/Qwen/Qwen3.8-Max	1.650000	4.951000	0.206000	2026-09-30 15:21:13.249989+08
2007	deepinfra/zai-org/GLM-5.1	1.050000	3.500000	0.205000	2026-09-30 15:21:13.250364+08
2008	deepinfra/deepseek-ai/DeepSeek-V4-Pro	1.300000	2.600000	0.100000	2026-09-30 15:21:13.250624+08
2009	deepinfra/moonshotai/Kimi-K3	2.850000	14.250000	0.285000	2026-09-30 15:21:13.250999+08
2010	deepinfra/Qwen/Qwen3.6-27B	0.320000	3.200000	0.000000	2026-09-30 15:21:13.251264+08
2011	deepinfra/XiaomiMiMo/MiMo-V2.5-Pro	1.000000	3.000000	0.200000	2026-09-30 15:21:13.251519+08
2012	deepinfra/Qwen/Qwen3.5-9B	0.100000	0.150000	0.000000	2026-09-30 15:21:13.251914+08
2013	deepinfra/zai-org/GLM-4.7	0.400000	1.750000	0.080000	2026-09-30 15:21:13.252292+08
2014	groq/qwen/qwen3.8-27b	0.800000	4.000000	0.000000	2026-09-30 15:21:13.252563+08
2015	fireworks_ai/accounts/fireworks/routers/glm-5p3-us	2.100000	6.600000	0.390000	2026-09-30 15:21:13.253044+08
2016	fireworks_ai/glm-5p3-us	2.100000	6.600000	0.390000	2026-09-30 15:21:13.253529+08
2017	fireworks_ai/accounts/fireworks/routers/glm-5p3-fast	2.100000	6.600000	0.390000	2026-09-30 15:21:13.253803+08
2018	fireworks_ai/glm-5p3-fast	2.100000	6.600000	0.390000	2026-09-30 15:21:13.254084+08
2019	fireworks_ai/accounts/fireworks/routers/glm-5p3-flash-us	0.225000	0.750000	0.045000	2026-09-30 15:21:13.254699+08
2020	fireworks_ai/glm-5p3-flash-us	0.225000	0.750000	0.045000	2026-09-30 15:21:13.255162+08
2021	fireworks_ai/accounts/fireworks/models/qwen3-embedding-8b	0.100000	0.000000	0.000000	2026-09-30 15:21:13.255448+08
2022	together_ai/Qwen/Qwen3.8-Flash	0.090000	0.282000	0.000000	2026-09-30 15:21:13.25585+08
2023	scaleway/glm-5.2	1.800000	5.500000	0.000000	2026-09-30 15:21:13.25645+08
2024	scaleway/deepseek-v4-flash-0731	0.400000	0.800000	0.080000	2026-09-30 15:21:13.256698+08
2025	azure_ai/deepseek-v4.1-flash	0.300000	1.200000	0.006000	2026-09-30 15:21:13.257109+08
2026	azure_ai/FW-DeepSeek-V4.1-Flash	0.375000	1.500000	0.008000	2026-09-30 15:21:13.257409+08
2027	azure_ai/FW-DeepSeek-V4-Flash	0.150000	0.310000	0.030000	2026-09-30 15:21:13.257708+08
2028	azure_ai/FW-GLM-5.3	1.750000	5.500000	0.325000	2026-09-30 15:21:13.258008+08
2029	azure_ai/FW-GLM-5.3-Flash	0.188000	0.625000	0.038000	2026-09-30 15:21:13.258296+08
2030	azure_ai/deepseek-v3-0324	1.140000	4.560000	0.000000	2026-09-30 15:21:13.258643+08
2031	bedrock_mantle/deepseek.v3.1	0.580000	1.680000	0.000000	2026-09-30 15:21:13.259439+08
2032	bedrock_mantle/moonshotai.kimi-k2-thinking	0.600000	2.500000	0.000000	2026-09-30 15:21:13.259744+08
2033	bedrock_mantle/qwen.qwen3-235b-a22b-2507	0.220000	0.880000	0.000000	2026-09-30 15:21:13.260045+08
2034	bedrock_mantle/qwen.qwen3-32b	0.150000	0.600000	0.000000	2026-09-30 15:21:13.260345+08
2035	bedrock_mantle/qwen.qwen3-coder-30b-a3b-instruct	0.150000	0.600000	0.000000	2026-09-30 15:21:13.260638+08
2036	bedrock_mantle/qwen.qwen3-coder-480b-a35b-instruct	0.450000	1.800000	0.000000	2026-09-30 15:21:13.260931+08
2037	bedrock_mantle/qwen.qwen3-next-80b-a3b-instruct	0.140000	1.200000	0.000000	2026-09-30 15:21:13.261237+08
2038	bedrock_mantle/qwen.qwen3-vl-235b-a22b-instruct	0.530000	2.660000	0.000000	2026-09-30 15:21:13.261526+08
2039	baseten/zai-org/GLM-5.3-Fast	2.100000	6.600000	0.210000	2026-09-30 15:21:13.262219+08
2040	openrouter/z-ai/glm-5.3-flash	0.150000	0.500000	0.030000	2026-09-30 15:21:13.262802+08
2041	openrouter/deepseek/deepseek-v4-flash-vision-exp	0.215600	0.646800	0.006860	2026-09-30 15:21:13.263049+08
2042	openrouter/z-ai/glm-5.3	1.400000	4.400000	0.260000	2026-09-30 15:21:13.263293+08
2043	openrouter/qwen/qwen3.8-27b	0.420000	3.000000	0.085000	2026-09-30 15:21:13.263529+08
2044	openrouter/qwen/qwen3.8-max-prime	4.000000	12.000000	0.500000	2026-09-30 15:21:13.264407+08
2045	openrouter/deepseek/deepseek-v4-flash-0731	0.018000	0.320000	0.016000	2026-09-30 15:21:13.264644+08
2046	openrouter/moonshotai/kimi-k2.7-code	0.656200	3.300000	0.180000	2026-09-30 15:21:13.265348+08
2047	openrouter/qwen/qwen3.5-plus-20260420	0.300000	1.800000	0.000000	2026-09-30 15:21:13.265828+08
2048	openrouter/qwen/qwen3.6-35b-a3b	0.150000	1.000000	0.050000	2026-09-30 15:21:13.266174+08
2049	openrouter/qwen/qwen3.6-max-preview	1.027000	6.162000	0.000000	2026-09-30 15:21:13.266407+08
2050	openrouter/qwen/qwen3.6-27b	0.320000	3.200000	0.150000	2026-09-30 15:21:13.266653+08
2051	openrouter/deepseek/deepseek-v4-flash	0.140000	0.280000	0.028000	2026-09-30 15:21:13.266891+08
2052	openrouter/moonshotai/kimi-k2.6	0.650000	3.410000	0.150000	2026-09-30 15:21:13.267126+08
2053	openrouter/qwen/qwen3.5-9b	0.100000	0.150000	0.000000	2026-09-30 15:21:13.26783+08
2054	openrouter/qwen/qwen3-coder-next	0.120000	0.800000	0.070000	2026-09-30 15:21:13.268204+08
2055	openrouter/z-ai/glm-4.6v	0.300000	0.900000	0.055000	2026-09-30 15:21:13.268617+08
2056	openrouter/qwen/qwen3-vl-32b-instruct	0.104000	0.416000	0.000000	2026-09-30 15:21:13.269009+08
2057	openrouter/qwen/qwen3-vl-8b-thinking	0.180000	2.100000	0.000000	2026-09-30 15:21:13.269272+08
2058	openrouter/qwen/qwen3-vl-8b-instruct	0.117000	0.455000	0.000000	2026-09-30 15:21:13.269535+08
2059	openrouter/qwen/qwen3-vl-30b-a3b-thinking	0.200000	2.400000	0.000000	2026-09-30 15:21:13.269831+08
2060	openrouter/qwen/qwen3-vl-30b-a3b-instruct	0.150000	0.600000	0.000000	2026-09-30 15:21:13.270096+08
2061	openrouter/qwen/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-09-30 15:21:13.270377+08
2062	openrouter/qwen/qwen3-vl-235b-a22b-instruct	0.210000	1.900000	0.100000	2026-09-30 15:21:13.270643+08
2063	openrouter/qwen/qwen3-next-80b-a3b-instruct	0.100000	1.100000	0.070000	2026-09-30 15:21:13.271371+08
2064	openrouter/qwen/qwen-plus-2025-07-28	0.260000	0.780000	0.052000	2026-09-30 15:21:13.271628+08
2065	openrouter/qwen/qwen3-30b-a3b-thinking-2507	0.200000	2.400000	0.000000	2026-09-30 15:21:13.272019+08
2066	openrouter/z-ai/glm-4.5v	0.600000	1.800000	0.110000	2026-09-30 15:21:13.272282+08
2067	openrouter/qwen/qwen3-30b-a3b-instruct-2507	0.100000	0.300000	0.000000	2026-09-30 15:21:13.272653+08
2068	openrouter/z-ai/glm-4.5-air	0.130000	0.850000	0.025000	2026-09-30 15:21:13.273262+08
2069	openrouter/moonshotai/kimi-k2	0.570000	2.300000	0.000000	2026-09-30 15:21:13.273568+08
2070	openrouter/minimax/minimax-m1	0.400000	2.200000	0.000000	2026-09-30 15:21:13.273854+08
2071	openrouter/qwen/qwen3-8b	0.117000	0.455000	0.000000	2026-09-30 15:21:13.274239+08
2072	openrouter/qwen/qwen3-235b-a22b	0.455000	1.820000	0.000000	2026-09-30 15:21:13.274727+08
2073	openrouter/qwen/qwen2.5-vl-72b-instruct	0.800000	1.000000	0.400000	2026-09-30 15:21:13.275002+08
2074	openrouter/qwen/qwen-plus	0.260000	0.780000	0.052000	2026-09-30 15:21:13.275262+08
2075	openrouter/deepseek/deepseek-r1-distill-llama-70b	0.800000	0.800000	0.000000	2026-09-30 15:21:13.275554+08
2076	openrouter/minimax/minimax-01	0.200000	1.100000	0.000000	2026-09-30 15:21:13.275822+08
2077	openrouter/qwen/qwen-2.5-7b-instruct	0.100000	0.200000	0.000000	2026-09-30 15:21:13.276084+08
2078	openrouter/qwen/qwen-2.5-72b-instruct	0.360000	0.400000	0.000000	2026-09-30 15:21:13.27635+08
2079	together_ai/Qwen/Qwen2.5-14B-Instruct	0.800000	0.800000	0.000000	2026-09-30 15:21:13.276761+08
2080	together_ai/Qwen/Qwen2-72B-Instruct	0.900000	0.900000	0.000000	2026-09-30 15:21:13.277264+08
2081	together_ai/Qwen/Qwen2.5-Coder-32B-Instruct	0.800000	0.800000	0.000000	2026-09-30 15:21:13.277893+08
2082	together_ai/Qwen/Qwen3-VL-8B-Instruct	0.180000	0.680000	0.000000	2026-09-30 15:21:13.278871+08
2083	together_ai/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.350000	2026-09-30 15:21:13.279135+08
2084	together_ai/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B	1.600000	1.600000	0.000000	2026-09-30 15:21:13.27971+08
2085	together_ai/deepseek-ai/deepseek-coder-33b-instruct	0.800000	0.800000	0.000000	2026-09-30 15:21:13.280125+08
2086	together_ai/moonshotai/Kimi-K2.6	1.200000	4.500000	0.200000	2026-09-30 15:21:13.280365+08
2087	together_ai/zai-org/GLM-4.5-Air-FP8	0.200000	1.100000	0.000000	2026-09-30 15:21:13.280746+08
2088	together_ai/zai-org/GLM-4.7	0.450000	2.000000	0.000000	2026-09-30 15:21:13.281006+08
2089	together_ai/zai-org/GLM-5	1.000000	3.200000	0.000000	2026-09-30 15:21:13.281235+08
2090	aihubmix/coding-kimi-k3	0.440000	1.613330	0.066000	2026-09-30 15:21:13.281918+08
2091	aihubmix/coding-xiaomi-mimo-v2-omni	0.080000	0.400000	0.016000	2026-09-30 15:21:13.282123+08
2092	aihubmix/coding-xiaomi-mimo-v2.5-pro	0.200000	0.400000	0.001600	2026-09-30 15:21:13.28246+08
2093	aihubmix/deepseek-v4-flash	0.142000	0.284000	0.028400	2026-09-30 15:21:13.282719+08
2094	aihubmix/glm-5.3	1.126800	3.943800	0.281700	2026-09-30 15:21:13.283263+08
2095	aihubmix/glm-5v-turbo	0.704200	3.098480	0.169008	2026-09-30 15:21:13.283604+08
2096	aihubmix/kimi-k2.6	0.950000	3.999500	0.160835	2026-09-30 15:21:13.283817+08
2097	aihubmix/kimi-k2.7-code-highspeed	1.900000	7.999000	0.321670	2026-09-30 15:21:13.284005+08
2098	aihubmix/mimo-v2-pro	1.100000	3.300000	0.220000	2026-09-30 15:21:13.284411+08
2099	aihubmix/minimax-m2.7	0.295800	1.183200	0.059160	2026-09-30 15:21:13.284592+08
2100	aihubmix/qwen3-coder-next	0.137000	0.548000	0.000000	2026-09-30 15:21:13.284857+08
2101	aihubmix/qwen3.5-397b-a17b	0.164400	0.986400	0.000000	2026-09-30 15:21:13.285131+08
2102	aihubmix/qwen3.7-plus	0.282000	1.128000	0.056400	2026-09-30 15:21:13.285625+08
2103	aihubmix/qwen3.8-max	1.690000	5.070000	0.169000	2026-09-30 15:21:13.285982+08
2104	wandb/deepseek-ai/DeepSeek-V4.1-Flash	0.200000	0.650000	0.030000	2026-09-30 15:21:13.286204+08
2105	wandb/zai-org/GLM-5.3-Flash	0.150000	0.500000	0.050000	2026-09-30 15:21:13.286378+08
2106	openrouter/~deepseek/deepseek-pro-latest	1.320000	3.960000	0.044000	2026-09-30 15:21:13.286651+08
2107	openrouter/~z-ai/glm-flash-latest	0.150000	0.500000	0.050000	2026-09-30 15:21:13.287023+08
2108	openrouter/~z-ai/glm-latest	0.653800	2.054800	0.121420	2026-09-30 15:21:13.287212+08
2109	openrouter/moonshotai/kimi-k3:batch	2.280000	11.400000	0.228000	2026-09-30 15:21:13.287475+08
2110	openrouter/z-ai/glm-5.3-flash:batch	0.060000	0.200000	0.012000	2026-09-30 15:21:13.287823+08
2111	openrouter/z-ai/glm-5.3:batch	0.450000	2.000000	0.100000	2026-09-30 15:21:13.288+08
2112	openrouter/z-ai/glm-5.3-prime	2.800000	8.800000	0.560000	2026-09-30 15:21:13.288353+08
2113	openrouter/z-ai/glm-5.3-flashx	0.370000	1.250000	0.090000	2026-09-30 15:21:13.288533+08
2114	moonshotai.kimi-k3	3.300000	16.500000	0.330000	2026-09-30 15:21:13.288717+08
2115	us.moonshotai.kimi-k3	3.300000	16.500000	0.330000	2026-09-30 15:21:13.288991+08
2116	baseten/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.132000	2026-09-30 15:21:13.290356+08
2117	baseten/zai-org/GLM-5.2-Fast	2.100000	6.600000	0.210000	2026-09-30 15:21:13.290538+08
2118	fireworks_ai/accounts/fireworks/models/minimax-m2p7	0.000000	0.000000	0.000000	2026-09-30 15:21:13.290818+08
2119	openrouter/deepseek/deepseek-v4.1-flash:batch	0.112000	0.336000	0.003360	2026-09-30 15:21:13.291009+08
2120	deepseek.r1-v1:0	1.350000	5.400000	0.000000	2026-09-30 15:21:13.291423+08
2121	prism/deepseek-v4.1-flash	0.170000	0.630000	0.070000	2026-09-30 15:21:13.291673+08
2122	prism/deepseek-v4-flash	0.170000	0.210000	0.070000	2026-09-30 15:21:13.291874+08
2123	baseten/deepseek-ai/DeepSeek-V4.1-Flash-Fast	0.600000	2.400000	0.140000	2026-09-30 15:21:13.292079+08
2124	azure_ai/FW-DeepSeek-V4-Pro	1.925000	3.828000	0.000000	2026-10-01 10:11:28.454884+08
2125	azure_ai/FW-Kimi-K2.5	0.660000	3.300000	0.000000	2026-10-01 10:11:28.462066+08
2126	azure_ai/FW-Kimi-K2.7-Code	1.050000	4.400000	0.000000	2026-10-01 10:11:28.463835+08
2127	azure_ai/deepseek-v3	1.140000	4.560000	0.000000	2026-10-01 10:11:28.466481+08
2128	bedrock/ap-northeast-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-10-01 10:11:28.46918+08
2129	bedrock/ap-northeast-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-10-01 10:11:28.471362+08
2130	bedrock/ap-south-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-10-01 10:11:28.472992+08
2131	bedrock/ap-south-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-10-01 10:11:28.475114+08
2132	bedrock/ap-southeast-3/deepseek.v3.2	0.740000	2.220000	0.000000	2026-10-01 10:11:28.47663+08
2133	bedrock/ap-southeast-3/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-10-01 10:11:28.477735+08
2134	bedrock/eu-north-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-10-01 10:11:28.478574+08
2135	bedrock/eu-north-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-10-01 10:11:28.479711+08
2136	bedrock/eu-west-2/minimax.minimax-m2.1	0.470000	1.860000	0.000000	2026-10-01 10:11:28.482109+08
2137	bedrock/eu-west-2/minimax.minimax-m2.5	0.470000	1.860000	0.000000	2026-10-01 10:11:28.482714+08
2138	bedrock/eu-west-2/qwen.qwen3-coder-next	0.780000	1.860000	0.000000	2026-10-01 10:11:28.483288+08
2139	bedrock/sa-east-1/deepseek.v3.2	0.740000	2.220000	0.000000	2026-10-01 10:11:28.485018+08
2140	bedrock/sa-east-1/moonshotai.kimi-k2.5	0.720000	3.600000	0.000000	2026-10-01 10:11:28.486876+08
2141	cerebras/qwen-3-32b	0.400000	0.800000	0.000000	2026-10-01 10:11:28.494968+08
2142	cerebras/qwen-3.8-27b	0.990000	1.490000	0.000000	2026-10-01 10:11:28.495546+08
2143	cloudflare/@cf/deepseek-ai/deepseek-r1-distill-qwen-32b	0.497000	4.881000	0.000000	2026-10-01 10:11:28.496534+08
2144	cloudflare/@cf/zai-org/glm-4.7-flash	0.060500	0.400000	0.000000	2026-10-01 10:11:28.497539+08
2145	dashscope/deepseek-v4-flash	0.200000	0.400000	0.000000	2026-10-01 10:11:28.500561+08
2146	dashscope/deepseek-v4-flash-0731	0.200000	0.400000	0.000000	2026-10-01 10:11:28.501205+08
2147	dashscope/qwen-max	1.600000	6.400000	0.000000	2026-10-01 10:11:28.50406+08
2148	dashscope/qwen-plus	0.400000	1.200000	0.000000	2026-10-01 10:11:28.505346+08
2149	dashscope/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-10-01 10:11:28.505935+08
2150	dashscope/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-10-01 10:11:28.506541+08
2151	dashscope/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-10-01 10:11:28.507709+08
2152	dashscope/qwen-turbo	0.050000	0.200000	0.000000	2026-10-01 10:11:28.511237+08
2153	dashscope/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-10-01 10:11:28.511801+08
2154	dashscope/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-10-01 10:11:28.512416+08
2155	dashscope/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-10-01 10:11:28.512992+08
2156	dashscope/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-10-01 10:11:28.516665+08
2157	dashscope/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-10-01 10:11:28.517198+08
2158	qwencloud/deepseek-v4-flash	0.200000	0.400000	0.000000	2026-10-01 10:11:28.521248+08
2159	qwencloud/deepseek-v4-flash-0731	0.200000	0.400000	0.000000	2026-10-01 10:11:28.522011+08
2160	qwencloud/qwen-max	1.600000	6.400000	0.000000	2026-10-01 10:11:28.525143+08
2161	qwencloud/qwen-plus	0.400000	1.200000	0.000000	2026-10-01 10:11:28.525762+08
2162	qwencloud/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-10-01 10:11:28.526433+08
2163	qwencloud/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-10-01 10:11:28.526977+08
2164	qwencloud/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-10-01 10:11:28.527487+08
2165	qwencloud/qwen-turbo	0.050000	0.200000	0.000000	2026-10-01 10:11:28.529107+08
2166	qwencloud/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-10-01 10:11:28.529682+08
2167	qwencloud/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-10-01 10:11:28.530209+08
2168	qwencloud/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-10-01 10:11:28.530759+08
2169	qwencloud/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-10-01 10:11:28.534279+08
2170	qwencloud/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-10-01 10:11:28.535165+08
2171	qwencloud/qwq-plus	0.800000	2.400000	0.000000	2026-10-01 10:11:28.537573+08
2172	qwen_ai_platform/deepseek-v4-flash	0.200000	0.400000	0.000000	2026-10-01 10:11:28.53934+08
2173	qwen_ai_platform/deepseek-v4-flash-0731	0.200000	0.400000	0.000000	2026-10-01 10:11:28.53981+08
2174	qwen_ai_platform/qwen-max	1.600000	6.400000	0.000000	2026-10-01 10:11:28.542648+08
2175	qwen_ai_platform/qwen-plus	0.400000	1.200000	0.000000	2026-10-01 10:11:28.543271+08
2176	qwen_ai_platform/qwen-plus-2025-01-25	0.400000	1.200000	0.000000	2026-10-01 10:11:28.543902+08
2177	qwen_ai_platform/qwen-plus-2025-04-28	0.400000	1.200000	0.000000	2026-10-01 10:11:28.544417+08
2178	qwen_ai_platform/qwen-plus-2025-07-14	0.400000	1.200000	0.000000	2026-10-01 10:11:28.544888+08
2179	qwen_ai_platform/qwen-turbo	0.050000	0.200000	0.000000	2026-10-01 10:11:28.546651+08
2180	qwen_ai_platform/qwen-turbo-2024-11-01	0.050000	0.200000	0.000000	2026-10-01 10:11:28.547164+08
2181	qwen_ai_platform/qwen-turbo-2025-04-28	0.050000	0.200000	0.000000	2026-10-01 10:11:28.547644+08
2182	qwen_ai_platform/qwen-turbo-latest	0.050000	0.200000	0.000000	2026-10-01 10:11:28.548097+08
2183	qwen_ai_platform/qwen3-vl-235b-a22b-instruct	0.400000	1.600000	0.000000	2026-10-01 10:11:28.550942+08
2184	qwen_ai_platform/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-10-01 10:11:28.551396+08
2185	qwen_ai_platform/qwq-plus	0.800000	2.400000	0.000000	2026-10-01 10:11:28.553945+08
2186	databricks/databricks-deepseek-v4-pro-0813	1.319990	3.959970	0.000000	2026-10-01 10:11:28.555478+08
2187	databricks/databricks-glm-5-2	1.400000	4.399990	0.000000	2026-10-01 10:11:28.555926+08
2188	databricks/databricks-glm-5-3	1.400000	4.399990	0.000000	2026-10-01 10:11:28.556344+08
2189	databricks/databricks-glm-5-3-flash	0.150010	0.500010	0.000000	2026-10-01 10:11:28.556882+08
2190	databricks/databricks-qwen35-122b-a10b	0.220010	2.200030	0.000000	2026-10-01 10:11:28.558154+08
2191	deepinfra/Qwen/QwQ-32B	0.150000	0.400000	0.000000	2026-10-01 10:11:28.559119+08
2192	deepinfra/Qwen/Qwen2.5-72B-Instruct	0.360000	0.400000	0.000000	2026-10-01 10:11:28.559582+08
2193	deepinfra/Qwen/Qwen2.5-7B-Instruct	0.040000	0.100000	0.000000	2026-10-01 10:11:28.560105+08
2194	deepinfra/Qwen/Qwen2.5-VL-32B-Instruct	0.200000	0.600000	0.000000	2026-10-01 10:11:28.560582+08
2195	deepinfra/Qwen/Qwen3-235B-A22B-Thinking-2507	0.300000	2.900000	0.000000	2026-10-01 10:11:28.562047+08
2196	deepinfra/Qwen/Qwen3-Coder-480B-A35B-Instruct	0.400000	1.600000	0.000000	2026-10-01 10:11:28.562931+08
2197	deepinfra/deepseek-ai/DeepSeek-R1-0528	0.500000	2.150000	0.000000	2026-10-01 10:11:28.564273+08
2198	deepinfra/deepseek-ai/DeepSeek-R1-Distill-Llama-70B	0.200000	0.600000	0.000000	2026-10-01 10:11:28.564909+08
2199	deepinfra/deepseek-ai/DeepSeek-V3	0.320000	0.890000	0.000000	2026-10-01 10:11:28.56577+08
2200	deepinfra/deepseek-ai/DeepSeek-V3-0324	0.240000	0.900000	0.000000	2026-10-01 10:11:28.566187+08
2201	deepinfra/zai-org/GLM-4.5	0.400000	1.600000	0.000000	2026-10-01 10:11:28.567056+08
2202	deepseek/deepseek-r1	0.550000	2.190000	0.000000	2026-10-01 10:11:28.567851+08
2203	deepseek/deepseek-v3.2	0.280000	0.400000	0.000000	2026-10-01 10:11:28.568388+08
2204	sail/deepseek-ai/DeepSeek-V4-Pro-0813	0.920000	2.770000	0.000000	2026-10-01 10:11:28.570274+08
2205	sail/Qwen/Qwen3.6-35B-A3B	0.050000	0.400000	0.000000	2026-10-01 10:11:28.571153+08
2206	fireworks_ai/accounts/fireworks/models/deepseek-r1-basic	0.550000	2.190000	0.000000	2026-10-01 10:11:28.572657+08
2207	fireworks_ai/accounts/fireworks/models/deepseek-v3	0.900000	0.900000	0.000000	2026-10-01 10:11:28.573529+08
2208	fireworks_ai/accounts/fireworks/models/deepseek-v3-0324	0.900000	0.900000	0.000000	2026-10-01 10:11:28.573958+08
2209	fireworks_ai/accounts/fireworks/models/deepseek-v4-pro-0813	1.320000	3.960000	0.000000	2026-10-01 10:11:28.57488+08
2210	fireworks_ai/deepseek-v4-pro-0813	1.320000	3.960000	0.000000	2026-10-01 10:11:28.575238+08
2211	fireworks_ai/accounts/fireworks/models/glm-4p5	0.550000	2.190000	0.000000	2026-10-01 10:11:28.576145+08
2212	fireworks_ai/accounts/fireworks/models/glm-4p6	0.550000	2.190000	0.000000	2026-10-01 10:11:28.576621+08
2213	fireworks_ai/accounts/fireworks/models/qwen2-72b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.578915+08
2214	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.579504+08
2215	fireworks_ai/qwen3p7-plus	0.400000	1.600000	0.000000	2026-10-01 10:11:28.581276+08
2216	friendliai/zai-org/GLM-5.3	1.260000	3.960000	0.000000	2026-10-01 10:11:28.581687+08
2217	gmi/deepseek-ai/DeepSeek-V3.2	0.280000	0.400000	0.000000	2026-10-01 10:11:28.582636+08
2218	gmi/moonshotai/Kimi-K2-Thinking	0.800000	1.200000	0.000000	2026-10-01 10:11:28.583021+08
2219	gmi/zai-org/GLM-4.7-FP8	0.400000	2.000000	0.000000	2026-10-01 10:11:28.584524+08
2220	gradient_ai/deepseek-r1-distill-llama-70b	0.990000	0.990000	0.000000	2026-10-01 10:11:28.585886+08
2221	hyperbolic/Qwen/QwQ-32B	0.200000	0.200000	0.000000	2026-10-01 10:11:28.586444+08
2222	hyperbolic/deepseek-ai/DeepSeek-R1	0.400000	0.400000	0.000000	2026-10-01 10:11:28.587055+08
2223	hyperbolic/deepseek-ai/DeepSeek-V3	0.200000	0.200000	0.000000	2026-10-01 10:11:28.587419+08
2224	hyperbolic/deepseek-ai/DeepSeek-V3-0324	0.400000	0.400000	0.000000	2026-10-01 10:11:28.587672+08
2225	lambda_ai/deepseek-llama3.3-70b	0.200000	0.600000	0.000000	2026-10-01 10:11:28.588515+08
2226	lambda_ai/deepseek-r1-0528	0.200000	0.600000	0.000000	2026-10-01 10:11:28.588768+08
2227	lambda_ai/deepseek-r1-671b	0.800000	0.800000	0.000000	2026-10-01 10:11:28.589041+08
2228	lambda_ai/deepseek-v3-0324	0.200000	0.600000	0.000000	2026-10-01 10:11:28.589291+08
2229	lambda_ai/qwen25-coder-32b-instruct	0.050000	0.100000	0.000000	2026-10-01 10:11:28.589577+08
2230	lambda_ai/qwen3-32b-fp8	0.050000	0.100000	0.000000	2026-10-01 10:11:28.590258+08
2231	moonshot/moonshot-v1-8k	0.200000	2.000000	0.000000	2026-10-01 10:11:28.594338+08
2232	moonshot/moonshot-v1-8k-vision-preview	0.200000	2.000000	0.000000	2026-10-01 10:11:28.595032+08
2233	nscale/Qwen/QwQ-32B	0.180000	0.200000	0.000000	2026-10-01 10:11:28.59547+08
2234	nscale/Qwen/Qwen2.5-Coder-32B-Instruct	0.060000	0.200000	0.000000	2026-10-01 10:11:28.595733+08
2235	nscale/deepseek-ai/DeepSeek-R1-Distill-Llama-8B	0.025000	0.025000	0.000000	2026-10-01 10:11:28.596335+08
2236	nscale/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B	0.200000	0.200000	0.000000	2026-10-01 10:11:28.596997+08
2237	nebius/deepseek-ai/DeepSeek-R1	0.800000	2.400000	0.000000	2026-10-01 10:11:28.597294+08
2238	nebius/deepseek-ai/DeepSeek-R1-0528	0.800000	2.400000	0.000000	2026-10-01 10:11:28.597593+08
2239	nebius/Qwen/Qwen3-235B-A22B	0.200000	0.600000	0.000000	2026-10-01 10:11:28.59821+08
2240	nebius/Qwen/Qwen3-32B	0.100000	0.300000	0.000000	2026-10-01 10:11:28.59856+08
2241	nebius/Qwen/Qwen3-30B-A3B	0.100000	0.300000	0.000000	2026-10-01 10:11:28.598959+08
2242	nebius/Qwen/QwQ-32B	0.150000	0.450000	0.000000	2026-10-01 10:11:28.599434+08
2243	nebius/Qwen/Qwen2.5-72B-Instruct	0.130000	0.400000	0.000000	2026-10-01 10:11:28.599688+08
2244	nebius/Qwen/Qwen2.5-32B-Instruct	0.060000	0.200000	0.000000	2026-10-01 10:11:28.599948+08
2245	nebius/Qwen/Qwen2-VL-72B-Instruct	0.130000	0.400000	0.000000	2026-10-01 10:11:28.60042+08
2246	nebius/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.000000	2026-10-01 10:11:28.601173+08
2247	nebius/Qwen/Qwen3-235B-A22B-Instruct-2507	0.200000	0.600000	0.000000	2026-10-01 10:11:28.602358+08
2248	nebius/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-10-01 10:11:28.602611+08
2249	nebius/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.000000	2026-10-01 10:11:28.602974+08
2250	openrouter/deepseek/deepseek-chat-v3-0324	0.290000	1.140000	0.000000	2026-10-01 10:11:28.604607+08
2251	openrouter/deepseek/deepseek-r1-0528	0.500000	2.150000	0.000000	2026-10-01 10:11:28.605426+08
2252	openrouter/deepseek/deepseek-v4-pro	0.783000	1.566000	0.000000	2026-10-01 10:11:28.605695+08
2253	openrouter/deepseek/deepseek-v4.1-flash	0.019800	0.396000	0.000000	2026-10-01 10:11:28.606343+08
2254	openrouter/deepseek/deepseek-v4-pro-0813	1.320000	3.960000	0.000000	2026-10-01 10:11:28.606595+08
2255	openrouter/moonshotai/kimi-k2.5	0.450000	2.250000	0.000000	2026-10-01 10:11:28.606946+08
2256	openrouter/qwen/qwen3-235b-a22b-thinking-2507	0.230000	2.300000	0.000000	2026-10-01 10:11:28.607771+08
2257	openrouter/z-ai/glm-4.6:exacto	0.450000	1.900000	0.000000	2026-10-01 10:11:28.608941+08
2258	openrouter/xiaomi/mimo-v2-flash	0.100000	0.300000	0.000000	2026-10-01 10:11:28.609193+08
2259	openrouter/z-ai/glm-4.7-flash	0.060500	0.400000	0.000000	2026-10-01 10:11:28.609786+08
2260	openrouter/z-ai/glm-5.1	0.964600	3.031600	0.000000	2026-10-01 10:11:28.610148+08
2261	ovhcloud/Qwen2.5-VL-72B-Instruct	0.910000	0.910000	0.000000	2026-10-01 10:11:28.610842+08
2262	ovhcloud/Qwen3-32B	0.080000	0.230000	0.000000	2026-10-01 10:11:28.611106+08
2263	qwen.qwen3-coder-480b-a35b-v1:0	0.450000	1.800000	0.000000	2026-10-01 10:11:28.611942+08
2264	bedrock/ap-northeast-1/qwen.qwen3-next-80b-a3b	0.180000	1.450000	0.000000	2026-10-01 10:11:28.612605+08
2265	bedrock/ap-south-1/qwen.qwen3-next-80b-a3b	0.180000	1.410000	0.000000	2026-10-01 10:11:28.612861+08
2266	bedrock/eu-west-1/qwen.qwen3-next-80b-a3b	0.180000	1.410000	0.000000	2026-10-01 10:11:28.613378+08
2267	bedrock/eu-west-2/qwen.qwen3-next-80b-a3b	0.230000	1.860000	0.000000	2026-10-01 10:11:28.613635+08
2268	bedrock/sa-east-1/qwen.qwen3-next-80b-a3b	0.180000	1.450000	0.000000	2026-10-01 10:11:28.613907+08
2269	replicate/qwen/qwen3-235b-a22b-instruct-2507	0.264000	1.060000	0.000000	2026-10-01 10:11:28.614469+08
2270	replicate/deepseek-ai/deepseek-v3	1.450000	1.450000	0.000000	2026-10-01 10:11:28.614737+08
2271	replicate/deepseek-ai/deepseek-v3.1	0.672000	2.016000	0.000000	2026-10-01 10:11:28.615003+08
2272	scx-ai/GLM-5.2	0.610000	1.980000	0.000000	2026-10-01 10:11:28.615889+08
2273	scx-ai/Qwen3.8-Max	1.650000	4.990000	0.000000	2026-10-01 10:11:28.616138+08
2274	together_ai/Qwen/Qwen3.5-9B	0.170000	0.250000	0.000000	2026-10-01 10:11:28.61741+08
2275	together_ai/arize-ai/qwen-2-1.5b-instruct	0.100000	0.100000	0.000000	2026-10-01 10:11:28.618278+08
2276	together_ai/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.000000	2026-10-01 10:11:28.618771+08
2277	eu.deepseek.v3.2	0.740000	2.220000	0.000000	2026-10-01 10:11:28.619863+08
2278	vercel_ai_gateway/alibaba/qwen-3-235b	0.200000	0.600000	0.000000	2026-10-01 10:11:28.620262+08
2279	vercel_ai_gateway/alibaba/qwen-3-30b	0.100000	0.300000	0.000000	2026-10-01 10:11:28.620541+08
2280	vercel_ai_gateway/alibaba/qwen-3-32b	0.100000	0.300000	0.000000	2026-10-01 10:11:28.620817+08
2281	vercel_ai_gateway/alibaba/qwen3-coder	0.400000	1.600000	0.000000	2026-10-01 10:11:28.621082+08
2282	vercel_ai_gateway/deepseek/deepseek-r1	0.550000	2.190000	0.000000	2026-10-01 10:11:28.621361+08
2283	vercel_ai_gateway/deepseek/deepseek-r1-distill-llama-70b	0.750000	0.990000	0.000000	2026-10-01 10:11:28.621783+08
2284	vercel_ai_gateway/deepseek/deepseek-v3	0.900000	0.900000	0.000000	2026-10-01 10:11:28.622047+08
2285	vercel_ai_gateway/zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-10-01 10:11:28.622867+08
2286	vercel_ai_gateway/zai/glm-4.6	0.450000	1.800000	0.000000	2026-10-01 10:11:28.623167+08
2287	vertex_ai/zai-org/glm-5-maas	1.000000	3.200000	0.000000	2026-10-01 10:11:28.624222+08
2288	vertex_ai/qwen/qwen3-coder-480b-a35b-instruct-maas	0.220000	1.800000	0.000000	2026-10-01 10:11:28.624766+08
2289	wandb/deepseek-ai/DeepSeek-V3.1	0.550000	1.650000	0.000000	2026-10-01 10:11:28.625447+08
2290	zai.glm-5	1.000000	3.200000	0.000000	2026-10-01 10:11:28.625903+08
2291	zai.glm-4.7-flash	0.070000	0.400000	0.000000	2026-10-01 10:11:28.626222+08
2292	zai/glm-5	1.000000	3.200000	0.000000	2026-10-01 10:11:28.626478+08
2293	zai/glm-4.5v	0.600000	1.800000	0.000000	2026-10-01 10:11:28.627625+08
2294	zai/glm-4.5-air	0.200000	1.100000	0.000000	2026-10-01 10:11:28.628014+08
2295	zai/glm-4-32b-0414-128k	0.100000	0.100000	0.000000	2026-10-01 10:11:28.628377+08
2296	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-a35b-instruct	0.450000	1.800000	0.000000	2026-10-01 10:11:28.628795+08
2297	fireworks_ai/accounts/fireworks/models/code-qwen-1p5-7b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.629276+08
2298	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-14b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.629573+08
2299	fireworks_ai/accounts/fireworks/models/cogito-v1-preview-qwen-32b	0.900000	0.900000	0.000000	2026-10-01 10:11:28.629854+08
2300	fireworks_ai/accounts/fireworks/models/deepseek-coder-1b-base	0.100000	0.100000	0.000000	2026-10-01 10:11:28.630137+08
2301	fireworks_ai/accounts/fireworks/models/deepseek-coder-33b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.630421+08
2302	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base	0.200000	0.200000	0.000000	2026-10-01 10:11:28.630709+08
2303	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-base-v1p5	0.200000	0.200000	0.000000	2026-10-01 10:11:28.631018+08
2304	fireworks_ai/accounts/fireworks/models/deepseek-coder-7b-instruct-v1p5	0.200000	0.200000	0.000000	2026-10-01 10:11:28.631325+08
2305	fireworks_ai/accounts/fireworks/models/deepseek-r1-0528-distill-qwen3-8b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.63199+08
2306	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-70b	0.900000	0.900000	0.000000	2026-10-01 10:11:28.632265+08
2307	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-llama-8b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.632549+08
2308	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-14b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.632834+08
2309	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-1p5b	0.100000	0.100000	0.000000	2026-10-01 10:11:28.633104+08
2310	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-32b	0.900000	0.900000	0.000000	2026-10-01 10:11:28.633384+08
2311	fireworks_ai/accounts/fireworks/models/deepseek-r1-distill-qwen-7b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.633676+08
2312	fireworks_ai/accounts/fireworks/models/dolphin-2-9-2-qwen2-72b	0.900000	0.900000	0.000000	2026-10-01 10:11:28.634207+08
2313	fireworks_ai/accounts/fireworks/models/minimax-m1-80k	0.100000	0.100000	0.000000	2026-10-01 10:11:28.634704+08
2314	fireworks_ai/accounts/fireworks/models/qwen-qwq-32b-preview	0.900000	0.900000	0.000000	2026-10-01 10:11:28.635168+08
2315	fireworks_ai/accounts/fireworks/models/qwen-v2p5-14b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.635471+08
2316	fireworks_ai/accounts/fireworks/models/qwen-v2p5-7b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.635763+08
2317	fireworks_ai/accounts/fireworks/models/qwen1p5-72b-chat	0.900000	0.900000	0.000000	2026-10-01 10:11:28.636053+08
2318	fireworks_ai/accounts/fireworks/models/qwen2-7b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.636344+08
2319	fireworks_ai/accounts/fireworks/models/qwen2-vl-2b-instruct	0.100000	0.100000	0.000000	2026-10-01 10:11:28.636629+08
2320	fireworks_ai/accounts/fireworks/models/qwen2-vl-72b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.637052+08
2321	fireworks_ai/accounts/fireworks/models/qwen2-vl-7b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.637329+08
2322	fireworks_ai/accounts/fireworks/models/qwen2p5-0p5b-instruct	0.100000	0.100000	0.000000	2026-10-01 10:11:28.637618+08
2323	fireworks_ai/accounts/fireworks/models/qwen2p5-14b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.637895+08
2324	fireworks_ai/accounts/fireworks/models/qwen2p5-1p5b-instruct	0.100000	0.100000	0.000000	2026-10-01 10:11:28.638164+08
2325	fireworks_ai/accounts/fireworks/models/qwen2p5-32b	0.900000	0.900000	0.000000	2026-10-01 10:11:28.638434+08
2326	fireworks_ai/accounts/fireworks/models/qwen2p5-32b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.638703+08
2327	fireworks_ai/accounts/fireworks/models/qwen2p5-72b	0.900000	0.900000	0.000000	2026-10-01 10:11:28.638995+08
2328	fireworks_ai/accounts/fireworks/models/qwen2p5-72b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.639483+08
2329	fireworks_ai/accounts/fireworks/models/qwen2p5-7b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.640044+08
2330	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b	0.100000	0.100000	0.000000	2026-10-01 10:11:28.640308+08
2331	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-0p5b-instruct	0.100000	0.100000	0.000000	2026-10-01 10:11:28.64058+08
2332	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.640867+08
2333	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-14b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.64115+08
2334	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b	0.100000	0.100000	0.000000	2026-10-01 10:11:28.641447+08
2335	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-1p5b-instruct	0.100000	0.100000	0.000000	2026-10-01 10:11:28.641742+08
2336	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b	0.900000	0.900000	0.000000	2026-10-01 10:11:28.642057+08
2337	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-128k	0.900000	0.900000	0.000000	2026-10-01 10:11:28.642696+08
2338	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-32k-rope	0.900000	0.900000	0.000000	2026-10-01 10:11:28.64315+08
2339	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-32b-instruct-64k	0.900000	0.900000	0.000000	2026-10-01 10:11:28.643451+08
2340	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b	0.100000	0.100000	0.000000	2026-10-01 10:11:28.643736+08
2341	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-3b-instruct	0.100000	0.100000	0.000000	2026-10-01 10:11:28.644019+08
2342	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.644306+08
2343	fireworks_ai/accounts/fireworks/models/qwen2p5-coder-7b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.644595+08
2344	fireworks_ai/accounts/fireworks/models/qwen2p5-math-72b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.644882+08
2345	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-32b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.645167+08
2346	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-3b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.645461+08
2347	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-72b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.645734+08
2348	fireworks_ai/accounts/fireworks/models/qwen2p5-vl-7b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.646035+08
2349	fireworks_ai/accounts/fireworks/models/qwen3-0p6b	0.100000	0.100000	0.000000	2026-10-01 10:11:28.64632+08
2350	fireworks_ai/accounts/fireworks/models/qwen3-14b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.646609+08
2351	fireworks_ai/accounts/fireworks/models/qwen3-1p7b	0.100000	0.100000	0.000000	2026-10-01 10:11:28.64688+08
2352	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft	0.100000	0.100000	0.000000	2026-10-01 10:11:28.647163+08
2353	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-131072	0.100000	0.100000	0.000000	2026-10-01 10:11:28.647463+08
2354	fireworks_ai/accounts/fireworks/models/qwen3-1p7b-fp8-draft-40960	0.100000	0.100000	0.000000	2026-10-01 10:11:28.647767+08
2355	fireworks_ai/accounts/fireworks/models/qwen3-30b-a3b-thinking-2507	0.900000	0.900000	0.000000	2026-10-01 10:11:28.64865+08
2356	fireworks_ai/accounts/fireworks/models/qwen3-32b	0.900000	0.900000	0.000000	2026-10-01 10:11:28.648915+08
2357	fireworks_ai/accounts/fireworks/models/qwen3-4b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.649188+08
2358	fireworks_ai/accounts/fireworks/models/qwen3-4b-instruct-2507	0.200000	0.200000	0.000000	2026-10-01 10:11:28.649479+08
2359	fireworks_ai/accounts/fireworks/models/qwen3-8b	0.200000	0.200000	0.000000	2026-10-01 10:11:28.649882+08
2360	fireworks_ai/accounts/fireworks/models/qwen3-coder-480b-instruct-bf16	0.900000	0.900000	0.000000	2026-10-01 10:11:28.650277+08
2361	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.65079+08
2362	fireworks_ai/accounts/fireworks/models/qwen3-next-80b-a3b-thinking	0.900000	0.900000	0.000000	2026-10-01 10:11:28.65108+08
2363	fireworks_ai/accounts/fireworks/models/qwen3-reranker-8b	0.200000	0.000000	0.000000	2026-10-01 10:11:28.651685+08
2364	fireworks_ai/accounts/fireworks/models/qwen3-vl-32b-instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.652478+08
2365	fireworks_ai/accounts/fireworks/models/qwen3-vl-8b-instruct	0.200000	0.200000	0.000000	2026-10-01 10:11:28.652772+08
2366	fireworks_ai/accounts/fireworks/models/qwen3p7-plus	0.400000	1.600000	0.000000	2026-10-01 10:11:28.653065+08
2367	scaleway/qwen/qwen3.5-397b-a17b	0.600000	3.600000	0.000000	2026-10-01 10:11:28.653743+08
2368	scaleway/qwen/qwen3-embedding-8b	0.100000	0.000000	0.000000	2026-10-01 10:11:28.654246+08
2369	scaleway/qwen/qwen3-coder-30b-a3b-instruct	0.200000	0.800000	0.000000	2026-10-01 10:11:28.654506+08
2370	novita/deepseek/deepseek-v3.2	0.269000	0.400000	0.000000	2026-10-01 10:11:28.654776+08
2371	novita/zai-org/autoglm-phone-9b-multilingual	0.035000	0.138000	0.000000	2026-10-01 10:11:28.655382+08
2372	novita/zai-org/glm-4.6v	0.300000	0.900000	0.000000	2026-10-01 10:11:28.656524+08
2373	novita/qwen/qwen3-max	2.110000	8.450000	0.000000	2026-10-01 10:11:28.657488+08
2374	novita/moonshotai/kimi-k2-instruct	0.570000	2.300000	0.000000	2026-10-01 10:11:28.658314+08
2375	novita/zai-org/glm-4.5v	0.600000	1.800000	0.000000	2026-10-01 10:11:28.65901+08
2376	novita/qwen/qwen-2.5-72b-instruct	0.380000	0.400000	0.000000	2026-10-01 10:11:28.65955+08
2377	novita/deepseek/deepseek-r1-distill-llama-70b	0.800000	0.800000	0.000000	2026-10-01 10:11:28.660286+08
2378	novita/qwen/qwen3-235b-a22b-fp8	0.200000	0.800000	0.000000	2026-10-01 10:11:28.660732+08
2379	novita/qwen/qwen2.5-vl-72b-instruct	0.800000	0.800000	0.000000	2026-10-01 10:11:28.66101+08
2380	novita/qwen/qwen3-32b-fp8	0.100000	0.450000	0.000000	2026-10-01 10:11:28.661404+08
2381	novita/qwen/qwen3-30b-a3b-fp8	0.090000	0.450000	0.000000	2026-10-01 10:11:28.66169+08
2382	novita/deepseek/deepseek-v3-turbo	0.400000	1.300000	0.000000	2026-10-01 10:11:28.661966+08
2383	novita/qwen/qwen3-vl-30b-a3b-instruct	0.200000	0.700000	0.000000	2026-10-01 10:11:28.662576+08
2384	novita/qwen/qwen3-vl-30b-a3b-thinking	0.200000	1.000000	0.000000	2026-10-01 10:11:28.662841+08
2385	novita/qwen/qwen3-omni-30b-a3b-thinking	0.250000	0.970000	0.000000	2026-10-01 10:11:28.663113+08
2386	novita/qwen/qwen3-omni-30b-a3b-instruct	0.250000	0.970000	0.000000	2026-10-01 10:11:28.663375+08
2387	novita/qwen/qwen3-8b-fp8	0.035000	0.138000	0.000000	2026-10-01 10:11:28.663784+08
2388	novita/qwen/qwen3-reranker-8b	0.050000	0.050000	0.000000	2026-10-01 10:11:28.664532+08
2389	llamagate/deepseek-r1-8b	0.100000	0.200000	0.000000	2026-10-01 10:11:28.664903+08
2390	bedrock/us-east-1/zai.glm-5	1.000000	3.200000	0.000000	2026-10-01 10:11:28.666709+08
2391	bedrock/us-west-2/zai.glm-5	1.000000	3.200000	0.000000	2026-10-01 10:11:28.666972+08
2392	tensormesh/Qwen/Qwen3.5-397B-A17B-FP8	0.600000	3.600000	0.000000	2026-10-01 10:11:28.667241+08
2393	tensormesh/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8	0.450000	1.800000	0.000000	2026-10-01 10:11:28.667509+08
2394	tensormesh/Qwen/Qwen3.6-27B-FP8	0.320000	3.200000	0.000000	2026-10-01 10:11:28.667801+08
2395	deepseek-v4-pro	1.320000	3.960000	0.000000	2026-10-01 10:11:28.668973+08
2396	deepseek/deepseek-v4-pro	1.320000	3.960000	0.000000	2026-10-01 10:11:28.669608+08
2397	pinstripes/ps/glm-4.5-air	0.125000	0.450000	0.000000	2026-10-01 10:11:28.670218+08
2398	pinstripes/ps/qwen3.6-35b-a3b	0.140000	0.450000	0.000000	2026-10-01 10:11:28.67048+08
2399	pinstripes/ps/qwen3-30b-a3b	0.090000	0.200000	0.000000	2026-10-01 10:11:28.67075+08
2400	pinstripes/ps/deepseek-v4-flash	0.100000	0.200000	0.000000	2026-10-01 10:11:28.671113+08
2401	fireworks_ai/accounts/fireworks/routers/deepseek-v4p1-flash-us	0.450000	1.800000	0.000000	2026-10-01 10:11:28.67177+08
2402	fireworks_ai/deepseek-v4p1-flash-us	0.450000	1.800000	0.000000	2026-10-01 10:11:28.672585+08
2403	fireworks_ai/glm-5p2-fast	2.100000	6.600000	0.000000	2026-10-01 10:11:28.672972+08
2404	fireworks_ai/glm-5p2-fast-us	2.100000	6.600000	0.000000	2026-10-01 10:11:28.673662+08
2405	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast	2.100000	6.600000	0.000000	2026-10-01 10:11:28.674615+08
2406	fireworks_ai/accounts/fireworks/routers/glm-5p2-fast-us	2.100000	6.600000	0.000000	2026-10-01 10:11:28.674945+08
2407	novita/deepseek/deepseek-v4-pro-0813	1.320000	3.960000	0.000000	2026-10-01 10:11:28.675646+08
2408	wandb/deepseek-ai/DeepSeek-V4-Pro	1.150000	2.550000	0.000000	2026-10-01 10:11:28.680537+08
2409	wandb/MiniMaxAI/MiniMax-M3	0.230000	0.960000	0.000000	2026-10-01 10:11:28.680812+08
2410	wandb/OpenPipe/Qwen3-14B-Instruct	0.050000	0.220000	0.000000	2026-10-01 10:11:28.681319+08
2411	wandb/Qwen/Qwen3.8-27B	0.400000	3.000000	0.000000	2026-10-01 10:11:28.68158+08
2412	wandb/Qwen/Qwen3.6-27B	0.600000	3.600000	0.000000	2026-10-01 10:11:28.681943+08
2413	wandb/Qwen/Qwen3-30B-A3B-Instruct-2507	0.100000	0.300000	0.000000	2026-10-01 10:11:28.682299+08
2414	wandb/deepseek-ai/DeepSeek-V4-Pro-0813	1.310000	3.960000	0.000000	2026-10-01 10:11:28.682555+08
2415	deepinfra/Qwen/Qwen3.8-27B	0.400000	3.000000	0.000000	2026-10-01 10:11:28.683037+08
2416	deepinfra/moonshotai/Kimi-K2.5	0.450000	2.250000	0.000000	2026-10-01 10:11:28.683309+08
2417	deepinfra/zai-org/GLM-4.7-Flash	0.060000	0.400000	0.000000	2026-10-01 10:11:28.683581+08
2418	deepinfra/XiaomiMiMo/MiMo-V2.5	0.400000	2.000000	0.000000	2026-10-01 10:11:28.684076+08
2419	deepinfra/Qwen/Qwen3-VL-235B-A22B-Instruct	0.200000	0.880000	0.000000	2026-10-01 10:11:28.684573+08
2420	deepinfra/Qwen/Qwen3.6-35B-A3B	0.100000	0.950000	0.000000	2026-10-01 10:11:28.685115+08
2421	deepinfra/moonshotai/Kimi-K2.7-Code	0.680000	3.400000	0.000000	2026-10-01 10:11:28.686223+08
2422	deepinfra/Qwen/Qwen3.5-397B-A17B	0.450000	3.000000	0.000000	2026-10-01 10:11:28.686508+08
2423	deepinfra/Qwen/Qwen3.8-Max	1.650000	4.951000	0.000000	2026-10-01 10:11:28.687012+08
2424	deepinfra/zai-org/GLM-5.1	1.050000	3.500000	0.000000	2026-10-01 10:11:28.6874+08
2425	deepinfra/moonshotai/Kimi-K3	2.850000	14.250000	0.000000	2026-10-01 10:11:28.687868+08
2426	deepinfra/Qwen/Qwen3.6-27B	0.320000	3.200000	0.000000	2026-10-01 10:11:28.688116+08
2427	deepinfra/Qwen/Qwen3.5-9B	0.100000	0.150000	0.000000	2026-10-01 10:11:28.688604+08
2428	deepinfra/zai-org/GLM-4.7	0.400000	1.750000	0.000000	2026-10-01 10:11:28.68898+08
2429	groq/qwen/qwen3.8-27b	0.800000	4.000000	0.000000	2026-10-01 10:11:28.689275+08
2430	fireworks_ai/accounts/fireworks/routers/glm-5p3-us	2.100000	6.600000	0.000000	2026-10-01 10:11:28.689669+08
2431	fireworks_ai/glm-5p3-us	2.100000	6.600000	0.000000	2026-10-01 10:11:28.690239+08
2432	fireworks_ai/accounts/fireworks/routers/glm-5p3-fast	2.100000	6.600000	0.000000	2026-10-01 10:11:28.690703+08
2433	fireworks_ai/glm-5p3-fast	2.100000	6.600000	0.000000	2026-10-01 10:11:28.691181+08
2434	fireworks_ai/accounts/fireworks/routers/glm-5p3-flash-us	0.225000	0.750000	0.000000	2026-10-01 10:11:28.691592+08
2435	fireworks_ai/glm-5p3-flash-us	0.225000	0.750000	0.000000	2026-10-01 10:11:28.692006+08
2436	fireworks_ai/accounts/fireworks/models/qwen3-embedding-8b	0.100000	0.000000	0.000000	2026-10-01 10:11:28.692265+08
2437	together_ai/Qwen/Qwen3.8-Flash	0.090000	0.282000	0.000000	2026-10-01 10:11:28.692635+08
2438	scaleway/glm-5.2	1.800000	5.500000	0.000000	2026-10-01 10:11:28.693229+08
2439	scaleway/deepseek-v4-flash-0731	0.400000	0.800000	0.000000	2026-10-01 10:11:28.693483+08
2440	azure_ai/deepseek-v3-0324	1.140000	4.560000	0.000000	2026-10-01 10:11:28.694603+08
2441	bedrock_mantle/qwen.qwen3-coder-480b-a35b-instruct	0.450000	1.800000	0.000000	2026-10-01 10:11:28.695699+08
2442	baseten/zai-org/GLM-5.3-Fast	2.100000	6.600000	0.000000	2026-10-01 10:11:28.696623+08
2443	openrouter/deepseek/deepseek-v4-flash-vision-exp	0.215600	0.646800	0.000000	2026-10-01 10:11:28.697405+08
2444	openrouter/deepseek/deepseek-v4-flash-0731	0.008900	1.280000	0.000000	2026-10-01 10:11:28.698433+08
2445	openrouter/moonshotai/kimi-k3	0.280000	10.000000	0.000000	2026-10-01 10:11:28.69884+08
2446	openrouter/z-ai/glm-5.2	0.324900	3.990000	0.000000	2026-10-01 10:11:28.699101+08
2447	openrouter/moonshotai/kimi-k2.7-code	0.671200	3.350000	0.000000	2026-10-01 10:11:28.699473+08
2448	openrouter/qwen/qwen3.5-plus-20260420	0.300000	1.800000	0.000000	2026-10-01 10:11:28.69997+08
2449	openrouter/qwen/qwen3.6-max-preview	1.027000	6.162000	0.000000	2026-10-01 10:11:28.700461+08
2450	openrouter/qwen/qwen3.6-27b	0.320000	3.200000	0.000000	2026-10-01 10:11:28.700727+08
2451	openrouter/deepseek/deepseek-v4-flash	0.078540	0.157080	0.000000	2026-10-01 10:11:28.700996+08
2452	openrouter/minimax/minimax-m2.7	0.210000	0.840000	0.000000	2026-10-01 10:11:28.701574+08
2453	openrouter/qwen/qwen3.5-9b	0.100000	0.150000	0.000000	2026-10-01 10:11:28.702087+08
2454	openrouter/qwen/qwen3-coder-next	0.120000	0.800000	0.000000	2026-10-01 10:11:28.702497+08
2455	openrouter/z-ai/glm-4.6v	0.300000	0.900000	0.000000	2026-10-01 10:11:28.702886+08
2456	openrouter/qwen/qwen3-vl-32b-instruct	0.104000	0.416000	0.000000	2026-10-01 10:11:28.703282+08
2457	openrouter/qwen/qwen3-vl-8b-thinking	0.180000	2.100000	0.000000	2026-10-01 10:11:28.703552+08
2458	openrouter/qwen/qwen3-vl-8b-instruct	0.117000	0.455000	0.000000	2026-10-01 10:11:28.703827+08
2459	openrouter/qwen/qwen3-vl-30b-a3b-thinking	0.200000	2.400000	0.000000	2026-10-01 10:11:28.704108+08
2460	openrouter/qwen/qwen3-vl-235b-a22b-thinking	0.400000	4.000000	0.000000	2026-10-01 10:11:28.704497+08
2461	openrouter/deepseek/deepseek-v3.1-terminus	0.300000	1.000000	0.000000	2026-10-01 10:11:28.705014+08
2462	openrouter/qwen/qwen3-next-80b-a3b-instruct	0.100000	1.100000	0.000000	2026-10-01 10:11:28.705513+08
2463	openrouter/qwen/qwen3-30b-a3b-thinking-2507	0.200000	2.400000	0.000000	2026-10-01 10:11:28.706025+08
2464	openrouter/z-ai/glm-4.5v	0.600000	1.800000	0.000000	2026-10-01 10:11:28.706272+08
2465	openrouter/qwen/qwen3-30b-a3b-instruct-2507	0.048150	0.193050	0.000000	2026-10-01 10:11:28.706634+08
2466	openrouter/moonshotai/kimi-k2	0.570000	2.300000	0.000000	2026-10-01 10:11:28.707119+08
2467	openrouter/minimax/minimax-m1	0.400000	2.200000	0.000000	2026-10-01 10:11:28.70737+08
2468	openrouter/qwen/qwen3-8b	0.117000	0.455000	0.000000	2026-10-01 10:11:28.707742+08
2469	openrouter/qwen/qwen3-235b-a22b	0.455000	1.820000	0.000000	2026-10-01 10:11:28.708249+08
2470	openrouter/qwen/qwen2.5-vl-72b-instruct	0.800000	1.000000	0.000000	2026-10-01 10:11:28.708544+08
2471	openrouter/deepseek/deepseek-r1-distill-llama-70b	0.800000	0.800000	0.000000	2026-10-01 10:11:28.709002+08
2472	openrouter/minimax/minimax-01	0.200000	1.100000	0.000000	2026-10-01 10:11:28.709285+08
2473	openrouter/qwen/qwen-2.5-7b-instruct	0.100000	0.200000	0.000000	2026-10-01 10:11:28.709695+08
2474	openrouter/qwen/qwen-2.5-72b-instruct	0.360000	0.400000	0.000000	2026-10-01 10:11:28.709956+08
2475	together_ai/Qwen/Qwen2.5-14B-Instruct	0.800000	0.800000	0.000000	2026-10-01 10:11:28.710388+08
2476	together_ai/Qwen/Qwen2-72B-Instruct	0.900000	0.900000	0.000000	2026-10-01 10:11:28.710886+08
2477	together_ai/Qwen/Qwen2.5-Coder-32B-Instruct	0.800000	0.800000	0.000000	2026-10-01 10:11:28.711388+08
2478	together_ai/Qwen/Qwen3-VL-8B-Instruct	0.180000	0.680000	0.000000	2026-10-01 10:11:28.712378+08
2479	together_ai/Qwen/Qwen3.5-397B-A17B	0.600000	3.600000	0.000000	2026-10-01 10:11:28.712659+08
2480	together_ai/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B	1.600000	1.600000	0.000000	2026-10-01 10:11:28.713199+08
2481	together_ai/deepseek-ai/deepseek-coder-33b-instruct	0.800000	0.800000	0.000000	2026-10-01 10:11:28.713594+08
2482	together_ai/zai-org/GLM-4.5-Air-FP8	0.200000	1.100000	0.000000	2026-10-01 10:11:28.714127+08
2483	together_ai/zai-org/GLM-4.7	0.450000	2.000000	0.000000	2026-10-01 10:11:28.71442+08
2484	together_ai/zai-org/GLM-5	1.000000	3.200000	0.000000	2026-10-01 10:11:28.714689+08
2485	aihubmix/coding-kimi-k3	0.440000	1.613330	0.000000	2026-10-01 10:11:28.715345+08
2486	aihubmix/coding-xiaomi-mimo-v2-omni	0.080000	0.400000	0.000000	2026-10-01 10:11:28.715593+08
2487	aihubmix/coding-xiaomi-mimo-v2.5-pro	0.200000	0.400000	0.000000	2026-10-01 10:11:28.71596+08
2488	aihubmix/glm-5.3	1.126800	3.943800	0.000000	2026-10-01 10:11:28.716583+08
2489	aihubmix/glm-5v-turbo	0.704200	3.098480	0.000000	2026-10-01 10:11:28.716954+08
2490	aihubmix/kimi-k2.6	0.950000	3.999500	0.000000	2026-10-01 10:11:28.717219+08
2491	aihubmix/kimi-k2.7-code-highspeed	1.900000	7.999000	0.000000	2026-10-01 10:11:28.717477+08
2492	aihubmix/mimo-v2-pro	1.100000	3.300000	0.000000	2026-10-01 10:11:28.717965+08
2493	aihubmix/qwen3-coder-next	0.137000	0.548000	0.000000	2026-10-01 10:11:28.718476+08
2494	aihubmix/qwen3.5-397b-a17b	0.164400	0.986400	0.000000	2026-10-01 10:11:28.718838+08
2495	aihubmix/qwen3.7-plus	0.282000	1.128000	0.000000	2026-10-01 10:11:28.719474+08
2496	aihubmix/qwen3.8-max	1.690000	5.070000	0.000000	2026-10-01 10:11:28.719972+08
2497	wandb/deepseek-ai/DeepSeek-V4.1-Flash	0.200000	0.650000	0.000000	2026-10-01 10:11:28.720246+08
2498	openrouter/~deepseek/deepseek-pro-latest	1.320000	3.960000	0.000000	2026-10-01 10:11:28.720731+08
2499	openrouter/~z-ai/glm-latest	0.653800	2.054800	0.000000	2026-10-01 10:11:28.721347+08
2500	openrouter/moonshotai/kimi-k3:batch	2.280000	11.400000	0.000000	2026-10-01 10:11:28.721675+08
2501	openrouter/z-ai/glm-5.3-flash:batch	0.060000	0.200000	0.000000	2026-10-01 10:11:28.722122+08
2502	openrouter/z-ai/glm-5.3:batch	0.450000	2.000000	0.000000	2026-10-01 10:11:28.7224+08
2503	moonshotai.kimi-k3	3.300000	16.500000	0.000000	2026-10-01 10:11:28.722877+08
2504	us.moonshotai.kimi-k3	3.300000	16.500000	0.000000	2026-10-01 10:11:28.723235+08
2505	baseten/deepseek-ai/DeepSeek-V4-Pro-0813	1.320000	3.960000	0.000000	2026-10-01 10:11:28.725023+08
2506	baseten/zai-org/GLM-5.2-Fast	2.100000	6.600000	0.000000	2026-10-01 10:11:28.725275+08
2507	openrouter/deepseek/deepseek-v4.1-flash:batch	0.112000	0.336000	0.000000	2026-10-01 10:11:28.725784+08
2508	prism/deepseek-v4.1-flash	0.170000	0.630000	0.000000	2026-10-01 10:11:28.726461+08
2509	prism/deepseek-v4-flash	0.170000	0.210000	0.000000	2026-10-01 10:11:28.72673+08
\.


--
-- Data for Name: llm_probes; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.llm_probes (id, model_id, region, status_code, ttft_ms, tokens_per_sec, error_type, "timestamp") FROM stdin;
2	qwen/qwen-max	us-east	200	313	41.43	\N	2026-09-22 16:23:20.467126+08
3	qwen/qwen-max	us-east	200	393	20.08	\N	2026-09-22 16:24:05.974825+08
4	moonshot/kimi-k3	us-east	404	0	0.00	HTTP_404	2026-09-22 16:28:35.55299+08
5	qwen/qwen-max	us-east	200	345	38.64	\N	2026-09-22 16:28:35.699003+08
6	qwen/qwen-max	us-east	200	328	14.05	\N	2026-09-22 16:34:49.770939+08
7	moonshot/kimi-k2.7-code	us-east	200	743	79.10	\N	2026-09-22 16:34:49.99587+08
8	deepseek/deepseek-chat	us-east	401	0	0.00	HTTP_401	2026-09-22 16:40:38.773853+08
9	qwen/qwen-max	us-east	200	298	32.79	\N	2026-09-22 16:40:39.029437+08
10	moonshot/kimi-k2.7-code	us-east	200	998	112.97	\N	2026-09-22 16:40:39.656306+08
11	deepseek/deepseek-chat	us-east	401	0	0.00	HTTP_401	2026-09-22 20:32:36.155508+08
12	qwen/qwen-max	us-east	200	268	27.45	\N	2026-09-22 20:32:36.351586+08
13	moonshot/kimi-k2.7-code	us-east	200	650	148.02	\N	2026-09-22 20:32:36.672237+08
14	qwen/qwen-max	us-east	200	347	18.33	\N	2026-09-22 20:35:47.638397+08
15	deepseek/deepseek-chat	us-east	200	131	5.67	\N	2026-09-22 20:35:47.830705+08
16	moonshot/kimi-k2.7-code	us-east	200	663	130.15	\N	2026-09-22 20:35:47.850076+08
17	qwen/qwen-max	us-east	200	357	37.64	\N	2026-09-23 06:46:08.389122+08
18	deepseek/deepseek-chat	us-east	200	113	7.83	\N	2026-09-23 06:46:08.415705+08
19	moonshot/kimi-k2.7-code	us-east	200	612	201.15	\N	2026-09-23 06:46:08.544081+08
20	zhipu/glm-5.3-flash	us-east	200	623	17.38	\N	2026-09-23 06:46:08.719442+08
21	qwen/qwen-max	us-east	200	348	30.87	\N	2026-09-23 21:35:20.418321+08
22	deepseek/deepseek-chat	us-east	200	155	12.84	\N	2026-09-23 21:35:20.418552+08
23	moonshot/kimi-k2.7-code	us-east	200	698	65.92	\N	2026-09-23 21:35:20.72961+08
24	zhipu/glm-5.3-flash	us-east	200	556	22.34	\N	2026-09-23 21:35:20.791293+08
25	qwen/qwen-max	us-east	200	388	29.01	\N	2026-09-23 23:13:12.954623+08
26	moonshot/kimi-k2.7-code	us-east	200	637	132.74	\N	2026-09-23 23:13:13.120927+08
27	deepseek/deepseek-chat	us-east	200	380	7.18	\N	2026-09-23 23:13:13.260991+08
28	xiaomi/mimo-v2.6-pro	us-east	200	677	15.70	\N	2026-09-23 23:13:13.466507+08
29	zhipu/glm-5.3-flash	us-east	200	1088	16.13	\N	2026-09-23 23:13:13.802734+08
30	qwen/qwen-max	us-east	200	371	35.89	\N	2026-09-23 23:13:37.880609+08
31	deepseek/deepseek-chat	us-east	200	142	9.12	\N	2026-09-23 23:13:37.889181+08
32	moonshot/kimi-k2.7-code	us-east	200	516	109.84	\N	2026-09-23 23:13:37.955705+08
33	xiaomi/mimo-v2.6-pro	us-east	200	1302	18.60	\N	2026-09-23 23:13:38.993429+08
34	zhipu/glm-5.3-flash	us-east	200	971	6.60	\N	2026-09-23 23:13:38.99993+08
35	qwen/qwen-max	us-east	200	407	27.88	\N	2026-09-23 23:40:11.117184+08
36	moonshot/kimi-k2.7-code	us-east	200	809	122.51	\N	2026-09-23 23:40:11.47371+08
37	deepseek/deepseek-chat	us-east	200	446	5.39	\N	2026-09-23 23:40:11.640875+08
38	xiaomi/mimo-v2.6-pro	us-east	200	1001	48.41	\N	2026-09-23 23:40:11.730515+08
39	zhipu/glm-5.3-flash	us-east	200	1001	19.30	\N	2026-09-23 23:40:11.833305+08
40	qwen/qwen-max	us-east	200	210	38.20	none	2026-09-29 23:32:47.165766+08
41	qwen/qwen-max	us-east	200	210	38.20	none	2026-09-30 15:16:11.553227+08
42	qwen/qwen-max	us-east	200	388	25.93	\N	2026-09-30 15:21:11.44896+08
43	zhipu/glm-5.3-flash	us-east	200	569	46.38	\N	2026-09-30 15:21:11.635414+08
44	deepseek/deepseek-chat	us-east	200	237	4.54	\N	2026-09-30 15:21:11.656717+08
45	moonshot/kimi-k2.7-code	us-east	200	931	168.80	\N	2026-09-30 15:21:11.92299+08
47	deepseek/deepseek-chat	us-east	200	310	42.00	none	2026-09-30 15:28:35.553788+08
46	xiaomi/mimo-v2.6-pro	us-east	200	1513	18.70	none	2026-09-30 15:21:12.812992+08
48	moonshot/kimi-k2.7-code	us-east	200	195	55.10	none	2026-09-30 15:36:17.128132+08
49	zhipu/glm-5.3-flash	us-east	200	180	60.30	none	2026-09-30 17:12:45.336327+08
50	minimax/MiniMax-M3	us-east	200	240	35.00	none	2026-09-30 17:12:45.360136+08
51	xiaomi/mimo-v2.6-flash	us-east	200	165	70.00	none	2026-09-30 17:12:45.377492+08
52	deepseek/deepseek-chat	us-east	200	165	9.02	none	2026-10-01 10:03:05.947005+08
53	moonshot/kimi-k2.7-code	us-east	200	725	55.23	none	2026-10-01 10:03:06.175312+08
54	zhipu/glm-5.3-flash	us-east	200	496	12.03	none	2026-10-01 10:03:06.179252+08
55	qwen/qwen-max	us-east	200	688	42.63	none	2026-10-01 10:03:06.18428+08
56	xiaomi/mimo-v2.6-pro	us-east	200	3493	35.55	none	2026-10-01 10:03:09.061303+08
\.


--
-- Data for Name: raw_export_hs; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.raw_export_hs (data_month, hs_code, commodity_name, quantity, unit, supplementary_quantity, supplementary_unit, usd_value, ingested_at) FROM stdin;
202101	84714940	Microprocessors, presented in the form of systems	6859	Number of item	48821	Kilogram	21344315	2026-07-26 08:44:38.017807
202102	84714940	Microprocessors, presented in the form of systems	3487	Number of item	27920	Kilogram	13108368	2026-07-26 08:44:38.017807
202103	84714940	Microprocessors, presented in the form of systems	9676	Number of item	77009	Kilogram	29460092	2026-07-26 08:44:38.017807
202104	84714940	Microprocessors, presented in the form of systems	5309	Number of item	47819	Kilogram	15447446	2026-07-26 08:44:38.017807
202105	84714940	Microprocessors, presented in the form of systems	12780	Number of item	102366	Kilogram	24101399	2026-07-26 08:44:38.017807
202106	84714940	Microprocessors, presented in the form of systems	9305	Number of item	92641	Kilogram	25354623	2026-07-26 08:44:38.017807
202107	84714940	Microprocessors, presented in the form of systems	7145	Number of item	71248	Kilogram	13285798	2026-07-26 08:44:38.017807
202108	84714940	Microprocessors, presented in the form of systems	6079	Number of item	50506	Kilogram	14995968	2026-07-26 08:44:38.017807
202109	84714940	Microprocessors, presented in the form of systems	5023	Number of item	58501	Kilogram	19026050	2026-07-26 08:44:38.017807
202110	84714940	Microprocessors, presented in the form of systems	8592	Number of item	92909	Kilogram	19044130	2026-07-26 08:44:38.017807
202111	84714940	Microprocessors, presented in the form of systems	5610	Number of item	47707	Kilogram	9495473	2026-07-26 08:44:38.017807
202112	84714940	Microprocessors, presented in the form of systems	927	Number of item	18359	Kilogram	14010227	2026-07-26 08:44:38.017807
202201	84714940	Microprocessors, presented in the form of systems	669	Number of item	12019	Kilogram	11527477	2026-07-26 08:44:38.017807
202202	84714940	Microprocessors, presented in the form of systems	302	Number of item	8996	Kilogram	11692955	2026-07-26 08:44:38.017807
202203	84714940	Microprocessors, presented in the form of systems	915	Number of item	15972	Kilogram	17319351	2026-07-26 08:44:38.017807
202204	84714940	Microprocessors, presented in the form of systems	423	Number of item	8788	Kilogram	11552329	2026-07-26 08:44:38.017807
202205	84714940	Microprocessors, presented in the form of systems	866	Number of item	15795	Kilogram	19117768	2026-07-26 08:44:38.017807
202206	84714940	Microprocessors, presented in the form of systems	431	Number of item	10511	Kilogram	10335585	2026-07-26 08:44:38.017807
202207	84714940	Microprocessors, presented in the form of systems	852	Number of item	13530	Kilogram	11926504	2026-07-26 08:44:38.017807
202208	84714940	Microprocessors, presented in the form of systems	731	Number of item	13676	Kilogram	18594959	2026-07-26 08:44:38.017807
202209	84714940	Microprocessors, presented in the form of systems	2399	Number of item	14174	Kilogram	14474035	2026-07-26 08:44:38.017807
202210	84714940	Microprocessors, presented in the form of systems	259	Number of item	6673	Kilogram	7101612	2026-07-26 08:44:38.017807
202211	84714940	Microprocessors, presented in the form of systems	692	Number of item	18067	Kilogram	13511192	2026-07-26 08:44:38.017807
202212	84714940	Microprocessors, presented in the form of systems	1845	Number of item	20933	Kilogram	13090679	2026-07-26 08:44:38.017807
202301	84714940	Microprocessors, presented in the form of systems	1301	Number of item	15009	Kilogram	13611160	2026-07-26 08:44:38.017807
202302	84714940	Microprocessors, presented in the form of systems	633	Number of item	11705	Kilogram	18484334	2026-07-26 08:44:38.017807
202303	84714940	Microprocessors, presented in the form of systems	1535	Number of item	16843	Kilogram	18841275	2026-07-26 08:44:38.017807
202304	84714940	Microprocessors, presented in the form of systems	968	Number of item	15186	Kilogram	16344617	2026-07-26 08:44:38.017807
202305	84714940	Microprocessors, presented in the form of systems	2363	Number of item	15572	Kilogram	16676323	2026-07-26 08:44:38.017807
202306	84714940	Microprocessors, presented in the form of systems	1411	Number of item	19163	Kilogram	16343088	2026-07-26 08:44:38.017807
202307	84714940	Microprocessors, presented in the form of systems	2265	Number of item	20455	Kilogram	14871827	2026-07-26 08:44:38.017807
202308	84714940	Microprocessors, presented in the form of systems	342	Number of item	9561	Kilogram	12122185	2026-07-26 08:44:38.017807
202309	84714940	Microprocessors, presented in the form of systems	324	Number of item	10994	Kilogram	13524753	2026-07-26 08:44:38.017807
202310	84714940	Microprocessors, presented in the form of systems	352	Number of item	9639	Kilogram	10359379	2026-07-26 08:44:38.017807
202311	84714940	Microprocessors, presented in the form of systems	367	Number of item	10708	Kilogram	9849156	2026-07-26 08:44:38.017807
202312	84714940	Microprocessors, presented in the form of systems	599	Number of item	12290	Kilogram	12088935	2026-07-26 08:44:38.017807
202401	84714940	Microprocessors, presented in the form of systems	253	Number of item	8478	Kilogram	6861511	2026-07-26 08:44:38.017807
202402	84714940	Microprocessors, presented in the form of systems	283	Number of item	9102	Kilogram	7633814	2026-07-26 08:44:38.017807
202403	84714940	Microprocessors, presented in the form of systems	451	Number of item	15234	Kilogram	13587343	2026-07-26 08:44:38.017807
202404	84714940	Microprocessors, presented in the form of systems	560	Number of item	11304	Kilogram	5861133	2026-07-26 08:44:38.017807
202405	84714940	Microprocessors, presented in the form of systems	918	Number of item	13545	Kilogram	7103249	2026-07-26 08:44:38.017807
202406	84714940	Microprocessors, presented in the form of systems	487	Number of item	12807	Kilogram	13056606	2026-07-26 08:44:38.017807
202407	84714940	Microprocessors, presented in the form of systems	714	Number of item	10709	Kilogram	7474020	2026-07-26 08:44:38.017807
202408	84714940	Microprocessors, presented in the form of systems	322	Number of item	8420	Kilogram	9519872	2026-07-26 08:44:38.017807
202409	84714940	Microprocessors, presented in the form of systems	372	Number of item	8822	Kilogram	12135488	2026-07-26 08:44:38.017807
202410	84714940	Microprocessors, presented in the form of systems	384	Number of item	8009	Kilogram	10630533	2026-07-26 08:44:38.017807
202411	84714940	Microprocessors, presented in the form of systems	495	Number of item	10316	Kilogram	8242125	2026-07-26 08:44:38.017807
202412	84714940	Microprocessors, presented in the form of systems	485	Number of item	15096	Kilogram	19099530	2026-07-26 08:44:38.017807
202501	84714940	Microprocessors, presented in the form of systems	303	Number of item	5859	Kilogram	8297986	2026-07-26 08:44:38.017807
202305	84795090	Industrial robots, nes	76	Number of item	51788	Kilogram	2738469	2026-07-26 08:44:38.017807
202502	84714940	Microprocessors, presented in the form of systems	411	Number of item	11291	Kilogram	18512870	2026-07-26 08:44:38.017807
202503	84714940	Microprocessors, presented in the form of systems	429	Number of item	8021	Kilogram	10087247	2026-07-26 08:44:38.017807
202504	84714940	Microprocessors, presented in the form of systems	1972	Number of item	22258	Kilogram	14172433	2026-07-26 08:44:38.017807
202505	84714940	Microprocessors, presented in the form of systems	321	Number of item	8583	Kilogram	7936756	2026-07-26 08:44:38.017807
202506	84714940	Microprocessors, presented in the form of systems	410	Number of item	9874	Kilogram	14690130	2026-07-26 08:44:38.017807
202507	84714940	Microprocessors, presented in the form of systems	576	Number of item	9383	Kilogram	15157170	2026-07-26 08:44:38.017807
202508	84714940	Microprocessors, presented in the form of systems	432	Number of item	7785	Kilogram	12932692	2026-07-26 08:44:38.017807
202509	84714940	Microprocessors, presented in the form of systems	611	Number of item	9269	Kilogram	12429160	2026-07-26 08:44:38.017807
202510	84714940	Microprocessors, presented in the form of systems	267	Number of item	5633	Kilogram	8278441	2026-07-26 08:44:38.017807
202511	84714940	Microprocessors, presented in the form of systems	300	Number of item	6150	Kilogram	10664794	2026-07-26 08:44:38.017807
202512	84714940	Microprocessors, presented in the form of systems	424	Number of item	10337	Kilogram	19002130	2026-07-26 08:44:38.017807
202601	84714940	Microprocessors, presented in the form of systems	294815	Number of item	2776113	Kilogram	186001078	2026-07-26 08:44:38.017807
202602	84714940	Microprocessors, presented in the form of systems	180149	Number of item	1705146	Kilogram	116259151	2026-07-26 08:44:38.017807
202603	84714940	Microprocessors, presented in the form of systems	279312	Number of item	2636271	Kilogram	193016052	2026-07-26 08:44:38.017807
202604	84714940	Microprocessors, presented in the form of systems	276213	Number of item	2637080	Kilogram	200787043	2026-07-26 08:44:38.017807
202605	84714940	Microprocessors, presented in the form of systems	218693	Number of item	2024152	Kilogram	160399626	2026-07-26 08:44:38.017807
202606	84714940	Microprocessors, presented in the form of systems	243577	Number of item	2191592	Kilogram	180480554	2026-07-26 08:44:38.017807
202101	84715040	Process units of microprocessors	695217	Number of item	397998	Kilogram	190656497	2026-07-26 08:44:38.017807
202102	84715040	Process units of microprocessors	671295	Number of item	329827	Kilogram	218784362	2026-07-26 08:44:38.017807
202103	84715040	Process units of microprocessors	942721	Number of item	400163	Kilogram	202655418	2026-07-26 08:44:38.017807
202104	84715040	Process units of microprocessors	811774	Number of item	352267	Kilogram	167036184	2026-07-26 08:44:38.017807
202105	84715040	Process units of microprocessors	893059	Number of item	400095	Kilogram	211005302	2026-07-26 08:44:38.017807
202106	84715040	Process units of microprocessors	914707	Number of item	456531	Kilogram	208834793	2026-07-26 08:44:38.017807
202107	84715040	Process units of microprocessors	843450	Number of item	409670	Kilogram	205650001	2026-07-26 08:44:38.017807
202108	84715040	Process units of microprocessors	924122	Number of item	433589	Kilogram	200809471	2026-07-26 08:44:38.017807
202109	84715040	Process units of microprocessors	837542	Number of item	420698	Kilogram	202784252	2026-07-26 08:44:38.017807
202110	84715040	Process units of microprocessors	885440	Number of item	457624	Kilogram	195962471	2026-07-26 08:44:38.017807
202111	84715040	Process units of microprocessors	1033888	Number of item	482974	Kilogram	251400066	2026-07-26 08:44:38.017807
202112	84715040	Process units of microprocessors	1001109	Number of item	563438	Kilogram	285931310	2026-07-26 08:44:38.017807
202201	84715040	Process units of microprocessors	1043757	Number of item	523634	Kilogram	305250023	2026-07-26 08:44:38.017807
202202	84715040	Process units of microprocessors	679847	Number of item	341641	Kilogram	187069604	2026-07-26 08:44:38.017807
202203	84715040	Process units of microprocessors	696314	Number of item	350919	Kilogram	189050638	2026-07-26 08:44:38.017807
202204	84715040	Process units of microprocessors	627010	Number of item	390098	Kilogram	203627644	2026-07-26 08:44:38.017807
202205	84715040	Process units of microprocessors	559933	Number of item	314943	Kilogram	184865444	2026-07-26 08:44:38.017807
202206	84715040	Process units of microprocessors	638958	Number of item	352535	Kilogram	190097483	2026-07-26 08:44:38.017807
202207	84715040	Process units of microprocessors	756445	Number of item	377802	Kilogram	217521007	2026-07-26 08:44:38.017807
202208	84715040	Process units of microprocessors	868055	Number of item	383147	Kilogram	255013534	2026-07-26 08:44:38.017807
202209	84715040	Process units of microprocessors	820012	Number of item	417558	Kilogram	229675412	2026-07-26 08:44:38.017807
202210	84715040	Process units of microprocessors	731739	Number of item	292059	Kilogram	194678562	2026-07-26 08:44:38.017807
202211	84715040	Process units of microprocessors	834717	Number of item	338683	Kilogram	221914738	2026-07-26 08:44:38.017807
202212	84715040	Process units of microprocessors	1001443	Number of item	359206	Kilogram	238927512	2026-07-26 08:44:38.017807
202301	84715040	Process units of microprocessors	619738	Number of item	302283	Kilogram	167243080	2026-07-26 08:44:38.017807
202302	84715040	Process units of microprocessors	768000	Number of item	280924	Kilogram	223349539	2026-07-26 08:44:38.017807
202303	84715040	Process units of microprocessors	985872	Number of item	460188	Kilogram	333120825	2026-07-26 08:44:38.017807
202304	84715040	Process units of microprocessors	919867	Number of item	405995	Kilogram	301229766	2026-07-26 08:44:38.017807
202305	84715040	Process units of microprocessors	1150331	Number of item	412259	Kilogram	411996882	2026-07-26 08:44:38.017807
202306	84715040	Process units of microprocessors	1231322	Number of item	493804	Kilogram	438060510	2026-07-26 08:44:38.017807
202307	84715040	Process units of microprocessors	1277269	Number of item	429984	Kilogram	472329238	2026-07-26 08:44:38.017807
202308	84715040	Process units of microprocessors	1020472	Number of item	407597	Kilogram	373990513	2026-07-26 08:44:38.017807
202309	84715040	Process units of microprocessors	1030306	Number of item	482326	Kilogram	368746373	2026-07-26 08:44:38.017807
202310	84715040	Process units of microprocessors	1119691	Number of item	410634	Kilogram	432253443	2026-07-26 08:44:38.017807
202311	84715040	Process units of microprocessors	841938	Number of item	402286	Kilogram	390541488	2026-07-26 08:44:38.017807
202312	84715040	Process units of microprocessors	952806	Number of item	594911	Kilogram	544339149	2026-07-26 08:44:38.017807
202401	84715040	Process units of microprocessors	923660	Number of item	389728	Kilogram	428453978	2026-07-26 08:44:38.017807
202402	84715040	Process units of microprocessors	950157	Number of item	386474	Kilogram	549846436	2026-07-26 08:44:38.017807
202403	84715040	Process units of microprocessors	1391599	Number of item	520811	Kilogram	690715957	2026-07-26 08:44:38.017807
202404	84715040	Process units of microprocessors	1320735	Number of item	610965	Kilogram	834223552	2026-07-26 08:44:38.017807
202405	84715040	Process units of microprocessors	1312546	Number of item	593475	Kilogram	899906856	2026-07-26 08:44:38.017807
202406	84715040	Process units of microprocessors	906142	Number of item	470090	Kilogram	703187287	2026-07-26 08:44:38.017807
202407	84715040	Process units of microprocessors	936056	Number of item	577467	Kilogram	970167390	2026-07-26 08:44:38.017807
202408	84715040	Process units of microprocessors	1002189	Number of item	483395	Kilogram	726111330	2026-07-26 08:44:38.017807
202409	84715040	Process units of microprocessors	1003178	Number of item	574676	Kilogram	859885474	2026-07-26 08:44:38.017807
202410	84715040	Process units of microprocessors	1092733	Number of item	519962	Kilogram	801910312	2026-07-26 08:44:38.017807
202411	84715040	Process units of microprocessors	958667	Number of item	607773	Kilogram	1017701188	2026-07-26 08:44:38.017807
202412	84715040	Process units of microprocessors	878123	Number of item	692680	Kilogram	1076938263	2026-07-26 08:44:38.017807
202501	84715040	Process units of microprocessors	1018135	Number of item	655291	Kilogram	1048851521	2026-07-26 08:44:38.017807
202502	84715040	Process units of microprocessors	1214142	Number of item	602768	Kilogram	922688632	2026-07-26 08:44:38.017807
202503	84715040	Process units of microprocessors	1537736	Number of item	997878	Kilogram	1803714466	2026-07-26 08:44:38.017807
202504	84715040	Process units of microprocessors	2416431	Number of item	1204786	Kilogram	2279972327	2026-07-26 08:44:38.017807
202505	84715040	Process units of microprocessors	3128685	Number of item	1704191	Kilogram	3389379353	2026-07-26 08:44:38.017807
202506	84715040	Process units of microprocessors	3096425	Number of item	1048578	Kilogram	1882749123	2026-07-26 08:44:38.017807
202507	84715040	Process units of microprocessors	1942222	Number of item	816522	Kilogram	1486063990	2026-07-26 08:44:38.017807
202508	84715040	Process units of microprocessors	2096037	Number of item	787836	Kilogram	1438342976	2026-07-26 08:44:38.017807
202509	84715040	Process units of microprocessors	1793528	Number of item	788068	Kilogram	1296637255	2026-07-26 08:44:38.017807
202510	84715040	Process units of microprocessors	1525797	Number of item	652224	Kilogram	1117996021	2026-07-26 08:44:38.017807
202511	84715040	Process units of microprocessors	1286786	Number of item	658916	Kilogram	1163642670	2026-07-26 08:44:38.017807
202512	84715040	Process units of microprocessors	1376203	Number of item	670200	Kilogram	1122565294	2026-07-26 08:44:38.017807
202601	84715040	Process units of microprocessors	3014008	Number of item	7935399	Kilogram	1448478041	2026-07-26 08:44:38.017807
202602	84715040	Process units of microprocessors	1964796	Number of item	5316888	Kilogram	1125484634	2026-07-26 08:44:38.017807
202603	84715040	Process units of microprocessors	2868720	Number of item	7538874	Kilogram	1872974901	2026-07-26 08:44:38.017807
202604	84715040	Process units of microprocessors	2882837	Number of item	7603307	Kilogram	1877821131	2026-07-26 08:44:38.017807
202605	84715040	Process units of microprocessors	2314449	Number of item	6480847	Kilogram	2024952337	2026-07-26 08:44:38.017807
202606	84715040	Process units of microprocessors	2834313	Number of item	7352186	Kilogram	2263720230	2026-07-26 08:44:38.017807
202101	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1408432	Kilogram	0	?	203698264	2026-07-26 08:44:38.017807
202102	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1107427	Kilogram	0	?	155143164	2026-07-26 08:44:38.017807
202103	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1657254	Kilogram	0	?	223753485	2026-07-26 08:44:38.017807
202104	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1426894	Kilogram	0	?	184717127	2026-07-26 08:44:38.017807
202105	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1525087	Kilogram	0	?	213940388	2026-07-26 08:44:38.017807
202106	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1555032	Kilogram	0	?	252322140	2026-07-26 08:44:38.017807
202107	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	2012006	Kilogram	0	?	244409471	2026-07-26 08:44:38.017807
202108	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1731911	Kilogram	0	?	253150724	2026-07-26 08:44:38.017807
202109	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1967685	Kilogram	0	?	284756817	2026-07-26 08:44:38.017807
202110	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1976939	Kilogram	0	?	236281652	2026-07-26 08:44:38.017807
202111	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	2083540	Kilogram	0	?	244620499	2026-07-26 08:44:38.017807
202112	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1861207	Kilogram	0	?	202099918	2026-07-26 08:44:38.017807
202201	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1921659	Kilogram	0	?	220634686	2026-07-26 08:44:38.017807
202202	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1690696	Kilogram	0	?	128330312	2026-07-26 08:44:38.017807
202203	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1629647	Kilogram	0	?	160961115	2026-07-26 08:44:38.017807
202204	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1521493	Kilogram	0	?	152934230	2026-07-26 08:44:38.017807
202205	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1492794	Kilogram	0	?	131182914	2026-07-26 08:44:38.017807
202206	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1213791	Kilogram	0	?	133964384	2026-07-26 08:44:38.017807
202207	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1171332	Kilogram	0	?	143579743	2026-07-26 08:44:38.017807
202208	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	915743	Kilogram	0	?	79678381	2026-07-26 08:44:38.017807
202209	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	386042	Kilogram	0	?	65955335	2026-07-26 08:44:38.017807
202210	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	488738	Kilogram	0	?	74357321	2026-07-26 08:44:38.017807
202211	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	344204	Kilogram	0	?	70971895	2026-07-26 08:44:38.017807
202212	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	720857	Kilogram	0	?	75046587	2026-07-26 08:44:38.017807
202301	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	724480	Kilogram	0	?	82342783	2026-07-26 08:44:38.017807
202302	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	849960	Kilogram	0	?	92331452	2026-07-26 08:44:38.017807
202303	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	691876	Kilogram	0	?	86833787	2026-07-26 08:44:38.017807
202304	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	946054	Kilogram	0	?	85357431	2026-07-26 08:44:38.017807
202305	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	855913	Kilogram	0	?	95523882	2026-07-26 08:44:38.017807
202306	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	655774	Kilogram	0	?	98983638	2026-07-26 08:44:38.017807
202307	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	866162	Kilogram	0	?	82089055	2026-07-26 08:44:38.017807
202308	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	736856	Kilogram	0	?	87945536	2026-07-26 08:44:38.017807
202309	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	695778	Kilogram	0	?	92326196	2026-07-26 08:44:38.017807
202310	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1031182	Kilogram	0	?	94052758	2026-07-26 08:44:38.017807
202311	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1089329	Kilogram	0	?	112429506	2026-07-26 08:44:38.017807
202312	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1176363	Kilogram	0	?	128569056	2026-07-26 08:44:38.017807
202401	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1277377	Kilogram	0	?	111329723	2026-07-26 08:44:38.017807
202402	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	926832	Kilogram	0	?	78848520	2026-07-26 08:44:38.017807
202403	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1161277	Kilogram	0	?	88426792	2026-07-26 08:44:38.017807
202404	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1278203	Kilogram	0	?	123311611	2026-07-26 08:44:38.017807
202405	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	982614	Kilogram	0	?	113471423	2026-07-26 08:44:38.017807
202406	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1085807	Kilogram	0	?	88957411	2026-07-26 08:44:38.017807
202407	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1481239	Kilogram	0	?	130710273	2026-07-26 08:44:38.017807
202408	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1201839	Kilogram	0	?	151646108	2026-07-26 08:44:38.017807
202409	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1032847	Kilogram	0	?	101425120	2026-07-26 08:44:38.017807
202410	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1123017	Kilogram	0	?	122356734	2026-07-26 08:44:38.017807
202411	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	995934	Kilogram	0	?	131162295	2026-07-26 08:44:38.017807
202412	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1050149	Kilogram	0	?	103243061	2026-07-26 08:44:38.017807
202501	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	920041	Kilogram	0	?	113945211	2026-07-26 08:44:38.017807
202502	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	758635	Kilogram	0	?	136463132	2026-07-26 08:44:38.017807
202503	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1168684	Kilogram	0	?	131514906	2026-07-26 08:44:38.017807
202504	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1103521	Kilogram	0	?	128134437	2026-07-26 08:44:38.017807
202505	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	906309	Kilogram	0	?	125596241	2026-07-26 08:44:38.017807
202506	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1018337	Kilogram	0	?	114461544	2026-07-26 08:44:38.017807
202507	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1087433	Kilogram	0	?	143256606	2026-07-26 08:44:38.017807
202508	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	911186	Kilogram	0	?	137586434	2026-07-26 08:44:38.017807
202509	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1186422	Kilogram	0	?	146370538	2026-07-26 08:44:38.017807
202510	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1308013	Kilogram	0	?	139521552	2026-07-26 08:44:38.017807
202511	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1179236	Kilogram	0	?	144471013	2026-07-26 08:44:38.017807
202512	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1335067	Kilogram	0	?	138855543	2026-07-26 08:44:38.017807
202601	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	3853287	Kilogram	0	?	234297473	2026-07-26 08:44:38.017807
202602	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	3109288	Kilogram	0	?	185069901	2026-07-26 08:44:38.017807
202603	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	4175296	Kilogram	0	?	253252252	2026-07-26 08:44:38.017807
202604	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	4225455	Kilogram	0	?	246469114	2026-07-26 08:44:38.017807
202306	84795090	Industrial robots, nes	83	Number of item	43159	Kilogram	3614040	2026-07-26 08:44:38.017807
202605	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	4563759	Kilogram	0	?	261871188	2026-07-26 08:44:38.017807
202606	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	4188463	Kilogram	0	?	248435236	2026-07-26 08:44:38.017807
202301	84795011	Cooperative robots	52	Number of item	50060	Kilogram	1873601	2026-07-26 08:44:38.017807
202302	84795011	Cooperative robots	40	Number of item	7358	Kilogram	540804	2026-07-26 08:44:38.017807
202303	84795011	Cooperative robots	80	Number of item	13438	Kilogram	2471876	2026-07-26 08:44:38.017807
202304	84795011	Cooperative robots	57	Number of item	4636	Kilogram	1371133	2026-07-26 08:44:38.017807
202305	84795011	Cooperative robots	160	Number of item	10604	Kilogram	3251990	2026-07-26 08:44:38.017807
202306	84795011	Cooperative robots	171	Number of item	9530	Kilogram	2685010	2026-07-26 08:44:38.017807
202307	84795011	Cooperative robots	334	Number of item	14740	Kilogram	4893833	2026-07-26 08:44:38.017807
202308	84795011	Cooperative robots	175	Number of item	60627	Kilogram	1843093	2026-07-26 08:44:38.017807
202309	84795011	Cooperative robots	146	Number of item	7837	Kilogram	2377631	2026-07-26 08:44:38.017807
202310	84795011	Cooperative robots	98	Number of item	5217	Kilogram	1475024	2026-07-26 08:44:38.017807
202311	84795011	Cooperative robots	213	Number of item	56996	Kilogram	2800835	2026-07-26 08:44:38.017807
202312	84795011	Cooperative robots	397	Number of item	81660	Kilogram	5819894	2026-07-26 08:44:38.017807
202401	84795011	Cooperative robots	101	Number of item	8876	Kilogram	2122357	2026-07-26 08:44:38.017807
202402	84795011	Cooperative robots	154	Number of item	34114	Kilogram	2069625	2026-07-26 08:44:38.017807
202403	84795011	Cooperative robots	163	Number of item	7383	Kilogram	2458670	2026-07-26 08:44:38.017807
202404	84795011	Cooperative robots	169	Number of item	10649	Kilogram	2824184	2026-07-26 08:44:38.017807
202405	84795011	Cooperative robots	596	Number of item	19784	Kilogram	2498211	2026-07-26 08:44:38.017807
202406	84795011	Cooperative robots	350	Number of item	16759	Kilogram	5271510	2026-07-26 08:44:38.017807
202407	84795011	Cooperative robots	138	Number of item	12660	Kilogram	2178924	2026-07-26 08:44:38.017807
202408	84795011	Cooperative robots	152	Number of item	7615	Kilogram	2035397	2026-07-26 08:44:38.017807
202409	84795011	Cooperative robots	253	Number of item	15335	Kilogram	4707932	2026-07-26 08:44:38.017807
202410	84795011	Cooperative robots	205	Number of item	12769	Kilogram	3027208	2026-07-26 08:44:38.017807
202411	84795011	Cooperative robots	169	Number of item	10378	Kilogram	2458745	2026-07-26 08:44:38.017807
202412	84795011	Cooperative robots	692	Number of item	32348	Kilogram	9984664	2026-07-26 08:44:38.017807
202501	84795011	Cooperative robots	98	Number of item	6196	Kilogram	1372394	2026-07-26 08:44:38.017807
202502	84795011	Cooperative robots	107	Number of item	9191	Kilogram	1763484	2026-07-26 08:44:38.017807
202503	84795011	Cooperative robots	235	Number of item	11757	Kilogram	3451223	2026-07-26 08:44:38.017807
202504	84795011	Cooperative robots	130	Number of item	7383	Kilogram	2736546	2026-07-26 08:44:38.017807
202505	84795011	Cooperative robots	194	Number of item	9475	Kilogram	2548607	2026-07-26 08:44:38.017807
202506	84795011	Cooperative robots	385	Number of item	18242	Kilogram	4731241	2026-07-26 08:44:38.017807
202507	84795011	Cooperative robots	114	Number of item	7944	Kilogram	1978943	2026-07-26 08:44:38.017807
202508	84795011	Cooperative robots	106	Number of item	6419	Kilogram	1505041	2026-07-26 08:44:38.017807
202509	84795011	Cooperative robots	170	Number of item	10145	Kilogram	3415813	2026-07-26 08:44:38.017807
202510	84795011	Cooperative robots	100	Number of item	5657	Kilogram	1513172	2026-07-26 08:44:38.017807
202511	84795011	Cooperative robots	127	Number of item	7615	Kilogram	2054756	2026-07-26 08:44:38.017807
202512	84795011	Cooperative robots	176	Number of item	19561	Kilogram	4243366	2026-07-26 08:44:38.017807
202601	84795011	Cooperative robots	1685	Number of item	91146	Kilogram	9665548	2026-07-26 08:44:38.017807
202602	84795011	Cooperative robots	1193	Number of item	86247	Kilogram	8175405	2026-07-26 08:44:38.017807
202603	84795011	Cooperative robots	1659	Number of item	106438	Kilogram	11748499	2026-07-26 08:44:38.017807
202604	84795011	Cooperative robots	1592	Number of item	133044	Kilogram	11775914	2026-07-26 08:44:38.017807
202605	84795011	Cooperative robots	1461	Number of item	115206	Kilogram	10561165	2026-07-26 08:44:38.017807
202606	84795011	Cooperative robots	1603	Number of item	107079	Kilogram	11862386	2026-07-26 08:44:38.017807
202301	84795019	Other industrial robots for multiple uses	5656	Number of item	4266947	Kilogram	89908245	2026-07-26 08:44:38.017807
202302	84795019	Other industrial robots for multiple uses	9701	Number of item	7240829	Kilogram	151981784	2026-07-26 08:44:38.017807
202303	84795019	Other industrial robots for multiple uses	8155	Number of item	6096663	Kilogram	125546051	2026-07-26 08:44:38.017807
202304	84795019	Other industrial robots for multiple uses	7357	Number of item	6259558	Kilogram	116586548	2026-07-26 08:44:38.017807
202305	84795019	Other industrial robots for multiple uses	6422	Number of item	4936110	Kilogram	97448996	2026-07-26 08:44:38.017807
202306	84795019	Other industrial robots for multiple uses	8553	Number of item	7045253	Kilogram	127955745	2026-07-26 08:44:38.017807
202307	84795019	Other industrial robots for multiple uses	5788	Number of item	5407887	Kilogram	90682806	2026-07-26 08:44:38.017807
202308	84795019	Other industrial robots for multiple uses	5687	Number of item	5178696	Kilogram	96036741	2026-07-26 08:44:38.017807
202309	84795019	Other industrial robots for multiple uses	5669	Number of item	4287094	Kilogram	88428695	2026-07-26 08:44:38.017807
202310	84795019	Other industrial robots for multiple uses	4814	Number of item	2717163	Kilogram	66037850	2026-07-26 08:44:38.017807
202311	84795019	Other industrial robots for multiple uses	5200	Number of item	2387197	Kilogram	64732235	2026-07-26 08:44:38.017807
202312	84795019	Other industrial robots for multiple uses	5365	Number of item	2403872	Kilogram	59348541	2026-07-26 08:44:38.017807
202401	84795019	Other industrial robots for multiple uses	3669	Number of item	2107579	Kilogram	44796084	2026-07-26 08:44:38.017807
202402	84795019	Other industrial robots for multiple uses	4483	Number of item	2694572	Kilogram	53231840	2026-07-26 08:44:38.017807
202403	84795019	Other industrial robots for multiple uses	4428	Number of item	2268738	Kilogram	47937346	2026-07-26 08:44:38.017807
202404	84795019	Other industrial robots for multiple uses	5533	Number of item	2620130	Kilogram	57723851	2026-07-26 08:44:38.017807
202405	84795019	Other industrial robots for multiple uses	3290	Number of item	1716361	Kilogram	36745400	2026-07-26 08:44:38.017807
202406	84795019	Other industrial robots for multiple uses	3937	Number of item	2165373	Kilogram	40134983	2026-07-26 08:44:38.017807
202407	84795019	Other industrial robots for multiple uses	4640	Number of item	2328271	Kilogram	47271542	2026-07-26 08:44:38.017807
202408	84795019	Other industrial robots for multiple uses	3373	Number of item	1702614	Kilogram	36197427	2026-07-26 08:44:38.017807
202409	84795019	Other industrial robots for multiple uses	5168	Number of item	2793049	Kilogram	55350575	2026-07-26 08:44:38.017807
202410	84795019	Other industrial robots for multiple uses	4515	Number of item	1969616	Kilogram	48228776	2026-07-26 08:44:38.017807
202411	84795019	Other industrial robots for multiple uses	4044	Number of item	1982337	Kilogram	43109702	2026-07-26 08:44:38.017807
202412	84795019	Other industrial robots for multiple uses	5393	Number of item	2256232	Kilogram	54537745	2026-07-26 08:44:38.017807
202501	84795019	Other industrial robots for multiple uses	4511	Number of item	2993218	Kilogram	50241780	2026-07-26 08:44:38.017807
202502	84795019	Other industrial robots for multiple uses	5991	Number of item	3781312	Kilogram	61127229	2026-07-26 08:44:38.017807
202503	84795019	Other industrial robots for multiple uses	5503	Number of item	3177002	Kilogram	63507457	2026-07-26 08:44:38.017807
202504	84795019	Other industrial robots for multiple uses	6576	Number of item	3890327	Kilogram	79273649	2026-07-26 08:44:38.017807
202505	84795019	Other industrial robots for multiple uses	4781	Number of item	3206696	Kilogram	59930339	2026-07-26 08:44:38.017807
202506	84795019	Other industrial robots for multiple uses	6008	Number of item	4009162	Kilogram	72518379	2026-07-26 08:44:38.017807
202507	84795019	Other industrial robots for multiple uses	6302	Number of item	3779449	Kilogram	74045346	2026-07-26 08:44:38.017807
202508	84795019	Other industrial robots for multiple uses	5632	Number of item	3417612	Kilogram	65827629	2026-07-26 08:44:38.017807
202509	84795019	Other industrial robots for multiple uses	6980	Number of item	3450451	Kilogram	78245256	2026-07-26 08:44:38.017807
202510	84795019	Other industrial robots for multiple uses	5386	Number of item	2649019	Kilogram	57639723	2026-07-26 08:44:38.017807
202511	84795019	Other industrial robots for multiple uses	5050	Number of item	2704374	Kilogram	50442303	2026-07-26 08:44:38.017807
202512	84795019	Other industrial robots for multiple uses	6562	Number of item	4154949	Kilogram	77558302	2026-07-26 08:44:38.017807
202601	84795019	Other industrial robots for multiple uses	2171	Number of item	1446627	Kilogram	32532047	2026-07-26 08:44:38.017807
202602	84795019	Other industrial robots for multiple uses	1975	Number of item	829259	Kilogram	26554497	2026-07-26 08:44:38.017807
202603	84795019	Other industrial robots for multiple uses	2548	Number of item	1408535	Kilogram	37555805	2026-07-26 08:44:38.017807
202604	84795019	Other industrial robots for multiple uses	2829	Number of item	1195653	Kilogram	42087633	2026-07-26 08:44:38.017807
202605	84795019	Other industrial robots for multiple uses	2330	Number of item	1320108	Kilogram	33000950	2026-07-26 08:44:38.017807
202606	84795019	Other industrial robots for multiple uses	3664	Number of item	1863984	Kilogram	42816605	2026-07-26 08:44:38.017807
202101	84795090	Industrial robots, nes	772	Number of item	108054	Kilogram	9071461	2026-07-26 08:44:38.017807
202102	84795090	Industrial robots, nes	803	Number of item	19839	Kilogram	2785579	2026-07-26 08:44:38.017807
202103	84795090	Industrial robots, nes	352	Number of item	262277	Kilogram	3390540	2026-07-26 08:44:38.017807
202104	84795090	Industrial robots, nes	150	Number of item	47851	Kilogram	6160866	2026-07-26 08:44:38.017807
202105	84795090	Industrial robots, nes	72	Number of item	17201	Kilogram	1870247	2026-07-26 08:44:38.017807
202106	84795090	Industrial robots, nes	335	Number of item	335997	Kilogram	11119424	2026-07-26 08:44:38.017807
202107	84795090	Industrial robots, nes	206	Number of item	39829	Kilogram	3642936	2026-07-26 08:44:38.017807
202108	84795090	Industrial robots, nes	148	Number of item	81349	Kilogram	8223561	2026-07-26 08:44:38.017807
202109	84795090	Industrial robots, nes	104	Number of item	42071	Kilogram	4715214	2026-07-26 08:44:38.017807
202110	84795090	Industrial robots, nes	59	Number of item	70287	Kilogram	4114092	2026-07-26 08:44:38.017807
202111	84795090	Industrial robots, nes	184	Number of item	157494	Kilogram	10477589	2026-07-26 08:44:38.017807
202112	84795090	Industrial robots, nes	89	Number of item	163330	Kilogram	9238696	2026-07-26 08:44:38.017807
202201	84795090	Industrial robots, nes	139	Number of item	23066	Kilogram	2223686	2026-07-26 08:44:38.017807
202202	84795090	Industrial robots, nes	30	Number of item	91109	Kilogram	3510271	2026-07-26 08:44:38.017807
202203	84795090	Industrial robots, nes	100	Number of item	112899	Kilogram	4083764	2026-07-26 08:44:38.017807
202204	84795090	Industrial robots, nes	101	Number of item	12527	Kilogram	2280472	2026-07-26 08:44:38.017807
202205	84795090	Industrial robots, nes	83	Number of item	64862	Kilogram	2887568	2026-07-26 08:44:38.017807
202206	84795090	Industrial robots, nes	66	Number of item	64178	Kilogram	9166092	2026-07-26 08:44:38.017807
202207	84795090	Industrial robots, nes	76	Number of item	20161	Kilogram	1779084	2026-07-26 08:44:38.017807
202208	84795090	Industrial robots, nes	101	Number of item	19299	Kilogram	1576543	2026-07-26 08:44:38.017807
202209	84795090	Industrial robots, nes	69	Number of item	28150	Kilogram	2486594	2026-07-26 08:44:38.017807
202210	84795090	Industrial robots, nes	42	Number of item	27723	Kilogram	1321308	2026-07-26 08:44:38.017807
202211	84795090	Industrial robots, nes	67	Number of item	36437	Kilogram	2709066	2026-07-26 08:44:38.017807
202212	84795090	Industrial robots, nes	107	Number of item	38464	Kilogram	2434159	2026-07-26 08:44:38.017807
202301	84795090	Industrial robots, nes	46	Number of item	21017	Kilogram	1432916	2026-07-26 08:44:38.017807
202302	84795090	Industrial robots, nes	279	Number of item	69941	Kilogram	3193271	2026-07-26 08:44:38.017807
202303	84795090	Industrial robots, nes	71	Number of item	50821	Kilogram	6023626	2026-07-26 08:44:38.017807
202304	84795090	Industrial robots, nes	571	Number of item	50365	Kilogram	3559098	2026-07-26 08:44:38.017807
202307	84795090	Industrial robots, nes	58	Number of item	50836	Kilogram	4322986	2026-07-26 08:44:38.017807
202308	84795090	Industrial robots, nes	489	Number of item	100412	Kilogram	6087734	2026-07-26 08:44:38.017807
202309	84795090	Industrial robots, nes	95	Number of item	40622	Kilogram	3282816	2026-07-26 08:44:38.017807
202310	84795090	Industrial robots, nes	37	Number of item	16909	Kilogram	1832258	2026-07-26 08:44:38.017807
202311	84795090	Industrial robots, nes	52	Number of item	37530	Kilogram	3791159	2026-07-26 08:44:38.017807
202312	84795090	Industrial robots, nes	150	Number of item	16248	Kilogram	1928643	2026-07-26 08:44:38.017807
202401	84795090	Industrial robots, nes	109	Number of item	32901	Kilogram	2842045	2026-07-26 08:44:38.017807
202402	84795090	Industrial robots, nes	179	Number of item	58997	Kilogram	3669755	2026-07-26 08:44:38.017807
202403	84795090	Industrial robots, nes	216	Number of item	32496	Kilogram	2706095	2026-07-26 08:44:38.017807
202404	84795090	Industrial robots, nes	88	Number of item	96628	Kilogram	4851990	2026-07-26 08:44:38.017807
202405	84795090	Industrial robots, nes	155	Number of item	64766	Kilogram	4820979	2026-07-26 08:44:38.017807
202406	84795090	Industrial robots, nes	84	Number of item	29021	Kilogram	1437981	2026-07-26 08:44:38.017807
202407	84795090	Industrial robots, nes	88	Number of item	30145	Kilogram	2869181	2026-07-26 08:44:38.017807
202408	84795090	Industrial robots, nes	95	Number of item	62523	Kilogram	5011358	2026-07-26 08:44:38.017807
202409	84795090	Industrial robots, nes	71	Number of item	53625	Kilogram	4661882	2026-07-26 08:44:38.017807
202410	84795090	Industrial robots, nes	82	Number of item	37187	Kilogram	2100545	2026-07-26 08:44:38.017807
202411	84795090	Industrial robots, nes	98	Number of item	23192	Kilogram	1402544	2026-07-26 08:44:38.017807
202412	84795090	Industrial robots, nes	328	Number of item	10738	Kilogram	1446736	2026-07-26 08:44:38.017807
202501	84795090	Industrial robots, nes	84	Number of item	52502	Kilogram	3562562	2026-07-26 08:44:38.017807
202502	84795090	Industrial robots, nes	93	Number of item	59769	Kilogram	3396167	2026-07-26 08:44:38.017807
202503	84795090	Industrial robots, nes	142	Number of item	23841	Kilogram	1513054	2026-07-26 08:44:38.017807
202504	84795090	Industrial robots, nes	23	Number of item	13344	Kilogram	458103	2026-07-26 08:44:38.017807
202505	84795090	Industrial robots, nes	35	Number of item	21030	Kilogram	1718858	2026-07-26 08:44:38.017807
202506	84795090	Industrial robots, nes	42	Number of item	13989	Kilogram	1104085	2026-07-26 08:44:38.017807
202507	84795090	Industrial robots, nes	67	Number of item	24158	Kilogram	1756437	2026-07-26 08:44:38.017807
202508	84795090	Industrial robots, nes	78	Number of item	10688	Kilogram	1048314	2026-07-26 08:44:38.017807
202509	84795090	Industrial robots, nes	43	Number of item	50828	Kilogram	1320555	2026-07-26 08:44:38.017807
202510	84795090	Industrial robots, nes	58	Number of item	64876	Kilogram	1325339	2026-07-26 08:44:38.017807
202511	84795090	Industrial robots, nes	80	Number of item	22404	Kilogram	1528062	2026-07-26 08:44:38.017807
202512	84795090	Industrial robots, nes	140	Number of item	53526	Kilogram	3106311	2026-07-26 08:44:38.017807
202601	84795090	Industrial robots, nes	5138	Number of item	1563546	Kilogram	35925767	2026-07-26 08:44:38.017807
202602	84795090	Industrial robots, nes	1807	Number of item	1543148	Kilogram	47350721	2026-07-26 08:44:38.017807
202603	84795090	Industrial robots, nes	4621	Number of item	983619	Kilogram	24811314	2026-07-26 08:44:38.017807
202604	84795090	Industrial robots, nes	2840	Number of item	720132	Kilogram	19647195	2026-07-26 08:44:38.017807
202605	84795090	Industrial robots, nes	4149	Number of item	965570	Kilogram	28538053	2026-07-26 08:44:38.017807
202606	84795090	Industrial robots, nes	3610	Number of item	883254	Kilogram	26899452	2026-07-26 08:44:38.017807
202601	84798970	Intelligent bionic robot	740	Number of item	19119	Kilogram	5433836	2026-07-26 08:44:38.017807
202602	84798970	Intelligent bionic robot	2163	Number of item	50096	Kilogram	11750082	2026-07-26 08:44:38.017807
202603	84798970	Intelligent bionic robot	1674	Number of item	51513	Kilogram	14671329	2026-07-26 08:44:38.017807
202604	84798970	Intelligent bionic robot	1532	Number of item	65146	Kilogram	22485478	2026-07-26 08:44:38.017807
202605	84798970	Intelligent bionic robot	2173	Number of item	71533	Kilogram	20256335	2026-07-26 08:44:38.017807
202606	84798970	Intelligent bionic robot	2118	Number of item	97535	Kilogram	29458312	2026-07-26 08:44:38.017807
202101	85176222	Optical transmission equipment for wave-division multiplexing	135227	Number of item	4480	Kilogram	4933855	2026-07-26 08:44:38.017807
202102	85176222	Optical transmission equipment for wave-division multiplexing	89042	Number of item	941	Kilogram	1362059	2026-07-26 08:44:38.017807
202103	85176222	Optical transmission equipment for wave-division multiplexing	151196	Number of item	1864	Kilogram	2601431	2026-07-26 08:44:38.017807
202104	85176222	Optical transmission equipment for wave-division multiplexing	197496	Number of item	930	Kilogram	2137561	2026-07-26 08:44:38.017807
202105	85176222	Optical transmission equipment for wave-division multiplexing	173647	Number of item	1165	Kilogram	1888843	2026-07-26 08:44:38.017807
202106	85176222	Optical transmission equipment for wave-division multiplexing	204209	Number of item	1688	Kilogram	2295014	2026-07-26 08:44:38.017807
202107	85176222	Optical transmission equipment for wave-division multiplexing	196358	Number of item	1836	Kilogram	2578662	2026-07-26 08:44:38.017807
202108	85176222	Optical transmission equipment for wave-division multiplexing	210279	Number of item	2069	Kilogram	3158440	2026-07-26 08:44:38.017807
202109	85176222	Optical transmission equipment for wave-division multiplexing	136370	Number of item	2523	Kilogram	2642566	2026-07-26 08:44:38.017807
202110	85176222	Optical transmission equipment for wave-division multiplexing	158781	Number of item	3234	Kilogram	3332539	2026-07-26 08:44:38.017807
202111	85176222	Optical transmission equipment for wave-division multiplexing	176416	Number of item	2598	Kilogram	2777940	2026-07-26 08:44:38.017807
202112	85176222	Optical transmission equipment for wave-division multiplexing	119823	Number of item	2674	Kilogram	2028629	2026-07-26 08:44:38.017807
202201	85176222	Optical transmission equipment for wave-division multiplexing	170373	Number of item	2270	Kilogram	2461290	2026-07-26 08:44:38.017807
202202	85176222	Optical transmission equipment for wave-division multiplexing	122297	Number of item	702	Kilogram	1116562	2026-07-26 08:44:38.017807
202508	85176232	Ethernet Exchangers	89174	Number of item	266560	Kilogram	63865116	2026-07-26 08:44:38.017807
202203	85176222	Optical transmission equipment for wave-division multiplexing	167636	Number of item	884	Kilogram	1571235	2026-07-26 08:44:38.017807
202204	85176222	Optical transmission equipment for wave-division multiplexing	102899	Number of item	1992	Kilogram	1380105	2026-07-26 08:44:38.017807
202205	85176222	Optical transmission equipment for wave-division multiplexing	79222	Number of item	5895	Kilogram	8861133	2026-07-26 08:44:38.017807
202206	85176222	Optical transmission equipment for wave-division multiplexing	84924	Number of item	856	Kilogram	2017165	2026-07-26 08:44:38.017807
202207	85176222	Optical transmission equipment for wave-division multiplexing	67553	Number of item	1139	Kilogram	2034685	2026-07-26 08:44:38.017807
202208	85176222	Optical transmission equipment for wave-division multiplexing	69372	Number of item	557	Kilogram	1048153	2026-07-26 08:44:38.017807
202209	85176222	Optical transmission equipment for wave-division multiplexing	70028	Number of item	3605	Kilogram	2612134	2026-07-26 08:44:38.017807
202210	85176222	Optical transmission equipment for wave-division multiplexing	52821	Number of item	3433	Kilogram	17519146	2026-07-26 08:44:38.017807
202211	85176222	Optical transmission equipment for wave-division multiplexing	79030	Number of item	4046	Kilogram	9178306	2026-07-26 08:44:38.017807
202212	85176222	Optical transmission equipment for wave-division multiplexing	63424	Number of item	10932	Kilogram	25478508	2026-07-26 08:44:38.017807
202301	85176222	Optical transmission equipment for wave-division multiplexing	49064	Number of item	489	Kilogram	968899	2026-07-26 08:44:38.017807
202302	85176222	Optical transmission equipment for wave-division multiplexing	57854	Number of item	593	Kilogram	1242288	2026-07-26 08:44:38.017807
202303	85176222	Optical transmission equipment for wave-division multiplexing	59760	Number of item	1655	Kilogram	1160817	2026-07-26 08:44:38.017807
202304	85176222	Optical transmission equipment for wave-division multiplexing	67479	Number of item	1058	Kilogram	2105166	2026-07-26 08:44:38.017807
202305	85176222	Optical transmission equipment for wave-division multiplexing	63579	Number of item	1059	Kilogram	995931	2026-07-26 08:44:38.017807
202306	85176222	Optical transmission equipment for wave-division multiplexing	65360	Number of item	748	Kilogram	768357	2026-07-26 08:44:38.017807
202307	85176222	Optical transmission equipment for wave-division multiplexing	112890	Number of item	760	Kilogram	2356436	2026-07-26 08:44:38.017807
202308	85176222	Optical transmission equipment for wave-division multiplexing	123879	Number of item	430	Kilogram	1030634	2026-07-26 08:44:38.017807
202309	85176222	Optical transmission equipment for wave-division multiplexing	68058	Number of item	1211	Kilogram	2295083	2026-07-26 08:44:38.017807
202310	85176222	Optical transmission equipment for wave-division multiplexing	57089	Number of item	659	Kilogram	2098959	2026-07-26 08:44:38.017807
202311	85176222	Optical transmission equipment for wave-division multiplexing	41543	Number of item	711	Kilogram	948547	2026-07-26 08:44:38.017807
202312	85176222	Optical transmission equipment for wave-division multiplexing	39950	Number of item	877	Kilogram	1343006	2026-07-26 08:44:38.017807
202401	85176222	Optical transmission equipment for wave-division multiplexing	56382	Number of item	164	Kilogram	976799	2026-07-26 08:44:38.017807
202402	85176222	Optical transmission equipment for wave-division multiplexing	34317	Number of item	102	Kilogram	489382	2026-07-26 08:44:38.017807
202403	85176222	Optical transmission equipment for wave-division multiplexing	59726	Number of item	552	Kilogram	852326	2026-07-26 08:44:38.017807
202404	85176222	Optical transmission equipment for wave-division multiplexing	64110	Number of item	639	Kilogram	2358343	2026-07-26 08:44:38.017807
202405	85176222	Optical transmission equipment for wave-division multiplexing	50400	Number of item	332	Kilogram	2158620	2026-07-26 08:44:38.017807
202406	85176222	Optical transmission equipment for wave-division multiplexing	34787	Number of item	359	Kilogram	1847580	2026-07-26 08:44:38.017807
202407	85176222	Optical transmission equipment for wave-division multiplexing	68413	Number of item	509	Kilogram	1391613	2026-07-26 08:44:38.017807
202408	85176222	Optical transmission equipment for wave-division multiplexing	65517	Number of item	499	Kilogram	944191	2026-07-26 08:44:38.017807
202409	85176222	Optical transmission equipment for wave-division multiplexing	71460	Number of item	978	Kilogram	854278	2026-07-26 08:44:38.017807
202410	85176222	Optical transmission equipment for wave-division multiplexing	67926	Number of item	487	Kilogram	1079361	2026-07-26 08:44:38.017807
202411	85176222	Optical transmission equipment for wave-division multiplexing	127170	Number of item	609	Kilogram	1095235	2026-07-26 08:44:38.017807
202412	85176222	Optical transmission equipment for wave-division multiplexing	95449	Number of item	206	Kilogram	732288	2026-07-26 08:44:38.017807
202501	85176222	Optical transmission equipment for wave-division multiplexing	91931	Number of item	1102	Kilogram	1199594	2026-07-26 08:44:38.017807
202502	85176222	Optical transmission equipment for wave-division multiplexing	86296	Number of item	439	Kilogram	830690	2026-07-26 08:44:38.017807
202503	85176222	Optical transmission equipment for wave-division multiplexing	105370	Number of item	433	Kilogram	912392	2026-07-26 08:44:38.017807
202504	85176222	Optical transmission equipment for wave-division multiplexing	122394	Number of item	859	Kilogram	1253556	2026-07-26 08:44:38.017807
202505	85176222	Optical transmission equipment for wave-division multiplexing	113649	Number of item	407	Kilogram	1227679	2026-07-26 08:44:38.017807
202506	85176222	Optical transmission equipment for wave-division multiplexing	152130	Number of item	942	Kilogram	2418973	2026-07-26 08:44:38.017807
202507	85176222	Optical transmission equipment for wave-division multiplexing	216568	Number of item	1770	Kilogram	4630762	2026-07-26 08:44:38.017807
202508	85176222	Optical transmission equipment for wave-division multiplexing	147864	Number of item	1192	Kilogram	2516700	2026-07-26 08:44:38.017807
202509	85176222	Optical transmission equipment for wave-division multiplexing	127691	Number of item	336	Kilogram	1199550	2026-07-26 08:44:38.017807
202510	85176222	Optical transmission equipment for wave-division multiplexing	130414	Number of item	265	Kilogram	1119209	2026-07-26 08:44:38.017807
202511	85176222	Optical transmission equipment for wave-division multiplexing	117928	Number of item	1324	Kilogram	2639922	2026-07-26 08:44:38.017807
202512	85176222	Optical transmission equipment for wave-division multiplexing	164837	Number of item	668	Kilogram	2018887	2026-07-26 08:44:38.017807
202601	85176222	Optical transmission equipment for wave-division multiplexing	914391	Number of item	301445	Kilogram	118477394	2026-07-26 08:44:38.017807
202602	85176222	Optical transmission equipment for wave-division multiplexing	514235	Number of item	216182	Kilogram	74084483	2026-07-26 08:44:38.017807
202603	85176222	Optical transmission equipment for wave-division multiplexing	694338	Number of item	199921	Kilogram	92051833	2026-07-26 08:44:38.017807
202604	85176222	Optical transmission equipment for wave-division multiplexing	922459	Number of item	239039	Kilogram	96696231	2026-07-26 08:44:38.017807
202605	85176222	Optical transmission equipment for wave-division multiplexing	798802	Number of item	307372	Kilogram	125503264	2026-07-26 08:44:38.017807
202606	85176222	Optical transmission equipment for wave-division multiplexing	625782	Number of item	403530	Kilogram	145604192	2026-07-26 08:44:38.017807
202101	85176232	Ethernet Exchangers	161889	Number of item	353506	Kilogram	71831263	2026-07-26 08:44:38.017807
202102	85176232	Ethernet Exchangers	85164	Number of item	261948	Kilogram	57051041	2026-07-26 08:44:38.017807
202103	85176232	Ethernet Exchangers	136349	Number of item	382795	Kilogram	87589746	2026-07-26 08:44:38.017807
202104	85176232	Ethernet Exchangers	96410	Number of item	314882	Kilogram	69161745	2026-07-26 08:44:38.017807
202105	85176232	Ethernet Exchangers	106127	Number of item	331779	Kilogram	74332676	2026-07-26 08:44:38.017807
202106	85176232	Ethernet Exchangers	99697	Number of item	324229	Kilogram	74033726	2026-07-26 08:44:38.017807
202107	85176232	Ethernet Exchangers	111855	Number of item	384194	Kilogram	89366241	2026-07-26 08:44:38.017807
202108	85176232	Ethernet Exchangers	116799	Number of item	310328	Kilogram	74842068	2026-07-26 08:44:38.017807
202109	85176232	Ethernet Exchangers	109481	Number of item	301661	Kilogram	61669118	2026-07-26 08:44:38.017807
202110	85176232	Ethernet Exchangers	113416	Number of item	282927	Kilogram	65349900	2026-07-26 08:44:38.017807
202111	85176232	Ethernet Exchangers	120848	Number of item	365940	Kilogram	88058402	2026-07-26 08:44:38.017807
202112	85176232	Ethernet Exchangers	112584	Number of item	290210	Kilogram	64626824	2026-07-26 08:44:38.017807
202201	85176232	Ethernet Exchangers	134527	Number of item	289308	Kilogram	68549440	2026-07-26 08:44:38.017807
202202	85176232	Ethernet Exchangers	104306	Number of item	249644	Kilogram	66657342	2026-07-26 08:44:38.017807
202203	85176232	Ethernet Exchangers	97774	Number of item	228791	Kilogram	57323352	2026-07-26 08:44:38.017807
202204	85176232	Ethernet Exchangers	103768	Number of item	286557	Kilogram	63288277	2026-07-26 08:44:38.017807
202205	85176232	Ethernet Exchangers	104151	Number of item	336261	Kilogram	74554271	2026-07-26 08:44:38.017807
202206	85176232	Ethernet Exchangers	102997	Number of item	284371	Kilogram	64659153	2026-07-26 08:44:38.017807
202207	85176232	Ethernet Exchangers	117554	Number of item	353691	Kilogram	87722686	2026-07-26 08:44:38.017807
202208	85176232	Ethernet Exchangers	128218	Number of item	438630	Kilogram	94024576	2026-07-26 08:44:38.017807
202209	85176232	Ethernet Exchangers	142951	Number of item	409415	Kilogram	80825347	2026-07-26 08:44:38.017807
202210	85176232	Ethernet Exchangers	117902	Number of item	360363	Kilogram	73436745	2026-07-26 08:44:38.017807
202211	85176232	Ethernet Exchangers	113324	Number of item	450697	Kilogram	99930797	2026-07-26 08:44:38.017807
202212	85176232	Ethernet Exchangers	164863	Number of item	397858	Kilogram	86305700	2026-07-26 08:44:38.017807
202301	85176232	Ethernet Exchangers	81937	Number of item	275504	Kilogram	54231080	2026-07-26 08:44:38.017807
202302	85176232	Ethernet Exchangers	103204	Number of item	313167	Kilogram	77196099	2026-07-26 08:44:38.017807
202303	85176232	Ethernet Exchangers	140262	Number of item	356384	Kilogram	85006387	2026-07-26 08:44:38.017807
202304	85176232	Ethernet Exchangers	107753	Number of item	343017	Kilogram	88638450	2026-07-26 08:44:38.017807
202305	85176232	Ethernet Exchangers	118304	Number of item	511111	Kilogram	110981390	2026-07-26 08:44:38.017807
202306	85176232	Ethernet Exchangers	105395	Number of item	363891	Kilogram	88826192	2026-07-26 08:44:38.017807
202307	85176232	Ethernet Exchangers	123641	Number of item	408140	Kilogram	91465191	2026-07-26 08:44:38.017807
202308	85176232	Ethernet Exchangers	106950	Number of item	417102	Kilogram	94491302	2026-07-26 08:44:38.017807
202309	85176232	Ethernet Exchangers	135253	Number of item	460128	Kilogram	101356764	2026-07-26 08:44:38.017807
202310	85176232	Ethernet Exchangers	94183	Number of item	359395	Kilogram	92828436	2026-07-26 08:44:38.017807
202311	85176232	Ethernet Exchangers	100442	Number of item	401681	Kilogram	89523838	2026-07-26 08:44:38.017807
202312	85176232	Ethernet Exchangers	127087	Number of item	399717	Kilogram	80212950	2026-07-26 08:44:38.017807
202401	85176232	Ethernet Exchangers	64647	Number of item	267219	Kilogram	81693373	2026-07-26 08:44:38.017807
202402	85176232	Ethernet Exchangers	47684	Number of item	176778	Kilogram	46028844	2026-07-26 08:44:38.017807
202403	85176232	Ethernet Exchangers	93982	Number of item	237916	Kilogram	83169208	2026-07-26 08:44:38.017807
202404	85176232	Ethernet Exchangers	74285	Number of item	250599	Kilogram	65335420	2026-07-26 08:44:38.017807
202405	85176232	Ethernet Exchangers	60861	Number of item	186205	Kilogram	52478809	2026-07-26 08:44:38.017807
202406	85176232	Ethernet Exchangers	66861	Number of item	154719	Kilogram	41329006	2026-07-26 08:44:38.017807
202407	85176232	Ethernet Exchangers	71324	Number of item	217967	Kilogram	64348185	2026-07-26 08:44:38.017807
202408	85176232	Ethernet Exchangers	74171	Number of item	216669	Kilogram	60577853	2026-07-26 08:44:38.017807
202409	85176232	Ethernet Exchangers	84656	Number of item	220890	Kilogram	53980746	2026-07-26 08:44:38.017807
202410	85176232	Ethernet Exchangers	68364	Number of item	171414	Kilogram	42361763	2026-07-26 08:44:38.017807
202411	85176232	Ethernet Exchangers	113968	Number of item	240067	Kilogram	59906513	2026-07-26 08:44:38.017807
202412	85176232	Ethernet Exchangers	81107	Number of item	225287	Kilogram	55405383	2026-07-26 08:44:38.017807
202501	85176232	Ethernet Exchangers	47709	Number of item	97777	Kilogram	28013595	2026-07-26 08:44:38.017807
202502	85176232	Ethernet Exchangers	67625	Number of item	210071	Kilogram	44976297	2026-07-26 08:44:38.017807
202503	85176232	Ethernet Exchangers	129674	Number of item	241464	Kilogram	46112104	2026-07-26 08:44:38.017807
202504	85176232	Ethernet Exchangers	88192	Number of item	216341	Kilogram	52083885	2026-07-26 08:44:38.017807
202505	85176232	Ethernet Exchangers	95372	Number of item	210564	Kilogram	46094828	2026-07-26 08:44:38.017807
202506	85176232	Ethernet Exchangers	90876	Number of item	211821	Kilogram	50341785	2026-07-26 08:44:38.017807
202507	85176232	Ethernet Exchangers	93626	Number of item	237304	Kilogram	56597615	2026-07-26 08:44:38.017807
202509	85176232	Ethernet Exchangers	101992	Number of item	263038	Kilogram	64230200	2026-07-26 08:44:38.017807
202510	85176232	Ethernet Exchangers	72523	Number of item	225307	Kilogram	49117086	2026-07-26 08:44:38.017807
202511	85176232	Ethernet Exchangers	132562	Number of item	302428	Kilogram	61459247	2026-07-26 08:44:38.017807
202512	85176232	Ethernet Exchangers	86372	Number of item	243119	Kilogram	60452483	2026-07-26 08:44:38.017807
202601	85176232	Ethernet Exchangers	2733235	Number of item	3249150	Kilogram	187355806	2026-07-26 08:44:38.017807
202602	85176232	Ethernet Exchangers	2426518	Number of item	2848579	Kilogram	196524059	2026-07-26 08:44:38.017807
202603	85176232	Ethernet Exchangers	2269295	Number of item	2795690	Kilogram	189399018	2026-07-26 08:44:38.017807
202604	85176232	Ethernet Exchangers	2539436	Number of item	3482945	Kilogram	271965112	2026-07-26 08:44:38.017807
202605	85176232	Ethernet Exchangers	2642430	Number of item	3393929	Kilogram	226635871	2026-07-26 08:44:38.017807
202606	85176232	Ethernet Exchangers	2917441	Number of item	3726829	Kilogram	245830246	2026-07-26 08:44:38.017807
202101	85423190	Other integrated circuits, as processors and controllers	12595806804	Number of item	2236107	Kilogram	12720783561	2026-07-26 08:44:38.017807
202102	85423190	Other integrated circuits, as processors and controllers	9815675611	Number of item	1684923	Kilogram	11063746390	2026-07-26 08:44:38.017807
202103	85423190	Other integrated circuits, as processors and controllers	13111971453	Number of item	2384337	Kilogram	15519922182	2026-07-26 08:44:38.017807
202104	85423190	Other integrated circuits, as processors and controllers	12646089218	Number of item	2289565	Kilogram	13625735613	2026-07-26 08:44:38.017807
202105	85423190	Other integrated circuits, as processors and controllers	11489401150	Number of item	2187198	Kilogram	13992220238	2026-07-26 08:44:38.017807
202106	85423190	Other integrated circuits, as processors and controllers	12294850102	Number of item	2208781	Kilogram	16371392871	2026-07-26 08:44:38.017807
202107	85423190	Other integrated circuits, as processors and controllers	13419752279	Number of item	2203173	Kilogram	14257371178	2026-07-26 08:44:38.017807
202108	85423190	Other integrated circuits, as processors and controllers	13318285549	Number of item	2224777	Kilogram	14808701864	2026-07-26 08:44:38.017807
202109	85423190	Other integrated circuits, as processors and controllers	13613039063	Number of item	2272956	Kilogram	17263673853	2026-07-26 08:44:38.017807
202110	85423190	Other integrated circuits, as processors and controllers	12090810493	Number of item	2065202	Kilogram	13529862674	2026-07-26 08:44:38.017807
202111	85423190	Other integrated circuits, as processors and controllers	13584548140	Number of item	2242263	Kilogram	16329834956	2026-07-26 08:44:38.017807
202112	85423190	Other integrated circuits, as processors and controllers	13713392813	Number of item	2259293	Kilogram	18336487082	2026-07-26 08:44:38.017807
202201	85423190	Other integrated circuits, as processors and controllers	13136764687	Number of item	2209477	Kilogram	15840856741	2026-07-26 08:44:38.017807
202202	85423190	Other integrated circuits, as processors and controllers	10877547773	Number of item	1683744	Kilogram	12958816986	2026-07-26 08:44:38.017807
202203	85423190	Other integrated circuits, as processors and controllers	12303405807	Number of item	2167973	Kilogram	16586922348	2026-07-26 08:44:38.017807
202204	85423190	Other integrated circuits, as processors and controllers	11188679863	Number of item	2007986	Kilogram	15178940963	2026-07-26 08:44:38.017807
202205	85423190	Other integrated circuits, as processors and controllers	10937451583	Number of item	1869899	Kilogram	13732043352	2026-07-26 08:44:38.017807
202206	85423190	Other integrated circuits, as processors and controllers	11825306886	Number of item	2030664	Kilogram	15414423891	2026-07-26 08:44:38.017807
202207	85423190	Other integrated circuits, as processors and controllers	11462873591	Number of item	1776005	Kilogram	14409041013	2026-07-26 08:44:38.017807
202208	85423190	Other integrated circuits, as processors and controllers	12127521845	Number of item	1866308	Kilogram	13312312870	2026-07-26 08:44:38.017807
202209	85423190	Other integrated circuits, as processors and controllers	12696554156	Number of item	2144779	Kilogram	16281157104	2026-07-26 08:44:38.017807
202210	85423190	Other integrated circuits, as processors and controllers	11104284938	Number of item	1768712	Kilogram	14939368936	2026-07-26 08:44:38.017807
202211	85423190	Other integrated circuits, as processors and controllers	11315779927	Number of item	1844962	Kilogram	12900813248	2026-07-26 08:44:38.017807
202212	85423190	Other integrated circuits, as processors and controllers	10358183000	Number of item	1907075	Kilogram	14725727595	2026-07-26 08:44:38.017807
202301	85423190	Other integrated circuits, as processors and controllers	10600231856	Number of item	1368634	Kilogram	10495093778	2026-07-26 08:44:38.017807
202302	85423190	Other integrated circuits, as processors and controllers	9751549470	Number of item	1581957	Kilogram	11040046149	2026-07-26 08:44:38.017807
202303	85423190	Other integrated circuits, as processors and controllers	10892867328	Number of item	1930229	Kilogram	14539638681	2026-07-26 08:44:38.017807
202304	85423190	Other integrated circuits, as processors and controllers	10316683085	Number of item	1676319	Kilogram	11801182453	2026-07-26 08:44:38.017807
202305	85423190	Other integrated circuits, as processors and controllers	10246200741	Number of item	1654756	Kilogram	11646928092	2026-07-26 08:44:38.017807
202306	85423190	Other integrated circuits, as processors and controllers	9322756309	Number of item	1856118	Kilogram	13652623877	2026-07-26 08:44:38.017807
202307	85423190	Other integrated circuits, as processors and controllers	11366014323	Number of item	1758018	Kilogram	12533479525	2026-07-26 08:44:38.017807
202308	85423190	Other integrated circuits, as processors and controllers	11152803342	Number of item	1793679	Kilogram	13332602823	2026-07-26 08:44:38.017807
202309	85423190	Other integrated circuits, as processors and controllers	10378286821	Number of item	1821841	Kilogram	13734738033	2026-07-26 08:44:38.017807
202310	85423190	Other integrated circuits, as processors and controllers	10448289237	Number of item	1720054	Kilogram	13899674949	2026-07-26 08:44:38.017807
202311	85423190	Other integrated circuits, as processors and controllers	8596106305	Number of item	1763010	Kilogram	14355712058	2026-07-26 08:44:38.017807
202312	85423190	Other integrated circuits, as processors and controllers	9481356893	Number of item	1905771	Kilogram	14338348537	2026-07-26 08:44:38.017807
202401	85423190	Other integrated circuits, as processors and controllers	9619655514	Number of item	1607359	Kilogram	12737123636	2026-07-26 08:44:38.017807
202402	85423190	Other integrated circuits, as processors and controllers	7805506007	Number of item	1335823	Kilogram	10192017012	2026-07-26 08:44:38.017807
202403	85423190	Other integrated circuits, as processors and controllers	9497193303	Number of item	1751326	Kilogram	13090519924	2026-07-26 08:44:38.017807
202404	85423190	Other integrated circuits, as processors and controllers	12235739947	Number of item	1720181	Kilogram	13333256053	2026-07-26 08:44:38.017807
202405	85423190	Other integrated circuits, as processors and controllers	11363679948	Number of item	1679876	Kilogram	12928350777	2026-07-26 08:44:38.017807
202406	85423190	Other integrated circuits, as processors and controllers	11953762124	Number of item	1665840	Kilogram	13625219638	2026-07-26 08:44:38.017807
202407	85423190	Other integrated circuits, as processors and controllers	13004844012	Number of item	1691843	Kilogram	14038128340	2026-07-26 08:44:38.017807
202408	85423190	Other integrated circuits, as processors and controllers	13212129198	Number of item	1716354	Kilogram	14512757553	2026-07-26 08:44:38.017807
202409	85423190	Other integrated circuits, as processors and controllers	11923643871	Number of item	1859491	Kilogram	16543952062	2026-07-26 08:44:38.017807
202410	85423190	Other integrated circuits, as processors and controllers	12108537764	Number of item	1566591	Kilogram	15191148560	2026-07-26 08:44:38.017807
202411	85423190	Other integrated circuits, as processors and controllers	11736601880	Number of item	1625866	Kilogram	15287227385	2026-07-26 08:44:38.017807
202412	85423190	Other integrated circuits, as processors and controllers	10710391194	Number of item	1854933	Kilogram	16551968792	2026-07-26 08:44:38.017807
202501	85423190	Other integrated circuits, as processors and controllers	10724340818	Number of item	1498428	Kilogram	13384380664	2026-07-26 08:44:38.017807
202502	85423190	Other integrated circuits, as processors and controllers	10815311934	Number of item	1390644	Kilogram	11705871735	2026-07-26 08:44:38.017807
202503	85423190	Other integrated circuits, as processors and controllers	11575251840	Number of item	1715807	Kilogram	14838759749	2026-07-26 08:44:38.017807
202504	85423190	Other integrated circuits, as processors and controllers	12469897689	Number of item	1814818	Kilogram	15109672176	2026-07-26 08:44:38.017807
202505	85423190	Other integrated circuits, as processors and controllers	11280907583	Number of item	1732485	Kilogram	14873275206	2026-07-26 08:44:38.017807
202506	85423190	Other integrated circuits, as processors and controllers	11047023334	Number of item	1730237	Kilogram	15458277447	2026-07-26 08:44:38.017807
202507	85423190	Other integrated circuits, as processors and controllers	12487316950	Number of item	1737262	Kilogram	15675780126	2026-07-26 08:44:38.017807
202508	85423190	Other integrated circuits, as processors and controllers	11317743623	Number of item	1670678	Kilogram	14701753774	2026-07-26 08:44:38.017807
202509	85423190	Other integrated circuits, as processors and controllers	11754475145	Number of item	1820599	Kilogram	17312704403	2026-07-26 08:44:38.017807
202510	85423190	Other integrated circuits, as processors and controllers	11067514802	Number of item	1636327	Kilogram	15561320993	2026-07-26 08:44:38.017807
202511	85423190	Other integrated circuits, as processors and controllers	10243517904	Number of item	1662193	Kilogram	15111633810	2026-07-26 08:44:38.017807
202512	85423190	Other integrated circuits, as processors and controllers	11613851982	Number of item	1784172	Kilogram	16557645338	2026-07-26 08:44:38.017807
202601	85423190	Other integrated circuits, as processors and controllers	7262851443	Number of item	1279707	Kilogram	5821657603	2026-07-26 08:44:38.017807
202602	85423190	Other integrated circuits, as processors and controllers	5408000188	Number of item	894813	Kilogram	3986352260	2026-07-26 08:44:38.017807
202603	85423190	Other integrated circuits, as processors and controllers	8068716811	Number of item	1314037	Kilogram	5412961587	2026-07-26 08:44:38.017807
202604	85423190	Other integrated circuits, as processors and controllers	8446220592	Number of item	1212831	Kilogram	5105755238	2026-07-26 08:44:38.017807
202605	85423190	Other integrated circuits, as processors and controllers	7623610868	Number of item	1219767	Kilogram	5016986429	2026-07-26 08:44:38.017807
202606	85423190	Other integrated circuits, as processors and controllers	8043037454	Number of item	1298893	Kilogram	5375516275	2026-07-26 08:44:38.017807
\.


--
-- Data for Name: raw_import_hs; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.raw_import_hs (data_month, hs_code, commodity_name, quantity, unit, supplementary_quantity, supplementary_unit, usd_value, ingested_at) FROM stdin;
202101	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1408432	Kilogram	0	?	203698264	2026-07-26 08:49:34.890893
202102	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1107427	Kilogram	0	?	155143164	2026-07-26 08:49:34.890893
202103	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1657254	Kilogram	0	?	223753485	2026-07-26 08:49:34.890893
202104	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1426894	Kilogram	0	?	184717127	2026-07-26 08:49:34.890893
202105	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1525087	Kilogram	0	?	213940388	2026-07-26 08:49:34.890893
202106	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1555032	Kilogram	0	?	252322140	2026-07-26 08:49:34.890893
202107	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	2012006	Kilogram	0	?	244409471	2026-07-26 08:49:34.890893
202108	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1731911	Kilogram	0	?	253150724	2026-07-26 08:49:34.890893
202109	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1967685	Kilogram	0	?	284756817	2026-07-26 08:49:34.890893
202110	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1976939	Kilogram	0	?	236281652	2026-07-26 08:49:34.890893
202111	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	2083540	Kilogram	0	?	244620499	2026-07-26 08:49:34.890893
202112	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1861207	Kilogram	0	?	202099918	2026-07-26 08:49:34.890893
202201	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1921659	Kilogram	0	?	220634686	2026-07-26 08:49:34.890893
202202	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1690696	Kilogram	0	?	128330312	2026-07-26 08:49:34.890893
202203	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1629647	Kilogram	0	?	160961115	2026-07-26 08:49:34.890893
202204	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1521493	Kilogram	0	?	152934230	2026-07-26 08:49:34.890893
202205	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1492794	Kilogram	0	?	131182914	2026-07-26 08:49:34.890893
202206	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1213791	Kilogram	0	?	133964384	2026-07-26 08:49:34.890893
202207	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	1171332	Kilogram	0	?	143579743	2026-07-26 08:49:34.890893
202208	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	915743	Kilogram	0	?	79678381	2026-07-26 08:49:34.890893
202209	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	386042	Kilogram	0	?	65955335	2026-07-26 08:49:34.890893
202210	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	488738	Kilogram	0	?	74357321	2026-07-26 08:49:34.890893
202211	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	344204	Kilogram	0	?	70971895	2026-07-26 08:49:34.890893
202212	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7019	720857	Kilogram	0	?	75046587	2026-07-26 08:49:34.890893
202301	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	724480	Kilogram	0	?	82342783	2026-07-26 08:49:34.890893
202302	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	849960	Kilogram	0	?	92331452	2026-07-26 08:49:34.890893
202303	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	691876	Kilogram	0	?	86833787	2026-07-26 08:49:34.890893
202304	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	946054	Kilogram	0	?	85357431	2026-07-26 08:49:34.890893
202305	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	855913	Kilogram	0	?	95523882	2026-07-26 08:49:34.890893
202306	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	655774	Kilogram	0	?	98983638	2026-07-26 08:49:34.890893
202307	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	866162	Kilogram	0	?	82089055	2026-07-26 08:49:34.890893
202308	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	736856	Kilogram	0	?	87945536	2026-07-26 08:49:34.890893
202309	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	695778	Kilogram	0	?	92326196	2026-07-26 08:49:34.890893
202310	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1031182	Kilogram	0	?	94052758	2026-07-26 08:49:34.890893
202311	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1089329	Kilogram	0	?	112429506	2026-07-26 08:49:34.890893
202312	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1176363	Kilogram	0	?	128569056	2026-07-26 08:49:34.890893
202401	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1277377	Kilogram	0	?	111329723	2026-07-26 08:49:34.890893
202402	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	926832	Kilogram	0	?	78848520	2026-07-26 08:49:34.890893
202403	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1161277	Kilogram	0	?	88426792	2026-07-26 08:49:34.890893
202404	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1278203	Kilogram	0	?	123311611	2026-07-26 08:49:34.890893
202405	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	982614	Kilogram	0	?	113471423	2026-07-26 08:49:34.890893
202406	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1085807	Kilogram	0	?	88957411	2026-07-26 08:49:34.890893
202407	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1481239	Kilogram	0	?	130710273	2026-07-26 08:49:34.890893
202408	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1201839	Kilogram	0	?	151646108	2026-07-26 08:49:34.890893
202409	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1032847	Kilogram	0	?	101425120	2026-07-26 08:49:34.890893
202410	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1123017	Kilogram	0	?	122356734	2026-07-26 08:49:34.890893
202411	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	995934	Kilogram	0	?	131162295	2026-07-26 08:49:34.890893
202412	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1050149	Kilogram	0	?	103243061	2026-07-26 08:49:34.890893
202501	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	920041	Kilogram	0	?	113945211	2026-07-26 08:49:34.890893
202502	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	758635	Kilogram	0	?	136463132	2026-07-26 08:49:34.890893
202503	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1168684	Kilogram	0	?	131514906	2026-07-26 08:49:34.890893
202504	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1103521	Kilogram	0	?	128134437	2026-07-26 08:49:34.890893
202505	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	906309	Kilogram	0	?	125596241	2026-07-26 08:49:34.890893
202506	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1018337	Kilogram	0	?	114461544	2026-07-26 08:49:34.890893
202507	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1087433	Kilogram	0	?	143256606	2026-07-26 08:49:34.890893
202508	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	911186	Kilogram	0	?	137586434	2026-07-26 08:49:34.890893
202509	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1186422	Kilogram	0	?	146370538	2026-07-26 08:49:34.890893
202510	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1308013	Kilogram	0	?	139521552	2026-07-26 08:49:34.890893
202511	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1179236	Kilogram	0	?	144471013	2026-07-26 08:49:34.890893
202512	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1335067	Kilogram	0	?	138855543	2026-07-26 08:49:34.890893
202601	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1339685	Kilogram	0	?	152322717	2026-07-26 08:49:34.890893
202602	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1074894	Kilogram	0	?	130699665	2026-07-26 08:49:34.890893
202603	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1316608	Kilogram	0	?	153362433	2026-07-26 08:49:34.890893
202604	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1253793	Kilogram	0	?	158829214	2026-07-26 08:49:34.890893
202605	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	1052750	Kilogram	0	?	140129131	2026-07-26 08:49:34.890893
202606	84733010	Parts/accessor of 8471.1000/4110/4120/4910/4920/5010/5020/6090/7011/7019/7020/7030/7090	957284	Kilogram	0	?	158024585	2026-07-26 08:49:34.890893
202101	85176222	Optical transmission equipment for wave-division multiplexing	135227	Number of item	4480	Kilogram	4933855	2026-07-26 08:49:34.890893
202102	85176222	Optical transmission equipment for wave-division multiplexing	89042	Number of item	941	Kilogram	1362059	2026-07-26 08:49:34.890893
202103	85176222	Optical transmission equipment for wave-division multiplexing	151196	Number of item	1864	Kilogram	2601431	2026-07-26 08:49:34.890893
202104	85176222	Optical transmission equipment for wave-division multiplexing	197496	Number of item	930	Kilogram	2137561	2026-07-26 08:49:34.890893
202105	85176222	Optical transmission equipment for wave-division multiplexing	173647	Number of item	1165	Kilogram	1888843	2026-07-26 08:49:34.890893
202106	85176222	Optical transmission equipment for wave-division multiplexing	204209	Number of item	1688	Kilogram	2295014	2026-07-26 08:49:34.890893
202107	85176222	Optical transmission equipment for wave-division multiplexing	196358	Number of item	1836	Kilogram	2578662	2026-07-26 08:49:34.890893
202108	85176222	Optical transmission equipment for wave-division multiplexing	210279	Number of item	2069	Kilogram	3158440	2026-07-26 08:49:34.890893
202109	85176222	Optical transmission equipment for wave-division multiplexing	136370	Number of item	2523	Kilogram	2642566	2026-07-26 08:49:34.890893
202110	85176222	Optical transmission equipment for wave-division multiplexing	158781	Number of item	3234	Kilogram	3332539	2026-07-26 08:49:34.890893
202111	85176222	Optical transmission equipment for wave-division multiplexing	176416	Number of item	2598	Kilogram	2777940	2026-07-26 08:49:34.890893
202112	85176222	Optical transmission equipment for wave-division multiplexing	119823	Number of item	2674	Kilogram	2028629	2026-07-26 08:49:34.890893
202201	85176222	Optical transmission equipment for wave-division multiplexing	170373	Number of item	2270	Kilogram	2461290	2026-07-26 08:49:34.890893
202202	85176222	Optical transmission equipment for wave-division multiplexing	122297	Number of item	702	Kilogram	1116562	2026-07-26 08:49:34.890893
202203	85176222	Optical transmission equipment for wave-division multiplexing	167636	Number of item	884	Kilogram	1571235	2026-07-26 08:49:34.890893
202204	85176222	Optical transmission equipment for wave-division multiplexing	102899	Number of item	1992	Kilogram	1380105	2026-07-26 08:49:34.890893
202205	85176222	Optical transmission equipment for wave-division multiplexing	79222	Number of item	5895	Kilogram	8861133	2026-07-26 08:49:34.890893
202206	85176222	Optical transmission equipment for wave-division multiplexing	84924	Number of item	856	Kilogram	2017165	2026-07-26 08:49:34.890893
202207	85176222	Optical transmission equipment for wave-division multiplexing	67553	Number of item	1139	Kilogram	2034685	2026-07-26 08:49:34.890893
202208	85176222	Optical transmission equipment for wave-division multiplexing	69372	Number of item	557	Kilogram	1048153	2026-07-26 08:49:34.890893
202209	85176222	Optical transmission equipment for wave-division multiplexing	70028	Number of item	3605	Kilogram	2612134	2026-07-26 08:49:34.890893
202210	85176222	Optical transmission equipment for wave-division multiplexing	52821	Number of item	3433	Kilogram	17519146	2026-07-26 08:49:34.890893
202211	85176222	Optical transmission equipment for wave-division multiplexing	79030	Number of item	4046	Kilogram	9178306	2026-07-26 08:49:34.890893
202212	85176222	Optical transmission equipment for wave-division multiplexing	63424	Number of item	10932	Kilogram	25478508	2026-07-26 08:49:34.890893
202301	85176222	Optical transmission equipment for wave-division multiplexing	49064	Number of item	489	Kilogram	968899	2026-07-26 08:49:34.890893
202302	85176222	Optical transmission equipment for wave-division multiplexing	57854	Number of item	593	Kilogram	1242288	2026-07-26 08:49:34.890893
202303	85176222	Optical transmission equipment for wave-division multiplexing	59760	Number of item	1655	Kilogram	1160817	2026-07-26 08:49:34.890893
202304	85176222	Optical transmission equipment for wave-division multiplexing	67479	Number of item	1058	Kilogram	2105166	2026-07-26 08:49:34.890893
202305	85176222	Optical transmission equipment for wave-division multiplexing	63579	Number of item	1059	Kilogram	995931	2026-07-26 08:49:34.890893
202306	85176222	Optical transmission equipment for wave-division multiplexing	65360	Number of item	748	Kilogram	768357	2026-07-26 08:49:34.890893
202307	85176222	Optical transmission equipment for wave-division multiplexing	112890	Number of item	760	Kilogram	2356436	2026-07-26 08:49:34.890893
202308	85176222	Optical transmission equipment for wave-division multiplexing	123879	Number of item	430	Kilogram	1030634	2026-07-26 08:49:34.890893
202309	85176222	Optical transmission equipment for wave-division multiplexing	68058	Number of item	1211	Kilogram	2295083	2026-07-26 08:49:34.890893
202310	85176222	Optical transmission equipment for wave-division multiplexing	57089	Number of item	659	Kilogram	2098959	2026-07-26 08:49:34.890893
202311	85176222	Optical transmission equipment for wave-division multiplexing	41543	Number of item	711	Kilogram	948547	2026-07-26 08:49:34.890893
202312	85176222	Optical transmission equipment for wave-division multiplexing	39950	Number of item	877	Kilogram	1343006	2026-07-26 08:49:34.890893
202401	85176222	Optical transmission equipment for wave-division multiplexing	56382	Number of item	164	Kilogram	976799	2026-07-26 08:49:34.890893
202402	85176222	Optical transmission equipment for wave-division multiplexing	34317	Number of item	102	Kilogram	489382	2026-07-26 08:49:34.890893
202403	85176222	Optical transmission equipment for wave-division multiplexing	59726	Number of item	552	Kilogram	852326	2026-07-26 08:49:34.890893
202404	85176222	Optical transmission equipment for wave-division multiplexing	64110	Number of item	639	Kilogram	2358343	2026-07-26 08:49:34.890893
202405	85176222	Optical transmission equipment for wave-division multiplexing	50400	Number of item	332	Kilogram	2158620	2026-07-26 08:49:34.890893
202406	85176222	Optical transmission equipment for wave-division multiplexing	34787	Number of item	359	Kilogram	1847580	2026-07-26 08:49:34.890893
202407	85176222	Optical transmission equipment for wave-division multiplexing	68413	Number of item	509	Kilogram	1391613	2026-07-26 08:49:34.890893
202408	85176222	Optical transmission equipment for wave-division multiplexing	65517	Number of item	499	Kilogram	944191	2026-07-26 08:49:34.890893
202409	85176222	Optical transmission equipment for wave-division multiplexing	71460	Number of item	978	Kilogram	854278	2026-07-26 08:49:34.890893
202410	85176222	Optical transmission equipment for wave-division multiplexing	67926	Number of item	487	Kilogram	1079361	2026-07-26 08:49:34.890893
202411	85176222	Optical transmission equipment for wave-division multiplexing	127170	Number of item	609	Kilogram	1095235	2026-07-26 08:49:34.890893
202412	85176222	Optical transmission equipment for wave-division multiplexing	95449	Number of item	206	Kilogram	732288	2026-07-26 08:49:34.890893
202501	85176222	Optical transmission equipment for wave-division multiplexing	91931	Number of item	1102	Kilogram	1199594	2026-07-26 08:49:34.890893
202502	85176222	Optical transmission equipment for wave-division multiplexing	86296	Number of item	439	Kilogram	830690	2026-07-26 08:49:34.890893
202503	85176222	Optical transmission equipment for wave-division multiplexing	105370	Number of item	433	Kilogram	912392	2026-07-26 08:49:34.890893
202504	85176222	Optical transmission equipment for wave-division multiplexing	122394	Number of item	859	Kilogram	1253556	2026-07-26 08:49:34.890893
202505	85176222	Optical transmission equipment for wave-division multiplexing	113649	Number of item	407	Kilogram	1227679	2026-07-26 08:49:34.890893
202506	85176222	Optical transmission equipment for wave-division multiplexing	152130	Number of item	942	Kilogram	2418973	2026-07-26 08:49:34.890893
202507	85176222	Optical transmission equipment for wave-division multiplexing	216568	Number of item	1770	Kilogram	4630762	2026-07-26 08:49:34.890893
202508	85176222	Optical transmission equipment for wave-division multiplexing	147864	Number of item	1192	Kilogram	2516700	2026-07-26 08:49:34.890893
202509	85176222	Optical transmission equipment for wave-division multiplexing	127691	Number of item	336	Kilogram	1199550	2026-07-26 08:49:34.890893
202510	85176222	Optical transmission equipment for wave-division multiplexing	130414	Number of item	265	Kilogram	1119209	2026-07-26 08:49:34.890893
202511	85176222	Optical transmission equipment for wave-division multiplexing	117928	Number of item	1324	Kilogram	2639922	2026-07-26 08:49:34.890893
202512	85176222	Optical transmission equipment for wave-division multiplexing	164837	Number of item	668	Kilogram	2018887	2026-07-26 08:49:34.890893
202601	85176222	Optical transmission equipment for wave-division multiplexing	190770	Number of item	1202	Kilogram	2637365	2026-07-26 08:49:34.890893
202602	85176222	Optical transmission equipment for wave-division multiplexing	122447	Number of item	355	Kilogram	1295835	2026-07-26 08:49:34.890893
202603	85176222	Optical transmission equipment for wave-division multiplexing	108139	Number of item	760	Kilogram	2745472	2026-07-26 08:49:34.890893
202604	85176222	Optical transmission equipment for wave-division multiplexing	116987	Number of item	1593	Kilogram	5072838	2026-07-26 08:49:34.890893
202605	85176222	Optical transmission equipment for wave-division multiplexing	136128	Number of item	881	Kilogram	2906476	2026-07-26 08:49:34.890893
202606	85176222	Optical transmission equipment for wave-division multiplexing	197379	Number of item	2180	Kilogram	13038976	2026-07-26 08:49:34.890893
202101	85423111	Semiconductor modules with converting function	44189395	Number of item	49285	Kilogram	104268987	2026-07-26 08:49:34.890893
202102	85423111	Semiconductor modules with converting function	31043165	Number of item	38861	Kilogram	64489432	2026-07-26 08:49:34.890893
202103	85423111	Semiconductor modules with converting function	45530866	Number of item	46858	Kilogram	98529991	2026-07-26 08:49:34.890893
202104	85423111	Semiconductor modules with converting function	46323683	Number of item	45503	Kilogram	110432857	2026-07-26 08:49:34.890893
202105	85423111	Semiconductor modules with converting function	38672018	Number of item	35006	Kilogram	82713004	2026-07-26 08:49:34.890893
202106	85423111	Semiconductor modules with converting function	45454229	Number of item	45566	Kilogram	107830815	2026-07-26 08:49:34.890893
202107	85423111	Semiconductor modules with converting function	36680778	Number of item	32477	Kilogram	69104328	2026-07-26 08:49:34.890893
202108	85423111	Semiconductor modules with converting function	40071776	Number of item	37615	Kilogram	96271146	2026-07-26 08:49:34.890893
202109	85423111	Semiconductor modules with converting function	38132615	Number of item	30193	Kilogram	81089881	2026-07-26 08:49:34.890893
202110	85423111	Semiconductor modules with converting function	37195171	Number of item	30371	Kilogram	107391235	2026-07-26 08:49:34.890893
202111	85423111	Semiconductor modules with converting function	45128879	Number of item	48971	Kilogram	182927126	2026-07-26 08:49:34.890893
202112	85423111	Semiconductor modules with converting function	45645183	Number of item	40128	Kilogram	121255752	2026-07-26 08:49:34.890893
202201	85423111	Semiconductor modules with converting function	48495434	Number of item	42361	Kilogram	169499540	2026-07-26 08:49:34.890893
202202	85423111	Semiconductor modules with converting function	39464472	Number of item	29470	Kilogram	96396929	2026-07-26 08:49:34.890893
202203	85423111	Semiconductor modules with converting function	54164135	Number of item	48800	Kilogram	146836877	2026-07-26 08:49:34.890893
202204	85423111	Semiconductor modules with converting function	41715869	Number of item	40561	Kilogram	152150821	2026-07-26 08:49:34.890893
202205	85423111	Semiconductor modules with converting function	41521003	Number of item	28846	Kilogram	107007873	2026-07-26 08:49:34.890893
202206	85423111	Semiconductor modules with converting function	42483965	Number of item	40043	Kilogram	142376179	2026-07-26 08:49:34.890893
202207	85423111	Semiconductor modules with converting function	35168670	Number of item	38610	Kilogram	171608120	2026-07-26 08:49:34.890893
202208	85423111	Semiconductor modules with converting function	38120178	Number of item	35825	Kilogram	107663892	2026-07-26 08:49:34.890893
202209	85423111	Semiconductor modules with converting function	38440467	Number of item	34903	Kilogram	123707242	2026-07-26 08:49:34.890893
202210	85423111	Semiconductor modules with converting function	31692739	Number of item	30594	Kilogram	82614020	2026-07-26 08:49:34.890893
202211	85423111	Semiconductor modules with converting function	34678716	Number of item	33537	Kilogram	118746749	2026-07-26 08:49:34.890893
202212	85423111	Semiconductor modules with converting function	32271375	Number of item	28691	Kilogram	93424034	2026-07-26 08:49:34.890893
202301	85423111	Semiconductor modules with converting function	24147371	Number of item	19780	Kilogram	90035095	2026-07-26 08:49:34.890893
202302	85423111	Semiconductor modules with converting function	25170461	Number of item	24824	Kilogram	92749341	2026-07-26 08:49:34.890893
202303	85423111	Semiconductor modules with converting function	24111960	Number of item	33439	Kilogram	101622074	2026-07-26 08:49:34.890893
202304	85423111	Semiconductor modules with converting function	26065938	Number of item	22216	Kilogram	94385294	2026-07-26 08:49:34.890893
202305	85423111	Semiconductor modules with converting function	27496577	Number of item	23942	Kilogram	75141745	2026-07-26 08:49:34.890893
202306	85423111	Semiconductor modules with converting function	24724704	Number of item	24870	Kilogram	72645426	2026-07-26 08:49:34.890893
202307	85423111	Semiconductor modules with converting function	25048126	Number of item	20619	Kilogram	79622408	2026-07-26 08:49:34.890893
202308	85423111	Semiconductor modules with converting function	25604435	Number of item	24047	Kilogram	89618955	2026-07-26 08:49:34.890893
202309	85423111	Semiconductor modules with converting function	27215328	Number of item	18990	Kilogram	58134451	2026-07-26 08:49:34.890893
202310	85423111	Semiconductor modules with converting function	27810321	Number of item	18027	Kilogram	65542005	2026-07-26 08:49:34.890893
202311	85423111	Semiconductor modules with converting function	24238841	Number of item	21195	Kilogram	71725586	2026-07-26 08:49:34.890893
202312	85423111	Semiconductor modules with converting function	25990213	Number of item	20883	Kilogram	76878689	2026-07-26 08:49:34.890893
202401	85423111	Semiconductor modules with converting function	30946662	Number of item	22374	Kilogram	78228979	2026-07-26 08:49:34.890893
202402	85423111	Semiconductor modules with converting function	18666126	Number of item	16950	Kilogram	49929894	2026-07-26 08:49:34.890893
202403	85423111	Semiconductor modules with converting function	21903145	Number of item	16307	Kilogram	80425646	2026-07-26 08:49:34.890893
202404	85423111	Semiconductor modules with converting function	24012959	Number of item	27850	Kilogram	75488463	2026-07-26 08:49:34.890893
202405	85423111	Semiconductor modules with converting function	21474498	Number of item	22464	Kilogram	69462138	2026-07-26 08:49:34.890893
202406	85423111	Semiconductor modules with converting function	19065136	Number of item	17422	Kilogram	71586641	2026-07-26 08:49:34.890893
202407	85423111	Semiconductor modules with converting function	26749528	Number of item	25738	Kilogram	89784832	2026-07-26 08:49:34.890893
202408	85423111	Semiconductor modules with converting function	23916240	Number of item	25395	Kilogram	64680577	2026-07-26 08:49:34.890893
202409	85423111	Semiconductor modules with converting function	23241789	Number of item	22551	Kilogram	60603391	2026-07-26 08:49:34.890893
202410	85423111	Semiconductor modules with converting function	21691608	Number of item	27371	Kilogram	76064586	2026-07-26 08:49:34.890893
202411	85423111	Semiconductor modules with converting function	22952739	Number of item	25507	Kilogram	68879637	2026-07-26 08:49:34.890893
202412	85423111	Semiconductor modules with converting function	23069915	Number of item	26245	Kilogram	80979976	2026-07-26 08:49:34.890893
202501	85423111	Semiconductor modules with converting function	25137469	Number of item	19965	Kilogram	59719079	2026-07-26 08:49:34.890893
202502	85423111	Semiconductor modules with converting function	18039262	Number of item	18445	Kilogram	36450179	2026-07-26 08:49:34.890893
202503	85423111	Semiconductor modules with converting function	21528818	Number of item	27367	Kilogram	44412587	2026-07-26 08:49:34.890893
202504	85423111	Semiconductor modules with converting function	24235423	Number of item	24543	Kilogram	93213467	2026-07-26 08:49:34.890893
202505	85423111	Semiconductor modules with converting function	21038637	Number of item	15214	Kilogram	50585759	2026-07-26 08:49:34.890893
202506	85423111	Semiconductor modules with converting function	21152078	Number of item	19072	Kilogram	51479169	2026-07-26 08:49:34.890893
202507	85423111	Semiconductor modules with converting function	20992801	Number of item	16075	Kilogram	37594780	2026-07-26 08:49:34.890893
202508	85423111	Semiconductor modules with converting function	18971654	Number of item	12853	Kilogram	17273257	2026-07-26 08:49:34.890893
202509	85423111	Semiconductor modules with converting function	19587299	Number of item	18268	Kilogram	22327688	2026-07-26 08:49:34.890893
202510	85423111	Semiconductor modules with converting function	17292662	Number of item	12120	Kilogram	15778401	2026-07-26 08:49:34.890893
202511	85423111	Semiconductor modules with converting function	16737184	Number of item	15547	Kilogram	14908523	2026-07-26 08:49:34.890893
202512	85423111	Semiconductor modules with converting function	16537113	Number of item	23567	Kilogram	19013707	2026-07-26 08:49:34.890893
202601	85423111	Semiconductor modules with converting function	18701314	Number of item	23810	Kilogram	19039851	2026-07-26 08:49:34.890893
202602	85423111	Semiconductor modules with converting function	20175190	Number of item	27608	Kilogram	18902398	2026-07-26 08:49:34.890893
202603	85423111	Semiconductor modules with converting function	20423777	Number of item	28990	Kilogram	20013621	2026-07-26 08:49:34.890893
202604	85423111	Semiconductor modules with converting function	22192184	Number of item	26211	Kilogram	22252868	2026-07-26 08:49:34.890893
202605	85423111	Semiconductor modules with converting function	19705529	Number of item	24533	Kilogram	21819244	2026-07-26 08:49:34.890893
202606	85423111	Semiconductor modules with converting function	22912460	Number of item	30072	Kilogram	26801586	2026-07-26 08:49:34.890893
202101	85423210	Multi-component integrated circuits, as memories	50230509	Number of item	19815	Kilogram	199702136	2026-07-26 08:49:34.890893
202102	85423210	Multi-component integrated circuits, as memories	28506985	Number of item	11264	Kilogram	137483430	2026-07-26 08:49:34.890893
202103	85423210	Multi-component integrated circuits, as memories	46652912	Number of item	19523	Kilogram	186325537	2026-07-26 08:49:34.890893
202104	85423210	Multi-component integrated circuits, as memories	50353468	Number of item	20084	Kilogram	216048009	2026-07-26 08:49:34.890893
202105	85423210	Multi-component integrated circuits, as memories	44077066	Number of item	19906	Kilogram	181139985	2026-07-26 08:49:34.890893
202106	85423210	Multi-component integrated circuits, as memories	55243414	Number of item	24170	Kilogram	237614680	2026-07-26 08:49:34.890893
202107	85423210	Multi-component integrated circuits, as memories	74052375	Number of item	25569	Kilogram	259841114	2026-07-26 08:49:34.890893
202108	85423210	Multi-component integrated circuits, as memories	69537321	Number of item	25309	Kilogram	296155696	2026-07-26 08:49:34.890893
202109	85423210	Multi-component integrated circuits, as memories	68028403	Number of item	22388	Kilogram	257766745	2026-07-26 08:49:34.890893
202110	85423210	Multi-component integrated circuits, as memories	60049007	Number of item	17368	Kilogram	265605132	2026-07-26 08:49:34.890893
202111	85423210	Multi-component integrated circuits, as memories	58193892	Number of item	22017	Kilogram	285443175	2026-07-26 08:49:34.890893
202112	85423210	Multi-component integrated circuits, as memories	69996903	Number of item	19974	Kilogram	527732061	2026-07-26 08:49:34.890893
202201	85423210	Multi-component integrated circuits, as memories	68890521	Number of item	21171	Kilogram	513805059	2026-07-26 08:49:34.890893
202202	85423210	Multi-component integrated circuits, as memories	52096977	Number of item	13534	Kilogram	215183054	2026-07-26 08:49:34.890893
202203	85423210	Multi-component integrated circuits, as memories	65184677	Number of item	19896	Kilogram	448677640	2026-07-26 08:49:34.890893
202204	85423210	Multi-component integrated circuits, as memories	51511310	Number of item	20333	Kilogram	263621423	2026-07-26 08:49:34.890893
202205	85423210	Multi-component integrated circuits, as memories	47656904	Number of item	21717	Kilogram	298695457	2026-07-26 08:49:34.890893
202206	85423210	Multi-component integrated circuits, as memories	47913860	Number of item	19437	Kilogram	229586819	2026-07-26 08:49:34.890893
202207	85423210	Multi-component integrated circuits, as memories	52505318	Number of item	19579	Kilogram	205003780	2026-07-26 08:49:34.890893
202208	85423210	Multi-component integrated circuits, as memories	61976474	Number of item	21619	Kilogram	379915227	2026-07-26 08:49:34.890893
202209	85423210	Multi-component integrated circuits, as memories	60684653	Number of item	25609	Kilogram	269632724	2026-07-26 08:49:34.890893
202210	85423210	Multi-component integrated circuits, as memories	52491039	Number of item	20137	Kilogram	190792651	2026-07-26 08:49:34.890893
202211	85423210	Multi-component integrated circuits, as memories	56023625	Number of item	21826	Kilogram	234503893	2026-07-26 08:49:34.890893
202212	85423210	Multi-component integrated circuits, as memories	65107080	Number of item	23874	Kilogram	264474097	2026-07-26 08:49:34.890893
202301	85423210	Multi-component integrated circuits, as memories	35216080	Number of item	12634	Kilogram	116781962	2026-07-26 08:49:34.890893
202302	85423210	Multi-component integrated circuits, as memories	40812301	Number of item	18768	Kilogram	190439144	2026-07-26 08:49:34.890893
202303	85423210	Multi-component integrated circuits, as memories	54190398	Number of item	20067	Kilogram	234602490	2026-07-26 08:49:34.890893
202304	85423210	Multi-component integrated circuits, as memories	55355326	Number of item	25091	Kilogram	312236750	2026-07-26 08:49:34.890893
202305	85423210	Multi-component integrated circuits, as memories	55214231	Number of item	24287	Kilogram	291802984	2026-07-26 08:49:34.890893
202306	85423210	Multi-component integrated circuits, as memories	72757942	Number of item	33342	Kilogram	343334821	2026-07-26 08:49:34.890893
202307	85423210	Multi-component integrated circuits, as memories	59220725	Number of item	23808	Kilogram	217129489	2026-07-26 08:49:34.890893
202308	85423210	Multi-component integrated circuits, as memories	81077783	Number of item	32761	Kilogram	328477246	2026-07-26 08:49:34.890893
202309	85423210	Multi-component integrated circuits, as memories	86591240	Number of item	36031	Kilogram	417446377	2026-07-26 08:49:34.890893
202310	85423210	Multi-component integrated circuits, as memories	69627610	Number of item	26395	Kilogram	300893956	2026-07-26 08:49:34.890893
202311	85423210	Multi-component integrated circuits, as memories	80328751	Number of item	30778	Kilogram	513078546	2026-07-26 08:49:34.890893
202312	85423210	Multi-component integrated circuits, as memories	92024573	Number of item	33949	Kilogram	590512092	2026-07-26 08:49:34.890893
202401	85423210	Multi-component integrated circuits, as memories	67670562	Number of item	23741	Kilogram	364100786	2026-07-26 08:49:34.890893
202402	85423210	Multi-component integrated circuits, as memories	56967709	Number of item	19142	Kilogram	499260307	2026-07-26 08:49:34.890893
202403	85423210	Multi-component integrated circuits, as memories	74261854	Number of item	32844	Kilogram	584761556	2026-07-26 08:49:34.890893
202404	85423210	Multi-component integrated circuits, as memories	87331888	Number of item	30703	Kilogram	655903163	2026-07-26 08:49:34.890893
202405	85423210	Multi-component integrated circuits, as memories	60759324	Number of item	25159	Kilogram	600482469	2026-07-26 08:49:34.890893
202406	85423210	Multi-component integrated circuits, as memories	75061612	Number of item	24904	Kilogram	783737629	2026-07-26 08:49:34.890893
202407	85423210	Multi-component integrated circuits, as memories	74687202	Number of item	23655	Kilogram	556778906	2026-07-26 08:49:34.890893
202408	85423210	Multi-component integrated circuits, as memories	67653564	Number of item	23161	Kilogram	702296492	2026-07-26 08:49:34.890893
202409	85423210	Multi-component integrated circuits, as memories	73148754	Number of item	23868	Kilogram	698723829	2026-07-26 08:49:34.890893
202410	85423210	Multi-component integrated circuits, as memories	56800987	Number of item	21611	Kilogram	502902853	2026-07-26 08:49:34.890893
202411	85423210	Multi-component integrated circuits, as memories	65898553	Number of item	23355	Kilogram	555217396	2026-07-26 08:49:34.890893
202412	85423210	Multi-component integrated circuits, as memories	75721426	Number of item	27406	Kilogram	627344335	2026-07-26 08:49:34.890893
202501	85423210	Multi-component integrated circuits, as memories	67511335	Number of item	23258	Kilogram	582924037	2026-07-26 08:49:34.890893
202502	85423210	Multi-component integrated circuits, as memories	53927903	Number of item	18116	Kilogram	316357132	2026-07-26 08:49:34.890893
202503	85423210	Multi-component integrated circuits, as memories	76995975	Number of item	27733	Kilogram	628751011	2026-07-26 08:49:34.890893
202504	85423210	Multi-component integrated circuits, as memories	79652894	Number of item	23329	Kilogram	500189744	2026-07-26 08:49:34.890893
202505	85423210	Multi-component integrated circuits, as memories	63635372	Number of item	20974	Kilogram	453166646	2026-07-26 08:49:34.890893
202506	85423210	Multi-component integrated circuits, as memories	81303647	Number of item	22972	Kilogram	567907218	2026-07-26 08:49:34.890893
202507	85423210	Multi-component integrated circuits, as memories	87030772	Number of item	24666	Kilogram	549551897	2026-07-26 08:49:34.890893
202508	85423210	Multi-component integrated circuits, as memories	94099055	Number of item	24923	Kilogram	642460485	2026-07-26 08:49:34.890893
202509	85423210	Multi-component integrated circuits, as memories	88839014	Number of item	31707	Kilogram	690911610	2026-07-26 08:49:34.890893
202510	85423210	Multi-component integrated circuits, as memories	84637702	Number of item	24713	Kilogram	624259008	2026-07-26 08:49:34.890893
202511	85423210	Multi-component integrated circuits, as memories	72663159	Number of item	19976	Kilogram	682689769	2026-07-26 08:49:34.890893
202512	85423210	Multi-component integrated circuits, as memories	82910727	Number of item	26820	Kilogram	714426104	2026-07-26 08:49:34.890893
202601	85423210	Multi-component integrated circuits, as memories	64374375	Number of item	19837	Kilogram	796021221	2026-07-26 08:49:34.890893
202602	85423210	Multi-component integrated circuits, as memories	67022037	Number of item	18875	Kilogram	901851428	2026-07-26 08:49:34.890893
202603	85423210	Multi-component integrated circuits, as memories	76662220	Number of item	23455	Kilogram	1427597135	2026-07-26 08:49:34.890893
202604	85423210	Multi-component integrated circuits, as memories	74683637	Number of item	24893	Kilogram	1177275977	2026-07-26 08:49:34.890893
202605	85423210	Multi-component integrated circuits, as memories	60112462	Number of item	19776	Kilogram	1403047120	2026-07-26 08:49:34.890893
202606	85423210	Multi-component integrated circuits, as memories	56911017	Number of item	17378	Kilogram	1408639136	2026-07-26 08:49:34.890893
202101	85423290	Other integrated circuits, as memories	3789955652	Number of item	826228	Kilogram	8000025307	2026-07-26 08:49:34.890893
202102	85423290	Other integrated circuits, as memories	3051056944	Number of item	649169	Kilogram	7342084369	2026-07-26 08:49:34.890893
202103	85423290	Other integrated circuits, as memories	3852142896	Number of item	925346	Kilogram	9142761868	2026-07-26 08:49:34.890893
202104	85423290	Other integrated circuits, as memories	3799659072	Number of item	848028	Kilogram	8842865603	2026-07-26 08:49:34.890893
202105	85423290	Other integrated circuits, as memories	3716821723	Number of item	833507	Kilogram	9176912502	2026-07-26 08:49:34.890893
202106	85423290	Other integrated circuits, as memories	3865635043	Number of item	834825	Kilogram	10177183730	2026-07-26 08:49:34.890893
202107	85423290	Other integrated circuits, as memories	3803442134	Number of item	818830	Kilogram	10090847343	2026-07-26 08:49:34.890893
202108	85423290	Other integrated circuits, as memories	4346998093	Number of item	819377	Kilogram	11101213275	2026-07-26 08:49:34.890893
202109	85423290	Other integrated circuits, as memories	3750950992	Number of item	762446	Kilogram	10945189316	2026-07-26 08:49:34.890893
202110	85423290	Other integrated circuits, as memories	3568504799	Number of item	701848	Kilogram	10182167631	2026-07-26 08:49:34.890893
202111	85423290	Other integrated circuits, as memories	3598128992	Number of item	815016	Kilogram	11642900810	2026-07-26 08:49:34.890893
202112	85423290	Other integrated circuits, as memories	4081179291	Number of item	805771	Kilogram	12000566601	2026-07-26 08:49:34.890893
202201	85423290	Other integrated circuits, as memories	3510629036	Number of item	785250	Kilogram	10097332084	2026-07-26 08:49:34.890893
202202	85423290	Other integrated circuits, as memories	2762538690	Number of item	615880	Kilogram	7437783729	2026-07-26 08:49:34.890893
202203	85423290	Other integrated circuits, as memories	3727766424	Number of item	846251	Kilogram	9144864155	2026-07-26 08:49:34.890893
202204	85423290	Other integrated circuits, as memories	3092366412	Number of item	737145	Kilogram	7747167549	2026-07-26 08:49:34.890893
202205	85423290	Other integrated circuits, as memories	3352998835	Number of item	669327	Kilogram	7828461726	2026-07-26 08:49:34.890893
202206	85423290	Other integrated circuits, as memories	3452606101	Number of item	702286	Kilogram	9057512107	2026-07-26 08:49:34.890893
202207	85423290	Other integrated circuits, as memories	3341304972	Number of item	701086	Kilogram	8573265081	2026-07-26 08:49:34.890893
202208	85423290	Other integrated circuits, as memories	3280214887	Number of item	635980	Kilogram	7460968237	2026-07-26 08:49:34.890893
202209	85423290	Other integrated circuits, as memories	3600895868	Number of item	723482	Kilogram	9032436704	2026-07-26 08:49:34.890893
202210	85423290	Other integrated circuits, as memories	3101893614	Number of item	599243	Kilogram	6836155016	2026-07-26 08:49:34.890893
202211	85423290	Other integrated circuits, as memories	3385070093	Number of item	632977	Kilogram	6300928862	2026-07-26 08:49:34.890893
202212	85423290	Other integrated circuits, as memories	3983796078	Number of item	726196	Kilogram	7432852197	2026-07-26 08:49:34.890893
202301	85423290	Other integrated circuits, as memories	2536130285	Number of item	427116	Kilogram	4804917452	2026-07-26 08:49:34.890893
202302	85423290	Other integrated circuits, as memories	3231916156	Number of item	545556	Kilogram	5481106185	2026-07-26 08:49:34.890893
202303	85423290	Other integrated circuits, as memories	3851285975	Number of item	678219	Kilogram	6233532459	2026-07-26 08:49:34.890893
202304	85423290	Other integrated circuits, as memories	3756479897	Number of item	637224	Kilogram	6080478389	2026-07-26 08:49:34.890893
202305	85423290	Other integrated circuits, as memories	3475375208	Number of item	655764	Kilogram	5799152229	2026-07-26 08:49:34.890893
202306	85423290	Other integrated circuits, as memories	3989299632	Number of item	733006	Kilogram	6887540564	2026-07-26 08:49:34.890893
202307	85423290	Other integrated circuits, as memories	3534849036	Number of item	683018	Kilogram	6103810046	2026-07-26 08:49:34.890893
202308	85423290	Other integrated circuits, as memories	3499178711	Number of item	707595	Kilogram	5978176889	2026-07-26 08:49:34.890893
202309	85423290	Other integrated circuits, as memories	3819327189	Number of item	759732	Kilogram	7360606066	2026-07-26 08:49:34.890893
202310	85423290	Other integrated circuits, as memories	3655360986	Number of item	679965	Kilogram	5935797376	2026-07-26 08:49:34.890893
202311	85423290	Other integrated circuits, as memories	3339462635	Number of item	743812	Kilogram	6706876145	2026-07-26 08:49:34.890893
202312	85423290	Other integrated circuits, as memories	3846132334	Number of item	845634	Kilogram	7609773507	2026-07-26 08:49:34.890893
202401	85423290	Other integrated circuits, as memories	3657624921	Number of item	751751	Kilogram	6567141360	2026-07-26 08:49:34.890893
202402	85423290	Other integrated circuits, as memories	2725797141	Number of item	622669	Kilogram	6433341520	2026-07-26 08:49:34.890893
202403	85423290	Other integrated circuits, as memories	3623643584	Number of item	729026	Kilogram	8127250848	2026-07-26 08:49:34.890893
202404	85423290	Other integrated circuits, as memories	3521196450	Number of item	707124	Kilogram	7209359007	2026-07-26 08:49:34.890893
202405	85423290	Other integrated circuits, as memories	3602934450	Number of item	679453	Kilogram	7627318052	2026-07-26 08:49:34.890893
202406	85423290	Other integrated circuits, as memories	3826010333	Number of item	635093	Kilogram	7424730237	2026-07-26 08:49:34.890893
202407	85423290	Other integrated circuits, as memories	3448240307	Number of item	616980	Kilogram	7615977111	2026-07-26 08:49:34.890893
202408	85423290	Other integrated circuits, as memories	3490794799	Number of item	616753	Kilogram	6756095110	2026-07-26 08:49:34.890893
202409	85423290	Other integrated circuits, as memories	3980922839	Number of item	636733	Kilogram	6983914790	2026-07-26 08:49:34.890893
202410	85423290	Other integrated circuits, as memories	3012987252	Number of item	622940	Kilogram	7019389272	2026-07-26 08:49:34.890893
202411	85423290	Other integrated circuits, as memories	3557522250	Number of item	628962	Kilogram	6765942469	2026-07-26 08:49:34.890893
202412	85423290	Other integrated circuits, as memories	4005380673	Number of item	659634	Kilogram	7565510111	2026-07-26 08:49:34.890893
202501	85423290	Other integrated circuits, as memories	3366526206	Number of item	591270	Kilogram	6281587322	2026-07-26 08:49:34.890893
202502	85423290	Other integrated circuits, as memories	2611771076	Number of item	507257	Kilogram	5386708104	2026-07-26 08:49:34.890893
202503	85423290	Other integrated circuits, as memories	4342238359	Number of item	687676	Kilogram	7187169631	2026-07-26 08:49:34.890893
202504	85423290	Other integrated circuits, as memories	4055726097	Number of item	808980	Kilogram	8044074891	2026-07-26 08:49:34.890893
202505	85423290	Other integrated circuits, as memories	3957030444	Number of item	776512	Kilogram	8371504080	2026-07-26 08:49:34.890893
202506	85423290	Other integrated circuits, as memories	4156738020	Number of item	774229	Kilogram	8624800489	2026-07-26 08:49:34.890893
202507	85423290	Other integrated circuits, as memories	4513067293	Number of item	817210	Kilogram	9487685144	2026-07-26 08:49:34.890893
202508	85423290	Other integrated circuits, as memories	4955159628	Number of item	776001	Kilogram	9245568619	2026-07-26 08:49:34.890893
202509	85423290	Other integrated circuits, as memories	5733950811	Number of item	822610	Kilogram	9740635552	2026-07-26 08:49:34.890893
202510	85423290	Other integrated circuits, as memories	4716304189	Number of item	778954	Kilogram	9795497571	2026-07-26 08:49:34.890893
202511	85423290	Other integrated circuits, as memories	4550399313	Number of item	809816	Kilogram	11189714738	2026-07-26 08:49:34.890893
202512	85423290	Other integrated circuits, as memories	5047824948	Number of item	827334	Kilogram	13290497381	2026-07-26 08:49:34.890893
202601	85423290	Other integrated circuits, as memories	4934632880	Number of item	802982	Kilogram	14920915234	2026-07-26 08:49:34.890893
202602	85423290	Other integrated circuits, as memories	3912195026	Number of item	616484	Kilogram	15706990242	2026-07-26 08:49:34.890893
202603	85423290	Other integrated circuits, as memories	5608078671	Number of item	748307	Kilogram	21895780919	2026-07-26 08:49:34.890893
202604	85423290	Other integrated circuits, as memories	5698816248	Number of item	805188	Kilogram	25616672585	2026-07-26 08:49:34.890893
202605	85423290	Other integrated circuits, as memories	5518996234	Number of item	701959	Kilogram	29364777946	2026-07-26 08:49:34.890893
202606	85423290	Other integrated circuits, as memories	4945438477	Number of item	714370	Kilogram	30631462538	2026-07-26 08:49:34.890893
\.


--
-- Data for Name: subscriber_api_keys; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.subscriber_api_keys (id, api_key, customer_name, customer_email, created_at, expires_at, is_active, max_requests_daily, notes, customer_id) FROM stdin;
1	SUB-vXWstiF0EWNIl3ZErRka_8M-fZA1lPABHUPqti7Tw2RXuL26	Demo Client	client@example.com	2026-07-28 16:18:37.239716	2027-07-28 00:00:00	t	1000	\N	\N
\.


--
-- Data for Name: x402_consumed_invoices; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.x402_consumed_invoices (id, invoice_id, nonce, tx_hash, consumed_at) FROM stdin;
\.


--
-- Data for Name: x402_invoices; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.x402_invoices (invoice_id, resource_path, query_params, amount_usdc, recipient_wallet, chain_id, created_at, expires_at, status) FROM stdin;
\.


--
-- Data for Name: x402_payment_audit; Type: TABLE DATA; Schema: public; Owner: trade_app
--

COPY public.x402_payment_audit (id, request_path, payment_header, settle_tx_hash, network_caip2, asset_contract, amount_atomic, wallet_payto, verify_success, settle_success, settle_error, created_at) FROM stdin;
1	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-05 22:32:35.476864+08
2	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-05 22:36:53.665128+08
3	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-05 22:46:36.804901+08
4	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-05 22:49:52.515242+08
5	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 20:53:59.533136+08
6	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 21:29:40.176156+08
7	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 21:30:45.250983+08
8	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 21:56:20.652644+08
9	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 22:01:24.327388+08
10	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 22:04:49.244902+08
11	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 22:13:58.626625+08
12	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 22:24:51.119025+08
13	http://127.0.0.1:8000/ai-trade/monthly?month=202101	invalidrandomstring	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-06 23:22:55.330594+08
14	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6MiwicGF5bG9hZCI6eyJhdXRob3JpemF0aW9uIjp7ImZyb20iOiIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCJ0byI6IjB4MTk2ZjVBNzkwYjQxNDJEMDZkNDRhMUFEZEYwYjY2RGQzNDZBNTZkYiIsInZhbHVlIjoiMTAwMCIsInZhbGlkQWZ0ZXIiOiIwIiwidmFsaWRCZWZvcmUiOiIxNzg2Mjg3NzcxIiwibm9uY2UiOiIweDUwZTVjYjc2YzZmNDU0YTUyNTUwMmFlMWFkNTlmOWI0ZWY2ZDljM2MzN2ZmYWM5ODMxM2MzMDI2Mjg3NDdhMzUifSwic2lnbmF0dXJlIjoiMHgyMmZiYjdkY2FmOWUyMzA5ZmVkNzk4MGJmMmVhZmQ2MDg3MWZlYWU4NzU2YjRjZTNiOGRkZDU3ZjcyNmEyM2E0MWEyODk0N2QzYjE2ZWQ0NzZlNDRiZGVkOWQyOTgxYjhlZGFhZTkwNzA4Njk4NTI4ZjFhMGI5YzE3ZmQxZTc5ZTFjIn0sImFjY2VwdGVkIjp7InNjaGVtZSI6ImV4YWN0IiwibmV0d29yayI6ImVpcDE1NTo4NDUzMiIsImFzc2V0IjoiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwiYW1vdW50IjoiMTAwMCIsInBheVRvIjoiMHgxOTZmNUE3OTBiNDE0MkQwNmQ0NGExQURkRjBiNjZEZDM0NkE1NmRiIiwibWF4VGltZW91dFNlY29uZHMiOjYwLCJleHRyYSI6eyJuYW1lIjoiVVNEQyIsInZlcnNpb24iOiIyIn19LCJyZXNvdXJjZSI6eyJ1cmwiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYWktdHJhZGUvbW9udGhseT9tb250aD0yMDIxMDEiLCJkZXNjcmlwdGlvbiI6IkFJIGhhcmR3YXJlIGN1c3RvbXMgdHJhZGUgZGF0YSwgcGF5LXBlci1jYWxsIHZpYSB4NDAyIiwibWltZVR5cGUiOiJhcHBsaWNhdGlvbi9qc29uIn19	0x6f6d7b5d00e41cd90273d2620980792dfd57d3a520a59826d9ab34c0102be288	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	t	t	\N	2026-08-09 23:01:54.616841+08
15	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6MiwicGF5bG9hZCI6eyJhdXRob3JpemF0aW9uIjp7ImZyb20iOiIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCJ0byI6IjB4MTk2ZjVBNzkwYjQxNDJEMDZkNDRhMUFEZEYwYjY2RGQzNDZBNTZkYiIsInZhbHVlIjoiMTAwMCIsInZhbGlkQWZ0ZXIiOiIwIiwidmFsaWRCZWZvcmUiOiIxNzg2MjkwMDM4Iiwibm9uY2UiOiIweDU2Y2E0MjQ5OGQ5MmYwZjliMzBmODAxZjM3N2EwOGUwM2JjNzBhNThhZThmZTlkOTUyY2QzNTUxM2ZlZjgxN2UifSwic2lnbmF0dXJlIjoiMHgxZTY1NWI5MGQ2NTUxM2IzYzRmYzdlZDcwNmI2OTMwMDg3OGJjZjY2ZDc2MjRhMTU3MzAxZWFiZTY3MzNkZGY5MTdhM2VmNTY3YWJmNmIyNTBkNWYxODcxNDI4ZGY0ZmY4MjdiMTBiNDk1ZTkyMzdkNDFiNzRhODIzOWIwYzM2NzFjIn0sImFjY2VwdGVkIjp7InNjaGVtZSI6ImV4YWN0IiwibmV0d29yayI6ImVpcDE1NTo4NDUzMiIsImFzc2V0IjoiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwiYW1vdW50IjoiMTAwMCIsInBheVRvIjoiMHgxOTZmNUE3OTBiNDE0MkQwNmQ0NGExQURkRjBiNjZEZDM0NkE1NmRiIiwibWF4VGltZW91dFNlY29uZHMiOjYwLCJleHRyYSI6eyJuYW1lIjoiVVNEQyIsInZlcnNpb24iOiIyIn19LCJyZXNvdXJjZSI6eyJ1cmwiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYWktdHJhZGUvbW9udGhseT9tb250aD0yMDIxMDEiLCJkZXNjcmlwdGlvbiI6IkFJIGhhcmR3YXJlIGN1c3RvbXMgdHJhZGUgZGF0YSwgcGF5LXBlci1jYWxsIHZpYSB4NDAyIiwibWltZVR5cGUiOiJhcHBsaWNhdGlvbi9qc29uIn19	0xb2486f051766301fa4b969a9f898f441513e893d8060430a974235c5173aaa99	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	t	t	\N	2026-08-09 23:39:40.541183+08
16	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6MiwicGF5bG9hZCI6eyJhdXRob3JpemF0aW9uIjp7ImZyb20iOiIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCJ0byI6IjB4MTk2ZjVBNzkwYjQxNDJEMDZkNDRhMUFEZEYwYjY2RGQzNDZBNTZkYiIsInZhbHVlIjoiMTAwMCIsInZhbGlkQWZ0ZXIiOiIwIiwidmFsaWRCZWZvcmUiOiIxNzg2MjkwMzMwIiwibm9uY2UiOiIweDRkOGU1YmJiY2RhNmJhZTMwNGU2ZDU2MzgwNDMxNmExZTg0NmE4NDc3OGYyNDkwMjQyNzA0YzJhZTMyMjQzOWQifSwic2lnbmF0dXJlIjoiMHg1ZDgxNTU1Nzc3MzU3YWIyMWQ4ZDRiZTE1MTA1OWQ5NDNkYzk2YTRkYjEwZWIwMWJjZDg1YmVhNGZlYjY1OWNkNDZmNWY1YzI2NTFhZjJjM2ZiOTQ1NTZhYmI3MmM0NTJmYjZkZGFhN2NjMThjYTk5ZDNkNDc3NjlmNjU1YTJhOTFiIn0sImFjY2VwdGVkIjp7InNjaGVtZSI6ImV4YWN0IiwibmV0d29yayI6ImVpcDE1NTo4NDUzMiIsImFzc2V0IjoiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwiYW1vdW50IjoiMTAwMCIsInBheVRvIjoiMHgxOTZmNUE3OTBiNDE0MkQwNmQ0NGExQURkRjBiNjZEZDM0NkE1NmRiIiwibWF4VGltZW91dFNlY29uZHMiOjYwLCJleHRyYSI6eyJuYW1lIjoiVVNEQyIsInZlcnNpb24iOiIyIn19LCJyZXNvdXJjZSI6eyJ1cmwiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYWktdHJhZGUvbW9udGhseT9tb250aD0yMDIxMDEiLCJkZXNjcmlwdGlvbiI6IkFJIGhhcmR3YXJlIGN1c3RvbXMgdHJhZGUgZGF0YSwgcGF54oCRcGVy4oCRY2FsbCB2aWEgeDQwMiIsIm1pbWVUeXBlIjoiYXBwbGljYXRpb24vanNvbiJ9fQ==	0x4d1e66278a308d61214214c53663d4195262591bf67429f4a5453c9fef79c8c3	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	t	t	\N	2026-08-09 23:44:34.410552+08
17	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6MiwicGF5bG9hZCI6eyJhdXRob3JpemF0aW9uIjp7ImZyb20iOiIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCJ0byI6IjB4MTk2ZjVBNzkwYjQxNDJEMDZkNDRhMUFEZEYwYjY2RGQzNDZBNTZkYiIsInZhbHVlIjoiMTAwMCIsInZhbGlkQWZ0ZXIiOiIwIiwidmFsaWRCZWZvcmUiOiIxNzg2MjkwNDg3Iiwibm9uY2UiOiIweDViZjhmNjU3ZDc1ZDZlNTdhYzUzMTU2Yzg4YTMxN2Y1NDQwMzgzNDE0NWYwZGEwY2Q2MmExYjdhNjg4NTQwYjQifSwic2lnbmF0dXJlIjoiMHhjOGQ0ZGFkYmJjZWY4YjM4ZDYzNDRjODZjMmEwOGJjODljOTkwMDIxMjhiMzg1MmQ2ZDJlNTkxN2EwMGIzMTI1MmU4ODlhODg5ZjJmMzJlMmI3ZjYwMTNkNzQyMWY1ODMzMWE0OTZkMDBmZmZkOTJhMmFhZmZmYjlmMWY3YWRlMTFiIn0sImFjY2VwdGVkIjp7InNjaGVtZSI6ImV4YWN0IiwibmV0d29yayI6ImVpcDE1NTo4NDUzMiIsImFzc2V0IjoiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwiYW1vdW50IjoiMTAwMCIsInBheVRvIjoiMHgxOTZmNUE3OTBiNDE0MkQwNmQ0NGExQURkRjBiNjZEZDM0NkE1NmRiIiwibWF4VGltZW91dFNlY29uZHMiOjYwLCJleHRyYSI6eyJuYW1lIjoiVVNEQyIsInZlcnNpb24iOiIyIn19LCJyZXNvdXJjZSI6eyJ1cmwiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYWktdHJhZGUvbW9udGhseT9tb250aD0yMDIxMDEiLCJkZXNjcmlwdGlvbiI6IkFJIGhhcmR3YXJlIGN1c3RvbXMgdHJhZGUgZGF0YSwgcGF5LXBlci1jYWxsIHZpYSB4NDAyIiwibWltZVR5cGUiOiJhcHBsaWNhdGlvbi9qc29uIn19	0x2779b27b2c07fe409be6d66a6c6e2ac1a0068c25795ad96e03ca3d100d7b004c	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	t	t	\N	2026-08-09 23:47:10.260605+08
18	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6IDIsICJwYXllciI6ICIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCAibmV0d29yayI6ICJlaXAxNTU6ODQ1MzIiLCAiYXNzZXQiOiAiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwgImFtb3VudCI6ICIxMDAwMDAwIiwgInRyYW5zYWN0aW9uIjogIjB4Mjc3OWIyN2IyYzA3ZmU0MDliZTZkNjZhNmM2ZTJhYzFhMDA2OGMyNTc5NWFkOTZlMDNjYTNkMTAwZDdiMDA0YyJ9	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	HTTPSConnectionPool(host='api.cdp.coinbase.com', port=443): Read timed out. (read timeout=12)	2026-08-09 23:48:47.024233+08
19	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6IDIsICJwYXllciI6ICIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCAibmV0d29yayI6ICJlaXAxNTU6ODQ1MzIiLCAiYXNzZXQiOiAiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwgImFtb3VudCI6ICIxMDAwMDAwIiwgInRyYW5zYWN0aW9uIjogIjB4Mjc3OWIyN2IyYzA3ZmU0MDliZTZkNjZhNmM2ZTJhYzFhMDA2OGMyNTc5NWFkOTZlMDNjYTNkMTAwZDdiMDA0YyJ9	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	HTTPSConnectionPool(host='api.cdp.coinbase.com', port=443): Max retries exceeded with url: /platform/v2/x402/verify (Caused by SSLError(SSLEOFError(8, '[SSL: UNEXPECTED_EOF_WHILE_READING] EOF occurred in violation of protocol (_ssl.c:1000)')))	2026-08-09 23:49:41.536815+08
20	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6IDIsICJwYXllciI6ICIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCAibmV0d29yayI6ICJlaXAxNTU6ODQ1MzIiLCAiYXNzZXQiOiAiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwgImFtb3VudCI6ICIxMDAwMDAwIiwgInRyYW5zYWN0aW9uIjogIjB4Mjc3OWIyN2IyYzA3ZmU0MDliZTZkNjZhNmM2ZTJhYzFhMDA2OGMyNTc5NWFkOTZlMDNjYTNkMTAwZDdiMDA0YyJ9	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-09 23:51:01.259672+08
21	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6IDIsICJwYXllciI6ICIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCAibmV0d29yayI6ICJlaXAxNTU6ODQ1MzIiLCAiYXNzZXQiOiAiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwgImFtb3VudCI6ICIxMDAwMDAwIiwgInRyYW5zYWN0aW9uIjogIjB4Mjc3OWIyN2IyYzA3ZmU0MDliZTZkNjZhNmM2ZTJhYzFhMDA2OGMyNTc5NWFkOTZlMDNjYTNkMTAwZDdiMDA0YyIsICJhY2NlcHRlZCI6IHsic2NoZW1lIjogImV4YWN0IiwgIm5ldHdvcmsiOiAiZWlwMTU1Ojg0NTMyIiwgImFzc2V0IjogIjB4MDM2Q2JENTM4NDJjNTQyNjYzNGU3OTI5NTQxZUMyMzE4ZjNkQ0Y3ZSIsICJhbW91bnQiOiAiMTAwMDAwMCIsICJwYXlUbyI6ICIweDE5NmY1eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eCJ9fQ==	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-09 23:53:16.528071+08
22	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6IDIsICJwYXllciI6ICIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCAibmV0d29yayI6ICJlaXAxNTU6ODQ1MzIiLCAiYXNzZXQiOiAiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwgImFtb3VudCI6ICIxMDAwMDAwIiwgInRyYW5zYWN0aW9uIjogIjB4Mjc3OWIyN2IyYzA3ZmU0MDliZTZkNjZhNmM2ZTJhYzFhMDA2OGMyNTc5NWFkOTZlMDNjYTNkMTAwZDdiMDA0YyIsICJhY2NlcHRlZCI6IHsic2NoZW1lIjogImV4YWN0IiwgIm5ldHdvcmsiOiAiZWlwMTU1Ojg0NTMyIiwgImFzc2V0IjogIjB4MDM2Q2JENTM4NDJjNTQyNjYzNGU3OTI5NTQxZUMyMzE4ZjNkQ0Y3ZSIsICJhbW91bnQiOiAiMTAwMDAwMCIsICJwYXlUbyI6ICIweDE5NmY1eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eCIsICJtYXhUaW1lb3V0U2Vjb25kcyI6IDYwfX0=	\N	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	f	f	\N	2026-08-10 00:00:56.574831+08
23	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6MiwicGF5bG9hZCI6eyJhdXRob3JpemF0aW9uIjp7ImZyb20iOiIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCJ0byI6IjB4MTk2ZjVBNzkwYjQxNDJEMDZkNDRhMUFEZEYwYjY2RGQzNDZBNTZkYiIsInZhbHVlIjoiMTAwMCIsInZhbGlkQWZ0ZXIiOiIwIiwidmFsaWRCZWZvcmUiOiIxNzg2MjkyMTE3Iiwibm9uY2UiOiIweDEyNWQxZTEwZDgzNWFlNDc4MTQwOWU1M2QzZGRkMzk5ODUxMTIwNDg0ZmEzMTAwMTA0ODNiZmJmOTlhNGYxMzIifSwic2lnbmF0dXJlIjoiMHgyZjZjNTI3NzQ1NGIyODk1YWRiZWYzMGMzNTY3Y2ZmZTFhZjJjMTcwNWEzYjIwOWY3ZjY1NGQ1NTVkZTAyNDM1MzIxODBlODQ5OGM1Mzg0NTMyNTc3YWViMWMxMGY1OGQ2ZTU3YWI4ZTRhZjE2N2U4N2I1N2I3ZmY4MzU3YjEyYjFiIn0sImFjY2VwdGVkIjp7InNjaGVtZSI6ImV4YWN0IiwibmV0d29yayI6ImVpcDE1NTo4NDUzMiIsImFzc2V0IjoiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwiYW1vdW50IjoiMTAwMCIsInBheVRvIjoiMHgxOTZmNUE3OTBiNDE0MkQwNmQ0NGExQURkRjBiNjZEZDM0NkE1NmRiIiwibWF4VGltZW91dFNlY29uZHMiOjYwLCJleHRyYSI6eyJuYW1lIjoiVVNEQyIsInZlcnNpb24iOiIyIn19LCJyZXNvdXJjZSI6eyJ1cmwiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYWktdHJhZGUvbW9udGhseT9tb250aD0yMDIxMDEiLCJkZXNjcmlwdGlvbiI6IkFJIGhhcmR3YXJlIGN1c3RvbXMgdHJhZGUgZGF0YSwgcGF5LXBlci1jYWxsIHZpYSB4NDAyIiwibWltZVR5cGUiOiJhcHBsaWNhdGlvbi9qc29uIn19	0x63c11caf964676121e1e2ecad57a5f0628ba45980693ca126693bf490c15ca8a	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	t	t	\N	2026-08-10 00:14:22.184018+08
24	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6MiwicGF5bG9hZCI6eyJhdXRob3JpemF0aW9uIjp7ImZyb20iOiIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCJ0byI6IjB4MTk2ZjVBNzkwYjQxNDJEMDZkNDRhMUFEZEYwYjY2RGQzNDZBNTZkYiIsInZhbHVlIjoiMTAwMCIsInZhbGlkQWZ0ZXIiOiIwIiwidmFsaWRCZWZvcmUiOiIxNzg2MjkyMjI0Iiwibm9uY2UiOiIweDg1ZTFkMDZjZGZiNTlkMDMyNDQ0YzEzZjU1NmIwZTkyYjYyNzZhZTc5OGM4ZjBhMTk2ODFjMzYyMWM3MzE3NjQifSwic2lnbmF0dXJlIjoiMHg1ODMxN2YyZWQzYjg0NjYxZWNjZWU4MTM4NmE0NmVlN2RiYWIyNzYxODMxMzJhZjc0OWZhMDE5ZmMzNThiMzQ1Njc2MzZjMmQ0NWEyZTkzNmM0OGE5OWEwZTI4NDQ3YzEwMzQ4YWVmNzEzZDg0MThjZmVmNjY3YmU0ZDQxN2VlMDFjIn0sImFjY2VwdGVkIjp7InNjaGVtZSI6ImV4YWN0IiwibmV0d29yayI6ImVpcDE1NTo4NDUzMiIsImFzc2V0IjoiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwiYW1vdW50IjoiMTAwMCIsInBheVRvIjoiMHgxOTZmNUE3OTBiNDE0MkQwNmQ0NGExQURkRjBiNjZEZDM0NkE1NmRiIiwibWF4VGltZW91dFNlY29uZHMiOjYwLCJleHRyYSI6eyJuYW1lIjoiVVNEQyIsInZlcnNpb24iOiIyIn19LCJyZXNvdXJjZSI6eyJ1cmwiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYWktdHJhZGUvbW9udGhseT9tb250aD0yMDIxMDEiLCJkZXNjcmlwdGlvbiI6IkFJIGhhcmR3YXJlIGN1c3RvbXMgdHJhZGUgZGF0YSwgcGF5LXBlci1jYWxsIHZpYSB4NDAyIiwibWltZVR5cGUiOiJhcHBsaWNhdGlvbi9qc29uIn19	0xec35bea34f40310fceba73a7fc8a81af6c41e2fd40e3a75e87098156c8411c49	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	t	t	\N	2026-08-10 00:16:08.238984+08
25	http://127.0.0.1:8000/ai-trade/monthly?month=202101	eyJ4NDAyVmVyc2lvbiI6MiwicGF5bG9hZCI6eyJhdXRob3JpemF0aW9uIjp7ImZyb20iOiIweDdCNUE1QUY3NmMyNDkwMDEwRDY4ZTRkMERkQjRmNUMxRkM3ZTczMDkiLCJ0byI6IjB4MTk2ZjVBNzkwYjQxNDJEMDZkNDRhMUFEZEYwYjY2RGQzNDZBNTZkYiIsInZhbHVlIjoiMTAwMCIsInZhbGlkQWZ0ZXIiOiIwIiwidmFsaWRCZWZvcmUiOiIxNzg2MzU4MDQ3Iiwibm9uY2UiOiIweGEwMzBlMTNjYWI4MDEwZGY0MGQ1NTI1NzMzYjRhNzMwYmMxNDI2YzFkY2U0YmZmMjg3MDVkZDFmYzJjMWY2ZjcifSwic2lnbmF0dXJlIjoiMHg4MDdmNGVhYjU0ZGRiOTUzNTVlMTIwMzg4MzY3ZWUxN2EwNDg5NzhmMjM0OGIyZmJiZDMyMzg1MWMxZDg1NjcyMjM2ZWI0YjA2MTMxNzNkMzMzZDc4MDJhODYyNTc2ZDNhNjgzMDAyZGRhMDAyOTdmMjYzYWZjNDRjZmMxZTdhZjFjIn0sImFjY2VwdGVkIjp7InNjaGVtZSI6ImV4YWN0IiwibmV0d29yayI6ImVpcDE1NTo4NDUzMiIsImFzc2V0IjoiMHgwMzZDYkQ1Mzg0MmM1NDI2NjM0ZTc5Mjk1NDFlQzIzMThmM2RDRjdlIiwiYW1vdW50IjoiMTAwMCIsInBheVRvIjoiMHgxOTZmNUE3OTBiNDE0MkQwNmQ0NGExQURkRjBiNjZEZDM0NkE1NmRiIiwibWF4VGltZW91dFNlY29uZHMiOjYwLCJleHRyYSI6eyJuYW1lIjoiVVNEQyIsInZlcnNpb24iOiIyIn19LCJyZXNvdXJjZSI6eyJ1cmwiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYWktdHJhZGUvbW9udGhseT9tb250aD0yMDIxMDEiLCJkZXNjcmlwdGlvbiI6IkFJIGhhcmR3YXJlIGN1c3RvbXMgdHJhZGUgZGF0YSwgcGF5LXBlci1jYWxsIHZpYSB4NDAyIiwibWltZVR5cGUiOiJhcHBsaWNhdGlvbi9qc29uIn19	0x220ff8b95c03778c49447255638861bc6ab74e62128bd63258fd94dc4e427211	eip155:84532	0x036CbD53842c5426634e7929541eC2318f3dCF7e	1000	0x196f5A790b4142D06d44a1ADdF0b66Dd346A56db	t	t	\N	2026-08-10 18:33:12.579755+08
\.


--
-- Name: api_access_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: trade_app
--

SELECT pg_catalog.setval('public.api_access_logs_id_seq', 1, false);


--
-- Name: llm_benchmarks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: trade_app
--

SELECT pg_catalog.setval('public.llm_benchmarks_id_seq', 1, false);


--
-- Name: llm_prices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: trade_app
--

SELECT pg_catalog.setval('public.llm_prices_id_seq', 2509, true);


--
-- Name: llm_probes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: trade_app
--

SELECT pg_catalog.setval('public.llm_probes_id_seq', 56, true);


--
-- Name: subscriber_api_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: trade_app
--

SELECT pg_catalog.setval('public.subscriber_api_keys_id_seq', 1, true);


--
-- Name: x402_consumed_invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: trade_app
--

SELECT pg_catalog.setval('public.x402_consumed_invoices_id_seq', 1, false);


--
-- Name: x402_payment_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: trade_app
--

SELECT pg_catalog.setval('public.x402_payment_audit_id_seq', 25, true);


--
-- Name: ai_customs_monthly ai_customs_monthly_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.ai_customs_monthly
    ADD CONSTRAINT ai_customs_monthly_pkey PRIMARY KEY (data_month);


--
-- Name: api_access_logs api_access_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.api_access_logs
    ADD CONSTRAINT api_access_logs_pkey PRIMARY KEY (id);


--
-- Name: llm_benchmarks llm_benchmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.llm_benchmarks
    ADD CONSTRAINT llm_benchmarks_pkey PRIMARY KEY (id);


--
-- Name: llm_models llm_models_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.llm_models
    ADD CONSTRAINT llm_models_pkey PRIMARY KEY (model_id);


--
-- Name: llm_prices llm_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.llm_prices
    ADD CONSTRAINT llm_prices_pkey PRIMARY KEY (id);


--
-- Name: llm_probes llm_probes_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.llm_probes
    ADD CONSTRAINT llm_probes_pkey PRIMARY KEY (id);


--
-- Name: raw_export_hs raw_export_hs_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.raw_export_hs
    ADD CONSTRAINT raw_export_hs_pkey PRIMARY KEY (data_month, hs_code);


--
-- Name: raw_import_hs raw_import_hs_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.raw_import_hs
    ADD CONSTRAINT raw_import_hs_pkey PRIMARY KEY (data_month, hs_code);


--
-- Name: subscriber_api_keys subscriber_api_keys_api_key_key; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.subscriber_api_keys
    ADD CONSTRAINT subscriber_api_keys_api_key_key UNIQUE (api_key);


--
-- Name: subscriber_api_keys subscriber_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.subscriber_api_keys
    ADD CONSTRAINT subscriber_api_keys_pkey PRIMARY KEY (id);


--
-- Name: x402_consumed_invoices x402_consumed_invoices_invoice_id_key; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.x402_consumed_invoices
    ADD CONSTRAINT x402_consumed_invoices_invoice_id_key UNIQUE (invoice_id);


--
-- Name: x402_consumed_invoices x402_consumed_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.x402_consumed_invoices
    ADD CONSTRAINT x402_consumed_invoices_pkey PRIMARY KEY (id);


--
-- Name: x402_invoices x402_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.x402_invoices
    ADD CONSTRAINT x402_invoices_pkey PRIMARY KEY (invoice_id);


--
-- Name: x402_payment_audit x402_payment_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.x402_payment_audit
    ADD CONSTRAINT x402_payment_audit_pkey PRIMARY KEY (id);


--
-- Name: idx_export_hs; Type: INDEX; Schema: public; Owner: trade_app
--

CREATE INDEX idx_export_hs ON public.raw_export_hs USING btree (hs_code);


--
-- Name: idx_export_month; Type: INDEX; Schema: public; Owner: trade_app
--

CREATE INDEX idx_export_month ON public.raw_export_hs USING btree (data_month);


--
-- Name: idx_import_hs; Type: INDEX; Schema: public; Owner: trade_app
--

CREATE INDEX idx_import_hs ON public.raw_import_hs USING btree (hs_code);


--
-- Name: idx_import_month; Type: INDEX; Schema: public; Owner: trade_app
--

CREATE INDEX idx_import_month ON public.raw_import_hs USING btree (data_month);


--
-- Name: idx_month_agg; Type: INDEX; Schema: public; Owner: trade_app
--

CREATE INDEX idx_month_agg ON public.ai_customs_monthly USING btree (data_month);


--
-- Name: idx_prices_model_time; Type: INDEX; Schema: public; Owner: trade_app
--

CREATE INDEX idx_prices_model_time ON public.llm_prices USING btree (model_id, recorded_at DESC);


--
-- Name: idx_probes_model_time; Type: INDEX; Schema: public; Owner: trade_app
--

CREATE INDEX idx_probes_model_time ON public.llm_probes USING btree (model_id, "timestamp" DESC);


--
-- Name: idx_probes_region; Type: INDEX; Schema: public; Owner: trade_app
--

CREATE INDEX idx_probes_region ON public.llm_probes USING btree (region);


--
-- Name: llm_benchmarks llm_benchmarks_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.llm_benchmarks
    ADD CONSTRAINT llm_benchmarks_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.llm_models(model_id) ON DELETE CASCADE;


--
-- Name: llm_prices llm_prices_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.llm_prices
    ADD CONSTRAINT llm_prices_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.llm_models(model_id) ON DELETE CASCADE;


--
-- Name: llm_probes llm_probes_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: trade_app
--

ALTER TABLE ONLY public.llm_probes
    ADD CONSTRAINT llm_probes_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.llm_models(model_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict UMxlHsVrmRxsw6aGYXuAIVPR42hzj2UMgemmIocaX4N8WY6PArE1Na2ePYDz0LH

