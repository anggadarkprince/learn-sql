DROP PROCEDURE IF EXISTS total_account;

DELIMITER $$

CREATE PROCEDURE total_account(OUT total DECIMAL(20,2))
BEGIN
	DECLARE count INT DEFAULT 0;
  IF total IS NULL THEN
		SET total = 0;
  END IF;

	-- while loop
  WHILE count < 10 DO
		SET total = total + 5;
		SET count = count + 1;
  END WHILE;
  
  -- loop label
  value_loop: LOOP
    
		IF count >= 20 THEN
			LEAVE value_loop;
    END IF;
    
		SET total = total + 1;
		SET count = count + 1;
  END LOOP;
  
END$$

DELIMITER ;

CALL total_account(@total);

SELECT @total;