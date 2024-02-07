
{% set sources = ["stg_rds_customers", "stg_hubspot_contacts"] %}

WITH merged_contacts AS (
  {% for source in sources%}
    SELECT 
      {{ 'customer_id' if 'rds' in source else 'null'}} AS rds_contact_id,
      {{ 'contact_id' if 'hubspot' in source else 'null' }} AS hubspot_contact_id,
      first_name,
      last_name,
      phone,
      {{ 'company_id' if 'hubspot' in source else 'null' }} AS hubspot_company_id,
      {{ 'company_id' if 'rds' in source else 'null' }} AS rds_company_id
    FROM {{ ref(source)}} {% if not loop.last %} UNION ALL {% endif %}
  {% endfor %}
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
