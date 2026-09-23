# Assignment 1 — Sunrise Supermarket Database

Student Name: Harerimana Jean Claude
Student ID: 20251SEN133
DBMS Used: MySQL

---

## 1. Business Scenario Summary

Sunrise Supermarket sells products to customers who place orders containing one
or more items. Management wants to understand 
who their customers are,
what they buy**, and how sales are trending over time.

The database models four entities:

- **customers** — the people who shop at Sunrise Supermarket
- **products** — items sold, grouped into categories (Beverages, Dairy, Bakery, Produce)
- **orders** — a purchase event placed by a customer on a given date
- **order_items** — the individual product lines (and quantities) that make up an order

The sample data contains **6 customers**, **8 proucts** across **4 categories**,
**15 orders**, and **25 order items**

---

## 2. How to Run

### Files in this repo
```
assignment_1_harerimana_jean_claude-20251SEN133/
├── README.md          <- this file
├── schema.sql          <- CREATE DATABASE + CREATE TABLE statements
├── data.sql            <- INSERT statements (sample data)
├── queries.sql 

### Steps
1. Install MySQL
2. From a terminal, in this folder, run:
   ```bash
   mysql -u root -p
   password : 
   use sunrise_supermarket;

---

3. Queries,
Q1 — Every order with customer name, city, and order date

Type: INNER JOIN (orders + customers)

Answers: A simple order log that ties each order back to who placed it and where they're from.

```sql
SELECT o.order_id, c.customer_name, c.city, o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;
```

**Result:**
```
+----------+-----------------+---------+------------+
| order_id | customer_name   | city    | order_date |
+----------+-----------------+---------+------------+
|        1 | Alice Uwase     | Kigali  | 2026-01-05 |
|        2 | Brian Mugisha   | Musanze | 2026-01-06 |
|        3 | Alice Uwase     | Kigali  | 2026-01-15 |
|        4 | Clara Ingabire  | Huye    | 2026-01-20 |
|        5 | David Niyonzima | Kigali  | 2026-01-25 |
|        6 | Brian Mugisha   | Musanze | 2026-02-02 |
|        7 | Grace Umutoni   | Rubavu  | 2026-02-05 |
|        8 | Alice Uwase     | Kigali  | 2026-02-10 |
|        9 | Clara Ingabire  | Huye    | 2026-02-15 |
|       10 | David Niyonzima | Kigali  | 2026-02-20 |
|       11 | Grace Umutoni   | Rubavu  | 2026-02-25 |
|       12 | Brian Mugisha   | Musanze | 2026-03-01 |
|       13 | Alice Uwase     | Kigali  | 2026-03-05 |
|       14 | Clara Ingabire  | Huye    | 2026-03-10 |
|       15 | David Niyonzima | Kigali  | 2026-03-15 |
+----------+-----------------+---------+------------+
```

---

### Q2 — Every order item with product name, category, price, and quantity
Type: JOIN (order_items + products)

Answers: A detailed line-item view of exactly what was bought in each order — the basis for revenue and product-mix analysis.

```sql
SELECT oi.order_item_id, oi.order_id, p.product_name, p.category, p.price, oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.order_item_id;
```

