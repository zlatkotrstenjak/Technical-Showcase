-- Get all customers from Canada
SELECT name, country
FROM customers
WHERE country = 'Canada';


-- 10 oldest orders
SELECT order_id, customer_id, order_date
FROM orders
ORDER BY order_date
LIMIT 10;


-- Product categories
SELECT DISTINCT category
FROM products;


-- Customers from Europe who joined after 2022
SELECT *
FROM customers
WHERE region = 'Europe' AND join_date > '2022-01-01'
ORDER BY join_date DESC;


-- Orders shipped using Same Day or First Class
SELECT *
FROM orders
WHERE shipping_mode IN ('Same Day', 'First Class')
ORDER BY ship_date;


-- Number of orders per country, show only countries with more than 5 orders
SELECT country, COUNT(*) AS number_of_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY country
HAVING number_of_orders > 5;


-- Total sales by category
SELECT p.category, SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
FROM orderdetail od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category;


-- Customer name and the products they ordered
SELECT c.name AS customer_name, p.name AS product_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetail od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;


-- Orders and return reasons if returned
SELECT o.*, r.reason
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id;
