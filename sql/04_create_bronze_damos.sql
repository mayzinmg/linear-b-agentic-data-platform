CREATE OR REPLACE TABLE bronze_damos_search_tokens AS
SELECT *
FROM read_csv_auto(
    'data/raw/damos/snapshots/damos_snapshot_2026-05-29.csv',
    header = true,
    all_varchar = true,
    ignore_errors = true
);