## Alternatives Considered

Several alternatives were considered:

- A single-table approach would be simpler, but it would mix raw source data, cleaned values, and analytical outputs in one place.
- A dimensional model or star schema would be useful for reporting, but it is more suitable for the Gold layer after the raw and cleaned data have been prepared.
- Data Vault would provide strong lineage and historical tracking for enterprise-scale integration, but it is too heavy for the first version of this project.
- Data Mesh provides useful thinking around data products and ownership, but it is more relevant to large organizations with multiple domain teams.

The medallion architecture was selected because it provides a clear and understandable progression from raw data to cleaned data to analysis-ready outputs.