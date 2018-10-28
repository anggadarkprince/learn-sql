-- ACID database
-- Atomicity execute bunch statement as one transaction
-- Consistency make sure database is not left inconsistency state (all proccess must be done or rollback before transaction)
-- Isolation prevent conflict with other connection that access database
-- Durability should posible recover from crashing

-- InnoDB cover ACID requirement (ACID compliant)
-- MyISAM fast but not ACID compliant
