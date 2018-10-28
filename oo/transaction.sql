-- make sure all statement succefully run all rollback if one or more fail 
-- transaction cannot rollback ALTER TABLE

SET autocommit = 0;
INSERT INTO book (name) VALUES ('The warior');
INSERT INTO book (name) VALUES ('The fighter');
-- another example need in account transfer problem, need to add balance to an account and substract from another
SELECT * FROM book;
-- DELETE FROM book WHERE id = 10;
COMMIT;
ROLLBACK;

-- another start transaction
START TRANSACTION;
UPDATE book SET name = 'Baby one more time' WHERE id = 3;
COMMIT;


-- Savepoint transaction
START TRANSACTION;
INSERT INTO person(name) VALUES ('Yuki');
DELETE FROM person WHERE id = 7;
SELECT * FROM person;
SAVEPOINT test1;
UPDATE person SET name = 'Liana' WHERE id = 8; -- if another session update this row, then it will wait until this transaction is committed (row locking)
ROLLBACK TO test1; -- will revert update (set until state test1) 