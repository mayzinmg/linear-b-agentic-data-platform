CREATE OR REPLACE TABLE silver_duplicate_audit AS
SELECT 
    trim(identifier) AS tablet_id,
    trim(location) AS site_code,
    trim(series) AS tablet_series,
    trim(inscription) AS transliterated_text,
    trim(original) AS original_inscription,
    COUNT(*) AS duplicate_count
FROM bronze_linear_b_tablets
GROUP BY 
    trim(identifier),
    trim(location),
    trim(series),
    trim(inscription),
    trim(original)
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


CREATE OR REPLACE TABLE silver_linear_b_tablets AS
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
    FROM bronze_linear_b_tablets
) AS deduped;