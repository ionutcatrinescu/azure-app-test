-- init.sql: Initial schema for the PostgreSQL database

-- Check if the user `app_user` exists before trying to create it
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'app_user'
   ) THEN
      CREATE USER app_user WITH ENCRYPTED PASSWORD 'password123';
   END IF;
END
$$;

-- Ensure the database app_db belongs to app_user
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database WHERE datname = 'app_db'
   ) THEN
      CREATE DATABASE app_db OWNER app_user;
   END IF;
END
$$;
-- Switch to the target database
\c app_db

-- Create the required tables
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

-- Optional: Insert sample data
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');
