-- Extension to support uuid_generate_v4() function
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Insert locations (Ethiopian cities and postal codes)
INSERT INTO "locations" (location_id, country, state, city, postal_code, lat, lng) VALUES
    (uuid_generate_v4(), 'Ethiopia', 'Addis Ababa', 'Addis Ababa', '1000', 9.0203, 38.7478),
    (uuid_generate_v4(), 'Ethiopia', 'Amhara', 'Bahir Dar', '3000', 11.5976, 37.3879),
    (uuid_generate_v4(), 'Ethiopia', 'Oromia', 'Adama', '2000', 8.5414, 39.2711),
    (uuid_generate_v4(), 'Ethiopia', 'Tigray', 'Mekelle', '4000', 13.4965, 39.4678);

-- Insert users with different roles (Ethiopian names)
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
    (uuid_generate_v4(), 'Abebe', 'Kebede', 'abebe.kebede@example.com', 'hashed_abebe_pwd', '+251911234567', 'host'),
    (uuid_generate_v4(), 'Tirunesh', 'Dibaba', 'tirunesh.dibaba@example.com', 'hashed_tirunesh_pwd', '+251920987654', 'guest'),
    (uuid_generate_v4(), 'Solomon', 'Bekele', 'solomon.bekele@example.com', 'hashed_solomon_pwd', '+251933445566', 'host'),
    (uuid_generate_v4(), 'Aster', 'Aweke', 'aster.aweke@example.com', 'hashed_aster_pwd', '+251945678901', 'guest'),
    (uuid_generate_v4(), 'Fitsum', 'Tesfaye', 'fitsum.tesfaye@example.com', 'hashed_fitsum_pwd', '+251950112233', 'admin');

-- Insert properties (Properties in Ethiopian locations with Ethiopian themes)
INSERT INTO properties (property_id, host_id, name, description, location, pricepernight) VALUES
    (uuid_generate_v4(),
     (SELECT user_id FROM users WHERE first_name = 'Abebe'),
     'Addis Ababa Cozy Apartment',
     'Modern 2-bedroom apartment in Bole, close to Edna Mall.',
     (SELECT location_id FROM locations WHERE city = 'Addis Ababa'),
     1500.00), -- Price in Ethiopian Birr (Br)
    (uuid_generate_v4(),
     (SELECT user_id FROM users WHERE first_name = 'Solomon'),
     'Lalibela Style Retreat',
     'Unique guesthouse inspired by the rock-hewn churches of Lalibela, near Bahir Dar.',
     (SELECT location_id FROM locations WHERE city = 'Bahir Dar'),
     2200.00),
    (uuid_generate_v4(),
     (SELECT user_id FROM users WHERE first_name = 'Abebe'),
     'Luxury Villa with City View',
     'Spacious villa overlooking Addis Ababa with a beautiful garden.',
     (SELECT location_id FROM locations WHERE city = 'Addis Ababa'),
     5000.00);

-- Insert bookings (New bookings for Ethiopian properties)
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
    (uuid_generate_v4(),
     (SELECT property_id FROM properties WHERE name = 'Addis Ababa Cozy Apartment'),
     (SELECT user_id FROM users WHERE first_name = 'Tirunesh'),
     '2025-07-20', '2025-07-25', 7500.00, 'confirmed'), -- 5 nights * 1500 Br
    (uuid_generate_v4(),
     (SELECT property_id FROM properties WHERE name = 'Lalibela Style Retreat'),
     (SELECT user_id FROM users WHERE first_name = 'Aster'),
     '2025-08-01', '2025-08-05', 8800.00, 'pending'); -- 4 nights * 2200 Br

-- Insert payments (Payments in Ethiopian Birr)
INSERT INTO payments (payment_id, booking_id, amount, payment_method) VALUES
    (uuid_generate_v4(),
     (SELECT booking_id FROM bookings WHERE total_price = 7500.00),
     7500.00, 'telebirr'), -- Example Ethiopian mobile money
    (uuid_generate_v4(),
     (SELECT booking_id FROM bookings WHERE total_price = 8800.00),
     8800.00, 'bank_transfer');

-- Insert reviews (Reviews for Ethiopian properties)
INSERT INTO reviews (review_id, property_id, user_id, rating, comment) VALUES
    (uuid_generate_v4(),
     (SELECT property_id FROM properties WHERE name = 'Addis Ababa Cozy Apartment'),
     (SELECT user_id FROM users WHERE first_name = 'Tirunesh'),
     5, 'Fantastic apartment, very clean and great location for exploring Addis!'),
    (uuid_generate_v4(),
     (SELECT property_id FROM properties WHERE name = 'Lalibela Style Retreat'),
     (SELECT user_id FROM users WHERE first_name = 'Aster'),
     4, 'Charming place, loved the cultural touches. A bit far from the city center but peaceful.');

-- Insert messages (Messages between Ethiopian users)
INSERT INTO messages (message_id, sender_id, recipient_id, message_body) VALUES
    (uuid_generate_v4(),
     (SELECT user_id FROM users WHERE first_name = 'Tirunesh'),
     (SELECT user_id FROM users WHERE first_name = 'Abebe'),
     'Selam! I am looking forward to my stay. Is there a good injera place nearby?'),
    (uuid_generate_v4(),
     (SELECT user_id FROM users WHERE first_name = 'Fitsum'),
     (SELECT user_id FROM users WHERE first_name = 'Solomon'),
     'Can you confirm the availability for a longer stay in September?');

