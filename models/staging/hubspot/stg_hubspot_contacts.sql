WITH source AS (
  SELECT * FROM {{ source('hubspot', 'northwinds_hubspot')}}
),
hubspot_contact AS (
  SELECT 
    CONCAT('hubspot-', hubspot_id) AS contact_id,
    first_name,
    last_name,
    REPLACE(TRANSLATE(phone, '(,),-,.', ''), ' ', '') AS updated_phone,
    business_name
  FROM source
),
hubspot_companies AS (
  SELECT * FROM {{ ref('stg_hubspot_companies')}}
),
final AS (
  SELECT 
    hcon.contact_id,
    hcon.first_name,
    hcon.last_name,
    CASE WHEN
      LENGTH(updated_phone) = 10 THEN
        '(' || SUBSTRING(updated_phone, 1, 3) || ')' || SUBSTRING(updated_phone, 4, 3) || '-'
        || SUBSTRING(updated_phone, 7, 4)
    END AS phone,
    hcom.company_id
  FROM hubspot_contact hcon JOIN hubspot_companies hcom 
    ON hcon.business_name = hcom.name
)
SELECT * FROM final
