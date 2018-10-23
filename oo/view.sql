-- view works like a virtual table that represent reault of saved query
CREATE TABLE book (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    notes VARCHAR(100)
);

-- create view
CREATE VIEW bookview AS
    SELECT id, name
    FROM book;

-- selecting view
SELECT * FROM bookview;

-- insert data via view
INSERT INTO bookview (id, name) VALUES (2, "War and Peace");

-- remove view
DROP VIEW bookview;

-- view algorithm
-- UNDEFINED default algorithm (MERGE, auto switch to TEMPTABLE if detect aggregate function)
-- MERGE more efficient, utilize table indexes but can't handle aggregate function, limit, distinct, union, subquery in select list
-- TEMPTABLE create temporary table before select (aggregate, limit, distinct, etc function allowed)
CREATE ALGORITHM = TEMPTABLE VIEW user_view AS
		SELECT users.id, first_name, message
    FROM users 
    INNER JOIN user_logs ON user_logs.user_id = users.id;
    
-- merge algorithm
-- let's say there is a view `user_view` that defined as SELECT * FROM users WHERE status = 'ACTIVATED'
-- then we selecting view and add some condition:
-- SELECT user_view WHERE score > 10
-- the result of merge algorithm rather than SELECT * FROM (SELECT * FROM users WHERE status = 'ACTIVATED') AS view_user WHERE score > 10
-- will result SELECT * FROM users WHERE (status = 'ACTIVATED') AND score > 0
    
-- option check make sure inserted value in view will appear
CREATE VIEW transaction_above_2000 AS
		SELECT id, user_id, title, category, description, transaction_date, discount, total_item, total
    FROM transactions WHERE total > 20000 WITH CHECK OPTION;

INSERT INTO transaction_above_2000 (id, user_id, title, category, description, transaction_date, discount, total_item, total) 
VALUES (NULL, 1, 'Daily shopping', 'shopping', 'no desc', '2018-11-11', 1000, 3, 18000);
    