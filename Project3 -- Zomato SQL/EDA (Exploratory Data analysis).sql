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




-- 3. Order Value Analysis 
-- Question: Find the average order value per customer who has placed more than 758 orders. 
-- Return customer_name, and aov (average order value)






