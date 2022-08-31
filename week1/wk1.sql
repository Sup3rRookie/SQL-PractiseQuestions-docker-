-- q1.What is the total amount each customer spent at the restaurant?
select s.customer_id, sum(m.price) as total_sales
from sales s
join menu m on s.product_id = m.product_id
group by s.customer_id
order by s.customer_id

-- q2.How many days has each customer visited the restaurant?
select customer_id , count(distinct order_date) as num_of_days
from sales
group by customer_id

-- q3.What was the first item from the menu purchased by each customer?
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

-- q4.What is the most purchased item on the menu and how many times was it purchased by all customers?
select  m.product_name,  count(m.product_id) as num_of_items
from sales s
join menu m on s.product_id = m.product_id
group by 1
order by num_of_items desc
limit 1

-- q5.Which item was the most popular for each customer?
select customer_id , product_name
from
(
  select s.customer_id, m.product_name, count(m.product_id), rank () over (partition by customer_id order by count(s.customer_id) desc) as rank
  from sales s
  join menu m on s.product_id = m.product_id
  group by 1,2
  order by s.customer_id
) x
where x.rank = 1

-- Using CTE
WITH top_selling_food_cte as (
  select s.customer_id, m.product_name, count(m.product_id) as count_food_ordered, rank () over (partition by customer_id order by count(s.customer_id) desc) as rank
  from sales s
  join menu m on s.product_id = m.product_id
  group by 1,2
  order by s.customer_id
)

select customer_id , product_name , count_food_ordered
from top_selling_food_cte
where rank = 1

-- q6.Which item was purchased first by the customer after they became a member?
WITH food_order_cte as (
  select s.customer_id,s.product_id, s.order_date, m.join_date, dense_rank() over(partition by s.customer_id order by s.order_date) as rank
  from  dannys_diner.sales s
  join dannys_diner.members m on s.customer_id = m.customer_id
  where s.order_date > m.join_date
  group by 1,2,3,4
  order by order_date
)

select f.customer_id , f.product_id, m.product_name, f.order_date, f.rank
from food_order_cte f
left join dannys_diner.menu m on f.product_id = m.product_id
where rank = 1

-- q7.Which item was purchased just before the customer became a member?
WITH food_order_cte as (
  select s.customer_id,s.product_id, s.order_date, m.join_date, dense_rank() over(partition by s.customer_id order by s.order_date) as rank
  from  dannys_diner.sales s
  join dannys_diner.members m on s.customer_id = m.customer_id
  where s.order_date < m.join_date
  group by 1,2,3,4
  order by order_date
)

select f.customer_id , m.product_name, f.order_date, f.rank
from food_order_cte f
left join dannys_diner.menu m on f.product_id = m.product_id
where rank = 1

-- q8.What is the total items and amount spent for each member before they became a member?
select s.customer_id , sum(m.price) as total_sales
from dannys_diner.sales s
join dannys_diner.menu m on s.product_id = m.product_id
join dannys_diner.members mb on s.customer_id = mb.customer_id
where s.order_date < mb.join_date
group by 1
order by 1

-- q9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select x.customer_id, sum(x.points) as total_points
from
  (select s.customer_id, m.price, m.product_name,
  case
    when product_name = 'curry' then (price*10)
    when product_name = 'sushi' then (price*10*2)
    when product_name = 'ramen' then (price*10)
  end as points
  from dannys_diner.sales s
  join dannys_diner.menu m on s.product_id = m.product_id
  order by customer_id) x
group by 1
order by total_points desc

-- alternate solution using CTE
WITH total_points_cte as (
  select s.customer_id, m.price, m.product_name,
  case
    when product_name = 'curry' then (price*10)
    when product_name = 'sushi' then (price*10*2)
    when product_name = 'ramen' then (price*10)
  end as points
  from dannys_diner.sales s
  join dannys_diner.menu m on s.product_id = m.product_id
  order by customer_id
)

select customer_id, sum(points) as total_points
from total_points_cte
group by 1
order by 2 desc