-- =====================================================================
-- Project: E-Commerce Database Management System
-- Task: SQL Task (E-Commerce Database System)
-- Author: Amarsinh Patil
-- Target DBMS: MySQL 8.0+ / MariaDB
-- Description: Official GUVI Task Implementation with customers, products, 
--              orders, 3NF normalization (order_items), and 10 required queries.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. DATABASE CREATION AND INITIALIZATION
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- ---------------------------------------------------------------------
-- 2. TABLE CREATION (CORE ENTITIES)
-- ---------------------------------------------------------------------

-- Table 1: Customers
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address TEXT NOT NULL
);

-- Table 2: Products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Table 3: Orders (Initial Relational Model)
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    product_id INT,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- ---------------------------------------------------------------------
-- 3. SAMPLE DATA INSERTION (SEED DATA)
-- ---------------------------------------------------------------------

-- Insert Sample Customers
INSERT INTO customers (id, name, email, address) VALUES
(1, 'John Doe', 'john.doe@example.com', '123 Elm Street, New York, NY'),
(2, 'Jane Smith', 'jane.smith@example.com', '456 Oak Avenue, Los Angeles, CA'),
(3, 'Bob Johnson', 'bob.johnson@example.com', '789 Pine Road, Chicago, IL'),
(4, 'Alice Brown', 'alice.brown@example.com', '321 Maple Drive, Houston, TX'),
(5, 'Charlie Davis', 'charlie.davis@example.com', '654 Cedar Lane, Phoenix, AZ');

-- Insert Sample Products (Including Product A, Product B, Product C)
INSERT INTO products (id, name, price, description) VALUES
(1, 'Product A', 120.00, 'Premium noise-cancelling wireless Bluetooth headphones'),
(2, 'Product B', 85.50, 'Ergonomic backlit mechanical gaming keyboard with blue switches'),
(3, 'Product C', 35.00, 'High-precision optical USB gaming mouse (3200 DPI)'),
(4, 'Product D', 250.00, '27-inch 4K UHD IPS professional computer monitor'),
(5, 'Product E', 60.00, '20,000mAh portable power bank with fast-charging USB-C ports');

-- Insert Sample Orders (Dates within last 30 days and older for filtering demonstration)
INSERT INTO orders (id, customer_id, order_date, total_amount, product_id) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 120.00, 1),
(2, 2, DATE_SUB(CURDATE(), INTERVAL 12 DAY), 250.00, 4),
(3, 3, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 155.50, 2),
(4, 1, DATE_SUB(CURDATE(), INTERVAL 25 DAY), 70.00, 3),
(5, 4, DATE_SUB(CURDATE(), INTERVAL 45 DAY), 180.00, 1),
(6, 5, DATE_SUB(CURDATE(), INTERVAL 60 DAY), 60.00, 5);

-- =====================================================================
-- 4. THE 10 MANDATORY ANALYTICAL SQL QUERIES
-- =====================================================================

-- ---------------------------------------------------------------------
-- Query 1: Retrieve all customers who have placed an order in the last 30 days.
-- Objective: Filters orders within the past 30 days using DATE_SUB / INTERVAL.
-- ---------------------------------------------------------------------
SELECT DISTINCT 
    c.id AS customer_id,
    c.name AS customer_name,
    c.email,
    c.address,
    o.order_date
FROM 
    customers c
INNER JOIN 
    orders o ON c.id = o.customer_id
WHERE 
    o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY 
    o.order_date DESC;

-- ---------------------------------------------------------------------
-- Query 2: Get the total amount of all orders placed by each customer.
-- Objective: Aggregates cumulative spending per customer using SUM() and GROUP BY.
-- ---------------------------------------------------------------------
SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    c.email,
    COUNT(o.id) AS total_orders_placed,
    SUM(o.total_amount) AS total_order_amount
FROM 
    customers c
INNER JOIN 
    orders o ON c.id = o.customer_id
GROUP BY 
    c.id, c.name, c.email
ORDER BY 
    total_order_amount DESC;

-- ---------------------------------------------------------------------
-- Query 3: Update the price of Product C to 45.00.
-- Objective: Modifies existing record using UPDATE with WHERE filter.
-- ---------------------------------------------------------------------
UPDATE products
SET price = 45.00
WHERE name = 'Product C';

-- Verification of updated price:
SELECT id, name, price, description 
FROM products 
WHERE name = 'Product C';

