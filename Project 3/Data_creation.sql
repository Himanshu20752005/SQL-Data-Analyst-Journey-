-- Zomato Data analysis using SQL

-- START

Drop Table if Exists customers;
Drop Table if Exists restaurants;
Drop Table if Exists orders;
Drop Table if Exists riders;
Drop Table if Exists deliveries;

-- Customers Table
create table customers (
    customer_id INT primary key,
	customer_name varchar(25),
	reg_date date
);


-- Restaurants Table
create table restaurants (
    restaurant_id INT primary key ,
	restaurant_name varchar(55),
	city varchar(15),
	opening_hours varchar(55)
);


-- Order Table
create table orders (
    order_id INT primary key , 
	customer_id INT , -- Coming from Customer Table (FK)
	restaurant_id INT, -- Coming from Restaurants Table (FK)
	order_item VARCHAR(55),
	order_date DATE,
	order_time TIME,
	order_status VARCHAR(55),
	total_amount FLOAT
);




-- Riders Table
create table riders (
    rider_id INT Primary Key,
	rider_name Varchar(55),
	sign_up DATE
);


-- Deliveries Table 
create table deliveries (
    delivery_id	INT Primary Key,
	order_id INT, -- Coming from Orders Table (FK)
	delivery_status	Varchar(35), 
	delivery_time TIME,
	rider_id INT -- Coming from Riders Table (FK)
);


-- Foreign Key Constraints


-- Order Table FOREIGN KEYS
Alter table orders
Add constraint fk_customer
Foreign key (customer_id)
References customers(customer_id);

Alter table orders
Add constraint fk_restaurant
Foreign Key (restaurant_id)
References restaurants(restaurant_id);


-- Deliveries Table FOREIGN KEYS
Alter table deliveries
Add constraint fk_order
Foreign Key (order_id)
References orders(order_id);

Alter table deliveries
Add constraint fk_riders
Foreign Key (rider_id)
References riders(rider_id);


-- END 


--EXTRA 

-- Or We can add the foreign key constrainst directly during the table creation
Drop Table If Exists deliveries;

create table deliveries (
    delivery_id	INT Primary Key,
	order_id INT, -- Coming from Orders Table (FK)
	delivery_status	Varchar(35), 
	delivery_time TIME,
	rider_id INT, -- Coming from Riders Table (FK)
	constraint fk_order Foreign Key (order_id) References orders(order_id),
	constraint fk_riders Foreign Key (rider_id) References riders(rider_id)
);

