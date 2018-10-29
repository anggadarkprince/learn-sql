-- create basic procedure
DROP PROCEDURE IF EXISTS HelloWorld;

DELIMITER $$

CREATE DEFINER = root@loclhost PROCEDURE HelloWorld()
SQL SECURITY INVOKER -- check user has access to anything permission inside the procedure (definer just check if user can execute the procedure)
BEGIN
	SELECT 'Yo'; -- will override with select bellow
	SELECT 'HELLO';
	SELECT * FROM book;
END$$

DELIMITER ;

CALL HelloWorld();