{% set sources = ["stg_hubspot_companies", "stg_rds_companies"] %}
WITH merged_companies AS (
{% for source in sources %}
  SELECT
      name,
      {{ 'company_id' if 'hubspot' in source else 'null' }} AS hubspot_company_id,
      {{ 'company_id' if 'rds' in source else 'null' }} AS rds_company_id
  FROM
    {{ ref(source) }}

    {% if not loop.last %}
    UNION ALL
    {% endif %}
{% endfor %}
),
deduped AS (
  SELECT
    MAX(hubspot_company_id) AS hubspot_company_id,
    MAX(rds_company_id) AS rds_company_id,
    NAME
  FROM
    merged_companies
  GROUP BY
    NAME
)
SELECT
  {{ dbt_utils.generate_surrogate_key(['deduped.name']) }} AS company_pk,
  hubspot_company_id,
  rds_company_id,
  deduped.name,
  address,
  postal_code,
  city,
  country
FROM
  deduped
  JOIN {{ ref('stg_rds_companies') }}
  rds_companies
  ON rds_companies.company_id = deduped.rds_company_id
