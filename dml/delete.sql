-- delete syntax, some SQL MODE will restrict mass deletion (delete without condition)
DELETE FROM users;

-- delete with condition
DELETE FROM users WHERE id = 11;

-- another example delete
DELETE FROM users WHERE is_active = FALSE;

-- delete with subquery
DELETE FROM users WHERE id IN (SELECT id FROM mytable);