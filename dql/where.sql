-- basic check condition with where keyword
SELECT * FROM transactions WHERE id = 1;

-- condition example
SELECT * FROM transactions WHERE id >= 2;
SELECT * FROM transactions WHERE total < 10000;
SELECT * FROM users WHERE is_active = TRUE; -- 0 is false, anything else is true

-- multiple conditions
SELECT * FROM transactions 
WHERE discount > 0 AND total < 10000 AND transaction_date >= '2015-10-15';

SELECT * FROM transactions 
WHERE discount = 0 OR total_item > 2;

-- grouping condition
SELECT * FROM transactions 
WHERE discount = 0 AND (total > 10000 OR DATE(transaction_date) >= '2015-10-15');

-- compare condition from subquery
SELECT * FROM users WHERE id = (SELECT MAX(user_id) FROM user_logs); -- must result single row and column

-- in condition
SELECT * FROM transactions WHERE total_item IN (2,3);
SELECT * FROM transactions 
WHERE user_id IN(SELECT id FROM users WHERE role = 'USER'); -- must result single column, allowed multiple rows

-- where as join table
SELECT first_name, message FROM users, user_logs 
WHERE users.id = user_logs.user_id;

-- where combine with LIKE
SELECT * FROM transactions WHERE title LIKE 'Collection'; -- same as WHERE title = 'Collection'
SELECT * FROM transactions WHERE title LIKE 'C%'; -- will return record with title has value begin with C followed by anything
SELECT * FROM transactions WHERE title LIKE '%an%'; -- find title any value followed with 'an' and followed by anything

-- between keyword
SELECT * FROM transactions WHERE transaction_date BETWEEN '2018-10-15' AND CURDATE();

-- fulltext search
SELECT * FROM foods
WHERE MATCH(food_name, description) AGAINST('nasi goreng' IN NATURAL LANGUAGE MODE);

SELECT * FROM foods
WHERE MATCH(food_name, description) AGAINST('+nasi -goreng' IN BOOLEAN MODE);

SELECT * FROM foods
WHERE MATCH(food_name, description) AGAINST('sambel* -lele' IN BOOLEAN MODE);

SELECT * FROM foods
WHERE MATCH(food_name, description) AGAINST('nasi goreng' WITH QUERY EXPANSION);

SELECT * FROM foods
WHERE MATCH(food_name, description) AGAINST('nasi goreng' IN NATURAL LANGUAGE MODE WITH QUERY EXPANSION);

-- see rangking/scoring in fulltext search
SELECT id, MATCH(food_name,description) AGAINST('nasi' IN NATURAL LANGUAGE MODE) AS score FROM foods;