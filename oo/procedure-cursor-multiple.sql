DROP PROCEDURE IF EXISTS product_scanner;

DELIMITER $$

CREATE PROCEDURE product_scanner(OUT products TEXT)
BEGIN

  DECLARE obj TEXT DEFAULT '';  
  
  -- scan fruit table
  BEGIN
		DECLARE finished BOOLEAN DEFAULT false;  
		DECLARE product_cursor CURSOR FOR SELECT product FROM fruits;
		
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true;
		
		OPEN product_cursor;
		
			product_loop: LOOP
				
				FETCH product_cursor INTO obj;
			
				IF finished THEN
					LEAVE product_loop;
				END IF;
				
				SET products = CONCAT(IF(products IS NULL, '', CONCAT(products,', ')), obj);
			
			END LOOP product_loop;
			
		CLOSE product_cursor;
  END;
  
  -- scan vegetables table
  BEGIN
		DECLARE finished BOOLEAN DEFAULT false;  
		DECLARE product_cursor CURSOR FOR SELECT product FROM vegetables;
		
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true;
		
		OPEN product_cursor;
		
			product_loop: LOOP
				
				FETCH product_cursor INTO obj;
			
				IF finished THEN
					LEAVE product_loop;
				END IF;
				
				SET products = CONCAT(IF(products IS NULL, '', CONCAT(products,', ')), obj);
			
			END LOOP product_loop;
			
		CLOSE product_cursor;
  END;
  
  -- scan bakery table
  BEGIN
		DECLARE finished BOOLEAN DEFAULT false;  
		DECLARE product_cursor CURSOR FOR SELECT product FROM bakery;
		
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true;
		
		OPEN product_cursor;
		
			product_loop: LOOP
				
				FETCH product_cursor INTO obj;
			
				IF finished THEN
					LEAVE product_loop;
				END IF;
				
				SET products = CONCAT(IF(products IS NULL, '', CONCAT(products,', ')), obj);
			
			END LOOP product_loop;
			
		CLOSE product_cursor;
  END;
  
END$$

DELIMITER ;

CALL product_scanner(@products);

SELECT @products;