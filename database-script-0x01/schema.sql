-- Enable UUID extension for UUID generation (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Define Custom Enum Types
CREATE TYPE USER_ROLE AS ENUM ('guest', 'host', 'admin');
CREATE TYPE BOOKING_STATUS AS ENUM ('pending', 'confirmed', 'cancelled', 'completed');
CREATE TYPE PAYMENT_METHOD AS ENUM ('credit_card', 'paypal', 'stripe');

-- Table: users
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role USER_ROLE NOT NULL DEFAULT 'guest',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: properties
CREATE TABLE properties (
    property_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL REFERENCES users(user_id),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    number_of_rooms INTEGER NOT NULL,
    number_of_bathrooms INTEGER NOT NULL,
    max_guests INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    -- Note: 'ON UPDATE CURRENT_TIMESTAMP' functionality often requires a trigger in PostgreSQL.
    -- For DDL simplicity, we'll set a default for updated_at.
);

-- Table: bookings
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guest_id UUID NOT NULL REFERENCES users(user_id),
    property_id UUID NOT NULL REFERENCES properties(property_id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status BOOKING_STATUS NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_booking_dates CHECK (check_out_date >= check_in_date)
);

-- Table: reviews
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL REFERENCES bookings(booking_id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: amenities
CREATE TABLE amenities (
    amenity_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT
);

-- Table: property_amenities (Junction Table for Many-to-Many relationship)
CREATE TABLE property_amenities (
    property_id UUID NOT NULL REFERENCES properties(property_id),
    amenity_id UUID NOT NULL REFERENCES amenities(amenity_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (property_id, amenity_id) -- Composite Primary Key
);

-- Table: payments
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL REFERENCES bookings(booking_id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    payment_method PAYMENT_METHOD NOT NULL
);

-- Table: messages
CREATE TABLE messages (
    message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL REFERENCES users(user_id),
    recipient_id UUID NOT NULL REFERENCES users(user_id),
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for optimal query performance (beyond implicit indexes on PRIMARY KEY and UNIQUE constraints)

-- Foreign Key Indexes
CREATE INDEX idx_properties_host_id ON properties (host_id);
CREATE INDEX idx_bookings_guest_id ON bookings (guest_id);
CREATE INDEX idx_bookings_property_id ON bookings (property_id);
CREATE INDEX idx_reviews_booking_id ON reviews (booking_id);
CREATE INDEX idx_property_amenities_amenity_id ON property_amenities (amenity_id);
CREATE INDEX idx_payments_booking_id ON payments (booking_id);
CREATE INDEX idx_messages_sender_id ON messages (sender_id);
CREATE INDEX idx_messages_recipient_id ON messages (recipient_id);

-- Other useful indexes for common queries
CREATE INDEX idx_properties_location ON properties (location);
CREATE INDEX idx_properties_price_per_night ON properties (price_per_night);
CREATE INDEX idx_bookings_status ON bookings (status);
CREATE INDEX idx_bookings_check_in_date ON bookings (check_in_date);
CREATE INDEX idx_payments_payment_date ON payments (payment_date);

