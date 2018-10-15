-- specific column to be inserted
INSERT INTO users(first_name, last_name, email, username, password, day_of_birth, role) VALUES
('Angga', 'Ari', 'angga@mail.com', 'anggaari23', 'secret', '1992-05-26', 'ADMIN'),
('Mia', 'Aria', 'mia@mail.com', 'mimi23', 'secret', '1990-10-12', 'USER');

-- insert all column in the table
INSERT INTO user_logs VALUES 
(NULL, 1, 'Register new user', CURRENT_TIMESTAMP()),
(NULL, 1, 'Update account', CURRENT_TIMESTAMP()),
(NULL, 1, 'Create a post', CURRENT_TIMESTAMP()),
(NULL, 2, 'Register new user', CURRENT_TIMESTAMP());

-- insert from another table
INSERT INTO user_contacts(email, phone, address)
SELECT email, contact, location
FROM users
WHERE id = 1