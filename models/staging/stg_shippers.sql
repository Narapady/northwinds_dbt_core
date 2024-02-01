WITH stg_shipper AS (
  SELECT shipper_id,
        company_name
  FROM shippers
)
SELECT * from stg_shipper
