SET time_zone='SYSTEM';
SELECT @@time_zone;

SELECT NOW(); -- current datetime with related timezone eg: 2022-10-12 12:34:11
SELECT DATE('2022-10-12 12:34:11'); -- 2022-10-12

-- convert millis to date
SELECT FROM_UNIXTIME(1653899965313 / 1000)