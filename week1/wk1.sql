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

-- What was the first item from the menu purchased by each customer?
select x.customer_id, x.product_name
from
  (
    select s.customer_id, s.order_date , m.product_name,
    DENSE_RANK() OVER(partition by customer_id ORDER BY s.order_date) AS rank
    from sales s
    join menu m on s.product_id = m.product_id
  ) x
where x.rank = 1
group by x.customer_id, x.product_name
