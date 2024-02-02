WITH source AS (
  SELECT * FROM public.suppliers
),
transformed AS (
  SELECT supplier_id,
    company_name,
    split_part(contact_name, ' ', 1) AS contact_first_name,
    split_part(contact_name, ' ', 2) AS contact_last_name,
    contact_title,
    address,
    city,
    region,
    postal_code,
    country,
    CASE WHEN
      LENGTH(TRANSLATE(phone, '.(-) ', '')) = 10 THEN
      '('
      || SUBSTRING(TRANSLATE(phone, '.(-) ', '') FROM 1 FOR 3) 
      ||')'
      || SUBSTRING(TRANSLATE(phone, '.(-) ', '') FROM 4 FOR 3) 
      || '-'
      || SUBSTRING(TRANSLATE(phone, '.(-) ', '') FROM 7 FOR 10) ELSE phone END AS phone,
    fax
  FROM source
)
SELECT * FROM transformed
