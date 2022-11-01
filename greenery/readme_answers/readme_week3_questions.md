# Part 1. Create new models to answer the first two questions 
## What is our overall conversion rate?
To answer these questions, I plan to build out a fact_sessions model that will answer, for each session, what events happened? The grain will be a session. 
conversion rate = # of unique sessions with a purchase event / total number of unique sessions
number of unique sessions with a purchase event = 361
```
select count(distinct session_id)
from int_session_events_agg 
where checkout_count >= 1
```
total number of unique sessions = 578
```
select count(distinct session_id)
from int_session_events_agg
```
361 / 578 = ~62.5%

## What is our conversion rate by product?
Conversion rate by product = # of unique sessions with a purchase event of that product / total number of unique sessions that viewed the product
I would have liked to build the below into a dimension table for all of our products or something like that but ran out of time. This is part of what that model would have looked like:
```
with total_unique_sessions_with_purchase_event as (
  select
      product_id
      , count(distinct session_id) as total_unique_sessions_purchase_event
    from source_postgres__events
    where session_id in(select session_id from int_session_events_agg where checkout_count >= 1) -- all orders where there was a purchase event
      and product_id is not null
    group by 1
    order by 2 desc
)
, total_unique_sessions as (
  select
    product_id
    , count(distinct session_id) as total_unique_sessions
  from source_postgres__events
  group by 1
)
, joined as (
  select
    total_unique_sessions.product_id
    , total_unique_sessions_with_purchase_event.total_unique_sessions_purchase_event
    , total_unique_sessions.total_unique_sessions
    , total_unique_sessions_purchase_event / total_unique_sessions as conversion_rate_by_product
  from total_unique_sessions
  left join total_unique_sessions_with_purchase_event on total_unique_sessions.product_id = total_unique_sessions_with_purchase_event.product_id
)

select * from joined where product_id is not null
```

# Part 2. Create a macro to simplify part of a model
I used a macro in int_session_events_agg to simplify aggregating the event types in the events table.

# Part 3. Add a post hook to your project to apply grants to the role “reporting”. Create reporting role first by running CREATE ROLE reporting in your database instance.
Looks like the reporting role already exists - I put a post-hook in my dbt_project.yml file to apply grants to the role "reporting" on all of my staging and marts models.

# Part 4. Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project
I used dbt-utils to: 
- create a surrogate key for `source_postgres__order_items`
- set event_types to be all distinct values in the event_types columns in `int_session_events_agg`

I used dbt-expectations to: 
- create a test that ensures that there should only be a checkout event_type if the user added to cart during that session in `int_session_events_agg`

# Part 5. dbt Snapshots
## Run the orders snapshot model using dbt snapshot and query it in snowflake to see how the data has changed since last week. Which orders changed from week 2 to week 3? 

another 3 orders went from preparing to shipped.
```
select
  order_id
  , status
  , dbt_valid_from
  , dbt_valid_to
from orders_snapshot
where order_id in (select order_id from orders_snapshot where dbt_valid_to is not null)
order by dbt_valid_from asc
```
the orders that got updated are: 8385cfcd-2b3f-443a-a676-9756f7eb5404, e24985f3-2fb3-456e-a1aa-aaf88f490d70, 5741e351-3124-4de7-9dff-01a448e7dfd4
```
select
  order_id
  , status
  , dbt_valid_from
  , dbt_valid_to
from orders_snapshot
where order_id in (select order_id from orders_snapshot where dbt_valid_to like '2022-10-21%')
order by dbt_valid_from asc
```