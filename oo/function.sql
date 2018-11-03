DROP FUNCTION IF EXISTS total_after_tax;

DELIMITER $$
CREATE FUNCTION total_after_tax(transaction_id INT, tax FLOAT) RETURNS DECIMAL(20, 2)
BEGIN
	DECLARE result DECIMAL(20, 2);
  
  SELECT (total - discount) * ((100 + tax) / 100) FROM transactions 
  WHERE id = transaction_id INTO result;
  
  RETURN result;
END$$
DELIMITER ;


SELECT total_after_tax(1, 10);

