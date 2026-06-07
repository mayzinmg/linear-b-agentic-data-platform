{{ config(materialized='view') }}

SELECT
    COUNT(*) AS bronze_tablet_count
FROM bronze_linear_b_tablets