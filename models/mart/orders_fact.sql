{{ config(materialized='table')}}

WITH int_orders AS (
  SELECT * FROM {{ ref('int_orders')}}
),
int_contacts AS (
  SELECT * FROM {{ ref('int_contacts')}}
)
SELECT
    order_pk,
    contact_pk,
    order_date,
    product_id,
    employee_id,
    quantity,
    discount,
    unit_price
FROM int_orders io LEFT JOIN int_contacts ic ON io.customer_id = ic.rds_contact_id
ORDER BY order_date
