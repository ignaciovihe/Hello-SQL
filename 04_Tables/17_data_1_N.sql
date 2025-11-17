-- "companies" y "users"  (Relación 1:N)
INSERT INTO companies (name) VALUES ('MoureDev');
INSERT INTO companies (name) VALUES ('Apple');
INSERT INTO companies (name) VALUES ('Google');

UPDATE users SET company_id = 1 WHERE user_id = 1;
UPDATE users SET company_id = 2 WHERE user_id = 3;
UPDATE users SET company_id = 3 WHERE user_id = 4;
UPDATE users SET company_id = 1 WHERE user_id = 7;