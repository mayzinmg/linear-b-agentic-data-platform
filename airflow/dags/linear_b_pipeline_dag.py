from __future__ import annotations
import os
from pathlib import Path
from datetime import datetime

import duckdb
from airflow import DAG
from airflow.operators.python import PythonOperator

PROJECT_DIR = Path(os.getenv("LINEAR_B_PROJECT_DIR","/opt/airflow/project"))
DB_PATH = PROJECT_DIR / "linear_b.duckdb"
SQL_DIR = PROJECT_DIR / "sql"

def run_sql_file(sql_file_name:str)-> None:
    sql_path= SQL_DIR / sql_file_name
    if not sql_path.exists():
        raise FileNotFoundError(f"SQL file not found:{sql_path}")
    sql_text=sql_path.read_text(encoding="utf-8")

    with duckdb.connect(str(DB_PATH)) as conn:
        conn.execute(sql_text)

with DAG(
dag_id="linear_b_bronze_silver_gold_pipeline",
description="Runs the Linear B Bronze, Silver, and Gold DuckDB pipeline.",
start_date=datetime(2026,1,1),
schedule=None,
catchup=False,
tags=["linear-b", "duckdb", "data-engineering"],

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
    
    create_bronze >> create_silver >> create_gold