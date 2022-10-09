select
    /* Primary key */
    user_id

    /* Foreign keys and IDs */
    , address_id

    /* Timestamps */
    , created_at
    , updated_at

    /* Other */
    , first_name
    , last_name
    , email
    , phone_number

from {{ source('postgres','users') }}