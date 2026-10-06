1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```sql
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
```
Result:

| runners | start_of_week          |
| ------- | ---------------------- |
| 2       | 2021-01-01 00:00:00+00 |
| 1       | 2021-01-08 00:00:00+00 |
| 1       | 2021-01-15 00:00:00+00 |

---

2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```sql
select
    runner_id,
    round(
        avg(
            extract(
                epoch from (
                    to_timestamp(pickup_time, 'YYYY-MM-DD HH24:MI:SS')
                    - order_time
                )
            ) / 60
        )::numeric,
        2
    ) as avg_minutes_to_pickup
from runner_orders r
join customer_orders c
    on c.order_id = r.order_id
where pickup_time <> 'null'
group by runner_id;
```
Result:
| runner_id | avg_minutes_to_pickup |
| --------- | --------------------- |
| 3         | 10.47                 |
| 2         | 23.72                 |
| 1         | 15.68                 |

---

3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
```sql
    with pizzas_per_order as(
    select
    order_id,
    count(pizza_id) as pizzas
    from customer_orders
    group by order_id
    order by order_id
      ),
      
    order_times as(
      select
        c.order_id,
        round(
            avg(
                extract(
                    epoch from (
                        to_timestamp(pickup_time, 'YYYY-MM-DD HH24:MI:SS')
                        - order_time
                    )
                ) / 60
            )::numeric,
            2
        ) as avg_minutes_to_pickup
    from runner_orders r
    join customer_orders c
        on c.order_id = r.order_id
    where pickup_time <> 'null'
    group by c.order_id
    )
    
    select
    p.order_id,
    pizzas,
    avg_minutes_to_pickup
    from pizzas_per_order p
    join order_times as o
    on p.order_id=o.order_id
    order by pizzas desc
```

| order_id | pizzas | avg_minutes_to_pickup |
| -------- | ------ | --------------------- |
| 4        | 3      | 29.28                 |
| 3        | 2      | 21.23                 |
| 10       | 2      | 15.52                 |
| 7        | 1      | 10.27                 |
| 8        | 1      | 20.48                 |
| 5        | 1      | 10.47                 |
| 2        | 1      | 10.03                 |
| 1        | 1      | 10.53                 |

---

4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?
