-- Hospital Management System

CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- 1. Patients
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(200),
    registration_date DATE
);

-- 2. Doctors
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    available_days VARCHAR(100),
    consultation_fee DECIMAL(10,2),
    experience_years INT DEFAULT 0
);

-- 3. Departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);

-- 4. Doctor Department mapping
CREATE TABLE Doctor_Department (
    doctor_id INT,
    department_id INT,
    PRIMARY KEY (doctor_id, department_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- 5. Appointments
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 6. Medical Records
CREATE TABLE Medical_Records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    diagnosis VARCHAR(200),
    prescription VARCHAR(300),
    treatment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 7. Billing
CREATE TABLE Billing (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    appointment_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    payment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- Sample Patients
INSERT INTO Patients
(name, dob, gender, phone_number, email, address, registration_date)
VALUES
('Rahul Patel','2001-05-12','Male','9876543210','rahul@gmail.com','Ahmedabad','2026-01-10'),
('Neha Shah','1999-08-20','Female','9876543211','neha@gmail.com','Surat','2026-02-15'),
('Amit Desai','1995-03-10','Male','9876543212','amit@gmail.com','Vadodara','2025-06-20'),
('Karan Joshi','1998-01-18','Male','9876543214','karan@gmail.com','Rajkot','2025-03-12');

-- Sample Doctors
INSERT INTO Doctors
(name, specialization, phone_number, email, available_days, consultation_fee, experience_years)
VALUES
('Dr. Raj Mehta','Cardiology','9000000001','raj@hospital.com','Mon,Wed,Fri',25000,18),
('Dr. Priya Shah','Neurology','9000000002','priya@hospital.com','Tue,Thu',22000,12),
('Dr. Amit Patel','Dermatology','9000000003','amit@hospital.com','Mon,Sat',18000,7),
('Dr. Neel Joshi','Orthopedic','9000000004','neel@hospital.com','Wed,Sat',20000,4);

-- Departments
INSERT INTO Departments (department_name)
VALUES ('Cardiology'),('Neurology'),('Dermatology'),('Orthopedic');

-- Doctor Departments
INSERT INTO Doctor_Department VALUES
(1,1),(2,2),(3,3),(4,4);

-- Appointments
INSERT INTO Appointments
(patient_id, doctor_id, appointment_date, status)
VALUES
(1,1,'2026-09-01 10:00:00','Completed'),
(2,2,'2026-09-05 11:00:00','Completed'),
(3,3,'2026-09-10 12:00:00','Scheduled'),
(1,2,'2026-09-15 10:30:00','Completed'),
(4,4,'2026-09-20 14:00:00','Cancelled'),
(5,1,'2026-09-25 09:30:00','Completed');

-- Medical Records
INSERT INTO Medical_Records
(patient_id, doctor_id, diagnosis, prescription, treatment_date)
VALUES
(1,1,'Heart checkup','Regular medicine','2026-09-01'),
(2,2,'Migraine','Pain relief medicine','2026-09-05'),
(3,3,'Skin allergy','Skin cream','2026-09-10'),
(1,2,'Headache','Tablets','2026-09-15'),
(5,1,'Blood pressure','BP medicine','2026-09-25');

-- Billing
INSERT INTO Billing
(patient_id, appointment_id, amount, payment_status, payment_date)
VALUES
(1,1,25000,'Paid','2026-09-01'),
(2,2,22000,'Paid','2026-09-05'),
(3,3,18000,'Pending',NULL),
(1,4,22000,'Paid','2026-09-15'),
(4,5,20000,'Cancelled',NULL),
(5,6,25000,'Paid','2026-09-25');


-- Insert
INSERT INTO Patients
(name, gender, phone_number, email, address, registration_date)
VALUES ('Test Patient','Male','9999999999','test@gmail.com','Ahmedabad','2026-09-30');
-- Update address
UPDATE Patients
SET address = 'Gandhinagar'
WHERE patient_id = 1;
-- Delete cancelled appointments older than 6 months
DELETE FROM Appointments
WHERE status = 'Cancelled'
AND appointment_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);


-- Patients registered in last year
SELECT *
FROM Patients
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Top 5 highest paying patients
SELECT p.name, SUM(b.amount) AS total_paid
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
WHERE b.payment_status = 'Paid'
GROUP BY p.patient_id, p.name
ORDER BY total_paid DESC
LIMIT 5;

-- Doctors charging more than 21000
SELECT * FROM Doctors
WHERE consultation_fee > 21000;



SELECT *
FROM Appointments
WHERE status = 'Scheduled' AND doctor_id = 3;

SELECT *
FROM Doctors
WHERE specialization = 'Cardiology'
   OR specialization = 'Neurology';

SELECT p.*
FROM Patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM Appointments a
    WHERE a.patient_id = p.patient_id
      AND a.appointment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);


SELECT * FROM Doctors
ORDER BY specialization;

SELECT d.name, COUNT(a.patient_id) AS total_patients
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name;

SELECT dep.department_name, SUM(b.amount) AS revenue
FROM Departments dep
JOIN Doctor_Department dd ON dep.department_id = dd.department_id
JOIN Doctors d ON dd.doctor_id = d.doctor_id
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.payment_status = 'Paid'
GROUP BY dep.department_id, dep.department_name
ORDER BY revenue DESC;


SELECT SUM(amount) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';

SELECT d.name, COUNT(a.patient_id) AS patients_treated
FROM Doctors d
LEFT JOIN Appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name
ORDER BY patients_treated DESC
LIMIT 1;

SELECT AVG(consultation_fee) AS average_fee FROM Doctors;
SELECT MAX(consultation_fee) AS highest_fee FROM Doctors;
SELECT MIN(consultation_fee) AS lowest_fee FROM Doctors;
SELECT COUNT(*) AS total_patients FROM Patients;


-- Check medical records with patient and doctor
SELECT r.record_id, p.name AS patient, d.name AS doctor, r.diagnosis
FROM Medical_Records r
JOIN Patients p ON r.patient_id = p.patient_id
JOIN Doctors d ON r.doctor_id = d.doctor_id;

-- Check invoices with appointments
SELECT b.invoice_id, b.amount, a.appointment_date, b.payment_status
FROM Billing b
JOIN Appointments a ON b.appointment_id = a.appointment_id;


-- Doctors with department names
SELECT d.name AS doctor, dep.department_name
FROM Doctors d
INNER JOIN Doctor_Department dd ON d.doctor_id = dd.doctor_id
INNER JOIN Departments dep ON dd.department_id = dep.department_id;

-- All patients and completed appointments
SELECT p.name, a.appointment_date, a.status
FROM Patients p
LEFT JOIN Appointments a
ON p.patient_id = a.patient_id
AND a.status = 'Completed';

-- Appointments with no payment
SELECT a.appointment_id, a.patient_id, a.appointment_date
FROM Billing b
RIGHT JOIN Appointments a
ON b.appointment_id = a.appointment_id
WHERE b.invoice_id IS NULL;

-- FULL OUTER JOIN alternative in MySQL
SELECT p.patient_id, p.name, a.appointment_id
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
UNION
SELECT p.patient_id, p.name, a.appointment_id
FROM Patients p
RIGHT JOIN Appointments a ON p.patient_id = a.patient_id
WHERE p.patient_id IS NULL;



-- Doctors who handled more than 50 patients
SELECT d.name
FROM Doctors d
WHERE (
    SELECT COUNT(DISTINCT a.patient_id)
    FROM Appointments a
    WHERE a.doctor_id = d.doctor_id
) > 50;

-- Patient who spent the most
SELECT p.name, SUM(b.amount) AS total_spent
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
WHERE b.payment_status = 'Paid'
GROUP BY p.patient_id, p.name
ORDER BY total_spent DESC
LIMIT 1;

-- Appointments with Dermatology doctors
SELECT *
FROM Appointments
WHERE doctor_id IN (
    SELECT doctor_id
    FROM Doctors
    WHERE specialization = 'Dermatology'
);

-- Visits by month
SELECT MONTH(appointment_date) AS month, COUNT(*) AS visits
FROM Appointments
GROUP BY MONTH(appointment_date)
ORDER BY month;

-- Treatment date in DD-MM-YYYY
SELECT record_id, DATE_FORMAT(treatment_date,'%d-%m-%Y') AS treatment_date
FROM Medical_Records;

-- Example stay duration if admission/discharge columns are available
-- SELECT DATEDIFF(discharge_date, admission_date) AS stay_days
-- FROM Hospital_Stay;


SELECT UPPER(name) AS patient_name
FROM Patients;

SELECT TRIM(name) AS doctor_name
FROM Doctors;

SELECT name,
       COALESCE(NULLIF(phone_number,''),'Not Available') AS phone
FROM Patients;


-- Rank doctors by patients treated
SELECT d.name,
       COUNT(a.patient_id) AS patients_treated,
       RANK() OVER (ORDER BY COUNT(a.patient_id) DESC) AS doctor_rank
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name;

-- Cumulative revenue per month
SELECT month, monthly_revenue,
       SUM(monthly_revenue) OVER (ORDER BY month) AS cumulative_revenue
FROM (
    SELECT DATE_FORMAT(payment_date,'%Y-%m') AS month,
           SUM(amount) AS monthly_revenue
    FROM Billing
    WHERE payment_status = 'Paid'
    GROUP BY DATE_FORMAT(payment_date,'%Y-%m')
) x;

-- Running total of appointments
SELECT appointment_id, appointment_date,
       COUNT(*) OVER (ORDER BY appointment_date) AS running_total
FROM Appointments;


-- Patient risk level
SELECT p.name, COUNT(r.record_id) AS records,
       CASE
           WHEN COUNT(r.record_id) > 5 THEN 'High'
           WHEN COUNT(r.record_id) BETWEEN 3 AND 5 THEN 'Medium'
           ELSE 'Low'
       END AS patient_risk_level
FROM Patients p
LEFT JOIN Medical_Records r ON p.patient_id = r.patient_id
GROUP BY p.patient_id, p.name;

-- Doctor experience category
SELECT name, experience_years,
       CASE
           WHEN experience_years > 15 THEN 'Senior'
           WHEN experience_years BETWEEN 5 AND 15 THEN 'Mid-Level'
           ELSE 'Junior'
       END AS doctor_level
FROM Doctors;
