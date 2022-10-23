{%-
    set event_types = dbt_utils.get_column_values(
        table = ref('source_postgres__events')
        , column = 'event_type'
        , order_by = 'event_type asc'
    )
-%}

with events as (
  select * from {{ ref('source_postgres__events') }}
)

, final as (
  select
    /* Primary key */
    session_id

    /* Foreign keys and IDs */
    , user_id

    /* Timestamps */
    , min(created_at) as first_event_at
    , max(created_at) as last_event_at
    
    /* Aggregations */
    , count(*) as total_event_count
    , timestampdiff(minute,first_event_at, last_event_at) as session_duration_minutes
    {% for event_type in event_types %}
    , sum(case when event_type = '{{ event_type }}' then 1 end) as {{ event_type }}_count
    {% endfor %}
  from events
  group by 1,2
)

select * from final
