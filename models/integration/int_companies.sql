WITH hubspot_companies AS (
  SELECT * FROM {{ ref('stg_hubspot_companies')}}
),
rds_companies AS (
  SELECT * FROM {{ ref('stg_rds_companies')}}
),
merged_companies AS (
  SELECT 
    company_id AS hubspot_company_id,
    NULL AS rds_company_id,
    name
  FROM hubspot_companies
  UNION ALL
  SELECT 
    NULL AS hubspot_company_id,
    company_id AS rds_company_id,
    name
  FROM rds_companies
),
deduped AS (
  SELECT 
      MAX(hubspot_company_id) AS hubspot_company_id,
      MAX(rds_company_id) AS rds_company_id,
      name
  FROM merged_companies
  GROUP BY name
)
SELECT {{ dbt_utils.generate_surrogate_key(['deduped.name']) }} AS 
   company_pk, 
   hubspot_company_id, 
   rds_company_id,
   deduped.name,
   address,
   postal_code,
   city,
   country 
FROM deduped
LEFT OUTER JOIN rds_companies on rds_companies.company_id = deduped.rds_company_id
