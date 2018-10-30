-- CONTROL FLOW
SELECT IFNULL(NULL, 200) AS val;

SELECT IF(1 < 3, 'true result', 'false result') AS val;
SELECT IF(1 < 3, IF(FALSE, 'nest true', 'nest false'), 'false result') AS val;

SELECT CASE WHEN 2 > 3 THEN 'hello' END; 
SELECT CASE WHEN 2 > 3 THEN 'hello' ELSE 'world' END; 

SELECT 
  CASE 
    WHEN 2 > 3 THEN 'hello'
    WHEN 2 IS NULL THEN 'kitty' 
    WHEN 2 = 2 THEN 'kitty' 
    ELSE 'world' 
  END AS result; 