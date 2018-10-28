SET @user = 'Angga Ari Wijaya';

SELECT @user;

-- this line must be EXECUTE first
SET @max_item = 3;

SELECT * from transactions WHERE total_item < @max_item;

-- set variable from select
LOCK TABLES sales READ, sales_history WRITE;
SELECT @total := SUM(total), @min_total := MIN(total) FROM transactions;
SELECT @total, @min_total;
UNLOCK TABLES;

INSERT INTO sales_history(created_at, total) VALUES (NOW(), @total);