-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
-- Determine the distribution of orders by hour of the day.
-- Join relevant tables to find the category-wise distribution of pizzas.
-- Group the orders by date and calculate the average number of pizzas ordered per day.
-- Determine the top 3 most ordered pizza types based on revenue.
use pizzahut;
SELECT 
    pizza_types.category, SUM(order_details.quantity) AS qty
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY qty DESC;

SELECT 
    HOUR(order_time) AS orders_per_hour,
    COUNT(order_id) AS orders
FROM
    orders
GROUP BY orders_per_hour
ORDER BY orders_per_hour;


SELECT 
    pizza_types.category, COUNT(pizza_types.name) count
FROM
    pizza_types
GROUP BY category;


SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS quantity_ordered;
    
    select pizza_types.name, round(sum(order_details.quantity*pizzas.price),2) as revenue
   FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    group by pizza_types.name order by revenue desc limit 3;