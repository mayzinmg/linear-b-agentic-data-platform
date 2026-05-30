CREATE OR REPLACE TABLE silver_damos_tokens AS
SELECT
    row_number() OVER () AS damos_token_record_id,

    trim(itemid) AS source_item_id,
    trim(lineid) AS line_id,
    trim(linenumber) AS line_number,

    trim(itemheading) AS tablet_id,
    upper(regexp_replace(trim(itemheading), '[^A-Za-z0-9]', '', 'g')) AS tablet_key,

    trim(collectionname) AS site_code,
    trim(itemseries) AS tablet_series,
    trim(itemsubseries) AS tablet_subseries,
    trim(itemtablenumber) AS tablet_number,

    trim(pwcontent) AS phrase_content,
    trim(wordcontent) AS word_content,
    trim(wordtype) AS word_type,
    trim(plcontentwithnumber) AS line_content_with_number,

    trim(chronology) AS chronology,
    trim(findarea) AS find_area,
    trim(writers) AS writers,

    DATE '2026-05-29' AS source_snapshot_date,
    'damos_search_snapshot' AS source_system,
    'DĀMOS search-result CSV snapshot' AS source_reference
FROM bronze_damos_search_tokens;