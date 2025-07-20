#import data

CREATE DATABASE sales_showcase;
USE sales_showcase;

CREATE TABLE Customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50),
    join_date DATE
);

CREATE TABLE Products (
    product_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    cost_price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    shipping_mode VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE OrderDetail (
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT,
    unit_price DECIMAL(10, 2),
    discount DECIMAL(4, 2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE Returns (
    return_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    return_date DATE,
    reason VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

#table data import wizard to import csv-s