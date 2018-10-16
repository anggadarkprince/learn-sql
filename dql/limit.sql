-- limiting result as 2 rows
SELECT * FROM transactions LIMIT 2;

-- limiting with offset (same result as above) based 0 index offset
SELECT * FROM transactions LIMIT 0,2;

-- another offset example: start from second record (included) and take 3 records from there
SELECT * FROM transactions LIMIT 1,3;