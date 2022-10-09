select
    /* Primary key */
    order_id

    /* Foreign keys and IDs */
    , user_id
    , address_id
    , promo_id
    , tracking_id

    /* Timestamps */
    , created_at
    , estimated_delivery_at
    , delivered_at

    /* Other */
    , order_cost
    , shipping_cost
    , order_total
    , shipping_service
    , status as order_status

from {{ source('postgres','orders') }}