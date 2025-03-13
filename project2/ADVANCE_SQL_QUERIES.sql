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




	
