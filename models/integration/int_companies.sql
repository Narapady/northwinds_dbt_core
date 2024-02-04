WITH hubspot_companies AS (
  SELECT * FROM {{ ref('stg_hubspot_companies')}}
),
rds_companies AS (
  SELECT * FROM {{ ref('stg_rds_companies')}}
),
merged_companies AS (
  SELECT 
    company_id AS hubspot_company_id
)
