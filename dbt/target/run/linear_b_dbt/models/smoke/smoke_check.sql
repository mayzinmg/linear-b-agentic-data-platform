
  
  create view "linear_b"."main"."smoke_check__dbt_tmp" as (
    

SELECT
    COUNT(*) AS bronze_tablet_count
FROM bronze_linear_b_tablets
  );
