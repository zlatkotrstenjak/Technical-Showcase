-- advanced window functions - get mom sales change

WITH monthly_sales AS (
    SELECT 
        c.region,
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(od.quantity * od.unit_price * (1 - od.discount)) AS monthly_sales
    FROM orders o
    JOIN orderdetail od ON o.order_id = od.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.region, DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    region,
    month,
    monthly_sales,
    LAG(monthly_sales) OVER (PARTITION BY region ORDER BY month) AS prev_month_sales,
    ROUND(
        (monthly_sales - LAG(monthly_sales) OVER (PARTITION BY region ORDER BY month)) /
        NULLIF(LAG(monthly_sales) OVER (PARTITION BY region ORDER BY month), 0) * 100, 2
    ) AS mom_change_pct
FROM monthly_sales;


 -- recursive common table expressions - generate numbers from 1 to n
 
 WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;


-- correlated subqueries - get customers who spent more than average

SELECT customer_id
FROM orders o
JOIN orderdetail od ON o.order_id = od.order_id
GROUP BY customer_id
HAVING SUM(od.unit_price * od.quantity * (1 - od.discount)) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT customer_id,
               SUM(od.unit_price * od.quantity * (1 - od.discount)) AS customer_total
        FROM orders o
        JOIN orderdetail od ON o.order_id = od.order_id
        GROUP BY customer_id
    ) AS totals
);


 -- stored procedure - get top n customers by total sales

DELIMITER //
CREATE PROCEDURE TopCustomers(IN top_n INT)
BEGIN
    SELECT c.customer_id, c.name,
           SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN orderdetail od ON o.order_id = od.order_id
    GROUP BY c.customer_id
    ORDER BY total_sales DESC
    LIMIT top_n;
END //
DELIMITER ;

CALL TopCustomers(5);
 
 
 -- triggers - insert into return_audit after insert into returns
 
 CREATE TABLE return_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    return_id INT,
    order_id INT,
    action_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(10)
);

DELIMITER //
CREATE TRIGGER log_return_insert
AFTER INSERT ON returns
FOR EACH ROW
BEGIN
    INSERT INTO return_audit (return_id, order_id, action)
    VALUES (NEW.return_id, NEW.order_id, 'INSERT');
END //
DELIMITER ;

INSERT INTO returns (return_id, order_id, return_date, reason)
VALUES (101, 141, '2025-07-10', 'Damaged');

/*
SET SQL_SAFE_UPDATES = 0;
DELETE FROM returns
WHERE return_id = 101;
SET SQL_SAFE_UPDATES = 1;
*/


-- views - customers summary

CREATE VIEW customer_sales_summary AS
SELECT c.customer_id, c.name,
       SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetail od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.name;

SELECT * FROM customer_sales_summary;


-- cursors - get number of orders per customer in a seperate table

CREATE TABLE customer_order_summary (
    customer_id VARCHAR(10),
    total_orders INT
);

DELIMITER //
CREATE PROCEDURE ShowCustomerOrders()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cid VARCHAR(10);
    DECLARE cur CURSOR FOR SELECT DISTINCT customer_id FROM orders;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cid;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SELECT cid AS customer_id,
               COUNT(*) AS total_orders
        FROM orders
        WHERE customer_id = cid;
        
        INSERT INTO customer_order_summary (customer_id, total_orders)
		SELECT cid, COUNT(*) FROM orders WHERE customer_id = cid;

    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

CALL ShowCustomerOrders();

SELECT * FROM customer_order_summary