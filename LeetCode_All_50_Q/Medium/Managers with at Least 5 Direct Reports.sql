select name from Employee 
where id in (select managerId from Employee group by 1 having count(managerId) >4);
