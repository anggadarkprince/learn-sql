-- create table with ending and set start of auto increment
CREATE TABLE IF NOT EXISTS users (
	id INT(11) NOT NULL AUTO_INCREMENT,
	api_token VARCHAR(128) DEFAULT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(50) DEFAULT NULL UNIQUE,
	username VARCHAR(20) NOT NULL UNIQUE,
	password VARCHAR(50) DEFAULT NULL,
	location VARCHAR(100) DEFAULT NULL,
	birthday DATE DEFAULT NULL,
	avatar VARCHAR(255) DEFAULT NULL,
	is_active TINYINT(1) DEFAULT NULL,
	role ENUM('USER', 'ADMIN', 'CONTRIBUTOR') DEFAULT 'USER',
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
)  ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=LATIN1;

CREATE TABLE IF NOT EXISTS user_logs (
    id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT(11) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX fk_log_user_idx (user_id ASC), -- add index
	FULLTEXT (message), -- add fulltext index
    CONSTRAINT fk_log_user FOREIGN KEY (user_id) -- add foreign key
        REFERENCES users (id)
        ON DELETE CASCADE ON UPDATE RESTRICT
);

-- create table with cascade delete and update no action constraint
CREATE TABLE transactions (
	id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT(11) NOT NULL,
	title VARCHAR(150) NOT NULL,
	category VARCHAR(50) NOT NULL,
	description TEXT NOT NULL,
	transaction_date DATE DEFAULT NULL,
	total_item INT(11),
	discount DECIMAL(20,2),
	total DECIMAL(20,2),
	CONSTRAINT fk_transaction_user FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE CASCADE ON UPDATE NO ACTION
);

-- create table from selection
CREATE TABLE user_names AS
SELECT first_name FROM learn_db.users;

-- copy table structure from another table
CREATE TABLE members2 LIKE members;

-- constraint check only support mysql >= 8.0
CREATE TABLE IF NOT EXISTS foods (
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	food_name VARCHAR(150) NOT NULL,
	category VARCHAR(50) NOT NULL CHECK (category IN('MAIN COURSE', 'APPETIZER', 'DESSERT')),
	description TEXT,
	image VARCHAR(300),
	stock INT(11),
	CONSTRAINT check_stock CHECK (stock >= 0)
) ENGINE = INNODB;

ALTER TABLE foods
ADD CHECK (stock >= 1);

DESC foods;
SHOW CREATE TABLE foods;
