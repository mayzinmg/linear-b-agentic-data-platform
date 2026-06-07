{{ config(materialized='table') }}

SELECT 
    trim(identifier) AS tablet_id,
    trim(location) AS site_code,
    trim(series) AS tablet_series,
    trim(inscription) AS transliterated_text,
    trim(original) AS original_inscription,
    COUNT(*) AS duplicate_count
FROM {{ source('raw', 'bronze_linear_b_tablets') }}
GROUP BY 
    trim(identifier),
    trim(location),
    trim(series),
    trim(inscription),
    trim(original)
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC