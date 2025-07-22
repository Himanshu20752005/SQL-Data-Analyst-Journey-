SELECT s.user_id,
    ROUND(COUNT(CASE WHEN c.action = 'confirmed' THEN 1 END) / COUNT(*),2) AS confirmation_rate
FROM Signups AS s
LEFT JOIN Confirmations AS c
ON s.user_id = c.user_id
GROUP BY 1;
  
-- ROUND(INFO , 2 )  rounds upto 2 digit
-- CASE to apply the cases where the action was confirmed
-- LEFT JOIN coz 6 wont match with any user id in confirmations table 
-- GROUP BY 1 means group by the first column
