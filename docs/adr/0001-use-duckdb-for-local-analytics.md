# ADR 0001 — Use DuckDB for Local Analytics
DuckDB is suitable for this project because it provides a lightweight local analytical database that can persist data to a database file and run SQL transformations without a separate server. However, DuckDB is not intended to replace a distributed cloud data warehouse or a multi-user production database. If the project later requires larger-scale processing, stronger concurrency, cloud-native storage, or multi-user access, alternatives such as Snowflake, Redshift, BigQuery, PostgreSQL, Delta Lake, or a Spark-based lakehouse may be evaluated.

