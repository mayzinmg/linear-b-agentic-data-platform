# ADR 0005 — Integrate DĀMOS as an Academic Source

## Context

The first version of this project uses a simple public Linear B CSV dataset to build and validate the core data engineering workflow. This helped establish the Bronze, Silver, and Gold pipeline, Airflow orchestration, retry policy, evidence export, and basic observability.

However, the project aims to become more academically reliable and more production-minded. Since Linear B is a historical and research-oriented dataset, the project should eventually use a stronger academic source. DĀMOS is considered as a future source because it provides a richer corpus of Linear B material with scholarly context.

The current dataset is mostly static, so backfill and source-version tracking are not very visible. Adding a DĀMOS-based source layer can make the project more realistic by introducing source snapshots, source references, and future version-based processing.

## Decision

DĀMOS will be explored as a future academic source for this project.

The first integration will use a controlled source snapshot approach. This means a DĀMOS export or manually saved dataset snapshot may be stored under the raw data layer before being loaded into Bronze.

Automated DĀMOS ingestion will only be added if a stable, appropriate, and respectful export or download method is available.

## Alternatives Considered

* Continue using only the current CSV dataset.
* Replace the current dataset completely with DĀMOS.
* Scrape DĀMOS immediately without first checking source structure and access rules.
* Wait until after dbt migration before exploring DĀMOS.
* Use DĀMOS first as a manually stored source snapshot, then automate later if suitable.

## Reasoning

The current CSV dataset is useful for learning and prototyping, but DĀMOS can strengthen the project’s academic value and source credibility. It can also help the project evolve from a simple static-data pipeline into a more realistic multi-source data platform.

A controlled snapshot approach is preferred first because it is safer and easier to audit. It allows the project to record when the source was captured, where it came from, and how it was loaded. This supports source-version tracking and prepares the project for more meaningful backfill and idempotency patterns later.

The DĀMOS source should not be integrated through blind scraping. The project should first examine whether DĀMOS provides a stable export format, what fields are available, and how the source should be cited or attributed.

## Consequences

This decision improves the long-term academic and engineering direction of the project. It allows the pipeline to support multiple sources, source snapshots, and source references instead of depending on only one simple CSV file.

It also creates a path for learning more advanced data engineering concepts such as source-version tracking, snapshot dates, partition-based idempotency, and controlled reprocessing.

However, this decision adds complexity. DĀMOS may not provide a simple automated download method, and the source structure may require additional analysis before ingestion. Therefore, the first implementation should focus on source exploration and manual or controlled snapshot loading before full automation.

In the future, the project may include separate Bronze tables for each source, such as `bronze_insiderphd_tablets` and `bronze_damos_tablets`, before standardizing them into a common Silver model.
