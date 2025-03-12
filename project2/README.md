
# Library Management System Using SQL - P2

## Project Overview
**Project Title:** Library Management System  
**Level:** Intermediate  
**Database:** `library_db`  

This project implements a **Library Management System** using **SQL**, focusing on database design, CRUD operations, advanced SQL queries, and reporting. It helps in understanding SQL concepts such as **CTAS, joins, stored procedures, and data analysis.**

## Objectives
- **Database Setup:** Create and manage a structured database with tables for branches, employees, members, books, and transaction records.
- **CRUD Operations:** Perform Create, Read, Update, and Delete operations.
- **CTAS (Create Table As Select):** Generate new tables from query results.
- **Advanced SQL Queries:** Analyze and retrieve data efficiently.

## Project Structure
### 1. Database Setup
#### Entity Relationship Diagram (ERD)
Database consists of the following tables:
- `branch`
- `employees`
- `members`
- `books`
- `issued_status`
- `return_status`
![Library_project](https://github.com/Himanshu20752005/SQL-Data-Analyst-Journey-/blob/main/project2/ER_digram.png)
                   
```sql


CREATE DATABASE library_db;

-- Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no VARCHAR(15)
);

-- Employee Table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(30),
    position VARCHAR(30),
    salary DECIMAL(10,2),
    branch_id VARCHAR(10),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

-- Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(30),
    reg_date DATE
);

-- Books Table
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(80),
    category VARCHAR(30),
    rental_price DECIMAL(10,2),
    status VARCHAR(10),
    author VARCHAR(30),
    publisher VARCHAR(30)
);

-- Issued Status Table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(30),
    issued_book_name VARCHAR(80),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(10),
    FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
    FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn)
);

-- Return Status Table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(30),
    return_book_name VARCHAR(80),
    return_date DATE,
    return_book_isbn VARCHAR(50),
    FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);
```

### 2. CRUD Operations
```sql
-- Insert a new book
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Update a member's address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

-- Delete an issued record
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

### 3. Advanced SQL Queries
```sql
-- Retrieve all books issued by a specific employee
SELECT * FROM issued_status WHERE issued_emp_id = 'E101';

-- List members who have issued more than one book
SELECT issued_emp_id, COUNT(*) FROM issued_status GROUP BY 1 HAVING COUNT(*) > 1;
```

### 4. CTAS (Create Table As Select)
```sql
-- Create a summary table for book issue counts
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status AS ist
JOIN books AS b ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```

### 5. Advanced SQL Operations
```sql
-- Identify overdue books (30-day return period)
SELECT ist.issued_member_id, m.member_name, bk.book_title, ist.issued_date, CURRENT_DATE - ist.issued_date AS overdue_days
FROM issued_status AS ist
JOIN members AS m ON m.member_id = ist.issued_member_id
JOIN books AS bk ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL AND (CURRENT_DATE - ist.issued_date) > 30;
```

### 6. Stored Procedures
```sql
-- Procedure to handle book return and update status
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql AS $$
DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
BEGIN
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT issued_book_isbn, issued_book_name INTO v_isbn, v_book_name FROM issued_status WHERE issued_id = p_issued_id;
    UPDATE books SET status = 'yes' WHERE isbn = v_isbn;
    RAISE NOTICE 'Book returned: %', v_book_name;
END;
$$;
```

### 7. Reports & Data Analysis
```sql
-- Generate branch performance report
CREATE TABLE branch_reports AS
SELECT b.branch_id, b.manager_id, COUNT(ist.issued_id) AS books_issued, COUNT(rs.return_id) AS books_returned, SUM(bk.rental_price) AS total_revenue
FROM issued_status AS ist
JOIN employees AS e ON e.emp_id = ist.issued_emp_id
JOIN branch AS b ON e.branch_id = b.branch_id
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
JOIN books AS bk ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;
```

## How to Use
```bash
# Clone the repository
git clone https://github.com/HimanshuPandey/Library-Management-SQL.git

# Set up the database
# Execute the SQL scripts in 'database_setup.sql' to create and populate the database.

# Run queries
# Use the SQL scripts in 'analysis_queries.sql' to analyze data.
```

## Conclusion
This project provides a structured approach to **database management, data manipulation, and analysis** using **SQL**. It helps in understanding real-world applications of SQL in library management systems.
```



-- nEW QUERY