-- ---------------------------------------------------------------------
-- Query 4: Add a new column discount to the products table.
-- Objective: Modifies table schema using DDL ALTER TABLE ADD COLUMN.
-- ---------------------------------------------------------------------
ALTER TABLE products
ADD COLUMN discount DECIMAL(5, 2) DEFAULT 0.00 AFTER price;

-- Verification of new column structure:
DESCRIBE products;

-- ---------------------------------------------------------------------
-- Query 5: Retrieve the top 3 products with the highest price.
-- Objective: Sorts products descending by price and limits results to top 3.
-- ---------------------------------------------------------------------
SELECT 
    id AS product_id,
    name AS product_name,
    price,
    discount,
    description
FROM 
    products
ORDER BY 
    price DESC
LIMIT 3;

-- ---------------------------------------------------------------------
-- Query 6: Get the names of customers who have ordered Product A.
-- Objective: Multi-table JOIN linking customers, orders, and products.
-- ---------------------------------------------------------------------
SELECT DISTINCT 
    c.id AS customer_id,
    c.name AS customer_name,
    c.email,
    p.name AS product_ordered
FROM 
    customers c
INNER JOIN 
    orders o ON c.id = o.customer_id
INNER JOIN 
    products p ON o.product_id = p.id
WHERE 
    p.name = 'Product A';

-- ---------------------------------------------------------------------
-- Query 7: Join the orders and customers tables to retrieve the customer's 
--          name and order date for each order.
-- Objective: Performs relational INNER JOIN between orders and customers.
-- ---------------------------------------------------------------------
SELECT 
    o.id AS order_id,
    c.name AS customer_name,
    o.order_date,
    o.total_amount
FROM 
    orders o
INNER JOIN 
    customers c ON o.customer_id = c.id
ORDER BY 
    o.order_date DESC;

-- ---------------------------------------------------------------------
-- Query 8: Retrieve the orders with a total amount greater than 150.00.
-- Objective: Filters transactions using numeric threshold WHERE condition.
-- ---------------------------------------------------------------------
SELECT 
    id AS order_id,
    customer_id,
    order_date,
    total_amount
FROM 
    orders
WHERE 
    total_amount > 150.00
ORDER BY 
    total_amount DESC;

-- ---------------------------------------------------------------------
-- Query 9: Normalize the database by creating a separate table for order items 
--          and updating the orders table to reference the order_items table.
-- Objective: Converts 1-to-1/1-to-N product mapping into a 3NF normalized 
--            Many-to-Many associative table (order_items), supporting multiple 
--            items per order with distinct quantities and prices.
-- ---------------------------------------------------------------------

-- Step 9A: Create normalized order_items associative junction table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Step 9B: Populate order_items with line items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 120.00), -- Order 1 contains 1x Product A
(2, 4, 1, 250.00), -- Order 2 contains 1x Product D
(3, 2, 1, 85.50),  -- Order 3 contains 1x Product B
(3, 5, 1, 60.00),  -- Order 3 contains 1x Product E (multiple items in one order)
(4, 3, 1, 45.00),  -- Order 4 contains 1x Product C
(5, 1, 1, 120.00), -- Order 5 contains 1x Product A
(5, 5, 1, 60.00),  -- Order 5 contains 1x Product E
(6, 5, 1, 60.00);  -- Order 6 contains 1x Product E

-- Step 9C: Update orders table structure (drop denormalized product_id)
ALTER TABLE orders DROP FOREIGN KEY fk_orders_product;
ALTER TABLE orders DROP COLUMN product_id;

-- Demonstration of Normalized Query (Query 6 executed across 3NF order_items):
SELECT DISTINCT 
    c.id AS customer_id,
    c.name AS customer_name,
    p.name AS product_ordered,
    oi.quantity,
    oi.unit_price
FROM 
    customers c
INNER JOIN 
    orders o ON c.id = o.customer_id
INNER JOIN 
    order_items oi ON o.id = oi.order_id
INNER JOIN 
    products p ON oi.product_id = p.id
WHERE 
    p.name = 'Product A';

-- ---------------------------------------------------------------------
-- Query 10: Retrieve the average total of all orders.
-- Objective: Calculates store-wide arithmetic mean of order totals with AVG().
-- ---------------------------------------------------------------------
SELECT 
    COUNT(id) AS total_orders_count,
    ROUND(AVG(total_amount), 2) AS average_order_total
FROM 
    orders;

-- =====================================================================
-- End of Script
-- =====================================================================
