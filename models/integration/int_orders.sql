WITH stg_rds_orders AS (
  SELECT * FROM {{ ref('stg_rds_orders')}}
),
final AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(["order_id", "product_id", "employee_id", "customer_id",])}} AS order_pk,
    {{ dbt_utils.star(ref('stg_rds_orders'), except=["order_id"])}}
  FROM stg_rds_orders
)
SELECT * FROM final
