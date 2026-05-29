from __future__ import annotations
import os
from pathlib import Path
from datetime import datetime, timedelta

import duckdb
from airflow import DAG
from airflow.operators.python import PythonOperator

PROJECT_DIR = Path(os.getenv("LINEAR_B_PROJECT_DIR","/opt/airflow/project"))
DB_PATH = PROJECT_DIR / "linear_b.duckdb"
SQL_DIR = PROJECT_DIR / "sql"
EVIDENCE_DIR = PROJECT_DIR / "evidence" / "airflow_runs"

def run_sql_file(sql_file_name:str)-> None:
    sql_path= SQL_DIR / sql_file_name
    if not sql_path.exists():
        raise FileNotFoundError(f"SQL file not found:{sql_path}")
    sql_text=sql_path.read_text(encoding="utf-8")

    current_dir = os.getcwd()

    try:
        os.chdir(PROJECT_DIR)

        with duckdb.connect(str(DB_PATH)) as conn:
            conn.execute(sql_text)

    finally:
        os.chdir(current_dir)

def export_pipeline_evidence()-> None:
    EVIDENCE_DIR.mkdir(parents=True,exist_ok=True)

    row_counts_path=  EVIDENCE_DIR / "row_counts.csv"
    data_quality_path= EVIDENCE_DIR / "data_quality_summary.csv"
    duplicate_audit_path = EVIDENCE_DIR / "duplicate_audit_summary.csv"
    run_summary_path = EVIDENCE_DIR / "pipeline_run_summary.csv"

    with duckdb.connect(str(DB_PATH)) as conn:
        conn.execute(f"""
            COPY (
                SELECT 'bronze_linear_b_tablets' AS table_name, COUNT(*) AS row_count
                FROM bronze_linear_b_tablets

                UNION ALL

                SELECT 'silver_linear_b_tablets' AS table_name, COUNT(*) AS row_count
                FROM silver_linear_b_tablets

                UNION ALL

                SELECT 'silver_duplicate_audit' AS table_name, COUNT(*) AS row_count
                FROM silver_duplicate_audit

                UNION ALL

                SELECT 'gold_tablets_by_site' AS table_name, COUNT(*) AS row_count
                FROM gold_tablets_by_site

                UNION ALL

                SELECT 'gold_tablets_by_series' AS table_name, COUNT(*) AS row_count
                FROM gold_tablets_by_series

                UNION ALL

                SELECT 'gold_site_series_summary' AS table_name, COUNT(*) AS row_count
                FROM gold_site_series_summary

                UNION ALL

                SELECT 'gold_data_quality_summary' AS table_name, COUNT(*) AS row_count
                FROM gold_data_quality_summary
            )
            TO '{row_counts_path.as_posix()}'
            WITH (HEADER, DELIMITER ',');
        """)

        conn.execute(f"""
            COPY (
                SELECT *
                FROM gold_data_quality_summary
            )
            TO '{data_quality_path.as_posix()}'
            WITH (HEADER, DELIMITER ',');
        """)

        conn.execute(f"""
            COPY (
                SELECT
                    COUNT(*) AS duplicate_group_count,
                    SUM(duplicate_count - 1) AS duplicate_extra_row_count,
                    MAX(duplicate_count) AS highest_duplicate_count
                FROM silver_duplicate_audit
            )
            TO '{duplicate_audit_path.as_posix()}'
            WITH (HEADER, DELIMITER ',');
        """)

        conn.execute(f"""
            COPY (
                SELECT
                    'linear_b_bronze_silver_gold_pipeline' AS pipeline_name,
                    CURRENT_TIMESTAMP AS exported_at,
                    '{DB_PATH.as_posix()}' AS database_path
            )
            TO '{run_summary_path.as_posix()}'
            WITH (HEADER, DELIMITER ',');
        """)

default_args = {
    "retries": 2,
    "retry_delay": timedelta(minutes=2),
}

with DAG(
dag_id="linear_b_bronze_silver_gold_pipeline",
description="Runs the Linear B Bronze, Silver, and Gold DuckDB pipeline.",
start_date=datetime(2026,1,1),
schedule="@weekly",
catchup=False,
tags=["linear-b", "duckdb", "data-engineering"],
default_args=default_args,

) as dag:
    
    create_bronze= PythonOperator(
        task_id="create_bronze_layer",
        python_callable=run_sql_file,
        op_args=["01_create_bronze.sql"],
    )

    create_silver=PythonOperator(
        task_id="create_silver_layer",
        python_callable= run_sql_file,
        op_args=["02_create_silver.sql"],
    )
    create_gold= PythonOperator(
        task_id="create_gold_layer",
        python_callable=run_sql_file,
        op_args=["03_create_gold.sql"]
    )
    create_damos_bronze = PythonOperator(
        task_id="create_damos_bronze_layer",
        python_callable=run_sql_file,
        op_args=["04_create_bronze_damos.sql"],
    )

    create_damos_silver = PythonOperator(
        task_id="create_damos_silver_layer",
        python_callable=run_sql_file,
        op_args=["05_create_silver_damos.sql"],
    )

    create_damos_gold = PythonOperator(
        task_id="create_damos_gold_layer",
        python_callable=run_sql_file,
        op_args=["06_create_gold_damos.sql"],
    )

    create_combined_enrichment = PythonOperator(
        task_id="create_combined_enrichment_layer",
        python_callable=run_sql_file,
        op_args=["07_create_gold_tablet_damos_enrichment.sql"],
    )
    export_evidence = PythonOperator(
        task_id="export_pipeline_evidence",
        python_callable=export_pipeline_evidence,
    )

    create_bronze >> create_silver >> create_gold >> export_evidence