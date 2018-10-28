-- explain what query does
EXPLAIN 
SELECT * FROM (
	SELECT user_id, SUM(total) AS total FROM transactions
  GROUP BY user_id
) AS user_transactions
WHERE total > 500000;

EXPLAIN 
SELECT * FROM users WHERE id = (SELECT MAX(user_id) FROM user_logs);