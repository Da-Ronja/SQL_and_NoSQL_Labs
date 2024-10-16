CREATE DATABASE IF NOT EXISTS world_lexicon;

/* 1. Write a SQL statement to create a simple table countries including
columns country_id,country_name and region_id. */
CREATE TABLE IF NOT EXISTS countries (
country_id INT,
country_name VARCHAR(100),
region_id INT
);

/* 2. Write a SQL statement to create the structure of a table dup_countries
similar to countries. */
CREATE TABLE IF NOT EXISTS dup_countries LIKE countries;

/* wrong doing in 3. Write a SQL statement to create a table countries set a constraint NOT NULL. */
ALTER TABLE countries 
MODIFY country_id INT NOT NULL, 
MODIFY country_name VARCHAR(100) NOT NULL, 
MODIFY region_id INT  NOT NULL;

DROP TABLE countries;

/* 3. Write a SQL statement to create a table countries set a constraint NOT NULL. */
CREATE TABLE countries (
country_id INT NOT NULL,
country_name VARCHAR(100) NOT NULL,
region_id INT NOT NULL
);

/* 4. Write a SQL statement to insert a record with your own value into the
table countries against each columns. */
INSERT INTO countries (country_id, country_name, region_id)
VALUES (1, 'Argentina', 101);

/* 5. Write a SQL statement to insert 3 rows by a single insert statement. */
INSERT INTO countries (country_id, country_name, region_id)
VALUES (2, 'Sweden', 102), 
       (3, 'Irland', 103), 
       (4, 'Spain', 104);

/* 6. Write a SQL statement to insert a record into the table countries to
ensure that, a country_id and region_id combination will be entered once in
the table */
ALTER TABLE countries
ADD CONSTRAINT unique_country_region UNIQUE (country_id, region_id);
