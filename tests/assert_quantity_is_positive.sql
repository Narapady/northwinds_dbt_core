SELECT * FROM {{ ref('stg_rds_orders')}}
WHERE quantity < 0
