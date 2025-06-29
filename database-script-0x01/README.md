# Database Schema (DDL) for ALX Airbnb Clone

This directory contains the SQL Data Definition Language (DDL) script for creating the database schema of the Airbnb-like application. The schema is designed based on the normalized entity-relationship diagram (ERD) to ensure data integrity and minimize redundancy, adhering to Third Normal Form (3NF).

## Files

* `schema.sql`: Contains all the SQL `CREATE TABLE` statements, `CREATE TYPE` statements for enums, primary key definitions, foreign key relationships, constraints (NOT NULL, UNIQUE, CHECK), and indexes for optimal query performance.

## Database System

This `schema.sql` script is primarily written for **PostgreSQL**, leveraging its features like `UUID` data type and `ENUM` types.

## How to Use

To create the database schema using this script (assuming you have PostgreSQL installed and a database created):

1.  **Connect to your PostgreSQL database** using a client like `psql`:
    ```bash
    psql -U your_username -d your_database_name
    ```
    (Replace `your_username` and `your_database_name` with your actual PostgreSQL credentials.)

2.  **Execute the `schema.sql` script:**
    ```sql
    \i /path/to/your/alx-airbnb-database/database-script-0x01/schema.sql
    ```
    (Replace `/path/to/your/alx-airbnb-database/` with the actual path to your repository on your system.)

This will create all the tables, define relationships, and set up necessary constraints and indexes for the Airbnb application.

