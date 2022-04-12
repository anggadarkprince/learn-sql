-- EXCLUSIVE LOCK TABLE (WRITE)
-- lock table from another connection read and write data, prevent interuption transaction,
-- other connection will wait until the table is unlocked
LOCK TABLE book WRITE;
INSERT INTO book(name, notes) VALUES('Twilight', 'Novel'); -- ALLOWED
SELECT * FROM book; -- ALLOWED
SELECT * FROM transactions; -- ALLOWED
UNLOCK TABLES;

-- in other session (WRITE LOCK)
SELECT * FROM book; -- LOCKED
INSERT INTO book(name, notes) VALUES('Twilight', 'Novel'); -- WAIT UNTIL WRITE LOCK RELEASE
SELECT * FROM transactions; -- ALLOWED



-- SHARED TABLE LOCK (READ)
-- the session that holds the READ lock can only read data from the table, and cannot write and read other tables
LOCK TABLE person READ; -- prevent read other tables except `person` table and prevent write to table person
SELECT * FROM transactions; -- LOCKED
INSERT INTO `learn_db`.`book` (`name`) VALUES ('Hello'); -- LOCKED
INSERT INTO `learn_db`.`person` (`name`, `address_id`) VALUES ('23', '3'); -- LOCKED

-- in other session (READ LOCK)
INSERT INTO `learn_db`.`person` (`name`, `address_id`) VALUES ('23', '3'); -- WAIT UNTIL READ LOCK RELEASE (same as WRITE LOCK)
INSERT INTO `learn_db`.`book` (`name`) VALUES ('Hello'); -- ALLOWED
SELECT * FROM person; -- ALLOWED
SELECT * FROM book; -- ALLOWED



-- lock multiple table
LOCK TABLE book WRITE, users READ;


-- ROW LEVEL LOCKING

SELECT @@session.tx_isolation;

-- ROW level locking and isolation : must have indexes, if not mysql automatically lock the table rather than row locking
-- in case 2 connection try to update same row
-- by default second update will wait until first update complete
-- some framework notify user if they try to stalled record

-- ISSOLATION TYPE
-- Serializable: when we select the row, another session cannot update the row
-- Repeatable read: execute select query in range even though another session insert data in select range (current session will not affected the result until current session is ended or transaction is commited, or try from new connection)
-- Read committed: include data that commited from another session after commit the transaction
-- Read uncommitted: include data that has not commited yet from another session transaction

show index in person;

-- serializable vs table locking
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET sql_safe_updates = 0;
START TRANSACTION;
-- viewing row will lock the row in another sesion (but allow update other rows) 
-- not like table row that lock entire rows (table), but remember if result select not by index colum, mysql will lock the table in another session
SELECT * FROM person WHERE id = 1; -- other sessions will applied READ LOCK until this committed (update will wait)
COMMIT;

-- Repeatable read
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- default isolation type
START TRANSACTION;
-- two statement below will get same result (not affected insert or update from another session until this transaction is commited)
SELECT * FROM person;
-- in this phase another session insert new data
SELECT * FROM person; -- if another session insert value (committed or not), this select WILL NOT get new data until this transaction is committed
COMMIT;

-- Read commited
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM person;
-- in this phase another session insert new data
SELECT * FROM person; -- if another session insert value and committed, this select will get new data
COMMIT;

-- Read uncommited
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT * FROM person;
-- in this phase another session insert new data
SELECT * FROM person; -- even another session is not committed yet, this select will get new data
-- in this phase another session rollback last new data
SELECT * FROM person; -- the last new data will disappear as well
COMMIT;



-- https://dev.mysql.com/doc/refman/5.7/en/innodb-locking-reads.html
-- SELECT FOR UPDATE
START TRANSACTION;
SET @withdraw = 500;
SET @account_id = 1;
SELECT balance FROM accounts WHERE id = @account_id FOR UPDATE; -- (WRITE LOCK) with same query in other sessions will wait until this released by commit or rollback, but regular select is allowed (even though the update is not performed)
-- check that the balance is bigger than the withdraw amount
UPDATE accounts SET balance = balance - @withdraw WHERE id = @account_id;
COMMIT;


-- LOCK SHARE MODE
SELECT * FROM person;
START TRANSACTION;
-- say we find data and get the id that needed in next statement such as insert
SELECT @id := id FROM address WHERE id = 1 LOCK IN SHARE MODE; -- (READ LOCK) update and delete from other session will wait until the transaction commited or rollback
-- meanwhile other session delete the record, foreign key constrant will prevent inserting bellow, but in MyISAM and best practice we figure it out with LOCKING
INSERT INTO person(name, address_id) VALUES ('Ruka', @id);
COMMIT;