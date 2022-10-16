with
  orders as (
    select * from {{ ref('source_postgres__orders') }}
)

, final as (
    select
      user_id
      , count(distinct order_id) as distinct_order_count
    from orders
    group by 1
)

select * from final