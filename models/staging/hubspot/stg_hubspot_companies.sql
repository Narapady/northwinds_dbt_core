WITH source AS (
  SELECT * FROM {{ source('hubspot', 'northwinds_hubspot') }}
),
renamed AS (
  SELECT
    CONCAT('hubspot-', REPLACE(LOWER(business_name), ' ', '-')) AS company_id,
    business_name AS name
  FROM source
  GROUP BY business_name
)
SELECT * FROM renamed
