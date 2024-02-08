SELECT * FROM {{ ref('stg_rds_orders')}}
WHERE unit_price < 0
