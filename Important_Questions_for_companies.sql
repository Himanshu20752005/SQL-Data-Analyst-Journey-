




SELECT 
   c.customer_id ,
   c.customer_name,
   sum(amount) as purchase_amount 
FROM Customers as c
LEFT JOIN 
sale as s
ON c.customer_id = s.customer_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5

-----------------------------------------------------------


SELECT
    customer_id,
    order_date,
    COUNT(*) AS duplicates
FROM Orders
GROUP BY 1, 2
HAVING COUNT(*) > 1;

------------------------------------------------------------

WITH Employees_detail
AS(
SELECT 
     e1.*,
     e2.employee_name as manager_name
FROM Employees as e1
LEFT JOIN Employees as e2
ON e1.manager_id = e2.employee_id
)

SELECT 
    e3.employee_id,
    e3.employee_name,
    e3.manager_name,
   d.department_name
FROM Employees_detail as e3
JOIN department as d
ON e3.department_id = d.department_id;

---------------------------------------------------------------

SELECT 
   c.category_name,
   SUM(od.quantity * od.price) as revenue
FROM Orders as o
JOIN Order_Details as od
ON o.order_id = od.order_id
JOIN Products as p
ON od.product_id = p.product_id
JOIN Categories as c
ON p.category_id = c.category_id
GROUP BY 1
ORDER BY revenue DESC;

----------------------------------------------------------------

SELECT 
    order_id,
    (delivery_date - order_date) AS days_between
FROM Orders
WHERE stauts = 'completed';   

/* (delivery_date - order_date) doesn't work in SQL/MYSQL use DATEDIFF(delivery_date , order_date) */


-----------------------------------------------------------------

SELECT 
    p.product_name,
    SUM(od.quantity) AS total_sold_quantity
FROM Products as p
JOIN 
Order_Details AS od
ON p.product_id = od.product_id
GROUP BY 1
HAVING 
    SUM(od.quantity) > 1000;

/* HAVING ki jagha WHERE Likh diya tha */

----------------------------------------------------------------- 

SELECT 
  customer_id
FROM 
Customers
WHERE email IS NULL

----------------------------------------------------------------

SELECT 
   number
FROM
Numbers
WHERE number + 1 
  
   
