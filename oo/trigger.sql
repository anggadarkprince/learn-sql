-- triggers are embeded to table, if the table is deleted then triggers will deleted also.
-- triggers is listening event of create edit delete, and executed before or after each event of action.
DROP TRIGGER IF EXISTS before_user_update;
DELIMITER $$

CREATE TRIGGER before_user_update
BEFORE UPDATE ON users FOR EACH ROW
BEGIN
	-- BEFORE trigger has ability to change the `new` value before DML
  IF new.description IS NULL OR new.description = '' THEN
		SET new.description = 'No description';
  END IF;
  
	IF old.first_name != new.first_name THEN
		INSERT INTO user_logs(user_id, message)
		VALUES(old.id, CONCAT('Update ', old.first_name, ' to ', new.first_name));
  END IF;
END$$

DELIMITER ;