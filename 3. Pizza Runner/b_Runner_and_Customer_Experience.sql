-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
with runner_signups as (
select
runner_id,
registration_date,
date_trunc('week', registration_date) + interval '4' day as start_of_week
from runners
)

select
count(runner_id) as runners,
start_of_week
from runner_signups
group by start_of_week
order by start_of_week
-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- 4. What was the average distance travelled for each customer?
-- 5. What was the difference between the longest and shortest delivery times for all orders?
-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- 7. What is the successful delivery percentage for each runner?
