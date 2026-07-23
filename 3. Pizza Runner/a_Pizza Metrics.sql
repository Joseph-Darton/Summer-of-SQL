-- How many pizzas were ordered?
select 
count(order_id) as pizzas_ordered
from customer_orders

-- How many unique customer orders were made?
select 
count(distinct customer_id) as customer_orders
from customer_orders

-- How many successful orders were delivered by each runner?
select 
runner_id,
count(order_id) as successful_orders
from runner_orders
where cancellation is null or cancellation='null' or cancellation =''
group by runner_id

-- How many of each type of pizza was delivered?
select
pizza_name,
count(c.order_id) as successful_orders
from customer_orders as c
join pizza_names as p on c.pizza_id=p.pizza_id
join runner_orders as r on r.order_id=c.order_id
where cancellation is null or cancellation='null' or cancellation =''
group by pizza_name

-- How many Vegetarian and Meatlovers were ordered by each customer?
select
customer_id,
pizza_name,
count(c.order_id)
from customer_orders as c
join pizza_names as p on c.pizza_id=p.pizza_id
group by pizza_name, customer_id
order by customer_id

-- What was the maximum number of pizzas delivered in a single order?
select
count(pizza_id) as highest_pizza_count
from customer_orders as c
group by order_id
order by highest_pizza_count desc
limit 1

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select
customer_id,
SUM(case when (exclusions='null' or exclusions is null or length(exclusions)=0)
  and
  (extras='null' or extras is null or length(extras)=0)
  then 1
  else 0
  end) as no_changes,
SUM(case when (exclusions<>'null' and exclusions is not null and length(exclusions)>0)
  or 
  (extras<>'null' and extras is not null and length(extras)>0)
  then 1
  else 0
  end) as changes
from customer_orders as c
join runner_orders as r on c.order_id=r.order_id
where pickup_time<>'null'
group by customer_id

-- How many pizzas were delivered that had both exclusions and extras?
select
count(c.order_id) as pizzas_with_exclusions_and_extras
from customer_orders as c
join runner_orders as r on c.order_id=r.order_id
where pickup_time<>'null'
and (exclusions<>'null' and exclusions is not null and length(exclusions)>0)
and (extras<>'null' and extras is not null and length(extras)>0)

-- What was the total volume of pizzas ordered for each hour of the day?
select
count(order_id) as ordered_pizzas,
date_part('hour', order_time) as hour
from customer_orders
group by hour
order by hour

-- What was the volume of orders for each day of the week?
select
count(order_id) as ordered_pizzas,
to_char(order_time, 'day') as day
from customer_orders
group by day
order by day
