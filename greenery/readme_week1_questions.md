### How many users do we have?
There are 130 unique users. 
```
select count(distinct user_id)
from dev_db.dbt_yito16.stg_users
```

### On average, how many orders do we receive per hour?
There are 361 total orders. Given that our data spans 47 hours, that's approximately 7.7 orders per hour. 
With more time, I'd dig into the distribution of the orders, what time of day has the most orders, etc.
I calculated it this way since I'm assuming if there was an hour without an order, we'd still like to account for that hour. 

```
-- there are 47 hours between the first and last order.
select
    min(created_at) as first_order
    , max(created_at) as last_order
    , datediff(hour,first_order,last_order) as hours_from_first_to_last_order
from dev_db.dbt_yito16.stg_orders
;
-- There are 361 total orders
select
    count(*)
from dev_db.dbt_yito16.stg_orders
```

### On average, how long does an order take from being placed to being delivered?
On average, this takes approximately 93.4 hours, or 3.9 days

```
select 
  avg(datediff(hour,created_at,delivered_at)) as avg_placed_to_delivered_hours
  , min(datediff(hour,created_at,delivered_at)) as min_placed_to_delivered_hours
  , max(datediff(hour,created_at,delivered_at)) as max_placed_to_delivered_hours
from dev_db.dbt_yito16.stg_orders
where status = 'delivered'
```

### How many users have only made one purchase? Two purchases? Three+ purchases?
25 users have only made one purchase, 28 users have made two purchases, 71 users have made three+ purchases. It seems that 

```
with order_count as (
    select
      user_id
      , count(distinct order_id) as user_order_count
    from dev_db.dbt_yito16.stg_orders
    group by 1
)

select
 user_order_count
  , count(*)
from order_count
group by 1
order by user_order_count asc
```


### On average, how many unique sessions do we have per hour?
A unique session_id can show up in multiple hours. If we're counting each time a session_id shows up in a different hour of the day, there are approximately 16.3 sessions per hour. 

```
with unique_sessions_per_hour as (
    
    select
      date_trunc('hour',created_at) as hour_created_at
      , count(distinct session_id) as distinct_session_count
    from dev_db.dbt_yito16.stg_events
    group by 1
    
)

select avg(distinct_session_count) from unique_sessions_per_hour
```
If instead we wanted to calculate unique sessions only once, we know that there are 578 distinct session_id's, and the data span 57 hours between the first and last session (~10.1 unique sessions per hour). This drastically changes this metric, and that's why it's so important to document exactly how each metric was calculated, have it version controlled, etc.