{{ config(materialized='table') }}

SELECT
    site_code,
    COUNT(*) AS tablet_count
FROM {{ ref('silver_linear_b_tablets') }}
GROUP BY site_code
ORDER BY tablet_count DESC