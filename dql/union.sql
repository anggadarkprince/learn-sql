-- combine record from 2 table, automatically remove duplicate report
SELECT name, birthday FROM person
UNION
SELECT first_name AS name, day_of_birth FROM users;

-- union all will merge records without distinct duplicate record
SELECT name FROM person
UNION ALL
SELECT first_name AS name FROM users;