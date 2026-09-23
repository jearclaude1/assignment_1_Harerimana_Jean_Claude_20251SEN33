-- ============================================================
-- Sunrise Supermarket - Analytical Queries
-- DBMS: MySQL / MariaDB
-- ============================================================
USE sunrise_supermarket;

-- ------------------------------------------------------------
-- Q1. Every order with customer's name, city, and order date
-- (INNER JOIN: orders + customers)
-- ------------------------------------------------------------
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;


-- ------------------------------------------------------------
-- Q2. Every order item with product name, category, price,
-- and quantity ordered
-- (JOIN: order_items + products)
-- ------------------------------------------------------------
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    p.category,
    p.price,
    oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.order_item_id;


-- ------------------------------------------------------------
-- Q3. All customers and, where they exist, their orders --
-- including customers who have never placed an order
-- (LEFT JOIN: customers + orders)
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;


-- ------------------------------------------------------------
-- Q4. Customers who spent above the average customer spend
-- (CTE for per-customer totals, then filter against the average)
-- ------------------------------------------------------------
WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spent
FROM customer_spend
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spend)
ORDER BY total_spent DESC;


-- ------------------------------------------------------------
-- Q5. Rank customers by total amount spent, highest first
-- (Window function: RANK)
-- ------------------------------------------------------------
WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM customer_spend
ORDER BY spend_rank;


-- ------------------------------------------------------------
-- Q6. Number each customer's orders in the order they were placed
-- (Window function: ROW_NUMBER partitioned by customer)
-- ------------------------------------------------------------
SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS order_sequence
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.customer_name, order_sequence;


-- ------------------------------------------------------------
-- Q7. Running total of revenue over time, ordered by order date
-- (Window function: SUM ... OVER with a moving frame)
-- ------------------------------------------------------------
WITH order_revenue AS (
    SELECT
        o.order_id,
        o.order_date,
        SUM(oi.quantity * p.price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.order_date
)
SELECT
    order_id,
    order_date,
    order_total,
    SUM(order_total) OVER (ORDER BY order_date, order_id
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_revenue
FROM order_revenue
ORDER BY order_date, order_id;


-- ------------------------------------------------------------
-- Q8. For customers with more than one order, days passed
-- between their current and previous order
-- (Window function: LAG)
-- ------------------------------------------------------------
WITH ordered AS (
    SELECT
        c.customer_id,
        c.customer_name,
        o.order_id,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS previous_order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT
    customer_name,
    order_id,
    order_date,
    previous_order_date,
    DATEDIFF(order_date, previous_order_date) AS days_since_previous_order
FROM ordered
WHERE previous_order_date IS NOT NULL
ORDER BY customer_name, order_date;
