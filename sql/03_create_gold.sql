CREATE OR REPLACE TABLE gold_tablets_by_site AS
SELECT
    site_code,
    COUNT(*) AS tablet_count
FROM silver_linear_b_tablets
GROUP BY site_code
ORDER BY tablet_count DESC;


CREATE OR REPLACE TABLE gold_tablets_by_series AS
SELECT
    tablet_series,
    COUNT(*) AS tablet_count
FROM silver_linear_b_tablets
GROUP BY tablet_series
ORDER BY tablet_count DESC;

CREATE OR REPLACE TABLE gold_site_series_summary AS
SELECT
    site_code,
    tablet_series,
    COUNT(*) AS tablet_count
FROM silver_linear_b_tablets
GROUP BY site_code, tablet_series
ORDER BY site_code, tablet_count DESC;


CREATE OR REPLACE TABLE gold_data_quality_summary AS
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN tablet_id IS NULL OR tablet_id = '' THEN 1 ELSE 0 END) AS missing_tablet_id,
    SUM(CASE WHEN site_code IS NULL OR site_code = '' THEN 1 ELSE 0 END) AS missing_site_code,
    SUM(CASE WHEN tablet_series IS NULL OR tablet_series = '' THEN 1 ELSE 0 END) AS missing_tablet_series,
    SUM(CASE WHEN transliterated_text IS NULL OR transliterated_text = '' THEN 1 ELSE 0 END) AS missing_transliterated_text,
    SUM(CASE WHEN original_inscription IS NULL OR original_inscription = '' THEN 1 ELSE 0 END) AS missing_original_inscription
FROM silver_linear_b_tablets;