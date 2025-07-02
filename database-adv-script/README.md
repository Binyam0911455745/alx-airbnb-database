# Advanced Database Scripting: SQL Joins

This directory contains SQL scripts demonstrating advanced querying techniques, specifically focusing on different types of SQL JOINs in a MySQL database context. The queries are designed to operate on the `alx_airbnb_db` schema, which simulates an Airbnb-like accommodation booking system.

## Files

* `joins_queries.sql`: Contains three complex SQL queries demonstrating `INNER JOIN`, `LEFT JOIN`, and a MySQL-equivalent of `FULL OUTER JOIN` (using `LEFT JOIN` and `UNION` with `RIGHT JOIN`). These queries are designed to retrieve combined data from multiple tables based on their relationships.

## Objective

The primary objective of these scripts is to master SQL joins by writing and executing complex queries using various join types to retrieve meaningful insights from interconnected tables.

## How to Use

1.  **Ensure Database Setup:** Before running these queries, make sure the `alx_airbnb_db` database and all its tables are properly set up and populated with sample data.
    * Refer to the `database-script-0x01/schema.sql` to create the database schema.
    * Refer to the `database-script-0x02/seed_data.sql` to populate the tables with sample data.
    * Ensure that the `schema.sql` was run with `DROP DATABASE IF EXISTS alx_airbnb_db;` at the top for a clean setup.
    * Ensure that the `seed_data.sql` was run with `SET FOREIGN_KEY_CHECKS = 0;` and `SET FOREIGN_KEY_CHECKS = 1;` around the `TRUNCATE` statements to avoid foreign key errors.

2.  **Access MySQL Client:** Open your MySQL command-line client or a GUI tool like MySQL Workbench.

3.  **Execute `joins_queries.sql`:**
    * Select the database: `USE alx_airbnb_db;`
    * Copy and paste the queries from `joins_queries.sql` into your MySQL client and execute them one by one, or source the file if you have appropriate permissions (e.g., `source /path/to/alx-airbnb-database/database-adv-script/joins_queries.sql;`).

## Query Descriptions

### Query 1: Inner Join (Bookings and Users)

* **Purpose:** To retrieve a list of all confirmed bookings along with the details of the users who made those bookings. Only bookings that have a corresponding user will be returned.
* **Join Type:** `INNER JOIN`
* **Tables Involved:** `bookings`, `users`

### Query 2: Left Join (Properties and Reviews)

* **Purpose:** To list all properties and, if available, their associated review details. Properties that have no reviews (or no bookings that lead to reviews) will still be included in the result set, with `NULL` values for review-related columns.
* **Join Type:** `LEFT JOIN` (two consecutive LEFT JOINs: `properties` to `bookings`, then `bookings` to `reviews`)
* **Tables Involved:** `properties`, `bookings`, `reviews`

### Query 3: Full Outer Join (Users and Bookings - MySQL Equivalent)

* **Purpose:** To display all users and all bookings, regardless of whether a user has made a booking or if a booking exists without a valid user link (though this should ideally not happen due to foreign key constraints). This effectively combines the results of a LEFT JOIN and a RIGHT JOIN, ensuring all records from both tables are represented.
* **Join Type:** Emulated `FULL OUTER JOIN` using `LEFT JOIN`, `UNION`, and `RIGHT JOIN` with a `WHERE` clause.
* **Tables Involved:** `users`, `bookings`
# Advanced Database Scripting: SQL Joins and Subqueries

This directory contains SQL scripts demonstrating advanced querying techniques, specifically focusing on different types of SQL JOINs and Subqueries in a MySQL database context. The queries are designed to operate on the `alx_airbnb_db` schema, which simulates an Airbnb-like accommodation booking system.

## Files

