select
    /* Primary key */
    address_id

    /* Other */
    , address
    , zipcode
    , state
    , country

from {{ source('postgres','addresses') }}