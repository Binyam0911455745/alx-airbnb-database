# Database Normalization Steps for Airbnb ERD (3NF)

This document explains the steps taken to normalize the initial database design for the Airbnb-like application to the Third Normal Form (3NF).

## Objective

The primary objective of normalization is to reduce data redundancy and improve data integrity, ensuring that each piece of information is stored in only one place and dependencies are properly handled.

## Initial Schema Review and Identification of Violations

Upon reviewing the initial schema, two primary areas were identified as violating 3NF, or leading to significant redundancy:

1.  **Amenities in the `properties` table:**
    * The original design likely intended to store a list or string of amenities directly within the `properties` table (e.g., `amenities` TEXT column). This violates the principles of atomicity (First Normal Form - 1NF) if amenities are stored as a comma-separated list, or leads to redundancy and update anomalies if individual amenities are treated as separate, non-atomic attributes within the `properties` table.
    * Even if stored atomically, a direct `amenities` column for a property would indicate a many-to-many relationship (a property has many amenities, and an amenity can belong to many properties) which is not efficiently handled by a single column in 3NF.

2.  **`property_id` and `user_id` directly in the `reviews` table:**
    * A review is directly linked to a specific `booking`. A `booking` inherently links a `user` (guest) to a `property`. Therefore, storing `property_id` and `user_id` directly in the `reviews` table creates transitive dependencies. This means that `review_id` determines `booking_id`, and `booking_id` in turn determines `property_id` and `user_id`. This violates Third Normal Form (3NF), where non-key attributes should only depend on the primary key, not on other non-key attributes.

## Normalization Steps to Achieve 3NF

To address the identified violations and achieve 3NF, the following adjustments were made to the database design:

### 1. Normalizing Amenities (Addressing Many-to-Many Relationship)

* **Creation of `amenities` table:** A new table named `amenities` was introduced to store unique amenity details.
    * `amenity_id` (Primary Key, UUID)
    * `name` (VARCHAR, UNIQUE, NOT NULL)
    * `description` (TEXT)
    * `created_at` (TIMESTAMP)
* **Creation of `property_amenities` junction table:** To resolve the many-to-many relationship between `properties` and `amenities`, a junction (or associative) table called `property_amenities` was created.
    * `property_id` (Composite Primary Key, Foreign Key referencing `properties.property_id`)
    * `amenity_id` (Composite Primary Key, Foreign Key referencing `amenities.amenity_id`)
    * `created_at` (TIMESTAMP)
* **Removal of `amenities` column from `properties` table:** The original `amenities` column (if it existed as a free-text or list field) was removed from the `properties` table, as its data is now managed through the new `amenities` and `property_amenities` tables.

### 2. Normalizing Reviews (Removing Transitive Dependencies)

* **Linking `reviews` directly to `bookings`:** The `reviews` table was modified to establish a direct foreign key relationship only with the `bookings` table.
    * The `property_id` and `user_id` columns were removed from the `reviews` table.
    * A `booking_id` (Foreign Key referencing `bookings.booking_id`) was added as the determinant for the review.
* **Rationale:** Since every review must be associated with a specific booking, and that booking already links to the `user` (guest) who made the booking and the `property` being reviewed, retrieving the `user` and `property` details for a review can be done by joining `reviews` with `bookings`. This ensures that `rating` and `comment` directly depend on the `booking_id` (the primary key of the fact being reviewed, which is a booking event), adhering to 3NF.

### 3. Minor Adjustments and Refinements

* **Renaming for clarity:** `pricepernight` in `properties` was renamed to `price_per_night` for better snake_case consistency. Similarly, `user_id` in `bookings` was clarified to `guest_id`.
* **Enums and Constraints:** Ensured enums (`role`, `booking_status`, `payment_method`) are comprehensive (e.g., adding 'admin' to `role`, 'completed' to `booking_status`) and that all `NOT NULL`, `UNIQUE`, and `CHECK` constraints are properly defined as per requirements.
* **Adding property details:** `number_of_rooms`, `number_of_bathrooms`, and `max_guests` were added to the `properties` table, as these are direct attributes of a property.

## Conclusion

By implementing these normalization steps, the database design adheres to the Third Normal Form (3NF), significantly reducing data redundancy, improving data integrity, and making the schema more flexible and scalable for future application development.
