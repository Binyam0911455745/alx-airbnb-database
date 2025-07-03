# Database Performance Monitoring and Refinement Report

## Objective

The objective of this task is to continuously monitor and refine database performance by analyzing the execution plans of frequently used queries. This involves identifying performance bottlenecks, suggesting and implementing appropriate schema adjustments (primarily new indexes), and reporting on the observed improvements.

## Tools Used

For monitoring query performance, the primary tool used is the `EXPLAIN` SQL command.

* **`EXPLAIN <SQL_QUERY>`**: This command provides information about how MySQL executes a `SELECT`, `INSERT`, `UPDATE`, `DELETE`, or `REPLACE` statement. Key columns in the `EXPLAIN` output that help identify bottlenecks include:
    * `type`: Describes how tables are joined. `ALL` indicates a full table scan, which is typically undesirable for large tables. `ref`, `eq_ref`, `const`, `range` indicate more efficient access methods using indexes.
    * `rows`: An estimate of the number of rows MySQL must examine to execute the query. Lower is better.
    * `Extra`: Provides additional details about the execution plan, such as "Using filesort" (sorting data that doesn't fit in memory, often slow) or "Using temporary" (using a temporary table, also potentially slow). When an index is used for filtering or sorting, it might indicate "Using index" or "Using where". The presence of `Using where` along with an efficient `type` often indicates effective index usage for filtering. The `partitions` column (if available in your MySQL version's `EXPLAIN` output) shows which partitions were accessed.

## Monitoring and Refinement Process

The process involved identifying common query patterns, analyzing their initial performance using `EXPLAIN`, identifying bottlenecks, proposing index changes, implementing those changes, and then re-analyzing the performance to observe improvements.

**Note:** For the purpose of this exercise, we will assume the database tables (`users`, `properties`, `bookings`, `reviews`, `payments`) are already populated with a reasonable amount of data via `data.sql` and `partitioning.sql`.

### Query 1: Search Properties by Location and Price Range

**Description:** This query simulates a user searching for properties in a specific city within a given price range.

**Initial Query:**

```sql
USE alx_airbnb_db;

SELECT
    property_id,
    title,
    location,
    price_per_night,
    amenities
FROM
    properties
WHERE
    location = 'New York' AND price_per_night BETWEEN 100.00 AND 300.00;

