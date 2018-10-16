-- default update syntax
UPDATE users 
SET first_name = 'Angga', last_name = 'Ari Wijaya', email = 'angga.ari@mail.com'
WHERE id = 1;

-- update with value from another table via join	
UPDATE users
INNER JOIN user_logs ON user_logs.user_id = users.id
SET users.description = user_logs.message, users.created_at = user_logs.created_at
WHERE users.id = 1