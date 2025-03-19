# Zomato Data Analysis using SQL

## 📌 Project Overview (Level : Hard)
This project involves analyzing Zomato's food delivery data using SQL. It includes database schema design, creating relational tables, and enforcing foreign key constraints. The dataset contains information about customers, restaurants, orders, riders, and deliveries.

## 🗄 Database Schema
The project consists of the following tables:

1. **Customers** – Stores customer details and registration date.
2. **Restaurants** – Contains restaurant details, including city and operating hours.
3. **Orders** – Stores customer orders, order status, and total amount.
4. **Riders** – Stores rider details and sign-up date.
5. **Deliveries** – Tracks order deliveries, including status and assigned rider.

## 🏗 ER Diagram
![ER Diagram](https://github.com/Himanshu20752005/SQL-Data-Analyst-Journey-/blob/main/Project3%20--%20Zomato%20SQL/ER_Diagram/ER_Diagram.png)


## 🛠 SQL Implementation
### 🔹 Table Creation
The project creates normalized tables with primary keys and relationships:
- **Foreign Key Constraints** are added to maintain referential integrity.
- **Cascading Deletions** ensure consistency across tables.

### 🔹 Queries Used
- Data extraction for business insights
- Customer behavior analysis
- Restaurant performance analysis
- Order and delivery tracking

## 🚀 Getting Started
To run this project:
1. Install a database management system (e.g., MySQL, PostgreSQL).
2. Execute the SQL script provided in `zomato_analysis.sql`.
3. Run queries to analyze the dataset.

## 📊 Insights Derived
- Most ordered food items and high-revenue restaurants.
- Peak order times and delivery performance.
- Customer retention and ordering trends.

## 📂 Project Structure
