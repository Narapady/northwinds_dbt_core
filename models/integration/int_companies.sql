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
dedup_companies AS (
  SELECT 
      MAX(hubspot_company_id) AS hubspot_company_id,
      MAX(rds_company_id) AS rds_company_id,
      name
  FROM merged_companies
  GROUP BY name
),
final AS (
  SELECT
    dc.hubspot_company_id,
    dc.rds_company_id,
    dc.name,
    rc.address,
    rc.city,
    rc.postal_code,
    rc.country
  FROM dedup_companies AS dc
  LEFT JOIN rds_companies rc ON dc.name = rc.name
)
SELECT * FROM final
