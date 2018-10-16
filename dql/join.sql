-- basic joining table (only record that have connection will show up)
SELECT * FROM users
INNER JOIN user_logs ON user_logs.user_id = users.id;

-- join will result multiplication each record of one table againts the another
SELECT first_name, message, title FROM users
INNER JOIN user_logs ON user_logs.user_id = users.id
INNER JOIN transactions ON transactions.user_id = users.id;

-- join by one table and don't care the another table if it doesn't has connection
-- show all users, show transaction data if exist, or null if it does not exist
SELECT * FROM users
LEFT JOIN transactions ON transactions.user_id = users.id;

-- show all transactions, show user data if exist, or null if it does not exist
-- right or left is pointing the table that mentioned in left or right
SELECT * FROM users
RIGHT JOIN transactions ON transactions.user_id = users.id;

-- join with table that result of subquery
SELECT users.first_name, last_activities.created_at AS last_activity 
FROM users
LEFT JOIN (
	SELECT user_id, MAX(created_at) AS created_at FROM user_logs
  GROUP BY user_id
) AS last_activities ON last_activities.user_id = users.id;

-- join with multiple condition
SELECT * FROM users
INNER JOIN transactions
ON transactions.user_id = users.id AND total > 10000;

-- aliasing table for join condition
SELECT u.*, t.total FROM users AS u
INNER JOIN transactions AS t
ON t.user_id = u.id;
