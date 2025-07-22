# Write your MySQL query statement below
with ranks as (select *, dense_rank() over(partition by departmentId order by salary desc) as salary_rank from Employee  
)
select a.name as Department, b.name as Employee ,  b.salary as Salary 
from ranks b
join
(select name, id from Department) a
ON b.departmentId = a.id
where salary_rank<=3;