**Result (25 rows):**
```
+---------------+----------+--------------------+-----------+-------+----------+
| order_item_id | order_id | product_name       | category  | price | quantity |
+---------------+----------+--------------------+-----------+-------+----------+
|             1 |        1 | Bottled Water 1.5L | Beverages |  0.50 |        3 |
|             2 |        1 | Milk 1L            | Dairy     |  1.20 |        2 |
|             3 |        1 | Croissant          | Bakery    |  1.00 |        1 |
|             4 |        2 | Bread Loaf         | Bakery    |  1.50 |        1 |
|             5 |        2 | Orange Juice 1L    | Beverages |  2.50 |        2 |
|             6 |        3 | Cheese Block 500g  | Dairy     |  4.00 |        1 |
|             7 |        4 | Bananas (kg)       | Produce   |  0.80 |        2 |
|             8 |        4 | Bottled Water 1.5L | Beverages |  0.50 |        5 |
|             9 |        5 | Tomatoes (kg)      | Produce   |  1.10 |        3 |
|            10 |        6 | Milk 1L            | Dairy     |  1.20 |        2 |
|            11 |        6 | Bread Loaf         | Bakery    |  1.50 |        2 |
|            12 |        7 | Cheese Block 500g  | Dairy     |  4.00 |        1 |
|            13 |        8 | Bottled Water 1.5L | Beverages |  0.50 |        2 |
|            14 |        8 | Bananas (kg)       | Produce   |  0.80 |        1 |
|            15 |        9 | Tomatoes (kg)      | Produce   |  1.10 |        2 |
|            16 |       10 | Milk 1L            | Dairy     |  1.20 |        1 |
|            17 |       10 | Bread Loaf         | Bakery    |  1.50 |        3 |
|            18 |       11 | Croissant          | Bakery    |  1.00 |        2 |
|            19 |       11 | Cheese Block 500g  | Dairy     |  4.00 |        1 |
|            20 |       12 | Bottled Water 1.5L | Beverages |  0.50 |        4 |
|            21 |       13 | Bananas (kg)       | Produce   |  0.80 |        2 |
|            22 |       13 | Orange Juice 1L    | Beverages |  2.50 |        1 |
|            23 |       14 | Orange Juice 1L    | Beverages |  2.50 |        1 |
|            24 |       15 | Croissant          | Bakery    |  1.00 |        3 |
|            25 |       15 | Tomatoes (kg)      | Produce   |  1.10 |        1 |
+---------------+----------+--------------------+-----------+-------+----------+
```

---

### Q3 — All customers, including those who never ordered
Type: LEFT JOIN (customers + orders)
Answers: A full customer roster showing order activity .

```sql
SELECT c.customer_id, c.customer_name, c.city, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
```

**Result:**
```
+-------------+-----------------+---------+----------+------------+
| customer_id | customer_name   | city    | order_id | order_date |
+-------------+-----------------+---------+----------+------------+
|           1 | Alice Uwase     | Kigali  |        1 | 2026-01-05 |
|           1 | Alice Uwase     | Kigali  |        3 | 2026-01-15 |
|           1 | Alice Uwase     | Kigali  |        8 | 2026-02-10 |
|           1 | Alice Uwase     | Kigali  |       13 | 2026-03-05 |
|           2 | Brian Mugisha   | Musanze |        2 | 2026-01-06 |
|           2 | Brian Mugisha   | Musanze |        6 | 2026-02-02 |
|           2 | Brian Mugisha   | Musanze |       12 | 2026-03-01 |
|           3 | Clara Ingabire  | Huye    |        4 | 2026-01-20 |
|           3 | Clara Ingabire  | Huye    |        9 | 2026-02-15 |
|           3 | Clara Ingabire  | Huye    |       14 | 2026-03-10 |
|           4 | David Niyonzima | Kigali  |        5 | 2026-01-25 |
|           4 | David Niyonzima | Kigali  |       10 | 2026-02-20 |
|           4 | David Niyonzima | Kigali  |       15 | 2026-03-15 |
|           5 | Grace Umutoni   | Rubavu  |        7 | 2026-02-05 |
|           5 | Grace Umutoni   | Rubavu  |       11 | 2026-02-25 |
|           6 | Eric Habimana   | Kigali  |     NULL | NULL       |
+-------------+-----------------+---------+----------+------------+
```
Eric Habimana (customer_id 6) appears with `NULL` order columns

---

### Q4 — Customers who spent above the average customer spend
**Type:** CTE + aggregation + subquery filter
**Answers:** Identifies the "above-average" spenders management should treat as high-value customers.

```sql
WITH customer_spend AS (
    SELECT c.customer_id, c.customer_name,
           SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, total_spent
FROM customer_spend
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spend)
ORDER BY total_spent DESC;
```

**Result** (average customer spend across all 5 ordering customers = **12.12**):
```
+-------------+-----------------+-------------+
| customer_id | customer_name   | total_spent |
+-------------+-----------------+-------------+
|           1 | Alice Uwase     |       14.80 |
|           2 | Brian Mugisha   |       13.90 |
|           4 | David Niyonzima |       13.10 |
+-------------+-----------------+-------------+
```

---

### Q5 — Rank customers by total amount spent
**Type:** Window function — `RANK() OVER (ORDER BY total_spent DESC)`
**Answers:** A leaderboard of customers by revenue contribution.

```sql
WITH customer_spend AS (
    SELECT c.customer_id, c.customer_name,
           SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM customer_spend
ORDER BY spend_rank;
```

