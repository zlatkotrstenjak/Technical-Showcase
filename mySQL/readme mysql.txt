Dataset Overview

5 tables with the following columns:
 -customers: customer_id, name, segment, country, region, join_date
 -products: product_id, name, category, sub_category, cost_price
 -orders: order_id, customer_id, order_date, ship_date, shipping_mode
 -orederdetails: order_id, product_id, quantity, unit_price, discount
 -returns: return_id, order_id, return_date, reason

Data randomly generated with python script MySQL Database Generator.


Skills demonstrated

basic.sql:
-data retrieval and filtering
-aggregations
-grouping
-joins

intermediate.sql
-subqueries
-common table expressions
-CASE statements
-string functions, date functions
-window functions
-rollout

advanced.sql
-recursive CTEs
-advanced window functions
-stored procedures
-triggers
-views
-cursors


Sample Use Cases

- Rank customers by number of orders.
- Calculate month-over-month sales by region.
- Detect orders that were returned and log return events using triggers.
