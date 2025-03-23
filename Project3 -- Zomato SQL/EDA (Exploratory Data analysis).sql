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
-- Determine Each Rider's delivery time for each order.

SELECT * FROM deliveries;
SELECT * FROM orders;

SELECT 
   o.order_id, 
   o.order_time, 
   d.delivery_time, 
   d.rider_id, 
   d.delivery_time - o.order_time AS time_difference, 
   EXTRACT(EPOCH FROM (
       d.delivery_time - o.order_time + 
       CASE WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day' ELSE INTERVAL '0 second' END
   ))/3600 AS time_difference_in_Hours 
FROM orders AS o 
JOIN deliveries AS d 
ON o.order_id = d.order_id 
WHERE d.delivery_status = 'Delivered'
ORDER BY 4;


-- Q11 Monthly Restaurants growth
-- Calculate each restaurants growth ratio based on the total numbers of deliveries since joining


WITH growth_ratio AS (
    SELECT 
        o.restaurant_id,
        TO_CHAR(o.order_date, 'mm-yy') AS month,
        COUNT(o.order_id) AS cr_month_orders,
        LAG(COUNT(o.order_id), 1) OVER(
            PARTITION BY o.restaurant_id 
            ORDER BY TO_CHAR(o.order_date, 'mm-yy')
        ) AS prev_month_orders
    FROM orders AS o
    JOIN deliveries AS d 
        ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
    GROUP BY 1, 2
    ORDER BY 1, 2
)

SELECT 
    restaurant_id,
    month,
    prev_month_orders,
    cr_month_orders,
    ROUND((cr_month_orders::numeric - prev_month_orders::numeric)/prev_month_orders::numeric * 100, 2) AS growth_ratio
FROM growth_ratio;



-- Q.12 Customer Segmentation:  
-- Customer Segmentation: Segment customers into 'Gold' or 'Silver' groups based on their total spending  
-- compared to the average order value (AOV). If a customer's total spending exceeds the AOV,  
-- label them as 'Gold'; otherwise, label them as 'Silver'. Write an SQL query to determine each segment's  
-- total number of orders and total revenue.  

-- Step 1: Calculate total spending and total orders per customer  
-- Step 2: Determine the AOV (Average Order Value)  
-- Step 3: Classify customers as 'Gold' or 'Silver' based on their total spending  
-- Step 4: Aggregate results by category to get total orders and total revenue  

SELECT 
    cx_category,
    SUM(total_orders) AS total_orders,
    SUM(total_spent) AS total_revenue
FROM (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent,
        COUNT(order_id) AS total_orders,
        CASE 
            WHEN SUM(total_amount) > (SELECT AVG(total_amount) FROM orders) THEN 'Gold'
            ELSE 'Silver'
        END AS cx_category
    FROM orders
    GROUP BY 1
) AS t1
GROUP BY 1;


SELECT AVG(total_amount) FROM orders;  -- 322


-- Q13 Riders Monthly Earnings:
-- Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.

SELECT 
    d.rider_id,  
    TO_CHAR(o.order_date, 'mm-yy') AS month, 
    SUM(total_amount) AS revenue,  
    SUM(total_amount) * 0.08 AS riders_earning 
FROM orders AS o  
JOIN deliveries AS d  
ON o.order_id = d.order_id  
GROUP BY 1, 2  
ORDER BY 1, 2; 


-- Q.14 Rider Ratings Analysis:
-- Find the number of 5-star, 4-star, and 3-star ratings each rider has.
-- Riders receive this rating based on delivery time.
-- If orders are delivered in less than 15 minutes of order received time, the rider gets a 5-star rating.
-- If they deliver between 15 and 20 minutes, they get a 4-star rating.
-- If they deliver after 20 minutes, they get a 3-star rating.


SELECT 
    rider_id,
    stars,
    COUNT(*) AS total_stars
