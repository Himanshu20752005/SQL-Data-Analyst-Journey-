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

select 
 br.branch_id,
 -- count(b.isbn) as number_of_books
 count(distinct iss.issued_book_isbn) as number_of_books_issued,
 count(distinct rs.return_id) as number_of_returned_books,
 sum (b.rental_price) as total_revenu
 
from books as b
left join issued_status as iss
on b.isbn = iss.issued_book_isbn
left join return_status as rs
on iss.issued_id = rs.issued_id
left join employees as e
on iss.issued_emp_id = e.emp_id
left join branch as br
on e.branch_id = br.branch_id

group by 1
order by 1
;




