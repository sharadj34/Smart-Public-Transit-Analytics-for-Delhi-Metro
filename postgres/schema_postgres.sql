-- PostgreSQL schema for Delhi Metro analytics
-- Run with: psql -d delhi_metro -f postgres/schema_postgres.sql

CREATE TABLE IF NOT EXISTS stations (
    station_id INTEGER PRIMARY KEY,
    station_name VARCHAR(100),
    line_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS passengers (
    passenger_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    age INTEGER,
    card_type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS trips (
    trip_id INTEGER PRIMARY KEY,
    passenger_id INTEGER REFERENCES passengers(passenger_id),
    entry_station INTEGER REFERENCES stations(station_id),
    exit_station INTEGER REFERENCES stations(station_id),
    trip_datetime TIMESTAMP,
    fare NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS revenue (
    revenue_id INTEGER PRIMARY KEY,
    station_id INTEGER REFERENCES stations(station_id),
    revenue_date DATE,
    total_revenue NUMERIC(12,2)
);


