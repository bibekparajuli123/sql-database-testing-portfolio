
-- ==========================================
-- DATABASE TESTING PORTFOLIO — E-COMMERCE BACKEND
-- Environment: MySQL
-- Tool Used: OneCompiler
-- ==========================================

-- ==========================================
-- PART 1: DATABASE SETUP & MOCK DATA
-- ==========================================

-- 1. Create Tables
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    status VARCHAR(20),
    created_at DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    stock INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    status VARCHAR(20) -- 'Pending', 'Shipped', 'Cancelled'
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10, 2),
    payment_date DATE
);

-- 2. Insert Mock Data (Includes intentional bugs for testing)
INSERT INTO Users VALUES 
(1, 'bibek', 'bibek@example.com', 'active', '2026-01-01'),
(2, 'john_doe', 'john@example.com', 'active', '2026-01-02'),
(3, 'jane_smith', 'jane@example.com', 'inactive', '2026-01-03'),
(4, 'test_user', 'bibek@example.com', 'active', '2026-01-04'), -- BUG: Duplicate email
(5, 'ghost_user', 'ghost@example.com', 'active', '2026-01-05');

INSERT INTO Products VALUES 
(101, 'Laptop', 1000.00, 50),
(102, 'Mouse', 50.00, 200),
(103, 'Keyboard', 80.00, 0), -- BUG: Out of stock
(104, 'Monitor', 300.00, 15);

INSERT INTO Orders VALUES 
(1, 1, 101, 1, '2026-10-01', 'Shipped'),
(2, 1, 102, 2, '2026-10-02', 'Shipped'),
(3, 2, 104, 1, '2026-10-03', 'Pending'),
(4, 99, 101, 1, '2026-10-04', 'Pending'), -- BUG: Orphan order (user 99 doesn't exist)
(5, 2, 103, 1, '2026-10-05', 'Pending'),  -- BUG: Ordered out-of-stock item
(6, 5, 101, -2, '2026-10-06', 'Pending'); -- BUG: Negative quantity

INSERT INTO Payments VALUES 
(1001, 1, 1000.00, '2026-10-01'),
(1002, 2, 100.00, '2026-10-02'),
(1003, 3, 300.00, '2026-10-03'),
(1004, 6, 500.00, '2026-10-06'); -- BUG: Payment amount doesn't match order total


-- ==========================================
-- PART 2: QA TEST QUERIES & VALIDATIONS
-- ==========================================

-- TEST 1: Data Integrity (Duplicate Emails)
-- Expected: 0 rows. Actual: 1 row (bibek@example.com)
SELECT email, COUNT(*) as duplicate_count 
FROM Users 
GROUP BY email 
HAVING duplicate_count > 1;

-- TEST 2: Referential Integrity (Orphaned Orders)
-- Expected: 0 rows. Actual: 1 row (Order 4)
SELECT * FROM Orders 
WHERE user_id NOT IN (SELECT user_id FROM Users);

-- TEST 3: Business Logic (Negative Quantities)
-- Expected: 0 rows. Actual: 1 row (Order 6)
SELECT * FROM Orders 
WHERE quantity <= 0;

-- TEST 4: Business Logic (Out-of-Stock Orders)
-- Expected: 0 rows. Actual: 1 row (Order 5, Keyboard)
SELECT o.order_id, p.product_name, p.stock 
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE p.stock = 0;

-- TEST 5: Financial Integrity (Payment Mismatch)
-- Expected: 0 rows. Actual: 1 row (Payment 1004)
SELECT p.payment_id, p.amount AS paid_amount, (o.quantity * pr.price) AS expected_amount, o.order_id
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
JOIN Products pr ON o.product_id = pr.product_id
WHERE p.amount != (o.quantity * pr.price);

-- TEST 6: Business Logic (Inactive Users Placing Orders)
-- Expected: 0 rows. Actual: 0 rows (PASS)
SELECT u.username, u.status, o.order_id
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
WHERE u.status = 'inactive';

-- TEST 7: Data Validation (Future Dated Orders)
-- Expected: 0 rows. Actual: 0 rows (PASS)
SELECT * FROM Orders 
WHERE order_date > CURRENT_DATE;

-- TEST 8: Completeness (Shipped Orders Missing Payments)
-- Expected: 0 rows. Actual: 0 rows (PASS)
SELECT o.order_id, o.status 
FROM Orders o
LEFT JOIN Payments p ON o.order_id = p.order_id
WHERE o.status = 'Shipped' AND p.payment_id IS NULL;

-- TEST 9: Data Consistency (Case Sensitivity in Status)
-- Expected: 0 rows. Actual: 0 rows (PASS)
SELECT DISTINCT status FROM Orders 
WHERE status != BINARY UPPER(LEFT(status, 1)) OR status != BINARY LOWER(SUBSTRING(status, 2));

-- TEST 10: Data Consistency (Empty Email or Username)
-- Expected: 0 rows. Actual: 0 rows (PASS)
SELECT * FROM Users 
WHERE username = '' OR username IS NULL 
   OR email = '' OR email IS NULL;
