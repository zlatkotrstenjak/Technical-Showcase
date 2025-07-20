--  subqueries - customers with more order counts than average

SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (
    SELECT AVG(order_count)
    FROM (
        SELECT customer_id, COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) AS subquery
);


-- common table expression - profit per order

WITH order_profits AS (
    SELECT od.order_id,
           SUM((od.unit_price - p.cost_price) * od.quantity * (1 - od.discount)) AS profit
    FROM orderdetail od
    JOIN products p ON od.product_id = p.product_id
    GROUP BY od.order_id
)
SELECT * FROM order_profits
ORDER BY profit DESC;


-- case statement - classify discont category

SELECT order_id, discount,
  CASE
    WHEN discount = 0 THEN 'No Discount'
    WHEN discount < 0.15 THEN 'Low Discount'
    ELSE 'High Discount'
  END AS discount_category
FROM orderdetail;


-- string functions - extract first and last name

SELECT name,
       SUBSTRING_INDEX(REPLACE(REPLACE(REPLACE(name, 'Mrs. ', ''), 'Mr. ', ''), 'Dr. ', ''), ' ', 1) AS first_name,
	CASE
	  WHEN name REGEXP ' (Jr\\.|Sr\\.|II|III|IV)$'
      THEN SUBSTRING_INDEX(SUBSTRING_INDEX(name, ' ', -2), ' ', 1)
      ELSE SUBSTRING_INDEX(name, ' ', -1)
  END AS last_name
FROM customers;


-- date functions - number of orders per year

SELECT YEAR(order_date) AS year, COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_date)
ORDER BY year;


-- window functions - rank customers by number of orders

SELECT customer_id,
       COUNT(*) AS total_orders,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
FROM orders
GROUP BY customer_id;

-- product quantity running total
SELECT 
    p.product_id,
    p.name,
    od.quantity,
    SUM(od.quantity) OVER (PARTITION BY od.product_id ORDER BY od.order_id) AS running_total
FROM products AS p
JOIN orderdetail AS od ON p.product_id = od.product_id;


-- multi table joins - join all tables

SELECT o.order_id, o.order_date, c.name AS customer_name, p.name AS product_name,
       od.quantity, od.unit_price,  r.reason AS return_reason
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN orderdetail od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
LEFT JOIN returns r ON od.order_id = r.order_id;


-- set operations - get customers from asia or europe

SELECT customer_id, name, region
FROM customers
WHERE region = 'Asia'
UNION
SELECT customer_id, name, region
FROM customers
WHERE region = 'Europe';


-- data formating - format date

SELECT name, 
       DATE_FORMAT(join_date, '%d/%m/%Y') AS formatted_join_date
FROM customers;


-- rollut - order count by region with subtotals

SELECT region, country, COUNT(*) AS total_customers
FROM customers
GROUP BY region, country WITH rollup;
