-- basic select syntax
SELECT 'Angga';

-- basic select table
SELECT * FROM users;

-- select with specifiying columns
SELECT first_name, last_name, email FROM users;

-- aliasing column
SELECT email AS email_address FROM users;

-- select with subquery
SELECT first_name, last_name, email, (
	SELECT message FROM user_logs 
  WHERE user_logs.user_id = users.id
  ORDER BY created_at DESC
  LIMIT 1
) AS last_log_message
FROM users;

-- select with built in function
SELECT 
    NOW() AS now,
    CURDATE() AS today,
    IFNULL(description, 'No desc') AS description
FROM users;

-- select empty value
SELECT first_name, "" AS remark FROM users;

-- operand and concat column
SELECT title, (total - discount) AS total_transaction FROM transactions;
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM users;