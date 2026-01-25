CREATE DATABASE RetailAnalytics;
GO
USE RetailAnalytics;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50)
);

INSERT INTO customers VALUES
(1,'Ravi Kumar','Male','Hyderabad','Telangana'),
(2,'Anita Sharma','Female','Bangalore','Karnataka'),
(3,'Suresh Reddy','Male','Chennai','Tamil Nadu'),
(4,'Priya Singh','Female','Mumbai','Maharashtra'),
(5,'Amit Verma','Male','Delhi','Delhi');


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    cost_price INT,
    selling_price INT
);

INSERT INTO products VALUES
(101,'Laptop','Electronics',40000,55000),
(102,'Mobile','Electronics',15000,22000),
(103,'Headphones','Accessories',2000,3000),
(104,'Office Chair','Furniture',5000,8000),
(105,'Table Lamp','Furniture',1200,1800);


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT
);

INSERT INTO orders VALUES
(1001,'2024-01-10',1),
(1002,'2024-01-15',2),
(1003,'2024-02-05',3),
(1004,'2024-02-20',4),
(1005,'2024-03-10',5);


CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT
);

INSERT INTO order_items VALUES
(1,1001,101,1),
(2,1001,103,2),
(3,1002,102,1),
(4,1003,104,1),
(5,1004,105,3),
(6,1005,101,2);


SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

CREATE VIEW vw_sales AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.gender,
    c.city,
    c.state,
    p.product_name,
    p.category,
    oi.quantity,
    p.cost_price,
    p.selling_price,
    (oi.quantity * p.selling_price) AS sales_amount,
    (oi.quantity * p.cost_price) AS cost_amount,
    (oi.quantity * (p.selling_price - p.cost_price)) AS profit_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;


SELECT * FROM vw_sales;

CREATE VIEW vw_monthly_finance AS
SELECT
    FORMAT(order_date, 'yyyy-MM') AS month,
    SUM(sales_amount) AS total_sales,
    SUM(cost_amount) AS total_cost,
    SUM(profit_amount) AS total_profit
FROM vw_sales
GROUP BY FORMAT(order_date, 'yyyy-MM');

SELECT * FROM vw_monthly_finance;

CREATE VIEW vw_customer_contribution AS
SELECT
    customer_name,
    SUM(sales_amount) AS total_sales,
    SUM(profit_amount) AS total_profit
FROM vw_sales
GROUP BY customer_name;

CREATE VIEW vw_product_profitability AS
SELECT
    product_name,
    category,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount) AS total_sales,
    SUM(profit_amount) AS total_profit
FROM vw_sales
GROUP BY product_name, category;

