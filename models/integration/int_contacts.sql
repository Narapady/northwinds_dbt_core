WITH customers AS (
  SELECT * FROM {{ ref('stg_rds_customers')}}
),
contacts AS (
  SELECT * FROM {{ ref('stg_hubspot_contacts')}}
),
merged_contacts AS (
  SELECT 
    contact_id AS hubspot_contact_id,
    NULL AS rds_contact_id,
    first_name,
    last_name,
    phone,
    company_id AS hubspot_company_id,
    NULL AS rds_company_id
  FROM contacts
  UNION ALL
  SELECT
    NULL AS hubspot_contact_id,
    customer_id AS rds_contact_id,
    first_name,
    last_name,
    phone,
    NULL AS hubspot_company_id,
    company_id AS rds_company_id
  FROM customers
),
final AS (
  SELECT 
    MAX(hubspot_contact_id) AS hubspot_contact_id,
    MAX(rds_contact_id) AS rds_contact_id,
    first_name,
    last_name,
    MAX(phone) AS phone,
    MAX(hubspot_company_id) as hubspot_company_id,
    MAX(rds_company_id) AS rds_company_id
  FROM merged_contacts
  GROUP BY
    first_name,
    last_name
)
SELECT {{ dbt_utils.generate_surrogate_key(['first_name', 'last_name', 'phone']) }} AS 
  contact_pk,
  hubspot_contact_id,
  rds_contact_id,
  first_name,
  last_name,
  phone,
  hubspot_company_id,
  rds_company_id 
FROM final
