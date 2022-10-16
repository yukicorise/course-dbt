select
    /* Primary key */
    promo_id

    /* Other */
    , discount
    , status

from {{ source('postgres','promos') }}