with unq as
(
    select a.pid, a.tiv_2016
    from Insurance as a , Insurance as b
    WHERE a.pid != b.pid 
        AND (a.lat = b.lat AND a.lon = b.lon)
    group by a.pid
),
mul as
(
    select a.pid, a.tiv_2016
    from Insurance as a, Insurance as b
    where a.pid != b.pid
        AND (a.tiv_2015 = b.tiv_2015)
    group by a.pid
)
SELECT ROUND(SUM(m.tiv_2016), 2) AS tiv_2016
FROM mul m
WHERE m.pid NOT IN (SELECT pid FROM unq);
