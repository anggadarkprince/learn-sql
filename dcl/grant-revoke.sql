-- create user and grant any privileges 
CREATE user ari@localhost IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON *.* TO ari@localhost;
FLUSH PRIVILEGES;

-- add specific privileges https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html
GRANT SELECT,INSERT,UPDATE ON learn_db.* TO ari@localhost, alex@localhost;
FLUSH PRIVILEGES;

-- revoke permission
REVOKE INSERT,UPDATE ON learn_db.* FROM ari@localhost;

-- show grant permission
SHOW GRANTS FOR  ari@localhost;

-- drop user
DROP USER 'ari'@'localhost';