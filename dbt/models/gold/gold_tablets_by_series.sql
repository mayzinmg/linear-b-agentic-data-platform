{{ config(materialized='table') }}

SELECT
    tablet_series,
    COUNT(*) AS tablet_count
FROM {{ ref('silver_linear_b_tablets') }}
GROUP BY tablet_series
ORDER BY tablet_count DESC