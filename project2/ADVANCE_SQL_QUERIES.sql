-- ADVANCE SQL QUERIES


-- Task 13: Identify Members with Overdue Books 
/* Write a query to identify members who have overdue books (assume a 30-day return period).
   Display the member's_id, member's name, book title, issue date, and days overdue. */

SELECT 
    issued_member_id,
    member_name,
    book_title,
    issued_date,

	current_date - issued_date
