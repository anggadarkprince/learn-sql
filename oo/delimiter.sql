-- change separator between statement
SELECT * FROM accounts;

DELIMITER $$
SELECT * FROM accounts$$
DELIMITER ;

SELECT * FROM accounts;