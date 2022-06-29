-- divide up the big tables/indexes into smaller segments (logical data spaces) stored in different physical data files,
-- so that the queries access only a fraction of the data;
-- thus there is less for them to scan, balancing the workload and potentially making queries faster.

## Partitioning while create new table: RANGE, LIST, HASH, KEY

-- partition by range, insert data will error if value is not meet in the range
CREATE TABLE members (id INT, first_name VARCHAR(50), hired DATE)
    PARTITION BY RANGE (YEAR(hired)) (
        PARTITION p0 VALUES LESS THAN (1991),
        PARTITION p1 VALUES LESS THAN (2000),
        PARTITION p2 VALUES LESS THAN (2010),
        PARTITION p3 VALUES LESS THAN MAXVALUE
    );

-- partition by list
CREATE TABLE members (id INT, first_name VARCHAR(50), hired DATE, location_id INT)
    PARTITION BY LIST (YEAR(location_id)) (
        PARTITION east_south_region VALUES IN (3, 5, 6, 9, 17),
        PARTITION west_region VALUES IN (1, 2, 10, 11, 19, 20)
    );

-- partition by hash
CREATE TABLE members (id INT, first_name VARCHAR(50), hired DATE)
    PARTITION BY HASH (YEAR(hired))
        PARTITIONS 4;

-- partition by key: similar with hash, with the difference that the hashing function is provided by MySQL
-- If we don’t explicitly specify the partitioning columns part of the key,
-- then MySQL will automatically use the primary key or a unique key as the partitioning column.
CREATE TABLE members (id INT, first_name VARCHAR(50), hired DATE)
    PARTITION BY KEY (id)
        PARTITIONS 4;


## Sub partition
-- also known as composite partitioning—is the further division of each partition in a partitioned table.
-- Table ts has 3 RANGE partitions. Each of these partitions—p0, p1, and p2—is further divided into 2 subpartitions.
-- In effect, the entire table is divided into 3 * 2 = 6 partitions.
CREATE TABLE ts(id INT, purchased DATE)
    PARTITION BY RANGE (YEAR(purchased))
        SUBPARTITION BY HASH (TO_DAYS(purchased))
        SUBPARTITIONS 2 (
            PARTITION p0 VALUES LESS THAN (1990),
            PARTITION p1 VALUES LESS THAN (2000),
            PARTITION p2 VALUES LESS THAN MAXVALUE
        );

-- more specific sub partition
CREATE TABLE ts (id INT, purchased DATE)
    PARTITION BY RANGE( YEAR(purchased) )
        SUBPARTITION BY HASH( TO_DAYS(purchased) ) (
        PARTITION p0 VALUES LESS THAN (1990) (
            SUBPARTITION s0,
            SUBPARTITION s1
        ),
        PARTITION p1 VALUES LESS THAN (2000) (
            SUBPARTITION s2,
            SUBPARTITION s3
        ),
        PARTITION p2 VALUES LESS THAN MAXVALUE (
            SUBPARTITION s4,
            SUBPARTITION s5
        )
    );


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


## Modify partition table

-- create partition on existing table
ALTER TABLE members PARTITION BY RANGE(YEAR(hired)) (
    PARTITION p0 VALUES LESS THAN (2020),
    PARTITION p1 VALUES LESS THAN MAXVALUE
    );

-- delete the rows of a partition without affecting the rest of the dataset in the table
ALTER TABLE members TRUNCATE PARTITION p0;

-- drop only specific partition
ALTER TABLE members DROP PARTITION east_south_region;

-- explain query execution plan with partition
EXPLAIN PARTITIONS SELECT * FROM members WHERE hired < '2020-01-01';

-- rebuild partition: this has the same effect as dropping all records stored in the partition, then reinserting them.
-- This can be useful for purposes of defragmentation
ALTER TABLE members REBUILD PARTITION p0, p1, p2, p3;

-- optimize partition: If you have deleted a large number of rows from a partition or if you have made many changes,
-- to reclaim any unused space and to defragment the partition data file. If table does not support optimize, it would run rebuild instead
ALTER TABLE members OPTIMIZE PARTITION p0, p1;

-- analyze partition: This reads and stores the key distributions for partitions
ALTER TABLE members ANALYZE PARTITION p3;

-- repair partition: This repairs corrupted partitions
ALTER TABLE members REPAIR PARTITION p0, p1;
ALTER IGNORE TABLE members REPAIR PARTITION p0, p1; -- REPAIR PARTITION fails when the partition contains duplicate key errors

-- check partition: check for errors in much the same way that you can use CHECK TABLE with non partitioned tables.
ALTER TABLE members CHECK PARTITION p1;

-- remove partitions of the table (existing data still exist)
ALTER TABLE members REMOVE PARTITIONING;

-- switch data inside partition (members) to other non partitioned table (members2), vice-versa: proceed with careful,
-- the next execution will move data from `members2` into `member` table again
ALTER TABLE members EXCHANGE PARTITION p0 WITH TABLE members2;


## Check partition table

SELECT table_name, partition_name, table_rows, avg_row_length, data_length
FROM information_schema.partitions;