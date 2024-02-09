{% snapshot customers_snapshot %}

{{
    config(
      target_database='northwinds',
      target_schema='dev',
      unique_key='customer_id',

      strategy='timestamp',
      updated_at='updated_at',
      invalidate_hard_delete=True,
    )
}}

select * from {{ source('rds', 'customers') }}

{% endsnapshot %}
