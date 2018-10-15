DELETE FROM users WHERE id = 11;

DELETE FROM users WHERE is_active = FALSE;

DELETE FROM users
WHERE id IN (SELECT id FROM mytable);