with int_session_events_agg as (
    select * from {{ ref('int_session_events_agg') }}
)

, users as (
    select * from {{ ref('source_postgres__users') }}
)

, final as (
    select
      /* Primary key */
      int_session_events_agg.session_id

      /* Foreign keys and IDs */
      , int_session_events_agg.user_id

      /* Timestamps */
      , int_session_events_agg.first_event_at
      , int_session_events_agg.last_event_at

      /* User Info */
      , users.first_name
      , users.last_name
      , users.email
      , users.phone_number
      
      /* Aggregations */
      , int_session_events_agg.total_event_count
      , int_session_events_agg.session_duration_minutes
      , int_session_events_agg.add_to_cart_count
      , int_session_events_agg.checkout_count
      , int_session_events_agg.package_shipped_count
      , int_session_events_agg.page_view_count

    from int_session_events_agg
    left join users on int_session_events_agg.user_id = users.user_id
)

select * from final