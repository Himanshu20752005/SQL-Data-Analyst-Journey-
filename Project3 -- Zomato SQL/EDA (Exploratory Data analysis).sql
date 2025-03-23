-- EDA (Exploratory Data Analysis)

SELECT * FROM customers;
SELECT * FROM restaurants;
SELECT * FROM orders;
SELECT * FROM riders;
SELECT * FROM deliveries;


-- Checking for Null values in each Table
-- Just check the Non prime Attributes


SELECT COUNT(*) FROM customers
WHERE customer_id IS NULL
      OR 
	  reg_date IS NULL;


SELECT COUNT(*) FROM restaurants
WHERE city IS NULL 
	  OR 
	  Opening_hours IS NULL
	  OR 
	  restaurant_name IS NULL;


SELECT COUNT(*)	FROM orders
WHERE order_item IS NULL
      OR 
	  order_date IS NULL
	  OR 
	  order_time IS NULL
	  OR 
	  order_status IS NULL
	  OR 
	  total_amount IS NULL;
  

SELECT COUNT(*) FROM riders
WHERE rider_name IS NULL
      OR
	  sign_up IS NULL;


SELECT COUNT(*) FROM deliveries
WHERE delivery_status IS NULL
      OR 
	  delivery_time IS NULL;


-- 0 Null Values Found Overall
-- Just to see how it would look with NULL values (Make sure to delete it afterwards)

INSERT INTO riders (rider_id , rider_name) VALUES (35 , 'Himanshu Pandey');
INSERT INTO riders (rider_id , rider_name) VALUES (36 , 'Harsh Shrivastava');
INSERT INTO riders (rider_id , rider_name) VALUES (37 , 'Romit Ghosh');


SELECT * FROM riders
WHERE rider_name IS NULL
      OR
	  sign_up IS NULL;


DELETE FROM riders
WHERE sign_up IS NULL;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ANALYSIS & REPORT
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Q.1 
-- Write a query to find the top 5 most frequently ordered dishes by customer called "Arjun Mehta" in the last 2 year.

SELECT * FROM customers;
SELECT * FROM orders;

SELECT * 
FROM
(SELECT c.customer_name,
       o.order_item AS Dishes,
	   COUNT(o.order_item) AS order_count,
	   DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS rank
FROM orders	AS o
JOIN customers AS c
ON c.customer_id = o.customer_id
WHERE c.customer_name  = 'Arjun Mehta'   
      AND 
	  o.order_date >= CURRENT_DATE - INTERVAL '24 Months'
GROUP BY 1 , 2
ORDER BY 3 DESC ) AS t1
WHERE rank <= 5;


-- OR (Simpler)


SELECT c.customer_name,
       o.order_item AS Dishes,
	   COUNT(o.order_item) AS order_count
FROM orders	AS o
JOIN customers AS c
ON c.customer_id = o.customer_id
WHERE c.customer_name  = 'Arjun Mehta'   
      AND 
	  o.order_date >= CURRENT_DATE - INTERVAL '24 Months'
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 5 ;
	  
  
-- Q2. Popular Time Slots 
-- Question: Identify the time slots during which the most orders are placed. based on 2-hour intervals. 


SELECT * FROM orders;

SELECT 
       CASE
	     WHEN EXTRACT (HOUR FROM order_time)BETWEEN 0 AND 1 THEN '00:00 - 02:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 2 AND 3 THEN '02:00 - 04:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 4 AND 5 THEN '04:00 - 06:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 6 AND 7 THEN '06:00 - 08:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 8 AND 9 THEN '08:00 - 10:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 10 AND 11 THEN '10:00 - 12:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 12 AND 13 THEN '12:00 - 14:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 14 AND 15 THEN '14:00 - 16:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 16 AND 17 THEN '16:00 - 18:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 18 AND 19 THEN '18:00 - 20:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 20 AND 21 THEN '20:00 - 22:00'
		 WHEN EXTRACT (HOUR FROM order_time)BETWEEN 22 AND 23 THEN '22:00 - 24:00'
	   END AS start_slot,	 
       COUNT(*) AS Total_Orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


-- OR 

