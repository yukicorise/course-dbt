select
    /* Primary key */
    {{ dbt_utils.surrogate_key(['order_id', 'product_id']) }} as unique_id

    /* Foreign keys and IDs */
    , order_id
    , product_id

    /* Other */
    , quantity as order_item_quantity

from {{ source('postgres','order_items') }}