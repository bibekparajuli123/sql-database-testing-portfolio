# Database Testing Portfolio (SQL / MySQL)

This repository demonstrates manual database testing (Backend QA) on a mock E-commerce database. It includes database schema creation, data integrity checks, and advanced SQL queries used to identify critical backend bugs.

## 📊 Project Overview
- **Tool Used:** OneCompiler (MySQL Environment)
- **Tables Tested:** Users, Products, Orders, Payments
- **Test Cases Executed:** 10
- **Bugs Found:** 5

## 🐛 Key Defects Found
1. **Duplicate Emails:** The system allows multiple users to register with the same email.
2. **Orphaned Records:** Orders exist in the database for users that do not exist.
3. **Business Logic Failure:** The system allows negative quantities and out-of-stock items to be ordered.
4. **Financial Mismatch:** Payment amounts do not match the calculated order totals.

## 📁 Repository Structure
- [`test-cases.md`](./test-cases.md) — Detailed test cases with SQL queries, expected results, and pass/fail status.
- [`database-bugs.md`](./database-bugs.md) — Professional bug reports for the 5 critical defects found.
- [`database-tests.sql`](./database-tests.sql) — The raw SQL scripts to build the database and execute the tests.

## 🔍 How to Review
1. Open `test-cases.md` to see the testing methodology.
2. Open `database-bugs.md` to see the bugs found, complete with screenshots.
3. Open `database-tests.sql` to view the actual SQL queries.
