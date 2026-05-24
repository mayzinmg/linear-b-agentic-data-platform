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
