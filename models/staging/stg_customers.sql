WITH stg_customers AS (
  SELECT contact_name,
    address,
    phone
  FROM customers
)
SELECT * FROM stg_customers
