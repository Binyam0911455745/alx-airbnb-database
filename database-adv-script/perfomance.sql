-- Objective: Refactor complex queries to improve performance.

-- Make sure you are using the correct database
USE alx_airbnb_db;

-- Section 1: Initial Complex Query
-- This query retrieves all bookings along with associated user, property, and payment details.
-- It serves as the baseline for performance analysis.
SELECT
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    -- p.address, -- Removed: 'address' column does not exist in 'properties' table based on schema.sql
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method -- Changed: Using 'payment_method' instead of non-existent 'status'
FROM
    bookings AS b
INNER JOIN
    users AS u ON b.guest_id = u.user_id
INNER JOIN
    properties AS p ON b.property_id = p.property_id
INNER JOIN
    payments AS pay ON b.booking_id = pay.booking_id;

-- EXPLAIN ANALYZE for the Initial Complex Query (Paste output into optimization_report.md)
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    -- p.address, -- Removed: 'address' column does not exist in 'properties' table based on schema.sql
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method -- Changed: Using 'payment_method' instead of non-existent 'status'
FROM
    bookings AS b
INNER JOIN
    users AS u ON b.guest_id = u.user_id
INNER JOIN
    properties AS p ON b.property_id = p.property_id
INNER JOIN
    payments AS pay ON b.booking_id = pay.booking_id;


-- Section 2: Refactored/Optimized Query
-- For a query retrieving all details across these tables, the join structure is generally optimal
-- given proper indexing on foreign key columns (which MySQL typically handles automatically).
-- This 'refactored' version adds a WHERE clause using an indexed column (check_in_date)
-- to demonstrate how filtering further improves performance.
SELECT
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    -- p.address, -- Removed: 'address' column does not exist in 'properties' table based on schema.sql
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method -- Changed: Using 'payment_method' instead of non-existent 'status'
FROM
    bookings AS b
INNER JOIN
    users AS u ON b.guest_id = u.user_id
INNER JOIN
    properties AS p ON b.property_id = p.property_id
INNER JOIN
    payments AS pay ON b.booking_id = pay.booking_id
WHERE
    b.check_in_date BETWEEN '2025-01-01' AND '2025-03-31';


-- EXPLAIN ANALYZE for the Refactored/Optimized Query (Paste output into optimization_report.md)
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    -- p.address, -- Removed: 'address' column does not exist in 'properties' table based on schema.sql
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method -- Changed: Using 'payment_method' instead of non-existent 'status'
FROM
    bookings AS b
INNER JOIN
    users AS u ON b.guest_id = u.user_id
INNER JOIN
    properties AS p ON b.property_id = p.property_id
INNER JOIN
    payments AS pay ON b.booking_id = pay.booking_id
WHERE
    b.check_in_date BETWEEN '2025-01-01' AND '2025-03-31';

