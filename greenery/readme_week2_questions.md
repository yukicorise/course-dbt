# Part 1. Models
## What is our user repeat rate?
Repeat Rate = Users who purchased 2 or more times / users who purchased
Users who purchased 2 or more times = 99
users who purchased = 124
Repeat Rate = 99 / 124 = ~79.8%

```
with
  user_count as (
    select
      distinct_order_count
      , count(distinct user_id) as user_count
    from dim_users
    group by 1
    order by 1 asc
  )
  
  , user_count_distribution as (
      select
        case
          when distinct_order_count is null then 'Not Purchaser'
          when distinct_order_count = 1 then 'One Time Purchaser'
          when distinct_order_count >= 2 then 'Repeat Purchaser'
          else 'Other'
        end as user_count_bucket
      
        , sum(user_count) as total_users
      from user_count
      group by 1
  )

select * from user_count_distribution
```
## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
### NOTE: This is a hypothetical question vs. something we can analyze in our Greenery data set. Think about what exploratory analysis you would do to approach this question.
With more time and/or more data, I would explore: 
- Avg&Median age of repeat purchasers vs. one-time purchasers (What age demographic is our product popular in? Young social media users who see friends with "green" apartments might choose to buy from Greenery)
- Addresses of repeat purchasers vs. one-time purchasers (Are they mostly from the same state? Cities vs. rural areas? Greenery may be more appealing with users in major cities with disposable income and less access to "natural greenery")
- Are users more likely to be repeat users if their order items were delivered quickly?
- Are users more likely to be repeat users if their first purchase included a certain popular product? If they ordered more items in their first order? If they got a promo vs. did not?
- Ares users more likely to be repeat users if they had engaged events/sessions with lots of page views, lengthy sessions, links clicked, etc.?

## Explain the marts models you added. Why did you organize the models in the way you did?
I created intermediate models to calculate aggreations at the order grain and user grain. I used these in the dim_users and fact_user_orders tables. This way, the aggregations and joins made in the intermediate tables can be re-used elsewhere. The aggregations being calculated were created with intention of being able to spot patterns for who might be more likely to be a repeat user.

I'd love to add more models with more time, including fact tables for user sessions. Deeper insight into what types of products are being purchased, etc. I've created marketing and product directories I haven't added to yet, where I will add more models in future weeks


# Part 2. Tests
### What assumptions are you making about each model? (i.e. why are you adding each test?)
At a minimum, I'm assuming that the primary key should be unique and not null for each of these models. In addition, foreign keys should have referential integrity.

In addition, there are several models with fields that should only have a few accepted values (e.g., order status, promo status). For these, I've included the values that make sense for these fields. If there is a mistake in the future, or if a new reasonable status is identified, the data team will be able to know.

### Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
The order items table didn't have a primary key, so I used dbt_utils to create a surrogate key. The unique and not_null tests both work on this surrogate key. 

### Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
There are many ways to go about this. I would ensure dbt test failures notify stakeholders via slack/email (whatever their preference might be). There might also be a way to use the new store_failures feature in dbt to surface dbt test failures in a schema that is surfaced to stakeholders in a BI tool so they can look at these themselves, although I have not seen this in practice. 

# Part 3. dbt Snapshots
### Which orders changed from week 1 to week 2? 

3 orders changed from week 1 to week 2 (914b8929-e04a-40f8-86ee-357f2be3a2a2,  05202733-0e17-4726-97c2-0520c024ab85, 939767ac-357a-4bec-91f8-a7b25edd46c9)
```
select * 
from orders_snapshot
where dbt_valid_to is not null
```
;

Those 3 orders when from a preparing status to a shipped status
```
select *
from orders_snapshot
where order_id in (select order_id from orders_snapshot where dbt_valid_to is not null)
```