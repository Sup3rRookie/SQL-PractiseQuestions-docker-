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
