{{ config(materialized='table') }}

SELECT
    site_code,
    tablet_series,
    COUNT(*) AS token_count,
    COUNT(DISTINCT tablet_id) AS tablet_count
FROM {{ ref('silver_damos_tokens') }}
GROUP BY site_code, tablet_series
ORDER BY site_code, token_count DESC