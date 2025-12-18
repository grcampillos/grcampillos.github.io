-- Note: Every line should be executed orderly aside from queries to check the DATA

-- This is to check all of the Content of the TABLE
SELECT * FROM contacts_test; 

-- CREATING and IMPORTING DATA TO THE TABLE
-- 1. Use this to create a TABLE to import DATA
CREATE TABLE contacts_test (name VARCHAR(100), email VARCHAR(100),phone VARCHAR(20));



-- This is to IMPORT/INSERT data to the created TABLE and COLUMNS
INSERT INTO contacts_test (name, email, phone)
VALUES
('Oliver Smith', 'oliver.smith@example.com', '154-879-3662'),
('Emma Johnson', 'emma.johnson@example.com', '782-946-1547'),
('Liam Williams', 'liam.williams@example.com', '925-673-4891'),
('Ava Brown', 'ava.brown@example.com', '359-412-6785'),
('Noah Taylor', 'noah.taylor@example.com', '986-453-7128'),
('Isabella Miller', 'isabella.miller@example.com', '215-738-6945'),
('Lucas Davis', 'lucas.davis@example.com', '498-236-5791'),
('Sophia Wilson', 'sophia.wilson@example.com', '684-321-8765'),
('Mason Thomas', 'mason.thomas@example.com', '394-568-2394'),
('Mia Jackson', 'mia.jackson@example.com', '284-956-4123'),
('Ethan Martinez', 'ethan.martinez@example.com', '649-317-8259'),
('Harper Anderson', 'harper.anderson@example.com', '298-517-6423'),
('Michael Harris', 'michael.harris@example.com', '436-925-8137'),
('Ella Martin', 'ella.martin@example.com', '954-238-7165'),
('Aiden Thompson', 'aiden.thompson@example.com', '372-619-8542'),
('Aria White', 'aria.white@example.com', '863-294-1758'),
('Daniel Garcia', 'daniel.garcia@example.com', '786-349-2185'),
('Lily Martinez', 'lily.martinez@example.com', '289-146-7532'),
('Matthew Robinson', 'matthew.robinson@example.com', '652-398-4172'),
('Zoe Clark', 'zoe.clark@example.com', '542-369-8127'),
('David Rodriguez', 'david.rodriguez@example.com', '236-719-4852'),
('Chloe Lewis', 'chloe.lewis@example.com', '754-219-3861'),
('Joseph Walker', 'joseph.walker@example.com', '942-375-6184'),
('Scarlett Young', 'scarlett.young@example.com', '214-975-3486'),
('Benjamin Hall', 'benjamin.hall@example.com', '789-632-1549'),
('Sofia Allen', 'sofia.allen@example.com', '549-128-3674'),
('Samuel Wright', 'samuel.wright@example.com', '654-231-8974'),
('Abigail Scott', 'abigail.scott@example.com', '329-548-7162'),
('Logan King', 'logan.king@example.com', '127-589-4361'),
('Elizabeth Green', 'elizabeth.green@example.com', '543-678-2910');

-- 3. Normalizing the values in the phone column
UPDATE contacts_test
SET phone = CONCAT('+1-', SUBSTRING(phone, 1, 3), '-', SUBSTRING(phone, 4, 3), '-', SUBSTRING(phone, 7));

