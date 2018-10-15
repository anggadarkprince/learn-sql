-- common column modification
ALTER TABLE users 
DROP COLUMN is_active,
CHANGE COLUMN username username VARCHAR(25) NOT NULL ,
CHANGE COLUMN birthday day_of_birth DATE NULL DEFAULT NULL ,
ADD COLUMN description TEXT NULL AFTER role;

-- drop foreign key
ALTER TABLE user_logs 
DROP FOREIGN KEY fk_log_user;

-- recreate contraint
ALTER TABLE user_logs 
ADD CONSTRAINT fk_log_user
  FOREIGN KEY (user_id)
  REFERENCES users (id)
  ON DELETE CASCADE
  ON UPDATE RESTRICT;

-- add index
ALTER TABLE user_logs 
ADD INDEX log_message_idx (created_at DESC, user_id ASC);

-- drop index
ALTER TABLE user_logs 
DROP INDEX log_message_idx;
