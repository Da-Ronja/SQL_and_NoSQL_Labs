/* 
CREATE DATABASE IF NOT EXISTS `clinic`;

USE `clinic`;

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

INSERT INTO departments(name) VALUES('Therapy'), ('Support'), ('Management'), ('Other');

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    department_id INT NOT NULL,
    salary DOUBLE NOT NULL,
    CONSTRAINT `fk_department_id` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
);

INSERT INTO `employees` (`first_name`, `last_name`, `job_title`, `department_id`, `salary`) VALUES
('Maria', 'Anderson', 'Therapist', 1, 400.00),
('Anna', 'Johansson', 'Acupuncturist', 1, 830.00),
('Ingrid', 'Pettersson', 'Technician', 2, 1140.00),
('Lena', 'Magnusson', 'Supervisor', 3, 1200.00),
('Sandy', 'Petersson', 'Dentist', 4, 1400.23),
('Max', 'Persson', 'Therapist', 1, 992.00),
('Andres', 'Tegnell', 'Epidemiologist', 4, 1340.00),
('Margareta', 'Olsson', 'Medical Director', 3, 2500.00),
('Daniel', 'Nilsson', 'Nutrition Technician', 4, 2600.00);

CREATE TABLE rooms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    occupation VARCHAR(30)
);

INSERT INTO rooms(`occupation`) VALUES('free'), ('occupied'), ('free'), ('free'), ('occupied');

CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    room_id INT NOT NULL
);

INSERT INTO patients(`first_name`, `last_name`, `room_id`)
VALUES('Birgitta', 'Larsson', 1), ('Marianne', 'Lindeberg', 3), ('Bertil', 'Dahlberg', 2),
('Filip', 'Wilhelm', 2), ('Nikolay', 'Nikolaev', 3);
*/

/* 2. Write a query to select all employees (id, first_name, last_name, job_title, salary)
whose salaries are higher than 1000.00, ordered by id. Concatenate fields first_name and
last_name into ‘full_name’ */

/*
SELECT id, CONCAT(first_name, ' ', last_name) full_name,  job_title, salary
FROM employees
WHERE salary > 1000.00
ORDER BY id;
*/

/* 3. Update all employees salaries whose job_title is “Dentist” by 10%. Retrieve information about all
salaries ordered ascending. */

/*
UPDATE employees
SET salary = salary * 1.10
WHERE job_title = 'Dentist' AND id > 0;
*/

/* 4. Write a query to delete all employees from the “employees” table who are in department 3 or 4.
Order the information by id.*/

DELETE FROM employees
WHERE department_id IN (3, 4);

SELECT id, CONCAT(first_name, ' ', last_name) full_name,  job_title, salary
FROM employees;

SELECT *
FROM departments