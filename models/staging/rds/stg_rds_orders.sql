
WITH orders AS (
  SELECT * FROM {{ source('rds', 'orders')}}
),
order_details AS (
  SELECT * FROM {{ source('rds', 'order_details')}}
)
{% set cols = ["product_id", "employee_id", "customer_id"] %} 
SELECT 
  o.order_id,
  o.order_date,
  {% for col in cols %}
  CONCAT('rds-', {{col}}) AS {{col}},
  {% endfor %}
  od.quantity,
  od.discount,
  od.unit_price
FROM orders o LEFT JOIN order_details od ON o.order_id = od.order_id

