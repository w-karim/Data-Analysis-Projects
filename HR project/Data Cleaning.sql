#create the database
CREATE DATABASE Project_HR;

#connect to the database
USE project_hr;

#view our table
SELECT * FROM hr;

#change column name
ALTER TABLE hr RENAME COLUMN ï»¿id TO employee_id;

#check data type of our table
DESCRIBE hr;

# update birthdate format and data type
SET sql_safe_updates = 0;
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
	WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE hr MODIFY birthdate DATE;

SELECT birthdate FROM hr;

# update hire_date format and data type
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'),'%Y-%m-%d')
	WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE hr MODIFY hire_date DATE;

SELECT hire_date FROM hr;

# removing timestamp from termdate
UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC')) WHERE termdate IS NOT NULL AND termdate != ' ';
ALTER TABLE hr MODIFY termdate DATE;
SELECT termdate FROM hr;

# add age column
ALTER TABLE hr ADD COLUMN age INT;
UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

select birthdate,min(age) from hr;