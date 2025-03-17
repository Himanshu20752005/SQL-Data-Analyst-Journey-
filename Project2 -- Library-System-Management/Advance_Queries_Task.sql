-- ADVANCE SQL QUERIES


-- Task 13: Identify Members with Overdue Books 
/* Write a query to identify members who have overdue books (assume a 30-day return period).
   Display the member's_id, member's name, book title, issue date, and days overdue. */

SELECT 
    iss.issued_member_id,
    m.member_name,
    b.book_title,
    iss.issued_date,
	current_date - iss.issued_date as overdue_date 
from issued_status as iss 
join members as m
on iss.issued_member_id = m.member_id
join books as b
on iss.issued_book_isbn = b.isbn
left join return_status as rs
on rs.issued_id = iss.issued_id
where rs.return_date is null 
     and (current_date - iss.issued_date) > 30
order by 1;

-- Task 14: Update Book Status on Return
/* Write a query to update the status of books in the books table to "Yes" when they are
   returned (based on entries in the return_status table). */
select * from return_status;
select * from issued_status;

select * from books
where isbn = '978-0-307-58837-1';

update books
set status = 'no'
where isbn =  '978-0-307-58837-1';

create or replace procedure add_return_status (p_return_id varchar(10), p_issued_id varchar(30))
language plpgsql
as $$

declare
  v_isbn varchar(50);
   v_book_name varchar(50);
begin
  insert into return_status(return_id , issued_id , return_date) 
  values (p_return_id , p_issued_id , current_date);

  select issued_book_isbn ,issued_book_name into v_isbn , v_book_name
  from issued_status
  where issued_id = p_issued_id;
  
  update books
  set status = 'yes'
  where isbn = v_isbn;

  raise notice 'Thnaks for returning the book : %',v_book_name;
end;
$$

delete  from return_status
where return_id = 'RS138';

call add_return_status('RS138', 'IS135');

select * from books
where isbn = '978-0-307-58837-1';


/*Task 15: Branch Performance Report
  Create a query that generates a performance report for each branch, showing the number of books issued, the number
  of books returned, and the total revenue generated from book rentals. */

-- issued_status == retrun_status == books == branch == employees
-- my query 
select 
 br.branch_id,
 br.manager_id,
 -- count(b.isbn) as number_of_books
 count( iss.issued_book_isbn) as number_of_books_issued,
 count( rs.return_id) as number_of_returned_books,
 sum (b.rental_price) as total_revenu
 
from books as b
join issued_status as iss
on b.isbn = iss.issued_book_isbn
left join return_status as rs
on iss.issued_id = rs.issued_id
join employees as e
on iss.issued_emp_id = e.emp_id
join branch as br
on e.branch_id = br.branch_id

group by 1
order by 1
;

-- table creation

drop table if exists branch_reports;
CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2
order by 1
;

SELECT * FROM branch_reports;

/* Task 16: CTAS: Create a Table of Active Members
   Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued
   at least one book in the last 2 months. */


select * from issued_status;

-- select current_date - interval '12 month';

create table active_members as 
select * from members where member_id in (
select distinct issued_member_id 
from issued_status
where issued_date >= current_date - interval '11 months 30 days');

select * from active_members;


/* Task 17: Find Employees with the Most Book Issues Processed
   Write a query to find the top 3 employees who have processed the most book issues. Display the employee name,
   number of books processed, and their branch. */

select e.emp_id , b.* , count(iss.issued_id) as number_of_books_issued
from issued_status as iss
join employees as e
on e.emp_id = iss.issued_emp_id
join branch as b
on e.branch_id = b.branch_id
group by 1 ,2
order by 6;


/* Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
   Description: Write a stored procedure that updates the status of a book in the library based on its issuance. The 
   procedure should function as follows: The stored procedure should take the book_id as an input parameter. The
   procedure should first check if the book is available (status = 'yes'). If the book is available, it should be 
   issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'),
   the procedure should return an error message indicating that the book is currently not available. */



create or replace procedure issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30),
                                      p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
language plpgsql
as $$

declare
    v_status VARCHAR(10);
begin
-- all the code
    -- checking if book is available 'yes'
    select status 
    into v_status
    from books
    where isbn = p_issued_book_isbn;

    if v_status = 'yes' then

        insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        values (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        update books
        set status = 'no'
        where isbn = p_issued_book_isbn;

        raise notice 'The Book record for isbn no % have been added successfully ', p_issued_book_isbn;

    else
        raise notice 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    end if;
end;
$$

-- Testing The function
SELECT * FROM books where isbn = '978-0-553-29698-2';

-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');


SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'



