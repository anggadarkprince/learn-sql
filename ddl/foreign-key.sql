-- foreign key is used for increase integrity of the table data,
-- make sure related data is exist or completely update or removed when parent data changes
CREATE TABLE address(
	id INT PRIMARY KEY AUTO_INCREMENT, 
  street VARCHAR(50)
);
INSERT INTO address (street) VALUE ('Apple Lane'), ('Broad Street'), ('Church Lane');

-- by default foreign key has option on update and on delete
-- if it's not set then the value NO ACTION by default
-- NO ACTION constraints are checked deferred, similar as RESTRICT by term (a keyword from standard SQL)
-- RESTRICT constraints are checked immediately (a keyword from MySQL)
-- SET NULL set related table column to null if parent updated or deleted
-- CASCADE update or delete the child if parent updated or deleted
CREATE TABLE person(
	id INT PRIMARY KEY AUTO_INCREMENT, 
  name VARCHAR(50), 
  address_id INT, 
  FOREIGN KEY (address_id) REFERENCES address(id)
);

INSERT INTO person(name, address_id) VALUES ('Anna', 1);
INSERT INTO person(name, address_id) VALUES ('Bob', 2);
INSERT INTO person(name, address_id) VALUES ('Clare', 3);

-- This won't work because address_id reference to table address and column id, there is no id with 4 value
INSERT INTO person(name, address_id) VALUES ('David', 4);

-- But this will:
INSERT INTO person(name, address_id) VALUES ('Arnold', 1);
