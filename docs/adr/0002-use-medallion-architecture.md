
## Alternatives Considered

Several alternatives were considered:

- A single-table approach would be simpler, but it would mix raw source data, cleaned values, and analytical outputs in one place.
- A dimensional model or star schema would be useful for reporting, but it is more suitable for the Gold layer after the raw and cleaned data have been prepared.
- Data Vault would provide strong lineage and historical tracking for enterprise-scale integration, but it is too heavy for the first version of this project.
- Data Mesh provides useful thinking around data products and ownership, but it is more relevant to large organizations with multiple domain teams.

The medallion architecture was selected because it provides a clear and understandable progression from raw data to cleaned data to analysis-ready outputs.

# ADR 0002 — Use Medallion Architecture

## Context

This project uses an external Linear B dataset that may contain duplicate records, unclear column names, missing values, and mixed content. The project needs a clear structure to separate raw source data, cleaned data, and analysis-ready summaries.

## Decision

This project will use a medallion architecture with three layers: Bronze, Silver, and Gold.

## Reasoning

The Bronze layer stores raw source data as close to its original form as possible. This helps preserve the original evidence and makes the pipeline traceable.

The Silver layer focuses on cleaning and standardization. In this project, the Silver layer renames unclear columns, trims unnecessary spaces, removes confirmed exact duplicates, and keeps a duplicate audit table. This layer prepares reliable data for further analysis by data engineers, analysts, or data scientists.

The Gold layer provides analysis-ready summary tables. These tables are suitable for reporting, dashboards, research summaries, and later AI-assisted interpretation.

## Alternatives Considered

- A single-table approach would be simpler, but it would mix raw data, cleaned data, and analytical outputs.
- A raw-to-curated approach would be simpler than Bronze/Silver/Gold, but it would provide less visibility into the cleaning process.
- A star schema may be useful later for the Gold layer, but it does not replace the need to preserve and clean raw source data first.
- Data Vault and Data Mesh were considered too heavy for the first version of this project.

## Consequences

This design makes the project easier to understand, test, document, and extend. It also supports a production-minded learning approach because each layer has a clear responsibility.

For a small dataset, the medallion architecture may add more structure than strictly necessary. However, it helps demonstrate good data engineering practice and prepares the project for future extensions such as dbt, Airflow orchestration, DĀMOS integration, and an agentic AI interpretation layer.

