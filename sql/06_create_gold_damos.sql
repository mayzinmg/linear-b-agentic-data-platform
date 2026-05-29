CREATE OR REPLACE TABLE gold_damos_tokens_by_word_type AS
SELECT
    word_type,
    COUNT(*) AS token_count
FROM silver_damos_tokens
GROUP BY word_type
ORDER BY token_count DESC;


CREATE OR REPLACE TABLE gold_damos_tokens_by_site AS
SELECT
    site_code,
    COUNT(*) AS token_count,
    COUNT(DISTINCT tablet_id) AS tablet_count
FROM silver_damos_tokens
GROUP BY site_code
ORDER BY token_count DESC;


CREATE OR REPLACE TABLE gold_damos_tokens_by_series AS
SELECT
    site_code,
    tablet_series,
    COUNT(*) AS token_count,
    COUNT(DISTINCT tablet_id) AS tablet_count
FROM silver_damos_tokens
GROUP BY site_code, tablet_series
ORDER BY site_code, token_count DESC;


CREATE OR REPLACE TABLE gold_damos_tablet_token_summary AS
SELECT
    tablet_id,
    tablet_key,
    site_code,
    tablet_series,
    tablet_subseries,
    tablet_number,

    COUNT(*) AS token_count,
    COUNT(DISTINCT word_content) AS distinct_word_count,
    COUNT(DISTINCT word_type) AS distinct_word_type_count,

    SUM(CASE 
        WHEN lower(coalesce(word_type, '')) LIKE '%logogram%' 
        THEN 1 ELSE 0 
    END) AS logogram_token_count,

    SUM(CASE 
        WHEN lower(coalesce(word_type, '')) LIKE '%number%' 
        THEN 1 ELSE 0 
    END) AS number_token_count,

    MAX(source_snapshot_date) AS source_snapshot_date,
    MAX(source_system) AS source_system,
    MAX(source_reference) AS source_reference
FROM silver_damos_tokens
GROUP BY
    tablet_id,
    tablet_key,
    site_code,
    tablet_series,
    tablet_subseries,
    tablet_number
ORDER BY token_count DESC;