* `joins_queries.sql`: Contains three complex SQL queries demonstrating `INNER JOIN`, `LEFT JOIN`, and a MySQL-equivalent of `FULL OUTER JOIN` (using `LEFT JOIN` and `UNION` with `RIGHT JOIN`). These queries are designed to retrieve combined data from multiple tables based on their relationships.
* `subqueries.sql`: Contains SQL queries demonstrating both non-correlated and correlated subqueries to retrieve specific data subsets based on complex conditions.

## Objective

The primary objective of these scripts is to master SQL joins and subqueries by writing and executing complex queries using various techniques to retrieve meaningful insights from interconnected tables.

## How to Use

1.  **Ensure Database Setup:** Before running these queries, make sure the `alx_airbnb_db` database and all its tables are properly set up and populated with sample data.
    * Refer to the `database-script-0x01/schema.sql` to create the database schema.
    * Refer to the `database-script-0x02/seed_data.sql` to populate the tables with sample data.
    * Ensure that the `schema.sql` was run with `DROP DATABASE IF EXISTS alx_airbnb_db;` at the top for a clean setup.
    * Ensure that the `seed_data.sql` was run with `SET FOREIGN_KEY_CHECKS = 0;` and `SET FOREIGN_KEY_CHECKS = 1;` around the `TRUNCATE` statements to avoid foreign key errors.

2.  **Access MySQL Client:** Open your MySQL command-line client or a GUI tool like MySQL Workbench.

3.  **Execute SQL Files:**
    * Select the database: `USE alx_airbnb_db;`
    * To execute `joins_queries.sql`, copy and paste its queries or source the file (e.g., `source /path/to/alx-airbnb-database/database-adv-script/joins_queries.sql;`).
    * To execute `subqueries.sql`, copy and paste its queries or source the file (e.g., `source /path/to/alx-airbnb-database/database-adv-script/subqueries.sql;`).

## Query Descriptions

### Query 1: Inner Join (Bookings and Users) - from `joins_queries.sql`

* **Purpose:** To retrieve a list of all confirmed bookings along with the details of the users who made those bookings. Only bookings that have a corresponding user will be returned.
* **Join Type:** `INNER JOIN`
* **Tables Involved:** `bookings`, `users`

### Query 2: Left Join (Properties and Reviews) - from `joins_queries.sql`

* **Purpose:** To list all properties and, if available, their associated review details. Properties that have no reviews (or no bookings that lead to reviews) will still be included in the result set, with `NULL` values for review-related columns.
* **Join Type:** `LEFT JOIN` (two consecutive LEFT JOINs: `properties` to `bookings`, then `bookings` to `reviews`)
* **Tables Involved:** `properties`, `bookings`, `reviews`

### Query 3: Full Outer Join (Users and Bookings - MySQL Equivalent) - from `joins_queries.sql`

* **Purpose:** To display all users and all bookings, regardless of whether a user has made a booking or if a booking exists without a valid user link (though this should ideally not happen due to foreign key constraints). This effectively combines the results of a LEFT JOIN and a RIGHT JOIN, ensuring all records from both tables are represented.
* **Join Type:** Emulated `FULL OUTER JOIN` using `LEFT JOIN`, `UNION`, and `RIGHT JOIN` with a `WHERE` clause.
* **Tables Involved:** `users`, `bookings`

### Query 4: Non-Correlated Subquery (Properties by Average Rating) - from `subqueries.sql`

* **Purpose:** To identify properties that have received an average rating greater than 4.0 from their reviews. The subquery calculates the average ratings independently first.
* **Technique:** Non-correlated subquery with `IN` clause.
* **Tables Involved:** `properties`, `bookings`, `reviews`

### Query 5: Correlated Subquery (Users with Many Bookings) - from `subqueries.sql`

* **Purpose:** To find users who have made a significant number of bookings (specifically, more than 3 bookings in this example). The subquery depends on the outer query's context to count bookings for each individual user.
* **Technique:** Correlated subquery in a `WHERE` clause.
* **Tables Involved:** `users`, `bookings`

