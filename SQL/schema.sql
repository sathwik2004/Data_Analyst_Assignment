-- =========================
-- DROP OLD TABLES (SAFE RESET)
-- =========================
DROP TABLE IF EXISTS booking_commercials, bookings, items, users CASCADE;
DROP TABLE IF EXISTS expenses, clinic_sales, customer, clinics CASCADE;

-- =========================
-- HOTEL MANAGEMENT SYSTEM
-- =========================

-- USERS
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address VARCHAR(200)
);

INSERT INTO users VALUES
('u1','John Doe','9999999991','john@example.com','Address1'),
('u2','Jane Smith','9999999992','jane@example.com','Address2'),
('u3','Alex','9999999993','alex@example.com','Address3');

-- BOOKINGS
CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date TIMESTAMP,
    room_no VARCHAR(50),
    user_id VARCHAR(50)
);

INSERT INTO bookings VALUES
('b1','2021-11-10 10:00:00','r101','u1'),
('b2','2021-11-15 12:00:00','r102','u1'),
('b3','2021-10-05 09:00:00','r103','u2'),
('b4','2021-11-20 08:00:00','r104','u3');

-- ITEMS
CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate INT
);

INSERT INTO items VALUES
('i1','Paratha',20),
('i2','Veg Curry',100),
('i3','Rice',50),
('i4','Paneer',200);

-- BOOKING COMMERCIALS
CREATE TABLE booking_commercials (
    id VARCHAR(50),
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date TIMESTAMP,
    item_id VARCHAR(50),
    item_quantity FLOAT
);

INSERT INTO booking_commercials VALUES
('c1','b1','bill1','2021-11-10 11:00:00','i1',2),
('c2','b1','bill1','2021-11-10 11:00:00','i2',1),
('c3','b2','bill2','2021-11-15 13:00:00','i3',5),
('c4','b3','bill3','2021-10-05 10:00:00','i2',15),
('c5','b4','bill4','2021-11-20 09:00:00','i4',3),
('c6','b4','bill4','2021-11-20 09:00:00','i1',10);

-- =========================
-- CLINIC MANAGEMENT SYSTEM
-- =========================

-- CLINICS
CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

INSERT INTO clinics VALUES
('c1','Clinic A','City1','State1','India'),
('c2','Clinic B','City1','State1','India'),
('c3','Clinic C','City2','State2','India');

-- CUSTOMERS
CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

INSERT INTO customer VALUES
('u1','Ram','9999999999'),
('u2','Shyam','8888888888'),
('u3','Sita','7777777777');

-- CLINIC SALES
CREATE TABLE clinic_sales (
    oid VARCHAR(50),
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount INT,
    datetime TIMESTAMP,
    sales_channel VARCHAR(50)
);

INSERT INTO clinic_sales VALUES
('o1','u1','c1',2000,'2021-10-10 10:00:00','online'),
('o2','u2','c2',5000,'2021-10-15 12:00:00','offline'),
('o3','u3','c3',7000,'2021-10-20 14:00:00','online'),
('o4','u1','c1',3000,'2021-11-05 09:00:00','offline');

-- EXPENSES
CREATE TABLE expenses (
    eid VARCHAR(50),
    cid VARCHAR(50),
    description VARCHAR(100),
    amount INT,
    datetime TIMESTAMP
);

INSERT INTO expenses VALUES
('e1','c1','supplies',500,'2021-10-10 09:00:00'),
('e2','c2','rent',1000,'2021-10-15 11:00:00'),
('e3','c3','equipment',2000,'2021-10-20 13:00:00'),
('e4','c1','maintenance',800,'2021-11-05 08:00:00');
