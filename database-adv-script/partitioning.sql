-- Objective: Implement table partitioning to optimize queries on large datasets.

-- Use the alx_airbnb_db database
USE alx_airbnb_db;

-- -----------------------------------------------------------
-- PART 1: Creating a Partitioned Bookings Table
-- -----------------------------------------------------------

-- 1. Drop dependent tables first to avoid foreign key constraint errors
--    Order of drops: Tables that reference 'bookings' first, then 'bookings'.
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS bookings;

-- 2. Create the bookings table with partitioning by YEAR(check_in_date)
--    IMPORTANT: All Foreign Key Constraints are REMOVED from this table definition
--    due to MySQL version limitations (Error Code 1506) where FKs are not supported
--    on partitioned tables prior to MySQL 8.0.
CREATE TABLE bookings (
    booking_id VARCHAR(36) DEFAULT (UUID()) NOT NULL,
    property_id VARCHAR(36) NOT NULL, -- This will now be a regular column, not a FK
    guest_id VARCHAR(36) NOT NULL,     -- This will now be a regular column, not a FK
    check_in_date DATETIME NOT NULL,
    check_out_date DATETIME NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, check_in_date) -- Composite Primary Key for partitioning rule (Error 1503)
)
PARTITION BY RANGE ( YEAR(check_in_date) ) (
    PARTITION p_before_2024 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 3. Recreate dependent tables without foreign key constraints referencing 'bookings'
--    These FKs must also be removed/commented out because 'bookings' is partitioned
--    and cannot be referenced by FKs in older MySQL versions.
-- Recreate payments table as it was dropped
CREATE TABLE payments (
    payment_id VARCHAR(36) DEFAULT (UUID()) PRIMARY KEY,
    booking_id VARCHAR(36) NOT NULL, -- This will now be a regular column, not a FK
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer') NOT NULL,
    transaction_id VARCHAR(255) UNIQUE
    -- FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE -- REMOVED
);

-- Recreate reviews table as it was dropped
CREATE TABLE reviews (
    review_id VARCHAR(36) DEFAULT (UUID()) PRIMARY KEY,
    booking_id VARCHAR(36) NOT NULL, -- This will now be a regular column, not a FK
    reviewer_id VARCHAR(36) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP
    -- FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE, -- REMOVED
    -- FOREIGN KEY (reviewer_id) REFERENCES users(user_id) -- This FK is fine as 'users' is not partitioned
);

-- Re-add the FK to users on reviews table (users is not partitioned)
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_reviewer
FOREIGN KEY (reviewer_id) REFERENCES users(user_id);


-- -----------------------------------------------------------
-- PART 2: Insert Sample Data into Partitions
-- -----------------------------------------------------------
-- (Requires users and properties to exist. Assuming they are already populated from schema.sql/data.sql)

-- Placeholder IDs (REPLACE THESE WITH ACTUAL UUIDs FROM YOUR DATABASE if dynamic lookup fails or is not desired)
SET @user1_id = (SELECT user_id FROM users ORDER BY RAND() LIMIT 1);
SET @prop1_id = (SELECT property_id FROM properties ORDER BY RAND() LIMIT 1);
SET @user2_id = (SELECT user_id FROM users ORDER BY RAND() LIMIT 1);
SET @prop2_id = (SELECT property_id FROM properties ORDER BY RAND() LIMIT 1);

-- Insert bookings for different years to fall into different partitions
INSERT INTO bookings (property_id, guest_id, check_in_date, check_out_date, total_price, status) VALUES
(@prop1_id, @user1_id, '2023-05-10 14:00:00', '2023-05-15 11:00:00', 500.00, 'completed'),  -- p_before_2024
(@prop2_id, @user2_id, '2024-01-20 15:00:00', '2024-01-25 10:00:00', 750.00, 'confirmed'),   -- p2024
(@prop1_id, @user1_id, '2024-07-01 16:00:00', '2024-07-07 10:00:00', 1200.00, 'pending'),    -- p2024
(@prop2_id, @user1_id, '2025-03-10 14:00:00', '2025-03-12 11:00:00', 300.00, 'confirmed'),   -- p2025
(@prop1_id, @user2_id, '2025-09-01 15:00:00', '2025-09-10 10:00:00', 2000.00, 'pending'),    -- p2025
(@prop2_id, @user1_id, '2026-11-05 14:00:00', '2026-11-08 11:00:00', 600.00, 'pending'),    -- p2026
(@prop1_id, @user2_id, '2027-02-14 15:00:00', '2027-02-16 10:00:00', 400.00, 'pending');    -- p_future

-- Since FKs are removed, ensure you manually insert data into payments/reviews
-- if you want to test those tables, making sure booking_id matches a booking.
INSERT INTO payments (booking_id, amount, payment_method, transaction_id) VALUES
((SELECT booking_id FROM bookings WHERE check_in_date = '2024-01-20 15:00:00' LIMIT 1), 750.00, 'Credit Card', UUID()),
((SELECT booking_id FROM bookings WHERE check_in_date = '2025-03-10 14:00:00' LIMIT 1), 300.00, 'PayPal', UUID());

INSERT INTO reviews (booking_id, reviewer_id, rating, comment) VALUES
((SELECT booking_id FROM bookings WHERE check_in_date = '2023-05-10 14:00:00' LIMIT 1), @user1_id, 5, 'Great stay!'),
((SELECT booking_id FROM bookings WHERE check_in_date = '2025-03-10 14:00:00' LIMIT 1), @user2_id, 4, 'Comfortable and clean.');


-- -----------------------------------------------------------
-- PART 3: Test Queries on Partitioned Table
-- -----------------------------------------------------------

-- Query 1: Fetch bookings for a specific year (should hit only one partition or few)
-- Expected improvement: Only scans 'p2025' partition.
SELECT *
FROM bookings
WHERE check_in_date BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59';

-- Analyze Query 1 performance
EXPLAIN
SELECT *
FROM bookings
WHERE check_in_date BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59';

-- Query 2: Fetch bookings spanning multiple years (should hit multiple partitions)
-- Expected improvement: Scans only 'p2024' and 'p2025' partitions.
SELECT COUNT(*)
FROM bookings
WHERE check_in_date BETWEEN '2024-06-01 00:00:00' AND '2025-06-30 23:59:59';

-- Analyze Query 2 performance
EXPLAIN
SELECT COUNT(*)
FROM bookings
WHERE check_in_date BETWEEN '2024-06-01 00:00:00' AND '2025-06-30 23:59:59';

-- Query 3: Fetch bookings not using the partitioning key in the WHERE clause
-- Expected: Scans all relevant partitions, no direct benefit from partitioning.
SELECT *
FROM bookings
WHERE total_price > 1000;

-- Analyze Query 3 performance
EXPLAIN
SELECT *
FROM bookings
WHERE total_price > 1000;

-- Optional: Verify partition status (useful for debugging)
SELECT
    PARTITION_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH
FROM
    INFORMATION_SCHEMA.PARTITIONS
WHERE
    TABLE_SCHEMA = 'alx_airbnb_db' AND TABLE_NAME = 'bookings';
