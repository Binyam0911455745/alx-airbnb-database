# Indexing for Performance Optimization

This document outlines the process of identifying columns for indexing and measuring the performance impact of these indexes using `EXPLAIN` in MySQL.

## Objective

To improve query performance by strategically applying database indexes to high-usage columns.

## High-Usage Columns Identified for Indexing

Based on common query patterns and the schema design, the following columns were identified as candidates for indexing to optimize `WHERE`, `JOIN`, and `ORDER BY` clauses:

* **`bookings.check_in_date`**: Often used in `WHERE` clauses for date range filtering and in `ORDER BY` clauses for chronological sorting of bookings.

    *Note: Columns like `bookings.guest_id` and `bookings.property_id` are typically foreign keys and are automatically indexed by MySQL for performance when the foreign key constraint is defined. Therefore, explicit index creation on these specific columns is often redundant.*

## SQL Index Creation

The `database_index.sql` file contains the `CREATE INDEX` command for the identified column:

```sql
-- database_index.sql
USE alx_airbnb_db;
CREATE INDEX idx_bookings_check_in_date ON bookings (check_in_date);

