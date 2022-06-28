-- set server SYSTEM variable: can be configured,
-- how server system variables are set:
-- start with default value,
-- on startup read options file /etc/my.cnf,
-- apply persisted setting SET PERSIST <data-dir>/mysqld-auto.cnf
-- temporary setting applied SET GLOBAL,
-- temporary setting applied SET SESSION,

-- set temporary for the connection: different value for other connection
SET SESSION max_connections = 300;

-- set temporary for the server: same value all connection, but reverted after restart
SET GLOBAL max_connections = 300;

-- set permanently for the server: same as set global but persist value to <data-dir>/mysqld-auto.cnf
SET PERSIST max_connections = 300;


-- set server STATUS variable: cannot changed, read-only
SHOW STATUS;
SHOW GLOBAL STATUS;
SHOW SESSION STATUS; -- default SHOW STATUS