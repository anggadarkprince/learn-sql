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

-- another example
INSERT INTO transactions VALUES 
(NULL, 1, 'Gas station', '', '2018-10-09', 2, 2300, 60000),
(NULL, 1, 'Lunch and dinner', 'Daily expense', '2018-10-10', 3, 0, 430000)
(NULL, 2, 'Buy a daily routine', '', CURDATE(), 5, 1000, 500000),
(NULL, 2, 'Collection', '', CURDATE(), 2, 500, 8500);

-- insert from another table
INSERT INTO user_contacts(email, phone, address)
SELECT email, contact, location
FROM users
WHERE id = 1