# Indexing for Performance Optimization

This document outlines the strategy for identifying columns for indexing and how query performance is measured before and after index creation within the `database_index.sql` script using `EXPLAIN ANALYZE` in MySQL.

## Objective

To demonstrate and measure the improvement in query performance by strategically applying database indexes to high-usage columns.

## High-Usage Columns Identified for Indexing

Based on common query patterns and the schema design, `bookings.check_in_date` was identified as a primary candidate for indexing. This column is frequently used in `WHERE` clauses for date range filtering and in `ORDER BY` clauses for chronological sorting of bookings.

*Note: Columns like `bookings.guest_id` and `bookings.property_id` are typically foreign keys and are automatically indexed by MySQL for performance when their foreign key constraint is defined. Therefore, explicit index creation on these specific columns is often redundant.*

## SQL Index Creation and Performance Measurement

The `database_index.sql` file contains the `CREATE INDEX` command along with `EXPLAIN ANALYZE` statements to measure the query performance directly within the script.

**Content of `database_index.sql`:**

```sql
-- database_index.sql
USE alx_airbnb_db;

-- Section 1: Measure performance BEFORE adding the index.
-- This EXPLAIN ANALYZE provides the execution plan and actual statistics
-- for the query before the index 'idx_bookings_check_in_date' is created.
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.guest_id,
    b.property_id,
    b.check_in_date,
    b.check_out_date
FROM
    bookings AS b
WHERE
    b.check_in_date BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY
    b.check_in_date;

-- Create the index for optimizing queries that filter or order by check-in date.
CREATE INDEX idx_bookings_check_in_date ON bookings (check_in_date);

-- Section 2: Measure performance AFTER adding the index.
-- This EXPLAIN ANALYZE shows the updated execution plan and statistics,
-- demonstrating the impact of the newly created index.
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.guest_id,
    b.property_id,
    b.check_in_date,
    b.check_out_date
FROM
    bookings AS b
WHERE
    b.check_in_date BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY
    b.check_in_date;

