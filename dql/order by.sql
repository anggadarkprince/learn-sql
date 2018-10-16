-- order record
SELECT * FROM transactions ORDER BY total; -- ordered by totas ascending by default

-- order with direction
SELECT * FROM transactions ORDER BY discount DESC;

-- random order
SELECT * FROM transactions ORDER BY RAND();

-- order by defined value
SELECT * FROM users ORDER BY FIELD('ADMIN', 'USER', 'CONTRIBUTOR');

-- order multiple column
SELECT * FROM transactions ORDER BY transaction_date ASC, discount DESC;