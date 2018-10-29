-- create basic procedure
DROP PROCEDURE IF EXISTS HelloWorld;

DELIMITER $$

CREATE PROCEDURE HelloWorld()
BEGIN
	SELECT 'Yo'; -- will override with select bellow
	SELECT 'HELLO';
	SELECT * FROM book;
END$$

DELIMITER ;

CALL HelloWorld();