USE project_hr;

SELECT * FROM hr;

# 1) What is the gender breakdown of employees in the company ?
SELECT 
	gender,
    COUNT(gender) AS Count_Per_Gender,
    100.0 * COUNT(gender) / (SELECT COUNT(*) FROM hr WHERE age > 18 AND termdate = '0000-00-00') AS Percentage_Per_Gender
FROM hr 
WHERE age >18  AND termdate = '0000-00-00' 
GROUP BY gender;

# 2) What is the race breakdown of employees in the company
SELECT 
	race,
    COUNT(race) AS Count,
    100.0 * Count(race) / (SELECT COUNT(*) FROM hr WHERE age > 18 AND termdate = '0000-00-00') AS Percentange
FROM hr
WHERE age > 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY Count DESC;

# 3) What is the age distribution of employees in the company ?
SELECT 
	CASE
		WHEN age >= 20 AND age <= 30 THEN '20-30'
        WHEN age > 30 AND age <= 40 THEN '30-40'
        WHEN age > 40 AND age <= 50 THEN '40-50' 
        ELSE '50+ '
	END AS Age_group,
COUNT(*) AS Count,
gender
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY Age_group, gender
ORDER BY Age_group, gender;

# 4) How many employees work at headquarters versus remote locations ?
SELECT 
	location, 
    count(location) 
FROM hr 
WHERE age > 18 AND termdate = '0000-00-00'
GROUP BY location;

# 5) What is the average length of employment for employees who have been terminated ?
SELECT 
	ROUND(AVG(TIMESTAMPDIFF(YEAR, hire_date,termdate)),0) AS Average_Length_Employment
FROM hr 
WHERE age > 18 AND termdate <= CURDATE() AND termdate <> '0000-00-00';

# 6) How does the gender distribution vary across departements 
SELECT 
	gender, count(gender) ,
    department
FROM hr
WHERE age > 18 AND termdate ='0000-00-00' 
GROUP BY department, gender 
ORDER BY department;

# 7) What is the distribution of job titles across 
SELECT jobtitle,
		COUNT(jobtitle) AS Count
FROM hr
WHERE age > 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle desc;

# 8) Which department has the highest turnover rate
SELECT
	department,
    Number_Of_Employees,
    Number_Of_Termined_Employees,
    Number_Of_Termined_Employees / Number_Of_Employees AS Termination_rate
FROM
	(SELECT 
		department, 
		COUNT(*) AS Number_Of_Employees,
		SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS Number_Of_Termined_Employees
	FROM hr 
	WHERE age > 18
	GROUP BY department
	ORDER BY department) as SubQuary
ORDER BY Termination_rate DESC;


# 9) What is the distribution of employees across locations by city and state
SELECT location_state AS State, 
	   location_city AS City, 
       COUNT(*) AS Number_Of_Employees 
FROM hr 
WHERE age > 18 AND termdate = "0000-00-00"
GROUP BY State, City 
ORDER BY State;

# 10) How has the company's employee count changed over time based on hire and term dates ?
SELECT 
	Hire_year,
    Number_of_hired,
    Number_Of_Termination,
    ROUND(((Number_of_hired - Number_Of_Termination) / Number_of_hired) * 100, 2) AS Change_percentage
FROM
(SELECT 
	YEAR(hire_date) AS Hire_year,
    COUNT(*) AS Number_of_hired,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS Number_Of_Termination
FROM hr
WHERE age > 18
GROUP BY Hire_year) AS SubQuery
ORDER BY Hire_year ASC;    

# 11) What is the tenure distribution for each department ?
SELECT 
	department,
	ROUND( AVG ( DATEDIFF(termdate, hire_date) / 365 ), 0 ) AS Tenure_rate
FROM hr
WHERE age > 18 AND termdate <= curdate() AND termdate <> '0000-00-00'
GROUP BY department
ORDER BY department;

