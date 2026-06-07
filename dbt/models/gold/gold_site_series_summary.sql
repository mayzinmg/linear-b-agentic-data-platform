{{ config(materialized='table') }}

SELECT
    site_code,
    tablet_series,
    COUNT(*) AS tablet_count
FROM {{ ref('silver_linear_b_tablets') }}
GROUP BY site_code, tablet_series
ORDER BY site_code, tablet_count DESC