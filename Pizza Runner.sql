-- QUERY A1 SOLUTION
-- I had to clean the table first and change the "null" string values in the [extras] & [exclusion] column to actual NULL values

-- setting the 'null' string values for the exclusions column to actual NULL
UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions IN('null', '');

-- setting the 'null' string values for the extras column to actual NULL
UPDATE customer_orders
SET extras = NULL
WHERE extras IN('null', '');

SELECT COUNT(order_id) AS no_of_pizza_order
FROM customer_orders;

-- From the result we can see that 14 pizzas were ordered in total.


-- QUERY A2 SOLUTION

SELECT COUNT(DISTINCT order_id) AS no_of_unique_orders
FROM customer_orders;

-- We have 10 unique customer orders

-- QUERY A3 SOLUTION

-- Cleaned the first to get all the NULL values in the correct form/format instead of as string

UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation IN('null', '');

-- Pulling out all the successful order count for each runner

SELECT runner_id,
                COUNT(runner_id) AS sucessful_orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- We can see that runner 1 has the most successful orders

-- QUERY A4 SOLUTION

SELECT p.pizza_name,
                COUNT(pizza_id) AS sucessful_orders
FROM runner_orders o
JOIN customer_orders c USING(order_id)
JOIN pizza_names p USING(pizza_id)
WHERE cancellation IS NULL
GROUP BY pizza_id;

-- We can see from the result that the Meatlover pizza has more successful deliveries

-- QUERY A5 SOLUTION

SELECT c.customer_id, 
		p.pizza_name,
		COUNT(p.pizza_name) AS pizza_type_count
FROM customer_orders c
JOIN pizza_names p USING(pizza_id)
GROUP BY c.customer_id, p.pizza_id
ORDER BY customer_id;

-- Just from the result we can see thatthe Meatlover pizza is quite popular among the customers

-- QUERY A6 SOLUTION

SELECT c.order_id,
		COUNT(c.order_id) AS no_of_orders
FROM customer_orders c
JOIN runner_orders r USING(order_id)
WHERE r.cancellation IS NULL
GROUP BY order_id
ORDER BY no_of_orders DESC;

-- We can see that order_id 4 has the most pizza delivered in  one order

-- QUERY A7 SOLUTION

-- When there is no change in the delivered pizza
SELECT c.customer_id,
		c.order_id,
		COUNT(c.order_id) AS pizzas_without_change
FROM customer_orders c
JOIN runner_orders r USING(order_id)
WHERE r.cancellation IS NULL 
AND exclusions IS NULL 
AND extras IS NULL
GROUP BY c.customer_id;

-- When there's at least 1 change in the pizza
SELECT c.customer_id,
		c.order_id,
		COUNT(c.order_id) AS pizzas_with_change
FROM customer_orders c
JOIN runner_orders r USING(order_id)
WHERE r.cancellation IS NULL 
AND exclusions IS NOT NULL 
OR extras IS NOT NULL
GROUP BY c.customer_id;

-- After going through both tables we can see that there is more pizza with at least 1 change than pizza's without change

-- QUERYA8 SOLUTION

SELECT c.customer_id,
		c.order_id,
		COUNT(c.order_id) AS pizzas_with_both_change
FROM customer_orders c
JOIN runner_orders r USING(order_id)
WHERE r.cancellation IS NULL 
AND exclusions IS NOT NULL 
AND extras IS NOT NULL
GROUP BY c.customer_id;

-- We can see that order_id 10 is the only succesful order with both kind  of change(exclusion & extras)

-- QUERY A9 SOLUTION

SELECT CONCAT(HOUR(order_time), ':00') AS order_time,
		COUNT(order_id) AS no_of_orders
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY no_of_orders DESC;

-- From the result we can safely say there's more orders at night

-- QUERY A10 SOLUTION

SELECT DAYNAME(order_time) AS order_day, 
		COUNT(order_id) AS no_of_orders
FROM customer_orders
GROUP BY DAYNAME(order_time)
ORDER BY no_of_orders DESC;

-- Wednesdays and Saturdays seems to be the highest selling days

-- QUERY B1 SOLUTION

SELECT *
FROM runners
WHERE registration_date BETWEEN '2021-01-01' AND '2021-01-07';

-- We have just 2 runners that signed up on the first week

-- QUERY B2 SOLUTION
-- First we clean the runner_order table to fix the NULL values
UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null';

-- Finding the average pickup_time
SELECT r.runner_id,
		c.order_id,
		CONCAT(ROUND(AVG(TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time)), 0), ' mins') AS average_pickup_time
FROM customer_orders c
JOIN runner_orders r USING(order_id)
WHERE pickup_time IS NOT NULL
GROUP BY r.runner_id
ORDER BY average_pickup_time DESC;

-- From the result runner_id 3 is the fastest at pickup

-- QUERY B3 SOLUTION

SELECT r.runner_id,
                COUNT(c.order_id) AS no_of_orders,
		CONCAT(ROUND(AVG(TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time)), 0), ' mins') AS average_pickup_time
FROM customer_orders c
JOIN runner_orders r USING(order_id)
WHERE pickup_time IS NOT NULL
GROUP BY r.runner_id
ORDER BY average_pickup_time DESC;

-- Yes there is a relationship between the no of pizza ordered and the time it ts=akes to pickup

-- QUERY B4 SOLUTION

-- Cleaning the data to correct the 'null' values for the distance column
UPDATE runner_orders
SET distance = NULL
WHERE distance = 'null';

-- Finding the average delivery time for each customer

SELECT c.customer_id,
                CONCAT(ROUND(AVG(distance), 1), ' KM') AS avg_distance
FROM runner_orders r
JOIN customer_orders c USING(order_id)
GROUP BY customer_id
ORDER BY avg_distance DESC;

-- Customer_id 105 has the longest delivery time

-- QUERY B5 SOLUTION

-- Cleaning the data to correct the 'null' values for the durations column
UPDATE runner_orders
SET duration = NULL
WHERE duration = 'null';

-- Finding the difference between the longest and shortest delivery
SELECT r.order_id,
                c.exclusions,
                c.extras,
                r.distance,
                CONCAT(SUBSTR(r.duration, 1, 2), 'mins') AS duration
FROM runner_orders r
JOIN customer_orders c USING(order_id)
WHERE r.duration IS NOT NULL
AND r.cancellation IS NULL
GROUP BY r.order_id
ORDER BY r.duration DESC;

-- From the result we can at least say the distance travelled was the major factor

-- QUERY B6 SOLUTION

SELECT r.runner_id,
		c.order_id,
                CONCAT(ROUND(AVG(r.distance / r.duration), 1), ' km/hr') AS avg_speed
FROM runner_orders r
JOIN customer_orders c USING(order_id)
WHERE r.cancellation IS NULL
GROUP BY r.runner_id, r.order_id
ORDER BY avg_speed DESC;

-- Runner 2 has the fastest delivery speed

-- QUERY B7 SOLUTION
