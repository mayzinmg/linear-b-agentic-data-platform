{{ config(materialized='table') }}

WITH insider_tablets AS (
    SELECT
        silver_record_id,
        tablet_id,
        upper(regexp_replace(trim(tablet_id), '[^A-Za-z0-9]', '', 'g')) AS tablet_key,
        site_code,
        tablet_series,
        transliterated_text,
        original_inscription
    FROM {{ ref('silver_linear_b_tablets') }}
),

damos_tablets AS (
    SELECT
        tablet_id AS damos_tablet_id,
        tablet_key,
        site_code AS damos_site_code,
        tablet_series AS damos_tablet_series,
        tablet_subseries AS damos_tablet_subseries,
        tablet_number AS damos_tablet_number,
        token_count,
        distinct_word_count,
        distinct_word_type_count,
        logogram_token_count,
        number_token_count,
        source_snapshot_date,
        source_system,
        source_reference
    FROM {{ ref('gold_damos_tablet_token_summary') }}
)

SELECT
    i.silver_record_id,
    i.tablet_id AS insider_tablet_id,
    i.tablet_key,
    i.site_code AS insider_site_code,
    i.tablet_series AS insider_tablet_series,
    i.transliterated_text,
    i.original_inscription,

    d.damos_tablet_id,
    d.damos_site_code,
    d.damos_tablet_series,
    d.damos_tablet_subseries,
    d.damos_tablet_number,

    COALESCE(d.token_count, 0) AS damos_token_count,
    COALESCE(d.distinct_word_count, 0) AS damos_distinct_word_count,
    COALESCE(d.distinct_word_type_count, 0) AS damos_distinct_word_type_count,
    COALESCE(d.logogram_token_count, 0) AS damos_logogram_token_count,
    COALESCE(d.number_token_count, 0) AS damos_number_token_count,

    d.source_snapshot_date,
    d.source_system,
    d.source_reference,

    CASE
        WHEN d.damos_tablet_id IS NOT NULL THEN 'matched'
        ELSE 'not_matched'
    END AS damos_match_status
FROM insider_tablets i
LEFT JOIN damos_tablets d
    ON i.tablet_key = d.tablet_key