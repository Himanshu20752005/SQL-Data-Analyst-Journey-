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
