######## Pizza Metric ########

-- q1.How many pizzas were ordered?
select count(order_id) from customer_orders

-- q2.How many unique customer orders were made?
select count(distinct customer_id) from customer_orders

--q3.How many successful orders were delivered by each runner?
SELECT runner_id, count(order_id) as successful_order
FROM runner_orders
where pickup_time != 'null'
GROUP BY 1
order by 2 desc;

--q4.How many of each type of pizza was delivered?
SELECT count(c.order_id) as total_order, p.pizza_name
FROM customer_orders c
join pizza_names p on p.pizza_id = c.pizza_id
group by 2

-- q5.How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id,pizza_name, count(order_id)
from pizza_names p
join customer_orders c on p.pizza_id = c.pizza_id
group by 1,2
order by customer_id

-- q6.What was the maximum number of pizzas delivered in a single order?
with total_order_cte as (
  select c.order_id, c.customer_id, count(c.pizza_id) as total_order
  from customer_orders c
  join runner_orders r on c.order_id = r.order_id
  group by 1,2
  order by 1,2
)

select *
from total_order_cte
order by total_order desc
fetch first 1 rows only

