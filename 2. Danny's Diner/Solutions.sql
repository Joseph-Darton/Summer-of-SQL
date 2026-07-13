/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
select 
sales.customer_id,
sum(menu.price) as spend
from sales
join menu on sales.product_id=menu.product_id
group by sales.customer_id;

-- 2. How many days has each customer visited the restaurant?
select
sales.customer_id,
count(distinct sales.order_date)
from sales
group by sales.customer_id;

-- 3. What was the first item from the menu purchased by each customer?
with cte as (
select
customer_id,
order_date,
product_name,
rank() over (partition by customer_id order by order_date asc) as rank
from sales as s
join menu as m on s.product_id=m.product_id)

select 
customer_id,
product_name
from cte
where rank=1
   
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select 
product_name,
count(order_date) as orders
from sales as s
join menu as m on s.product_id=m.product_id
group by product_name
order by orders desc
limit 1
   
-- 5. Which item was the most popular for each customer?
with cte as(
select 
customer_id,
product_name,
count(order_date) as orders,
rank() over (partition by customer_id order by count(order_date) desc) as rank
from sales as s
join menu as m on s.product_id=m.product_id
group by customer_id, product_name
)

select
customer_id,
product_name,
orders
from cte
where rank=1
   
-- 6. Which item was purchased first by the customer after they became a member?
with cte as(
select 
s.customer_id,
product_name,
order_date,
join_date,
rank() over (partition by s.customer_id order by order_date asc) as rank
from sales as s
join menu as m on s.product_id=m.product_id
join members as mem on mem.customer_id=s.customer_id
where order_date>=join_date
)

select 
customer_id,
product_name,
order_date
from cte
where rank=1
   
-- 7. Which item was purchased just before the customer became a member? **
with cte as(
select 
s.customer_id,
product_name,
order_date,
join_date,
rank() over (partition by s.customer_id order by order_date desc) as rank
from sales as s
join menu as m on s.product_id=m.product_id
join members as mem on mem.customer_id=s.customer_id
where order_date<join_date
)

select
customer_id,
product_name
from cte
where rank=1
   
-- 8. What is the total items and amount spent for each member before they became a member?
select 
s.customer_id,
count(product_name),
sum(price)
from sales as s
join menu as m on s.product_id=m.product_id
join members as mem on mem.customer_id=s.customer_id
where order_date<join_date
group by s.customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select 
customer_id,
sum(
case product_name
  when 'sushi' then price*20
  else price*10
  end
) as points
from sales as s
join menu as m on s.product_id=m.product_id
group by customer_id

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
select 
s.customer_id,
sum(
  case 
  when order_date between join_date and join_date + 6
  then price*20
  else price*10
  end)
from sales as s
join menu as m on s.product_id=m.product_id
join members as mem on mem.customer_id=s.customer_id
group by s.customer_id

--Join all the things--
select
s.customer_id,
order_date,
product_name,
price,
case 
when join_date is null then 'n'
when order_date<join_date then 'n'
else 'y'
end as member
from sales as s
join menu as m on s.product_id=m.product_id
left join members as mem on mem.customer_id=s.customer_id
