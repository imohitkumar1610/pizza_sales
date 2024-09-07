-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
-- Analyze the cumulative revenue generated over time.
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
    
    SELECT 
    pizza_types.category, round(sum(order_details.quantity*pizzas.price)/(
    SELECT 
	round(sum(order_details.quantity*pizzas.price),2)
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    ) *100,2) as revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    group by pizza_types.category order by revenue desc;


select order_date, round(sum(revenue) over(order by order_date),2) as cum_revenue
from
(select orders.order_date, sum(order_details.quantity*pizzas.price) as revenue 
from order_details join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on order_details.order_id = orders.order_id
group by orders.order_date) as sales;


select name, revenue,rn
from 
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn 
from 
(
select pizza_types.category, pizza_types.name, sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as rank_table) as main_table
where rn <=3;
    
   