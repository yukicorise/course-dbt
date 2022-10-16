with 
  users as (
  select * from {{ ref('source_postgres__users') }}
)

, orders as (
  select * from {{ ref('source_postgres__orders') }}
)

, address as (
  select * from {{ ref('source_postgres__addresses') }}
)

, order_items_agg as (
  select * from {{ ref('int_order_items_agg') }}
)

, final as (
    select
      /* Primary key */
      orders.order_id

      /* Foreign keys and IDs */
      , orders.user_id
      , address.address_id
      
      /* Status and Properties */
      , orders.order_status
      , address.address
      , address.zipcode
      , address.state
      , address.country

      /* Aggregations */
      , order_items_agg.distinct_product_count
      
    from orders
    left join users on orders.user_id = users.user_id
    left join address on users.address_id = address.address_id
    left join order_items_agg on orders.order_id = order_items_agg.order_id
)

select * from final