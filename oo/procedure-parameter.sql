DROP PROCEDURE IF EXISTS ShowCheapestBooks;

DELIMITER $$

-- IN, OUT, INOUT
CREATE PROCEDURE ShowCheapestBooks(
   IN maxPrice INT, 
   IN titleSearch VARCHAR(100), 
   OUT cheapTitle VARCHAR(100), 
   OUT cheapPrice INT,
   INOUT refId INT
)
BEGIN
  DECLARE limitPrice INT DEFAULT 3;
  SET limitPrice = 0; -- limitPrice := 0; works as well
  
  IF maxPrice <= limitPrice THEN
     SET maxPrice = limitPrice;
  END IF;
  
  -- we can directly select into the output SELECT title, price INTO cheapTitle, cheapPrice 
  SELECT id, title, price INTO refId, @theTitle, @thePrice 
  FROM book 
  WHERE price <= maxPrice AND title LIKE CONCAT('%', titleSearch , '%') 
  ORDER BY price DESC LIMIT 1;
  
  -- passing inner set variable to output
  SELECT @theTitle AS title, @thePrice AS price INTO cheapTitle, cheapPrice;
END$$

DELIMITER ;

SET @maxId = 5;
CALL ShowCheapestBooks(-20, 'i', @title, @price, @maxId);

-- select variable output from procedure above
SELECT @title AS book_title, @price AS lowest_price, @maxId AS id;
