-- BRANCH TABLE
drop table if exists branch;
create table branch 
(  branch_id varchar(10) PRIMARY KEY,
   manager_id varchar(10),
   branch_address varchar(10),
   contact_no varchar(10)
);


-- EMPLOYEE TABLE
drop table if exists employees;
create table employees 
( emp_id varchar(10) PRIMARY KEY,
  emp_name varchar(25),
  position varchar(15),
  salary INT,
  branch_id varchar(25)
);

-- BOOKS TABLE
drop table if exists books;
create table books
( isbn varchar(20) PRIMARY KEY,
  book_title varchar(60),
  category	varchar(20),
  rental_price	float,
  status varchar(15), 
  author varchar(35),
  publisher varchar(55)
);

-- MEMBERS TABLE
drop table if exists members;
create table members
( member_id varchar(10) PRIMARY KEY,
  member_name varchar(25),
  member_address varchar(75),
  reg_date date
);

--ISSUED_SATE
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),  --FK
            issued_book_name VARCHAR(80),  
            issued_date DATE,
            issued_book_isbn VARCHAR(50),  --FK
            issued_emp_id VARCHAR(10)      --FK

);

-- RETUEN STATE TABLE
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50)
);

-- FORIGN KEYs
alter table issued_status
add constraint fk_members
FOREIGN KEY (issued_member_id )
REFERENCES members(member_id);

alter table issued_status
add constraint fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

alter table issued_status
add constraint fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

alter table employees
add constraint fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

alter table return_status
add constraint fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);






