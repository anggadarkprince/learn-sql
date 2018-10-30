DROP PROCEDURE IF EXISTS fill_tables;

delimiter $$

CREATE PROCEDURE fill_tables(OUT unassigned LONGTEXT)
BEGIN
	DECLARE the_id INT;
	DECLARE the_product VARCHAR(40);
	DECLARE the_category ENUM('bakery', 'fruit', 'vegetable');
  DECLARE finished BOOLEAN DEFAULT FALSE;

	DECLARE cur CURSOR FOR 
		SELECT id, product, category FROM products ORDER BY id;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true;
    
	OPEN cur;
    
	SET unassigned = "";
    
	the_loop: LOOP
    
		FETCH cur INTO the_id, the_product, the_category;
        
		IF finished = true THEN
			LEAVE the_loop;
		END IF;
        
		CASE the_category
			WHEN 'fruit' THEN
				INSERT INTO fruits (id, product) VALUES (the_id, the_product);
			WHEN 'vegetable' THEN
				INSERT INTO vegetables (id, product) VALUES (the_id, the_product);
			WHEN 'bakery' THEN
				INSERT INTO bakery (id, product) VALUES (the_id, the_product);
			ELSE
				SET unassigned := concat(unassigned, the_product, ", ");
			END CASE;
    
    END LOOP;
    
    CLOSE cur;
	
END$$

DELIMITER ;

SELECT * FROM products;

CALL fill_tables(@unassigned);

SELECT * FROM fruits;
SELECT * FROM vegetables;
SELECT * FROM bakery;

SELECT @unassigned;



