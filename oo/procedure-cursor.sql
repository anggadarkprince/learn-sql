DROP PROCEDURE IF EXISTS total_balance;

DELIMITER $$

CREATE PROCEDURE total_balance(OUT total DECIMAL(20,2), OUT users VARCHAR(50))
BEGIN
	DECLARE accounts VARCHAR(100) DEFAULT '';
	DECLARE amount DECIMAL(20,2) DEFAULT 0;
  DECLARE finished BOOLEAN DEFAULT false;
  
  DECLARE account_cursor CURSOR FOR
		SELECT name, balance FROM accounts;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true;
  
  IF total IS NULL THEN 
		SET total = 0; 
  END IF;
  
  OPEN account_cursor;
		-- FETCH account_cursor INTO accounts, amount; -- fetch first data
		-- FETCH account_cursor INTO accounts, amount; -- fetch second data
    account_loop: LOOP
    
      FETCH account_cursor INTO accounts, amount;
    
			IF finished THEN
				LEAVE account_loop;
			END IF;
      
			SET total = total + amount;
			SET users = CONCAT(IF(users IS NULL, '', CONCAT(users,', ')), accounts);
    END LOOP account_loop;
    
  CLOSE account_cursor;
  
END$$

DELIMITER ;

CALL total_balance(@total, @users);

SELECT @total, @users;