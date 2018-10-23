-- having used with group by to filter aggregate function
-- it's different with WHERE because we don't know yet result value after aggregate
-- having condition must one or more of column that mentioned in select
SELECT user_id, SUM(total) AS total FROM transactions
GROUP BY user_id
HAVING total > 500000 AND IFNULL(user_id, 1) >= 1;
