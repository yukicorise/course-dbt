with
  order_items as (
    select * from {{ ref('source_postgres__order_items') }}
)

, final as (
    select
      order_id
      , count(distinct product_id) as distinct_product_count
      , sum(order_item_quantity) as total_quantity
    from order_items
    group by order_id
)

select * from final