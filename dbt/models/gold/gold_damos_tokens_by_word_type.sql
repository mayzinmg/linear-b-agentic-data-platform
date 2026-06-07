{{ config(materialized='table') }}

SELECT
    word_type,
    COUNT(*) AS token_count
FROM {{ ref('silver_damos_tokens') }}
GROUP BY word_type
ORDER BY token_count DESC