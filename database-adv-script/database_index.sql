-- Make sure you are using the correct database
USE alx_airbnb_db;

-- Note on Foreign Key Indexes:
-- Columns involved in foreign key constraints (like bookings.guest_id and bookings.property_id)
-- are automatically indexed by MySQL when the foreign key is defined.
-- Explicitly dropping these foreign key-dependent indexes will result in Error Code 1553.
-- Explicitly creating a new index on these columns is often redundant as MySQL already
-- ensures they are indexed for constraint enforcement.

-- Index for optimizing queries that filter or order by check-in date in the bookings table.
-- This column is a prime candidate for an explicit index as it's not typically a foreign key
-- and is frequently used in date-based searches and sorting.
CREATE INDEX idx_bookings_check_in_date ON bookings (check_in_date);

-- If you were to add other non-foreign key indexes (e.g., for search on names/emails):
-- CREATE INDEX idx_users_email ON users (email);
-- CREATE INDEX idx_properties_name ON properties (name);
