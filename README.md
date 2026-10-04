# Hospital Management System

## About Project

This is a simple MySQL project for managing basic hospital data.

The system stores:
- Patients
- Doctors
- Appointments
- Medical Records
- Billing
- Departments

It also uses different SQL concepts like CRUD, joins, subqueries, aggregate functions, date functions, string functions, window functions and CASE.

## Database

Database name:

`hospital_management`

## Main Tables

1. **Patients** - stores patient details.
2. **Doctors** - stores doctor details and fees.
3. **Appointments** - connects patients with doctors.
4. **Medical_Records** - stores diagnosis and treatment details.
5. **Billing** - stores invoices and payment status.
6. **Departments** - stores hospital departments.
7. **Doctor_Department** - connects doctors with departments.

## Relationships

- Patients → Appointments
- Doctors → Appointments
- Patients → Medical_Records
- Doctors → Medical_Records
- Patients → Billing
- Appointments → Billing
- Doctors → Departments

## SQL Concepts Used

- CREATE DATABASE and TABLE
- INSERT, UPDATE and DELETE
- WHERE, HAVING and LIMIT
- AND, OR and NOT
- ORDER BY and GROUP BY
- SUM, AVG, MAX, MIN and COUNT
- Primary Keys and Foreign Keys
- INNER JOIN, LEFT JOIN and RIGHT JOIN
- FULL OUTER JOIN alternative using UNION
- Subqueries
- Date and Time Functions
- String Functions
- Window Functions
- CASE Expressions

## How to Run

1. Open MySQL Workbench or another MySQL editor.
2. Open `hospital_management.sql`.
3. Run the complete SQL file.
4. The database and sample data will be created.
5. Run the queries at the bottom of the file to check the results.
