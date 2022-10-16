select
    /* Primary key */
    product_id

    /* Other */
    , name
    , price
    , inventory

from {{ source('postgres','products') }}