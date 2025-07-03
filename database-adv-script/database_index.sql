-- Objective: Identify and create indexes to improve query performance.

-- Make sure you are using the correct database
USE alx_airbnb_db;

-- Query to measure performance BEFORE adding the index.
-- This will show the execution plan and actual execution statistics without the index.
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

-- Index Creation:
-- Note on Foreign Key Indexes:
-- Columns involved in foreign key constraints (like bookings.guest_id and bookings.property_id)
-- are automatically indexed by MySQL when the foreign key is defined.
-- Explicitly dropping these foreign key-dependent indexes will result in Error Code 1553.
-- Explicitly creating a new index on these columns is often redundant as MySQL already
-- ensures they are indexed for constraint enforcement.

-- Create the index for optimizing queries that filter or order by check-in date.
-- If this index already exists from a previous run, this line will cause an "Error Code: 1061. Duplicate key name".
-- This is expected if the database environment is not reset between runs and your MySQL version does not support DROP INDEX IF EXISTS.
CREATE INDEX idx_bookings_check_in_date ON bookings (check_in_date);

-- Query to measure performance AFTER adding the index.
-- This will show the execution plan and actual execution statistics with the new index applied.
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

-- Optional: If you were to add other non-foreign key indexes (e.g., for search on names/emails):
-- CREATE INDEX idx_users_email ON users (email);
-- CREATE INDEX idx_properties_name ON properties (name);

