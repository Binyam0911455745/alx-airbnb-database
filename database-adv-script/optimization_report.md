# Query Optimization Report

This report documents the process of analyzing and optimizing a complex SQL query to improve its performance within the `alx_airbnb_db` database.

## Objective

To analyze the performance of a complex multi-table join query, identify inefficiencies using `EXPLAIN ANALYZE`, and then refactor the query to reduce execution time.

## Initial Complex Query

The initial query aims to retrieve a comprehensive dataset by joining `bookings`, `users`, `properties`, and `payments` tables to get all related details for each booking.

```sql
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

