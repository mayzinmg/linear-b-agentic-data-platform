# ADR 0004 — Airflow

The pipeline improves the dataset layer by layer, moving from Bronze ingestion to Silver cleaning, Gold summaries, and evidence export. Since each step depends on the previous step, an orchestration tool is useful for controlling the execution order.

Airflow is used because it helps manage the workflow, monitor run status, identify task failures, retry failed tasks, and support scheduled batch processing. This makes the pipeline more production-minded than running SQL scripts manually.

In this project, Airflow does not replace the transformation logic. The SQL scripts still define the Bronze, Silver, and Gold transformations. Airflow is responsible for orchestrating when and how those scripts run.

## Backfill and Idempotency

The current Linear B dataset is a mostly static research dataset, so backfill does not visibly change the analytical output in the same way as a daily transactional dataset. However, backfill is still documented as an orchestration concept because it is important for production data pipelines.

The current pipeline uses full-refresh idempotency through `CREATE OR REPLACE TABLE`. This means the Bronze, Silver, and Gold tables are recreated on each run rather than appended repeatedly. As a result, rerunning the DAG or backfilling a period should produce the same final analytical tables without duplicate accumulation.

For future source integrations, especially DĀMOS or source snapshots, the project may introduce source-version tracking, snapshot dates, or partition-based idempotency. In that case, each run can process a specific source version or logical date, making backfill more meaningful and visible.

docker compose exec airflow-scheduler airflow backfill create --dag-id linear_b_bronze_silver_gold_pipeline --from-date 2026-05-01 

## Source Snapshot Consideration

The current Linear B dataset is mostly static, so backfill does not visibly change the analytical output. To make scheduled processing and backfill more meaningful, a later version of the project may introduce source snapshots, especially when integrating DĀMOS.

Each source snapshot can be stored with a snapshot date or source version. This would allow the pipeline to reprocess previous snapshots, compare outputs across versions, and demonstrate more realistic idempotency patterns.
