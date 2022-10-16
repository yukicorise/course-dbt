select
    /* Primary key */
    event_id

    /* Foreign keys and IDs */
    , session_id
    , user_id
    , order_id
    , product_id

    /* Timestamps */
    , created_at

    /* Other */
    , page_url
    , event_type

from {{ source('postgres','events') }}