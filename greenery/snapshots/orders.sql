{% snapshot orders_snapshot %}

  {{
    config(
      target_database=target.database
      , target_schema=target.schema
      , unique_key='order_id'
      , strategy='check'
      , check_cols=['status']
    )
  }}

  select * from {{ source('postgres', 'orders') }}

{% endsnapshot %}