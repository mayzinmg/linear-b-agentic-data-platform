{{ config(materialized='table') }}

SELECT
    row_number() OVER () AS silver_record_id,
    *
FROM (
    SELECT DISTINCT
        trim(identifier) AS tablet_id,
        trim(location) AS site_code,
        trim(series) AS tablet_series,
        trim(inscription) AS transliterated_text,
        trim(original) AS original_inscription
    FROM {{ source('raw', 'bronze_linear_b_tablets') }}
) AS deduped