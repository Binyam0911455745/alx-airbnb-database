# Table Partitioning Performance Report

## Objective

This report details the implementation of table partitioning on the `bookings` table within the `alx_airbnb_db` database and evaluates its impact on query performance for large datasets. The goal is to demonstrate how partitioning can reduce the amount of data scanned by queries, leading to faster execution times.

## Partitioning Strategy

The `bookings` table was chosen for partitioning due to its anticipated large size and frequent queries based on date ranges. The table was partitioned using a **`RANGE` partitioning strategy on the `YEAR(check_in_date)` column**.

This approach allows data to be physically separated into distinct partitions based on the year a booking starts. For example:
* `p_before_2024`: Contains bookings with `check_in_date` before January 1, 2024.
* `p2024`: Contains bookings with `check_in_date` in 2024.
* `p2025`: Contains bookings with `check_in_date` in 2025.
* `p2026`: Contains bookings with `check_in_date` in 2026.
* `p_future`: A `MAXVALUE` partition to catch all bookings with `check_in_date` from 2027 onwards, ensuring no data is rejected if new partitions are not explicitly added.

This strategy is highly effective for queries that filter data by `check_in_date` or date ranges spanning specific years, as the database can directly access only the relevant partition(s), avoiding full table scans.

## Implementation (SQL Snippet)

The following SQL was used to (re)create the `bookings` table with partitioning:

```sql
-- Assuming payments table depends on bookings, so it's dropped and recreated
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS bookings;

CREATE TABLE bookings (
    booking_id VARCHAR(36) DEFAULT (UUID()) PRIMARY KEY,
    property_id VARCHAR(36) NOT NULL,
    guest_id VARCHAR(36) NOT NULL,
    check_in_date DATETIME NOT NULL,
    check_out_date DATETIME NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (guest_id) REFERENCES users(user_id)
)
PARTITION BY RANGE ( YEAR(check_in_date) ) (
    PARTITION p_before_2024 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Recreate payments table
CREATE TABLE payments (
    payment_id VARCHAR(36) DEFAULT (UUID()) PRIMARY KEY,
    booking_id VARCHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer') NOT NULL,
    transaction_id VARCHAR(255) UNIQUE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);