**Result:**
```
+-------------+-----------------+-------------+------------+
| customer_id | customer_name   | total_spent | spend_rank |
+-------------+-----------------+-------------+------------+
|           1 | Alice Uwase     |       14.80 |          1 |
|           2 | Brian Mugisha   |       13.90 |          2 |
|           4 | David Niyonzima |       13.10 |          3 |
|           5 | Grace Umutoni   |       10.00 |          4 |
|           3 | Clara Ingabire  |        8.80 |          5 |
+-------------+-----------------+-------------+------------+
```

---

### Q6 — Number each customer's orders in placement order
**Type:** Window function — `ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)`
**Answers:** Lets management see each customer's 1st, 2nd, 3rd... order — useful for tracking loyalty/first-purchase vs repeat-purchase behavior.

```sql
SELECT c.customer_name, o.order_id, o.order_date,
       ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS order_sequence
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.customer_name, order_sequence;
```

**Result:**
```
+-----------------+----------+------------+----------------+
| customer_name   | order_id | order_date | order_sequence |
+-----------------+----------+------------+----------------+
| Alice Uwase     |        1 | 2026-01-05 |              1 |
| Alice Uwase     |        3 | 2026-01-15 |              2 |
| Alice Uwase     |        8 | 2026-02-10 |              3 |
| Alice Uwase     |       13 | 2026-03-05 |              4 |
| Brian Mugisha   |        2 | 2026-01-06 |              1 |
| Brian Mugisha   |        6 | 2026-02-02 |              2 |
| Brian Mugisha   |       12 | 2026-03-01 |              3 |
| Clara Ingabire  |        4 | 2026-01-20 |              1 |
| Clara Ingabire  |        9 | 2026-02-15 |              2 |
| Clara Ingabire  |       14 | 2026-03-10 |              3 |
| David Niyonzima |        5 | 2026-01-25 |              1 |
| David Niyonzima |       10 | 2026-02-20 |              2 |
| David Niyonzima |       15 | 2026-03-15 |              3 |
| Grace Umutoni   |        7 | 2026-02-05 |              1 |
| Grace Umutoni   |       11 | 2026-02-25 |              2 |
+-----------------+----------+------------+----------------+
```

---

### Q7 — Running total of revenue over time
**Type:** CTE + window function — `SUM(order_total) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`
**Answers:** A cumulative revenue curve — the clearest way to see how sales trend over the quarter.

```sql
WITH order_revenue AS (
    SELECT o.order_id, o.order_date,
           SUM(oi.quantity * p.price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.order_date
)
SELECT order_id, order_date, order_total,
       SUM(order_total) OVER (ORDER BY order_date, order_id
                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_revenue
FROM order_revenue
ORDER BY order_date, order_id;
```

**Result:**
```
+----------+------------+-------------+-----------------+
| order_id | order_date | order_total | running_revenue |
+----------+------------+-------------+-----------------+
|        1 | 2026-01-05 |        4.90 |            4.90 |
|        2 | 2026-01-06 |        6.50 |           11.40 |
|        3 | 2026-01-15 |        4.00 |           15.40 |
|        4 | 2026-01-20 |        4.10 |           19.50 |
|        5 | 2026-01-25 |        3.30 |           22.80 |
|        6 | 2026-02-02 |        5.40 |           28.20 |
|        7 | 2026-02-05 |        4.00 |           32.20 |
|        8 | 2026-02-10 |        1.80 |           34.00 |
|        9 | 2026-02-15 |        2.20 |           36.20 |
|       10 | 2026-02-20 |        5.70 |           41.90 |
|       11 | 2026-02-25 |        6.00 |           47.90 |
|       12 | 2026-03-01 |        2.00 |           49.90 |
|       13 | 2026-03-05 |        4.10 |           54.00 |
|       14 | 2026-03-10 |        2.50 |           56.50 |
|       15 | 2026-03-15 |        4.10 |           60.60 |
+----------+------------+-------------+-----------------+
```
Total revenue for the quarter (Jan–Mar 2026) is **60.60**.

---

### Q8 — Days between each customer's consecutive orders
**Type:** CTE + window function — `LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)` combined with `DATEDIFF`
**Answers:** Measures purchase frequency / re-order intervals per customer — useful for predicting the next likely visit.

