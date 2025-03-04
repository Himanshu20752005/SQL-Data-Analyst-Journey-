create database SQL_p1;
use SQL_p1;

# drop table if exist retail_sales;

create table retail_sales(
  transactions_id INT primary key,
  sale_date date,
  sale_time time,
  customer_id int,
  gender varchar(15),
  age int,
  category varchar(15),
  quantiy int,
  price_per_unit float,
  cogs float,
  total_sale float
);

alter table retail_sales change column quantiy quantity INT;

select * from retail_sales limit 5;

select count(*) from retail_sales;

select * from retail_sales where transactions_id is NULL;
select * from retail_sales where sale_date is NULL;                                 


-- data cleaning 

select * from retail_sales where transactions_id is NULL or
sale_date is NULL     or       sale_time is NUll or
customer_id is NUll   or       gender is NUll or
age is NUll           or       category is NUll or
quantiy is NUll       or       price_per_unit is NUll or
cogs is NUll          or       total_sale is NUll ;
      
      
SET SQL_SAFE_UPDATES = 0;
      
delete from retail_sales
where transactions_id is NULL or
sale_date is NULL     or       sale_time is NULL or
customer_id is NULL   or       gender is NULL or
age is NULL           or       category is NULL or
quantiy is NULL       or       price_per_unit is NULL or
cogs is NULL          or       total_sale is NULL ;	

SET SQL_SAFE_UPDATES = 1;


-- data exploration

-- 1. total unique customers from retail
select count(distinct customer_id) as total_unique_customer from retail_sales;

select distinct customer_id as total_unique_customer from retail_sales;

select distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
   select * from retail_sales where sale_date = '2022-11-05';
   
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
   select * from retail_sales where category = 'Clothing' AND quantity > 3 AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
   select * from retail_sales where category = 'Clothing' AND quantity > 3 AND year(sale_date)='2022' AND month(sale_date)='11';
   
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
   select category , sum(total_sale) as net_sale , count(*) as total_order from retail_sales group by category;
   
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
   select round(avg(age)) from retail_sales where category='Beauty' ;
   
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
   select * from retail_sales where total_sale > 1000;
   
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
   select category , gender ,count(transaction_id) as Total_transactions group by gender , category order by 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
   select year(sale_date),month(sale_date) ,avg(total_sale) from retail_sales group by 1 ,2 order by 1, 2 DESC ;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
   select customer_id , sum(total_sale) as total_sales from retail_sales group by 1 order by 2 DESC limit 5;
   
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
   select category , count(distinct customer_id) as cnt_unique_cs from retail_sales group by category;
   
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
   
   with hourly_sale as(
   select *,
   case
	   when hour(sale_time) < 12 then 'Morning'
       when hour(sale_time) between 12 and 17 then 'Evening'
       else 'Afternoon'
     end as shift  
   from retail_sales
)
select shift , count(total_sale) from hourly_sale group by 1 ;


-- Q customer who bought from every id ;
   select distinct category from retail_sales ;
   select customer_id , count(distinct category) as tot_category from retail_sales group by 1 having tot_category = 3;
