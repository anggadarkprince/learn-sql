-- group by ussualy using along with aggregate function such as MAX, MIN, AVG, SUM, COUNT
-- full group by (prevent SQL pick automatically column value for you for data integrity of your query result)
SELECT user_id FROM transactions
GROUP BY user_id;

-- example of group by, non aggregate column that mentioned in select must called in GROUP BY
SELECT user_id, SUM(discount) AS total_discount, SUM(total) AS total_transaction
FROM transactions
GROUP BY user_id;

-- multiple group by
SELECT user_id, category, SUM(total - discount) AS total, MAX(transaction_date) AS last_activity
FROM transactions
GROUP BY user_id, category;

-- counting result of rows
SELECT COUNT(*) AS total_rows FROM transactions; -- null value will counted because * means all record
SELECT COUNT(message) AS total_rows FROM transactions; -- null value will not be counted
SELECT COUNT(DISTINCT user_id, created_at) FROM user_logs GROUP BY user_id;