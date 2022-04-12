-- combine record from 2 table, automatically remove duplicate report
SELECT name, birthday FROM person
UNION
SELECT first_name AS name, day_of_birth FROM users;

-- union all will merge records without distinct duplicate record
SELECT name FROM person
UNION ALL
SELECT first_name AS name FROM users;

-- get intersect data from two select
SELECT name FROM customers
INTERSECT
SELECT name FROM vendors;

-- MINUS (select 1 substracted by select 2): mysql does not support minus, we can emulate them using left join
SELECT column_names FROM table1
LEFT JOIN table2 ON join_predicate
WHERE table2.column_name IS NULL; 