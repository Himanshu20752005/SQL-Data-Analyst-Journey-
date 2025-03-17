# Retail Sales Analysis SQL Project

## Project Overview

**Project Title:** Retail Sales Analysis  
**Level:** Beginner  
**Database:** p1_retail_db  

This project showcases SQL skills and techniques commonly used by data analysts to explore, clean, and analyze retail sales data. It involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering business questions using SQL queries. This project is ideal for beginners looking to build a strong foundation in SQL.

## Objectives
- **Set up a retail sales database:** Create and populate a database with the provided sales data.
- **Data Cleaning:** Identify and remove records with missing or null values.
- **Exploratory Data Analysis (EDA):** Perform basic EDA to understand the dataset.
- **Business Analysis:** Use SQL queries to derive insights from the sales data.

---

## Project Structure

### 1. Database Setup

Create a database named `p1_retail_db` and a table named `retail_sales` to store the sales data.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,    
    sale_time TIME,
    customer_id INT,    
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,    
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- Determine total records:
  ```sql
  SELECT COUNT(*) FROM retail_sales;
  ```
- Count unique customers:
  ```sql
  SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
  ```
- Identify unique product categories:
  ```sql
  SELECT DISTINCT category FROM retail_sales;
  ```
- Check for null values and remove records with missing data:
  ```sql
  SELECT * FROM retail_sales
  WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
        gender IS NULL OR age IS NULL OR category IS NULL OR 
        quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
  
  DELETE FROM retail_sales
  WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
        gender IS NULL OR age IS NULL OR category IS NULL OR 
        quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
  ```

### 3. Data Analysis & Findings

**Key SQL Queries:**

- Retrieve sales data for `2022-11-05`:
  ```sql
  SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
  ```
- Find transactions where category is 'Clothing' and quantity sold is more than 4 in Nov 2022:
  ```sql
  SELECT * FROM retail_sales
  WHERE category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;
  ```
- Calculate total sales for each category:
  ```sql
  SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
  FROM retail_sales
  GROUP BY category;
  ```
- Find average age of customers purchasing from 'Beauty' category:
  ```sql
  SELECT ROUND(AVG(age), 2) AS avg_age FROM retail_sales WHERE category = 'Beauty';
  ```
- Find transactions where total_sale is greater than 1000:
  ```sql
  SELECT * FROM retail_sales WHERE total_sale > 1000;
  ```
- Count transactions by gender and category:
  ```sql
  SELECT category, gender, COUNT(*) AS total_trans
  FROM retail_sales
  GROUP BY category, gender
  ORDER BY category;
  ```
- Find the best-selling month in each year:
  ```sql
  SELECT year, month, avg_sale FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           AVG(total_sale) AS avg_sale,
           RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
  ) AS ranked_data
  WHERE rank = 1;
  ```
- Find top 5 customers based on total sales:
  ```sql
  SELECT customer_id, SUM(total_sale) AS total_sales
  FROM retail_sales
  GROUP BY customer_id
  ORDER BY total_sales DESC
  LIMIT 5;
  ```
- Find the number of unique customers per category:
  ```sql
  SELECT category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
  FROM retail_sales
  GROUP BY category;
  ```
- Create shifts (Morning, Afternoon, Evening) and count orders per shift:
  ```sql
  WITH hourly_sale AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
  )
  SELECT shift, COUNT(*) AS total_orders FROM hourly_sale GROUP BY shift;
  ```

---

## Findings
- **Customer Demographics:** Customers from various age groups contribute to sales across multiple categories.
- **High-Value Transactions:** Some transactions exceed 1000 in total sales, indicating premium purchases.
- **Sales Trends:** Identifying peak sales months helps understand seasonal trends.
- **Customer Insights:** Recognizing top customers and popular product categories provides valuable business insights.

## Reports
- **Sales Summary:** Detailed report on total sales, customer demographics, and category performance.
- **Trend Analysis:** Sales trends across different months and shifts.
- **Customer Insights:** Reports on top customers and unique customer counts per category.

## Conclusion
This project provides a comprehensive introduction to SQL for data analysis, covering database setup, data cleaning, exploratory analysis, and business-driven queries. The insights gained can help businesses understand sales patterns, customer behavior, and product performance.

---

## Author
**Himanshu Pandey**  
[GitHub](https://github.com/Himanshu20752005) | [LinkedIn](https://linkedin.com/in/himanshu-pandey-9419a9276)  

Feel free to reach out for any questions or improvements!
