{% snapshot orders_snapshot %}

    {{
        config(
          target_database='northwinds',
          target_schema='dev',
          strategy='check',
          unique_key='order_id',
          check_cols=['ship_address', 'ship_city'],
        )
    }}

    select * from {{ source('rds', 'orders') }}

{% endsnapshot %}

