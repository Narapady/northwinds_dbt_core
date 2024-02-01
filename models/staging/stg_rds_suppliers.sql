WITH source AS (
  SELECT * FROM public.suppliers
),
renamed AS (
  SELECT *,
    split_part(contact_name, ' ', 1) AS contact_first,
    split_part(contact_name, ' ', 2) AS contact_last
  FROM source
),
valid_phone_number AS (
  SELECT * 
  FROM renamed
  WHERE length(replace(replace(replace(replace(replace(phone, '-', ''), '(', ''), ')', ''), '.', ''),' ', '')) = 10
)
SELECT * FROM valid_phone_number
