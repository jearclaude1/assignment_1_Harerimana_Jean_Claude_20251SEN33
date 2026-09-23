-- ============================================================
-- Sunrise Supermarket - Sample Data
-- DBMS: MySQL / MariaDB
-- ============================================================
USE sunrise_supermarket;

-- ------------------------------------------------------------
-- customers (6 customers; one -- Eric -- has never ordered,
-- to demonstrate the LEFT JOIN in Q3)
-- ------------------------------------------------------------
INSERT INTO customers (customer_id, customer_name, email, city) VALUES
(1, 'Alice Uwase',      'alice.uwase@example.com',    'Kigali'),
(2, 'Brian Mugisha',    'brian.mugisha@example.com',  'Musanze'),
(3, 'Clara Ingabire',   'clara.ingabire@example.com', 'Huye'),
(4, 'David Niyonzima',  'david.niyonzima@example.com','Kigali'),
(5, 'Grace Umutoni',    'grace.umutoni@example.com',  'Rubavu'),
(6, 'Eric Habimana',    'eric.habimana@example.com',  'Kigali');

-- ------------------------------------------------------------
-- products (8 products across 4 categories)
-- ------------------------------------------------------------
INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Bottled Water 1.5L', 'Beverages', 0.50),
(2, 'Orange Juice 1L',    'Beverages', 2.50),
(3, 'Milk 1L',            'Dairy',     1.20),
(4, 'Cheese Block 500g',  'Dairy',     4.00),
(5, 'Bread Loaf',         'Bakery',    1.50),
(6, 'Croissant',          'Bakery',    1.00),
(7, 'Bananas (kg)',       'Produce',   0.80),
(8, 'Tomatoes (kg)',      'Produce',   1.10);

-- ------------------------------------------------------------
-- orders (15 orders, spread Jan - Mar 2026, customer 6 excluded)
-- ------------------------------------------------------------
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1,  1, '2026-01-05'),
(2,  2, '2026-01-06'),
(3,  1, '2026-01-15'),
(4,  3, '2026-01-20'),
(5,  4, '2026-01-25'),
(6,  2, '2026-02-02'),
(7,  5, '2026-02-05'),
(8,  1, '2026-02-10'),
(9,  3, '2026-02-15'),
(10, 4, '2026-02-20'),
(11, 5, '2026-02-25'),
(12, 2, '2026-03-01'),
(13, 1, '2026-03-05'),
(14, 3, '2026-03-10'),
(15, 4, '2026-03-15');

-- ------------------------------------------------------------
-- order_items (25 line items across the 15 orders)
-- ------------------------------------------------------------
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES
(1,  1,  1, 3),
(2,  1,  3, 2),
(3,  1,  6, 1),
(4,  2,  5, 1),
(5,  2,  2, 2),
(6,  3,  4, 1),
(7,  4,  7, 2),
(8,  4,  1, 5),
(9,  5,  8, 3),
(10, 6,  3, 2),
(11, 6,  5, 2),
(12, 7,  4, 1),
(13, 8,  1, 2),
(14, 8,  7, 1),
(15, 9,  8, 2),
(16, 10, 3, 1),
(17, 10, 5, 3),
(18, 11, 6, 2),
(19, 11, 4, 1),
(20, 12, 1, 4),
(21, 13, 7, 2),
(22, 13, 2, 1),
(23, 14, 2, 1),
(24, 15, 6, 3),
(25, 15, 8, 1);
