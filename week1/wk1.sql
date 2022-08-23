-- What is the total amount each customer spent at the restaurant?
select s.customer_id, sum(m.price) as total_sales
from sales s
join menu m on s.product_id = m.product_id
group by s.customer_id
order by s.customer_id

-- How many days has each customer visited the restaurant?
select customer_id , count(distinct order_date) as num_of_days
from sales
group by customer_id