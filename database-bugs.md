# Database Bug Reports — E-Commerce Backend

Below are the critical data and logic defects found during database testing. 

---

## BUG-DB-01: Duplicate Email Addresses Allowed
**Severity:** High
**Priority:** High
**Test Case:** DB-01

**Description:**
The `Users` table allows multiple accounts to be created with the exact same email address (`bibek@example.com`). This breaks login authentication logic (which account does the system log in?) and violates standard account creation rules.

**Evidence:**
`test1-duplicate-emails.png`

---

## BUG-DB-02: Orphaned Orders Found in Database
**Severity:** Critical
**Priority:** High
**Test Case:** DB-02

**Description:**
Order ID 4 is associated with `user_id 99`, but this user does not exist in the `Users` table. This indicates that either a user was deleted without their orders being cleaned up, or the API allowed an order to be created without a valid user ID.

**Evidence:**
`test2-orphan-orders.png`

---

## BUG-DB-03: Negative Quantities Accepted in Orders
**Severity:** High
**Priority:** High
**Test Case:** DB-03

**Description:**
Order ID 6 was created with a quantity of `-2`. The database fails to enforce a `CHECK (quantity > 0)` constraint. This could result in negative totals, refund loopholes, or inventory inflation.

**Evidence:**
`test3-negative-quantities.png`

---

## BUG-DB-04: Out-of-Stock Items Can Be Purchased
**Severity:** High
**Priority:** High
**Test Case:** DB-04

**Description:**
Order ID 5 was placed for a Keyboard (Product ID 103), but the stock for this item is currently 0. The system is failing to validate stock levels before recording an order.

**Evidence:**
`test4-out-of-stock-orders.png`

---

## BUG-DB-05: Payment Amount Mismatch
**Severity:** Critical
**Priority:** High
**Test Case:** DB-05

**Description:**
Payment ID 1004 is recorded as `$500.00` for Order ID 6. However, Order ID 6 is for 2 Laptops (which cost $1000 each), meaning the expected payment should be `$2000.00`. This indicates a critical failure in the payment processing or order calculation logic.

**Evidence:**
`test5-payment-mismatch.png`
