DROP PROCEDURE IF EXISTS withdraw;

DELIMITER $$

CREATE PROCEDURE withdraw(
   IN account_id INT, 
   IN amount DECIMAL(10, 2), 
   OUT success BOOL,
   OUT beginningBalance DECIMAL(10, 2),
   OUT lastBalance DECIMAL(10, 2)
)
BEGIN
  DECLARE current_balance DECIMAL(10, 2) DEFAULT 0.0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
		SHOW ERRORS;
  END;
  
	DECLARE EXIT HANDLER FOR SQLWARNING
  BEGIN
		SHOW WARNINGS;
  END;
  
  START TRANSACTION;
  
  -- exclusive lock when we selecting balance
  SELECT balance INTO current_balance 
  FROM accounts WHERE id = account_id
  FOR UPDATE;
  
  -- check current balance is sufficient 
  IF current_balance >= amount THEN
     SET beginningBalance = current_balance;
     SET lastBalance = current_balance - amount;
     
     UPDATE accounts SET balance = lastBalance
     WHERE id = account_id;
     
     SET success = TRUE;
  ELSE
     SET success = FALSE;
  END IF;
  
  COMMIT;
END$$

DELIMITER ;

CALL withdraw(1, 250, @status, @beginningBalance, @lastBalance);

SELECT @status, @beginningBalance, @lastBalance;
