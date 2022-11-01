# Part 1. dbt Snapshots
## Which orders changed from week 3 to week 4? 
-- 3 orders went from preparing to shipped. 
-- the orders that got updated are: 38c516e8-b23a-493a-8a5c-bf7b2b9ea995, d1020671-7cdf-493c-b008-c48535415611, aafb9fbd-56e1-4dcc-b6b2-a3fd91381bb6
```
select
  order_id
  , status
  , dbt_valid_from
  , dbt_valid_to
from orders_snapshot
where order_id in (select order_id from orders_snapshot where dbt_valid_to like '2022-11-01%')
order by dbt_valid_from asc
```

# Part 2. Modeling challenge
## How are our users moving through the product funnel? 
To give Sigma a try, I pretended to be an end user who only had access to the fact_sessions model. I created a very simple viz, here: https://app.sigmacomputing.com/corise-dbt/workbook/week4-viz-YI-7LNfwY7TDe8UCuyXfnZdtc/edit?:nodeId=b85PQ4s5NL

I used simple formuals to calculate the below (although as an AE, I might just build these into the model)
Sessions with any event of type page_view: 578
Sessions with any event of type add_to_cart: 467
Sessions with any event of type checkout: 361

Technically, more people drop off from viewed -> added to cart than added to cart -> checked out. However, the relative % drop-off is fairly similar (81% vs. 77%). I wouldn't feel comfortable with this quick analysis to make a recommendation for where the product team should focus.

In hindsight, I wish I had more time to dig into using Sigma! It's quite different from my experience using Looker, but fairly intuitive if you know excel/gsheets.

# Part 3. Reflection questions -- please answer 3A or 3B, or both!
## 3A. dbt next steps for you 
I would try to pitch the value of dbt by showing them a simple proof of concept on project. I'd highlight specific benefits based on pain points I know the org has faced (e.g., do they not have unit tests on their data models that have hurt the org in the past? Have they struggled to untangle messy tranformations in the past? People wasting time on re-creating the wheel over and over because models are not DRY? etc.)