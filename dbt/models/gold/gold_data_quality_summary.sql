{{ config(materialized='table') }}

SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN tablet_id IS NULL OR tablet_id = '' THEN 1 ELSE 0 END) AS missing_tablet_id,
    SUM(CASE WHEN site_code IS NULL OR site_code = '' THEN 1 ELSE 0 END) AS missing_site_code,
    SUM(CASE WHEN tablet_series IS NULL OR tablet_series = '' THEN 1 ELSE 0 END) AS missing_tablet_series,
    SUM(CASE WHEN transliterated_text IS NULL OR transliterated_text = '' THEN 1 ELSE 0 END) AS missing_transliterated_text,
    SUM(CASE WHEN original_inscription IS NULL OR original_inscription = '' THEN 1 ELSE 0 END) AS missing_original_inscription
FROM {{ ref('silver_linear_b_tablets') }}