# Linear B Agentic Data Platform

An experimental data engineering and agentic AI project for transforming Linear B tablet records into structured, queryable, and explainable research data.

## Project Goal

This project explores how Linear B tablet records can be modeled as structured data. The first stage focuses on understanding tablet metadata, content data, and analytical fields. Later stages will include data ingestion, transformation, analysis, and an agentic AI interpretation layer.

## Project Roadmap — Future Improvements

This project is being developed step by step. The first version focuses on understanding Linear B tablet data and building a simple Bronze, Silver, and Gold data pipeline using DuckDB.

Later, the project will be extended into a more production-grade data engineering and agentic AI platform.

### Planned Improvements

#### 1. Reproducible SQL Pipeline

The current Bronze, Silver, and Gold transformations will be saved as SQL scripts. This will make the project easier to rerun, review, and maintain.

#### 2. Python Pipeline Runner

A Python script will be added to execute the SQL files automatically. This will allow the full pipeline to run in sequence:

Bronze ingestion → Silver cleaning → Gold summaries

## Project Evolution

This project was developed incrementally. It began with a small manually inspected Linear B dataset to understand the structure of tablet records. The first version implemented a simple Bronze, Silver, and Gold pipeline in DuckDB.

After the core transformation logic became clear, the project was extended toward a more production-grade design using reproducible SQL scripts, dbt models, data quality tests, orchestration, and an agentic AI interpretation layer.

This staged approach reflects a practical data engineering workflow: start simple, validate the logic, then improve reliability, maintainability, and analytical value.

## Current Architecture

This project is a multi-source data engineering pipeline for Linear B tablet data. It uses DuckDB for local analytical storage, SQL scripts for transformation logic, and Airflow for orchestration.

The project currently integrates two sources:

1. **InsiderPhD Linear B CSV dataset**  
   A tablet-level dataset used to build the first Bronze, Silver, and Gold pipeline.

2. **DĀMOS search-result snapshot**  
   A token-level academic snapshot used as an enrichment source. This snapshot does not represent the full DĀMOS corpus, but it provides richer token-level metadata for selected records.

The pipeline follows a medallion-style architecture:

text
Source datasets
   ↓
Bronze layer
   ↓
Silver layer
   ↓
Gold layer
   ↓
Combined enrichment layer
   ↓
Evidence export

## Data Layers

### Bronze Layer

The Bronze layer stores source data close to its original form.

Current Bronze tables:

- `bronze_linear_b_tablets`
- `bronze_damos_search_tokens`

### Silver Layer

The Silver layer cleans, standardizes, and prepares data for analysis.

Current Silver tables:

- `silver_linear_b_tablets`
- `silver_duplicate_audit`
- `silver_damos_tokens`

### Gold Layer

The Gold layer provides analysis-ready summary tables.

Current Gold tables include:

- `gold_tablets_by_site`
- `gold_tablets_by_series`
- `gold_site_series_summary`
- `gold_data_quality_summary`
- `gold_damos_tokens_by_word_type`
- `gold_damos_tokens_by_site`
- `gold_damos_tokens_by_series`
- `gold_damos_tablet_token_summary`
- `gold_tablet_damos_enrichment`

## Airflow Orchestration

Airflow orchestrates the full multi-source pipeline:

```text
create_bronze_layer
→ create_silver_layer
→ create_gold_layer
→ create_damos_bronze_layer
→ create_damos_silver_layer
→ create_damos_gold_layer
→ create_combined_enrichment_layer
→ export_pipeline_evidence