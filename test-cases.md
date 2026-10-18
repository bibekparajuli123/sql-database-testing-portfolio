# Database QA Test Cases — E-Commerce Backend

**Database:** MySQL 
**Tool Used:** OneCompiler (MySQL Environment)
**Tables Tested:** Users, Products, Orders, Payments

## Objective
To validate data integrity, referential integrity, and business logic rules directly at the database level. 

## Test Cases

| ID | Category | Test Scenario | SQL Query Used | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| DB-01 | Data Integrity | Check for duplicate user emails | `SELECT email, COUNT(*) as count FROM Users GROUP BY email HAVING count > 1;` | 0 rows returned | 1 row returned (bibek@example.com) | **FAIL (Bug)** |
| DB-02 | Referential Integrity | Check for orphaned orders (user_id doesn't exist) | `SELECT * FROM Orders WHERE user_id NOT IN (SELECT user_id FROM Users);` | 0 rows returned | 1 row returned (Order 4, user 99) | **FAIL (Bug)** |
| DB-03 | Business Logic | Check for negative order quantities | `SELECT * FROM Orders WHERE quantity <= 0;` | 0 rows returned | 1 row returned (Order 6, qty -2) | **FAIL (Bug)** |
| DB-04 | Business Logic | Check for orders of out-of-stock products | `SELECT o.order_id, p.product_name FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.stock = 0;` | 0 rows returned | 1 row returned (Order 5, Keyboard) | **FAIL (Bug)** |
| DB-05 | Financial Integrity | Verify payment amount matches order total | `SELECT p.payment_id, p.amount, (o.quantity * pr.price) FROM Payments p JOIN Orders o ON p.order_id = o.order_id JOIN Products pr ON o.product_id = pr.product_id WHERE p.amount != (o.quantity * pr.price);` | 0 rows returned | 1 row returned (Payment 1004) | **FAIL (Bug)** |
| DB-06 | Business Logic | Check if inactive users placed orders | `SELECT u.username, o.order_id FROM Users u JOIN Orders o ON u.user_id = o.user_id WHERE u.status = 'inactive';` | 0 rows returned | 0 rows returned | PASS |
| DB-07 | Data Validation | Check for future-dated orders | `SELECT * FROM Orders WHERE order_date > CURRENT_DATE;` | 0 rows returned | 0 rows returned | PASS |
| DB-08 | Completeness | Check for shipped orders missing payments | `SELECT o.order_id FROM Orders o LEFT JOIN Payments p ON o.order_id = p.order_id WHERE o.status = 'Shipped' AND p.payment_id IS NULL;` | 0 rows returned | 0 rows returned | PASS |
| DB-09 | Data Consistency | Check for empty usernames or emails | `SELECT * FROM Users WHERE username = '' OR email = '';` | 0 rows returned | 0 rows returned | PASS |
| DB-10 | Data Consistency | Check for improperly formatted statuses | `SELECT DISTINCT status FROM Orders WHERE status != BINARY UPPER(LEFT(status, 1)) OR status != BINARY LOWER(SUBSTRING(status, 2));` | 0 rows returned | 0 rows returned | PASS |
