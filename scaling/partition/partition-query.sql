## Query partition

-- select data by partition
SELECT * FROM members;
SELECT * FROM members PARTITION (p0,p1); -- use partition name
SELECT * FROM members PARTITION (east_south_region); -- use partition name

-- show all partition of table or schema
SELECT table_schema, table_name, partition_name, table_rows, partition_expression, partition_method
FROM information_schema.partitions
WHERE table_name = 'members';

-- update specific partition
UPDATE members PARTITION (p0) SET first_name = 'Angga' WHERE YEAR(hired) = 2022 ;

-- delete specific partition
DELETE FROM members PARTITION (p0, p1) WHERE first_name LIKE 'a%';