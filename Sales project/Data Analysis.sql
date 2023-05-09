CREATE DATABASE Sales_project;

USE Sales_Project;

# Number of rows
SELECT 
	COUNT(*) AS 'Total rows' 
FROM sales;

# View table
SELECT * FROM sales;

# number of customers
SELECT 
	COUNT(DISTINCT CUSTOMERNAME) AS 'Number of customers' 
FROM sales;

# total sales 
SELECT 
	SUM(SALES) AS 'Revenue' 
FROM sales;

# status distribution
SELECT 
	STATUS, 
	count(STATUS) 
FROM sales
GROUP BY STATUS;

# lowest and highest price
SELECT 
	MAX(PRICEEACH) AS 'HIGHEST PRICE' , 
    MIN(PRICEEACH) AS'CHEAPEST PRICE'
FROM sales;

# Sum sales by producline
SELECT 
	PRODUCTLINE, 
	SUM(SALES) AS Sales 
FROM sales 
GROUP BY PRODUCTLINE 
order by Sales desc;


# Year with the best sales
SELECT 
	YEAR_ID, 
    SUM(SALES) AS SALES 
FROM sales 
GROUP BY YEAR_ID 
ORDER BY 2 DESC;

-- Notice that the company didnt make good sales during 2005 compared to 2003 and 2004, lets analyse why.
SELECT 
	YEAR_ID, 
    COUNT(DISTINCT MONTH_ID) AS 'Number of worked months' 
FROM sales 
GROUP BY YEAR_ID;

# Which dealsize generate the best revenue
SELECT 
	DEALSIZE, 
    SUM(SALES) AS Revenue 
FROM sales 
GROUP BY DEALSIZE 
ORDER BY 2 DESC;

# What was the best month for sales in a specific year ? How much was earned that month ?
SELECT 
	MONTH_ID, 
    SUM(SALES) AS Revenue , 
    COUNT(*) AS 'Number of orders'
FROM sales
WHERE YEAR_ID = 2004
GROUP BY  MONTH_ID
ORDER BY 2 DESC;

# What product is sold during November
SELECT 
	MONTH_ID, 
    PRODUCTLINE, 
    SUM(SALES) AS Revenue
FROM sales
WHERE YEAR_ID = 2003 AND MONTH_ID = 11
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY 3 DESC;

SELECT 
	MONTH_ID, 
    YEAR_ID, 
    PRODUCTLINE, 
    SUM(QUANTITYORDERED) AS 'total of orders' 
FROM sales 
WHERE MONTH_ID = 11 AND YEAR_Id in (2003,2004)  
GROUP BY YEAR_ID, PRODUCTLINE 
ORDER BY 2 ASC;

# top 10 customers
SELECT 
	CUSTOMERNAME, 
    COUNT(ORDERNUMBER) AS Frequency, 
    SUM(QUANTITYORDERED) AS 'Quantity ordered',
    SUM(SALES) AS Sales
FROM sales
GROUP BY CUSTOMERNAME
ORDER BY 2 DESC;

# List of countries
SELECT 
	COUNTRY,
    COUNT(COUNTRY) 
FROM sales 
GROUP BY COUNTRY 
ORDER BY 2 DESC; 

# sales per year
SELECT 
	YEAR_ID, 
    ROUND(SUM(SALES),2) AS Sales 
FROM sales 
GROUP BY YEAR_ID 
ORDER BY 1 ASC;


