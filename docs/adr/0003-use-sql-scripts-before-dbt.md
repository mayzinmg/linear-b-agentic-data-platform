# ADR 0003 — Use SQL Scripts Before dbt
## Context

This project is being developed step by step. Before introducing dbt, the Bronze, Silver, and Gold transformation logic needs to be simple, visible, and easy to test.

## Decision

The first version of the pipeline uses standalone SQL scripts for Bronze, Silver, and Gold transformations.

## Reasoning

SQL scripts allow the transformation logic to be understood clearly before adding a framework. This helps validate the data flow, table structure, duplicate handling, and Gold summaries. Once the SQL logic becomes stable, it can be migrated into dbt models for better testing, documentation, lineage, and maintainability.