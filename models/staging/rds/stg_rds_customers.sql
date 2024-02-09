WITH customers AS (
  SELECT * FROM {{ source('rds', 'customers')}}
),
companies AS (
  SELECT * FROM {{ ref('stg_rds_companies')}}
),
renamed AS (
  SELECT 
        CONCAT('rds-', customer_id) AS customer_id,
        customers.country,
        split_part(contact_name, ' ', 1) AS first_name,
        split_part(contact_name, ' ', -1) AS last_name,
        REPLACE(TRANSLATE(phone, '(,),-,.', ''), ' ', '') AS updated_phone,
        companies.company_id
  FROM customers
  JOIN companies ON companies.name = customers.company_name
),
final AS (
  SELECT 
    customer_id,
    first_name,
    last_name,
    CASE WHEN
      LENGTH(updated_phone) = 10 THEN
        '(' || SUBSTRING(updated_phone, 1, 3) || ')' || SUBSTRING(updated_phone, 4, 3) || '-'
        || SUBSTRING(updated_phone, 7, 4)
    END AS phone,
    company_id,
    CURRENT_TIMESTAMP AS updated_at
  FROM renamed
)
SELECT * FROM final
