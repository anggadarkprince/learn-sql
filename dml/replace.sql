-- replace existing data with current data,
-- if no data available then insert, if produce duplicate error (ie: existing id as primary) then delete first data, and insert new one
-- need insert and delete privileges
REPLACE INTO cities(id, population)
VALUES(2, 3696820);

-- using replace to update data, different with standard update if we don't specify the column 
-- the value will set to default of structure setup, old value will be gone.
-- let's say we have product with id: 1, product_name: Soap and quantity: 5, then query bellow will make quantity 0 or null depends of default value of the column.
REPLACE INTO products
SET id = 1, product_name = "Shampoo";

-- using replace to insert data
REPLACE INTO products
SELECT name, sku
FROM stocks
WHERE stock > 0;