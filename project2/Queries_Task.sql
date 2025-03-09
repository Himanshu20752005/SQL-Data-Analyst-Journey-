-- Exploring the Data
select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;

-- Taskes for the data in project
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books 
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books where isbn = '978-1-60129-456-2';


-- Task 2: Update an Existing Member's Address
select * from members

update members
set member_address = '1234 Main St'
where member_id = 'C101';

select * from members order by member_id;

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
select * from issued_status where issued_id = 'IS121' ; -- checking before deletion

delete from issued_status 
where issued_id = 'IS121';

select * from issued_status where issued_id = 'IS121' ; -- checking after deletion

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status;

select issued_emp_id , issued_book_isbn , issued_book_name
from issued_status
where issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
select * from members;
select * from issued_status;

-- with members name											 
select mem.member_id ,mem.member_name ,count(iss.issued_book_name) as num_of_books
from members as mem join issued_status as iss
on mem.member_id = iss.issued_member_id
group by mem.member_id , mem.member_name 
having COUNT(iss.issued_book_name) >= 2;

-- without members name
select * from issued_status;

select issued_member_id , count(issued_book_isbn)
from issued_status
group by 1
having count(issued_book_isbn) > 1;

-- CTAS (Create Table As Select)
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**
select * from issued_status;
select * from books;
-- we didnt used only issued_status table coz there could be books which didnt got issued
create table book_issued_count as
select b.isbn as book_isbn ,b.book_title as book_name, count(iss.issued_book_isbn) 
from books as b join issued_status as iss
on b.isbn = iss.issued_book_isbn
group by 1,2;

select * from book_issued_count;



-- Data Analysis & Findings
-- The following SQL queries were used to address specific questions:
-- Task 7. Retrieve All Books in a Specific Category:

select * from books;
select bk.category , bk.book_title
from books as bk
group by 1;


-- Task 8: Find Total Rental Income by Category:
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM issued_status as ist
JOIN books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1


-- Task 9: List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


-- Task 10 : List Employees with Their Branch Manager's Name and their branch details:

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN branch as b
ON e1.branch_id = b.branch_id    
JOIN employees as e2
ON e2.emp_id = b.manager_id


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
select * from books;

create table books_above_5 as 
select *
from books where rental_price > 5;

select * from books_above_5 order by rental_price;

-- Task 12: Retrieve the List of Books which are Returned
select * from return_status;

select bk.isbn , bk.book_title , bk.category , bk.rental_price , rs.return_date
from books as bk 
join issued_status as iss
on bk.isbn = iss.issued_book_isbn
join return_status as rs
on iss.issued_id = rs.issued_id;

-- which are not returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

