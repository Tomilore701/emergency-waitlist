Create table PRIORITIES (
priority_id SERIAL PRIMARY KEY,
description VARCHAR(225) NOT NULL,
approximate_time INT NOT NULL
);

Create table ROOMS (
room_id SERIAL PRIMARY KEY,
doctor_assigned VARCHAR(225) NOT NULL,
status BOOLEAN NOT NULL DEFAULT FALSE
);

Create table PATIENTS (
patient_id SERIAL PRIMARY KEY,
card_number VARCHAR(225) NOT NULL,
name VARCHAR(225) NOT NULL,
gender VARCHAR(50),
date_of_birth DATE,
medical_issue VARCHAR(225),
arrival_time TIMESTAMP,
priority_id INT,
room_id INT,
FOREIGN KEY (priority_id) REFERENCES PRIORITIES(priority_id),
FOREIGN KEY (room_id) REFERENCES ROOMS(room_id)
)


--Inserting into PRIORITIES
INSERT INTO PRIORITIES (description, approximate_time) VALUES ('High', 15);
INSERT INTO PRIORITIES (description, approximate_time) VALUES ('Medium', 30);
INSERT INTO PRIORITIES (description, approximate_time) VALUES ('Low', 45);


--Inserting into ROOMS
INSERT INTO ROOMS (doctor_assigned, status) VALUES ('Dr. Smith', FALSE);
INSERT INTO ROOMS (doctor_assigned, status) VALUES ('Dr. Jones', TRUE);
INSERT INTO ROOMS (doctor_assigned, status) VALUES ('Dr. Brown', FALSE);

--Inserting into PATIENTS
INSERT INTO PATIENTS (card_number, name, gender, date_of_birth, medical_issue, arrival_time, priority_id, room_id) VALUES ('CN001', 'John Doe', 'Male', '1980-01-01', 'Headache', '2023-01-01 08:00:00',1,1);
INSERT INTO PATIENTS (card_number, name, gender, date_of_birth, medical_issue, arrival_time, priority_id, room_id) VALUES ('CN002', 'Jane Smith', 'Female', '1980-02-02', 'Cough', '2023-01-01 09:00:00',2,2);
INSERT INTO PATIENTS (card_number, name, gender, date_of_birth, medical_issue, arrival_time, priority_id, room_id) VALUES ('CN003', 'Bob Brown', 'Male', '1975-03-03', 'Fever', '2023-01-01 10:00:00',3,3);

SELECT * FROM patients

SELECT * FROM PRIORITIES;

SELECT priority_id FROM PATIENTS WHERE card_number = 'CN001';

SELECT * FROM PRIORITIES WHERE priority_id = 2;

UPDATE PATIENTS
SET priority_id = 2
WHERE card_number = 'CN001'
RETURNING *;

SELECT * FROM PATIENTS WHERE card_number = 'CN001';

SELECT * 
FROM PATIENTS p
JOIN PRIORITIES pr ON p.priority_id = pr.priority_id
JOIN ROOMS r ON p.room_id = r.room_id
ORDER BY p.priority_id ASC, p.arrival_time ASC;

DELETE FROM PATIENTS
WHERE card_number = 'CN001'
RETURNING *;

SELECT * FROM PATIENTS WHERE card_number = 'CN001';

INSERT INTO PATIENTS (card_number, name, gender, date_of_birth, medical_issue, arrival_time, priority_id, room_id) VALUES ('CN004', 'Sara Brown', 'Female', '1974-03-03', 'Cough', '2024-12-03 10:00:00',3,3);
INSERT INTO PATIENTS (card_number, name, gender, date_of_birth, medical_issue, arrival_time, priority_id, room_id) VALUES ('CN005', 'Tanya Leroy', 'Female', '1984-03-03', 'Fever', '2024-12-03 10:10:00',2,2);

SELECT * FROM patients

SELECT * FROM PATIENTS WHERE card_number = 'CN004';

SELECT p.priority_id, p.arrival_time, pr.approximate_time
FROM PATIENTS p
JOIN PRIORITIES pr ON p.priority_id = pr.priority_id
WHERE p.card_number = 'CN005';

SELECT SUM(pr.approximate_time) AS total_wait_time
FROM PATIENTS p
JOIN PRIORITIES pr ON p.priority_id = pr.priority_id
WHERE pr.priority_id < 2
AND p.arrival_time <= '2024-12-03 10:10:00'

SELECT * FROM PATIENTS WHERE card_number = 'CN005';
SELECT * FROM PATIENTS WHERE priority_id = 2;

SELECT * FROM PATIENTS WHERE priority_id < 2;
SELECT * FROM PATIENTS WHERE arrival_time <= '2024-12-03 10:10:00';

SELECT * 
FROM PATIENTS p
JOIN PRIORITIES pr ON p.priority_id = pr.priority_id
WHERE pr.priority_id < 2
AND p.arrival_time <= '2024-12-03 10:10:00';

INSERT INTO PATIENTS (card_number, name, gender, date_of_birth, medical_issue, arrival_time, priority_id, room_id)
VALUES ('CN006', 'Alice Moore', 'Female', '1990-01-01', 'Injury', '2024-12-03 09:30:00', 1, 1);

SELECT SUM(pr.approximate_time) AS total_wait_time
FROM PATIENTS p
JOIN PRIORITIES pr ON p.priority_id = pr.priority_id
WHERE pr.priority_id < 3
AND p.arrival_time <= '2024-12-03 10:10:00';

SELECT * FROM patients

WITH OrderedQueue AS (
    SELECT 
        p.card_number,
        p.priority_id,
        p.arrival_time,
        pr.approximate_time,
        ROW_NUMBER() OVER (ORDER BY p.priority_id ASC, p.arrival_time ASC) AS queue_position
    FROM PATIENTS p
    JOIN PRIORITIES pr ON p.priority_id = pr.priority_id
),
CurrentPatient AS (
    SELECT queue_position
    FROM OrderedQueue
    WHERE card_number = 'CN005'
)
SELECT COALESCE(SUM(oq.approximate_time), 0) AS total_wait_time
FROM OrderedQueue oq
JOIN CurrentPatient cp ON oq.queue_position < cp.queue_position;

SELECT * FROM patients

INSERT INTO PATIENTS (card_number, name, gender, date_of_birth, medical_issue, arrival_time, priority_id, room_id)
VALUES ('CN1234', 'John Doe', 'Male', '1980-01-01', 'Head Injury', NOW(), 
        (SELECT priority_id FROM PRIORITIES WHERE description = 'High'), 1)
RETURNING *;
