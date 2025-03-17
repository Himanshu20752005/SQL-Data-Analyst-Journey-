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


-------------------------------------------------------------------------------------------------------------------------
-- ANALYSIS & REPORT
-------------------------------------------------------------------------------------------------------------------------


-- Q.1 
-- Write a query to find the top 5 most frequently ordered dishes by customer called "Arjun Mehta" in the last 2 year.

SELECT * FROM customers;
SELECT * FROM orders;

SELECT c.customer_name,
       o.order_item,
	   COUNT(o.order_item) AS order_count
FROM orders	AS o
JOIN customers AS c
ON c.customer_id = o.customer_id
WHERE c.customer_name  = 'Arjun Mehta'   
      AND 
	  o.order_date >= CURRENT_DATE - INTERVAL '24 Months' -- Currently its 2025 and the video was uploaded for 2024 
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 5 ;

	  
  
-- Q2. Popular Time Slots 
-- Question: Identify the time slots during which the most orders are placed. based on 2-hour intervals. 


-- 3. Order Value Analysis 
-- Question: Find the average order value per customer who has placed more than 758 orders. 
-- Return customer_name, and aov (average order value)
	
