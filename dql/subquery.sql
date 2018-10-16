-- subquery is a query inside query, small chunck result value or derived table

-- subquery as derive table
SELECT * FROM (
	SELECT user_id, SUM(total) AS total FROM transactions
  GROUP BY user_id
) AS user_transactions
WHERE total > 500000;

-- subquery result value for select field
SELECT first_name, last_name, email, (
	SELECT message FROM user_logs 
  WHERE user_logs.user_id = users.id
  ORDER BY created_at DESC
  LIMIT 1
) AS last_log_message
FROM users;

-- subquery result value for where condition
SELECT * FROM users WHERE id = (SELECT MAX(user_id) FROM user_logs);
SELECT * FROM transactions WHERE user_id IN(SELECT id FROM users WHERE role = 'USER');

-- subquery result derive table for join 
SELECT users.first_name, last_activities.created_at AS last_activity 
FROM users
LEFT JOIN (
	SELECT user_id, MAX(created_at) AS created_at FROM user_logs
  GROUP BY user_id
) AS last_activities ON last_activities.user_id = users.id;