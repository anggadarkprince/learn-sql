SELECT @@general_log_file;
SELECT @@general_log;
SELECT @@log_output;
SET GLOBAL log_output = 'table';
SET GLOBAL log_output = 'file';
SET GLOBAL general_log=1;
SELECT * FROM mysql.general_log 
WHERE argument LIKE 'SELECT %';