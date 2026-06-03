{{ config(materialized='table') }}

SELECT
    site_code,
    COUNT(*) AS token_count,
    COUNT(DISTINCT tablet_id) AS tablet_count
FROM {{ ref('silver_damos_tokens') }}
GROUP BY site_code
ORDER BY token_count DESC