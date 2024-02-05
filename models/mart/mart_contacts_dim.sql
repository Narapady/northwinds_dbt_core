
{{ config(materialized='table')}}

WITH int_contacts AS (
  SELECT * FROM {{ ref('int_contacts') }}
),
int_companies AS (
  SELECT * FROM {{ ref('int_companies') }}
),
final AS (
  SELECT 
    contact_pk,
    first_name,
    last_name,
    phone,
    company_pk
  FROM int_contacts LEFT JOIN int_companies
    ON int_contacts.hubspot_company_id = int_companies.hubspot_company_id
    OR int_contacts.rds_company_id = int_companies.rds_company_id
)
SELECT * FROM final