-- if order time is 23:32 then we extract hours from it i.e 23 (EXTRACT(HOUR FROM order_time)
-- 23/2 = 11.5 
-- FLOOR of 11.5 is 11 (i.e the starting Value)
-- 11 + 2 is 13 (i.e the ending Value)

SELECT 
   FLOOR (EXTRACT(HOUR FROM order_time)/2)*2 AS starting_hour,
   FLOOR (EXTRACT(HOUR FROM order_time)/2)*2 +2 AS ending_hour,
   COUNT(*) AS Total_Orders
FROM orders
GROUP BY 1,2
ORDER BY 3 DESC;


-- Q3. Order Value Analysis 
-- Question: Find the average order value per customer who has placed more than 300 orders. 
-- Return customer_name, and aov (average order value)

SELECT * FROM orders;
SELECT * FROM customers;

SELECT 
   c.customer_name ,
   COUNT(o.order_item) AS total_orders,
   AVG(o.total_amount) AS average_order_values
FROM orders AS o
JOIN 
customers AS c
ON o.customer_id = c.customer_id
GROUP BY 1
HAVING COUNT(o.order_item)>300 
ORDER BY 3 DESC;

--AND o.order_status = 'Completed' 

-- Q4. High-Value Customers 
-- Question: List the customers who have spent more than 100K in total on food orders. 
-- return customer_name, and customer_id


SELECT 
   c.customer_id,
   c.customer_name ,
   COUNT(o.order_item) AS total_orders,
   SUM(o.total_amount) AS total_values
FROM orders AS o
JOIN 
customers AS c
ON o.customer_id = c.customer_id
GROUP BY 1
HAVING SUM(o.total_amount)>100000
ORDER BY 3 DESC;

-- Q5. Orders Without Delivery 
-- Question: Write a query to find orders that were placed but not delivered. 
-- Return each restuarant name, city and number of not delivered orders

SELECT * FROM restaurants;
SELECT * FROM orders;
SELECT * FROM deliveries;

SELECT 
    r.restaurant_name,
    r.city,
    COUNT(o.order_id) AS not_delivered_orders
FROM orders AS o
JOIN  
restaurants AS r
ON r.restaurant_id = o.restaurant_id
LEFT JOIN 
deliveries AS d
ON o.order_id = d.order_id
WHERE d.delivery_id IS NULL
GROUP BY 1,2
ORDER BY 3 DESC;

-- Q.6 
-- Restaurant Revenue Ranking: 
-- Rank restaurants by their total revenue from the last 2 year, including their name, 
-- totax revenue, and rank within their city. 


SELECT * FROM restaurants;
SELECT * FROM orders;

WITH ranking_table 
AS
(SELECT 
     r.city,
     r.restaurant_name,
     SUM(o.total_amount) AS total_revenue,
	 RANK () OVER(PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS rank
FROM
orders AS o
JOIN 
restaurants AS r
ON r.restaurant_id = o.restaurant_id
WHERE order_date >= CURRENT_DATE - INTERVAL '2 Years' 
      AND 
	  order_status = 'Completed' -- Its imported to consider the amounts from those orders that got completed 
GROUP BY 1,2
)

SELECT * 
FROM ranking_table 
WHERE rank = 1;


-- Q. 7 
-- Most Popular Dish by City: 
-- Identify the most popular dish in each city based on the number of orders

SELECT *
FROM
(
SELECT 
   r.city,
   o.order_item as Dishes,
   COUNT(order_id) as total_order,
   RANK() OVER(PARTITION BY r.city ORDER BY COUNT(order_id) DESC) AS rank
FROM orders AS o
JOIN
restaurants as r
ON r.restaurant_id = o.restaurant_id
GROUP BY 1,2
ORDER BY 3 DESC
) AS t1
WHERE rank = 1;


-- Q.8 Customer Churn: 
-- Find customers who haven't placed an order in 2024 but did in 2023.

SELECT  
    DISTINCT
    c.customer_id ,
	c.customer_name
FROM orders AS o
JOIN 
customers AS c
ON o.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM  order_date) = 2023
      AND 
	  c.customer_id NOT IN (
                           SELECT DISTINCT customer_id
						   FROM orders
						   WHERE EXTRACT(YEAR FROM order_date) = 2024
	  )

;



-- Q.9 Cancellation Rate Comparison: 
-- Calculate & compare the order cancellation rate for each restaurant between the current year and the previous year.
-- My data have a lot o cancelled orders (since i generated the data from ChatGBT .. its randome)

SELECT * FROM restaurants;
SELECT * FROM deliveries;
SELECT * FROM orders;

WITH cancel_ratio_2023
AS
(
SELECT 
     o.restaurant_id,
	 COUNT(o.order_id) as Total_orders,
	 COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS Cancelled_orders
FROM orders AS o
LEFT JOIN
deliveries AS d
ON o.order_id  =  d.order_id
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY 1),

cancel_ratio_2024
AS
(
SELECT 
     o.restaurant_id,
	 COUNT(o.order_id) as Total_orders,
	 COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS Cancelled_orders
FROM orders AS o
LEFT JOIN
deliveries AS d
ON o.order_id  =  d.order_id
WHERE EXTRACT(YEAR FROM order_date) = 2024
GROUP BY 1)

SELECT 
     c1.restaurant_id,
	 c1.Total_orders AS Total_Orders_2023, 
	 c1.Cancelled_orders AS Cancelled_Orders_2023,
	 ROUND( (c1.Cancelled_orders :: Numeric /c1.Total_orders :: Numeric) * 100 ,2)AS cancellation_rate_2023,
	 
	 c2.Total_orders AS Total_Orders_2024,
	 c2.Cancelled_orders AS Cancelled_Orders_2024,
	 ROUND( (c2.Cancelled_orders :: Numeric /c2.Total_orders :: Numeric) * 100 ,2 ) AS cancellation_rate_2024
FROM cancel_ratio_2023 As c1
LEFT JOIN
cancel_ratio_2024 As c2
ON c1.restaurant_id = c2.restaurant_id 
ORDER BY 1;

-- The values where we get null in 2024 are those restaurants where order in not placed till now


-- Q10 Rider Average delivery time	   
-- Determine Each Rider's Average delivery time.

SELECT * FROM deliveries;
SELECT * FROM orders;

SELECT
	 d.rider_id,
	 o.order_time,
	 d.delivery_time ,
	 d.delivery_time - o.order_time AS Average_delivery_time
FROM
orders AS o
JOIN
deliveries AS d
ON o.order_id = d.delivery_id
WHERE d.delivery_status = 'Delivered'
ORDER BY 1;
	 

