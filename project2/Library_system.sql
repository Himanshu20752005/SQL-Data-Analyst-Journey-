-- BRANCH TABLE
create table branch 
(  branch_id varchar(10),
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
drop table if exists employees;
create table employees 
( emp_id varchar(10) PRIMARY KEY,
  emp_name varchar(25),
  position varchar(15),
  salary INT,
  branch_id varchar(25)
);

-- MEMBERS TABLE
drop table if exists employees;
create table employees 
( emp_id varchar(10) PRIMARY KEY,
  emp_name varchar(25),
  position varchar(15),
  salary INT,
  branch_id varchar(25)
);

--ISSUED_SATE
drop table if exists employees;
create table employees 
( emp_id varchar(10) PRIMARY KEY,
  emp_name varchar(25),
  position varchar(15),
  salary INT,
  branch_id varchar(25)
);

-- RETUEN STATE TABLE
drop table if exists employees;
create table employees 
( emp_id varchar(10) PRIMARY KEY,
  emp_name varchar(25),
  position varchar(15),
  salary INT,
  branch_id varchar(25)
);