```sql
WITH ordered AS (
    SELECT c.customer_id, c.customer_name, o.order_id, o.order_date,
           LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS previous_order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT customer_name, order_id, order_date, previous_order_date,
       DATEDIFF(order_date, previous_order_date) AS days_since_previous_order
FROM ordered
WHERE previous_order_date IS NOT NULL
ORDER BY customer_name, order_date;
```

**Result:**
```
+-----------------+----------+------------+---------------------+---------------------------+
| customer_name   | order_id | order_date | previous_order_date | days_since_previous_order |
+-----------------+----------+------------+---------------------+---------------------------+
| Alice Uwase     |        3 | 2026-01-15 | 2026-01-05          |                        10 |
| Alice Uwase     |        8 | 2026-02-10 | 2026-01-15          |                        26 |
| Alice Uwase     |       13 | 2026-03-05 | 2026-02-10          |                        23 |
| Brian Mugisha   |        6 | 2026-02-02 | 2026-01-06          |                        27 |
| Brian Mugisha   |       12 | 2026-03-01 | 2026-02-02          |                        27 |
| Clara Ingabire  |        9 | 2026-02-15 | 2026-01-20          |                        26 |
| Clara Ingabire  |       14 | 2026-03-10 | 2026-02-15          |                        23 |
| David Niyonzima |       10 | 2026-02-20 | 2026-01-25          |                        26 |
| David Niyonzima |       15 | 2026-03-15 | 2026-02-20          |                        23 |
| Grace Umutoni   |       11 | 2026-02-25 | 2026-02-05          |                        20 |
+-----------------+----------+------------+---------------------+---------------------------+
```
(Note: Grace Umutoni has only 2 orders, so she contributes only 1 row here — customers with a single order don't appear at all, per the question's requirement.)

---

## 4. Business Interpretation

- **Top customers:** Alice Uwase (14.80), Brian Mugisha (13.90), and David
  Niyonzima (13.10) are Sunrise Supermarket's highest spenders and all sit
  above the average customer spend of 12.12. Together they account for a
  disproportionate share of revenue and are strong candidates for a loyalty
  or VIP program.
- **At-risk / low-engagement customers:** Clara Ingabire (8.80) is the lowest
  spender among active customers, and **Eric Habimana has never placed a
  single order** despite being in the customer database — he is a clear
  target for a "welcome back" or first-purchase incentive campaign.
- **Purchase frequency:** Most active customers re-order roughly every
  20–27 days (about every 3–4 weeks), suggesting a fairly consistent monthly
  shopping cycle rather than impulsive, irregular visits. Alice Uwase is the
  most frequent shopper (4 orders in the quarter, with a notably shorter
  10-day gap between her first two orders).
- **Revenue trend:** The running-total query shows steady, roughly linear
  growth in cumulative revenue from 4.90 on Jan 5 to 60.60 by Mar 15, with no
  large single-day spikes or drop-offs — indicating stable, predictable sales
  rather than seasonal volatility over this quarter.
- **Product mix:** Beverages and Dairy products (Bottled Water, Orange Juice,
  Milk, Cheese) appear across most orders, while Produce and Bakery items
  round out basket sizes — useful for stocking/replenishment planning.

## 5. Challenges Encountered
**creation of table column**

in mysql there is no Number data type found 

so used int datatype instead 

- **No pre-installed MySQL/MariaDB server and no `systemd`** in the working
  environment (a container), so the standard `systemctl start mysql` /
  `service mysql start` commands did not fully bring the daemon up on the
  first attempt. This was resolved by starting the server manually with
  `mysqld_safe --user=mysql` after ensuring the `/run/mysqld` socket
  directory existed and was owned by the `mysql` user.
- **Designing a `RANK`/`LAG`-friendly dataset:** to make the window-function
  queries (Q5–Q8) produce meaningfully different results, order dates were
  deliberately spread out with varying, realistic gaps (10–27 days) per
  customer rather than evenly spaced dates, and one customer (Eric Habimana)
  was intentionally left without any orders to properly exercise the LEFT
  JOIN in Q3.
- **`total_spent > AVG(total_spent)` in a CTE:** MySQL does not allow
  referencing a window/aggregate alias directly in the same `SELECT`'s
  `WHERE` clause, so the average was computed with a correlated scalar
  subquery (`SELECT AVG(total_spent) FROM customer_spend`) against the CTE
  instead of a bare `HAVING`-style comparison, per the assignment's
  instruction to filter against the average in the main query.