FROM 
    (SELECT 
        rider_id,
        delivery_took_time,
        CASE 
            WHEN delivery_took_time < 15 THEN '5 star'
            WHEN delivery_took_time BETWEEN 15 AND 20 THEN '4 star'
            ELSE '3 star'
        END AS stars
    FROM 
        (SELECT 
            o.order_id,
            o.order_time,
            d.delivery_time,
            EXTRACT(EPOCH FROM (d.delivery_time - o.order_time + 
                CASE 
                    WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day' 
                    ELSE INTERVAL '0 day' 
                END
            )) / 60 AS delivery_took_time,
            d.rider_id
        FROM orders AS o
        JOIN deliveries AS d
        ON o.order_id = d.order_id
        WHERE delivery_status = 'Delivered'
        ) AS t1
    ) AS t2
GROUP BY 1,2
ORDER BY 1,2;


-- Q.15 Order Frequency by Day:
-- Analyze order frequency per day of the week and identify the peak day for each restaurant.


SELECT * FROM 
(
    SELECT 
        r.restaurant_name,
        TO_CHAR(o.order_date, 'Day') AS day,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER(PARTITION BY r.restaurant_name ORDER BY COUNT(o.order_id) DESC) AS rank
    FROM orders AS o
    JOIN restaurants AS r 
    ON o.restaurant_id = r.restaurant_id
    GROUP BY 1, 2
    ORDER BY 1, 3 DESC
) AS t1
WHERE rank = 1;


-- Q.16 Customer Lifetime Value (CLV):
-- Calculate the total revenue generated by each customer over all their orders.

SELECT 
    o.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS CLV
FROM orders AS o
JOIN customers AS c 
ON o.customer_id = c.customer_id
GROUP BY 1, 2;

-- Q.17 Monthly Sales Trends:
-- Identify sales trends by comparing each month's total sales to the previous month.

SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(total_amount) AS total_sale,
    LAG(SUM(total_amount), 1) OVER ( ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
    ) AS prev_month_sale
FROM orders
GROUP BY 1, 2;




-- Q.18 Rider Efficiency:
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest 
-- and highest averages.

WITH new_table AS (
    SELECT 
        d.rider_id AS rider_id, 
        (EXTRACT(EPOCH FROM (d.delivery_time - o.order_time)) / 60) AS time_deliver 
    FROM orders AS o 
    JOIN deliveries AS d  
        ON o.order_id = d.order_id 
    WHERE d.delivery_status = 'Delivered'
) 
SELECT 
    rider_id, 
    AVG(time_deliver) AS avg_delivery_time 
INTO riders_time 
FROM new_table 
GROUP BY rider_id;


SELECT 
    MIN(avg_delivery_time) AS min_avg_time,
    MAX(avg_delivery_time) AS max_avg_time
FROM riders_time;




-- Q.19 Order Item Popularity: 
-- Track the popularity of specific order items over time and identify seasonal demand spikes. 

WITH season_table AS (
    SELECT 
        order_id, 
        order_item,
        EXTRACT(MONTH FROM order_date) AS month, 
        CASE 
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6 THEN 'Spring' 
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 9 THEN 'Summer' 
            ELSE 'Winter' 
        END AS seasons 
    FROM orders
) 
SELECT 
    order_item, 
    seasons, 
    COUNT(order_id) AS total_orders 
FROM season_table 
GROUP BY 1,2
ORDER BY 1,3 DESC;


-- Q.20 Monthly Restaurant Growth Ratio: 
-- Calculate each restaurant's growth ratio based on the total number of delivered orders since its joining

SELECT 
    r.city, 
    SUM(o.total_amount) AS total_revenue, 
    RANK() OVER(ORDER BY SUM(o.total_amount) DESC) AS city_rank 
FROM orders AS o 
JOIN restaurants AS r 
ON o.restaurant_id = r.restaurant_id 
GROUP BY r.city;

-- Completed
