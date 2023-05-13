CREATE DATABASE pizzasales_project;

USE pizzasales_project;

-- View tables
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

-- View data types
DESCRIBE order_details;
DESCRIBE orders;
DESCRIBE pizza_types;
DESCRIBE pizzas;

-- 1) What days and times do we tend to be busiest
SELECT DAYNAME(date) AS 'Day of week', 
	   COUNT(*) AS 'Number of orders'
FROM orders 
GROUP BY 1 
ORDER BY 2 DESC;

SELECT MONTHNAME(date) AS Month, 
	   DAYNAME(date) AS Day, 
       COUNT(*) AS 'Number of orders' 
FROM orders 
GROUP BY 2,1 ;

SELECT 
	SUM(CASE WHEN HOUR(time) > 8 AND HOUR(time) < 12 THEN 1 ELSE 0 END) AS "Morning orders",
    SUM(CASE WHEN HOUR(time) >= 12 AND HOUR(time) < 17 THEN 1 ELSE 0 END) AS "Afternoon orders",
    SUM(CASE WHEN HOUR(time) >= 17 AND HOUR(time) < 20 THEN 1 ELSE 0 END) AS "Evening orders",
    SUM(CASE WHEN HOUR(time) >= 20 THEN 1 ELSE 0 END) AS "Night orders"
from orders;

-- 2) What are our best and worst selling pizzas?
   -- best 5 selling pizzas :
SELECT pt.name , 
	   SUM(subquery.sales) AS sales
FROM pizza_types AS pt
JOIN (SELECT p.pizza_type_id, 
		     od.pizza_id, 
             (sum(od.quantity) * p.price) AS sales
	  FROM order_details AS od
	  JOIN pizzas AS p
	  ON od.pizza_id = p.pizza_id
	  GROUP BY od.pizza_id
      ) AS subquery
ON pt.pizza_type_id = subquery.pizza_type_id
GROUP BY pt.pizza_type_id
ORDER BY 2 DESC
LIMIT 5;

-- Worst 5 selling pizzas :
SELECT pt.name , 
	   SUM(subquery.sales) AS sales
FROM pizza_types AS pt
JOIN (SELECT p.pizza_type_id, 
		     od.pizza_id, 
             (sum(od.quantity) * p.price) AS sales
	  FROM order_details AS od
	  JOIN pizzas AS p
	  ON od.pizza_id = p.pizza_id
	  GROUP BY od.pizza_id
      ) AS subquery
ON pt.pizza_type_id = subquery.pizza_type_id
GROUP BY pt.pizza_type_id
ORDER BY 2 ASC
LIMIT 5;

-- 3) sales trend
SELECT Month, 
	   SUM(order_price) AS Sales 
FROM (SELECT od.order_id, 
			 MONTHNAME(o.date) AS Month, 
             SUM((od.quantity * p.price)) AS order_price
	 FROM order_details AS od
	 JOIN pizzas AS p
	 ON od.pizza_id = p.pizza_id
	 JOIN orders AS o
	 ON o.order_id = od.order_id
	 GROUP BY od.order_id) AS subquery
GROUP BY Month;

-- 4) Revenue 
select SUM(Sales) AS Revenue 
FROM (SELECT Month, 
	   SUM(order_price) AS Sales 
	FROM (SELECT od.order_id, 
				MONTHNAME(o.date) AS Month, 
				SUM((od.quantity * p.price)) AS order_price
		FROM order_details AS od
		JOIN pizzas AS p
		ON od.pizza_id = p.pizza_id
		JOIN orders AS o
		ON o.order_id = od.order_id
		GROUP BY od.order_id) AS subquery
	GROUP BY Month) as subquery2;

-- 5) Avg order value
SELECT ROUND(AVG(order_price),2) AS 'Average order price'
FROM (SELECT od.order_id, 
			 SUM((od.quantity * p.price)) AS order_price
	  FROM order_details AS od
	  JOIN pizzas AS p
	  ON od.pizza_id = p.pizza_id
	  GROUP BY order_id
	  ORDER BY 1) AS subquery;
      
-- 6) Sales per category
SELECT pt.category, 
	   SUM(subquery.sales) AS Sales
FROM (SELECT p.pizza_type_id, 
			 od.pizza_id,
			 (sum(od.quantity) * p.price) AS sales
	  FROM order_details AS od
	  JOIN pizzas AS p
	  ON od.pizza_id = p.pizza_id
	  GROUP BY od.pizza_id) AS subquery 
JOIN pizza_types AS pt
ON subquery.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;
