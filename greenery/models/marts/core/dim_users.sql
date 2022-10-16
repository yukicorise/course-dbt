with
  users as (
    select * from {{ ref('source_postgres__users') }} 
  )

  , addresses as (
    select * from {{ ref('source_postgres__addresses') }}
  )

  , orders_agg as (
    select * from {{ ref('int_orders_agg') }}
  )

  , final as (
    select
      /* Primary key */
      users.user_id
      /* Foreign keys and IDs */
      , users.address_id

      /* Timestamps */
      , users.created_at
      , users.updated_at
    
      /* Status and properties */
      , users.first_name
      , users.last_name
      , users.email
      , users.phone_number
      , addresses.address
      , addresses.zipcode
      , addresses.state
      , addresses.country

      /* Aggregations */
      , orders_agg.distinct_order_count

      from users
      left join addresses on users.address_id = addresses.address_id
      left join orders_agg on users.user_id = orders_agg.user_id
  )

select * from final