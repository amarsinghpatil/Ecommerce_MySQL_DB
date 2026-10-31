# 🛒 E-Commerce Database Management System

A relational database system designed in **MySQL** for an e-commerce platform. Features structured table design, foreign key constraints, cascading rules, mock test data, database normalization (3NF `order_items`), and all 10 required analytical SQL queries.

---

## 📌 Project Overview

* **Project Title:** SQL Task (E-Commerce Database System)
* **Author:** Amarsinh Patil
* **Database Engine:** MySQL 8.0+ / MariaDB
* **Script File:** [`ecommerce_database.sql`](ecommerce_database.sql)
* **Database Name:** `ecommerce`

---

## 🏗️ Database Schema & Normalization (3NF)

The database `ecommerce` manages customers, catalog products, and transactions:

| Table | Purpose | Primary Key | Foreign Keys |
| :--- | :--- | :---: | :--- |
| **`customers`** | Customer profiles, emails, and shipping addresses | `id` | None |
| **`products`** | Product catalog, pricing, discounts, and descriptions | `id` | None |
| **`orders`** | Transaction records, dates, and order totals | `id` | `customer_id` ➔ `customers(id)` |
| **`order_items`** | Normalized line items linking orders to multiple products | `id` | `order_id` ➔ `orders(id)`, `product_id` ➔ `products(id)` |

---

## 📊 Entity Relationship Diagram (ERD)

```
[ customers ] (1) ───< places >─── (N) [ orders ] (1) ───< contains >─── (N) [ order_items ] (N) ───< links >─── (1) [ products ]
```

---

## 🔍 The 10 Mandatory Analytical SQL Queries

1. **Orders in Last 30 Days:** Retrieve all customers who placed an order within the past 30 days (`DATE_SUB(CURDATE(), INTERVAL 30 DAY)`).
2. **Total Spend Per Customer:** Calculate the cumulative order total for each customer (`SUM(total_amount)` with `GROUP BY`).
3. **Price Update:** Update the price of **Product C** to **45.00** (`UPDATE ... WHERE name = 'Product C'`).
4. **Schema Alteration:** Add a new `discount` column to the `products` table (`ALTER TABLE products ADD COLUMN discount DECIMAL(5, 2)`).
5. **Top 3 Highest-Priced Products:** Rank catalog products descending by price (`ORDER BY price DESC LIMIT 3`).
6. **Customer Purchase Lookup:** Find the names of all customers who ordered **Product A** (`JOIN` across customers, orders, and products).
7. **Order & Customer Join:** Display customer name, order date, and order total for each transaction (`INNER JOIN`).
8. **High-Value Orders:** Filter orders with a total amount greater than **150.00** (`WHERE total_amount > 150.00`).
9. **Database Normalization (3NF):** Establish a separate `order_items` associative table and update `orders` to eliminate redundancy.
10. **Average Order Total:** Calculate the store-wide arithmetic mean of all order totals (`ROUND(AVG(total_amount), 2)`).

---

## 🚀 How to Execute the Script

1. Open **MySQL Workbench** (or any MySQL client / terminal).
2. Connect to your local MySQL instance (`localhost:3306`).
3. Open [`ecommerce_database.sql`](ecommerce_database.sql) (`File -> Open SQL Script...`).
4. Execute the entire script (<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd>).
5. The script automatically:
   - Initializes the `ecommerce` database.
   - Builds all tables with constraints.
   - Inserts realistic seed data (including `Product A`, `Product B`, `Product C`).
   - Executes and outputs all 10 required analytical queries.

---

## 📄 License
This project is open-source under the [MIT License](LICENSE).
