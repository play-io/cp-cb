CREATE USER 'debezium' IDENTIFIED BY 'dbz';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium'@'%';

# Create the database that we'll use to populate data and watch the effect in the binlog
CREATE DATABASE inventory;
GRANT ALL PRIVILEGES ON inventory.* TO 'mysqluser'@'%';

# Switch to this database
USE inventory;

# Create and populate our bookings using a single insert with many rows
CREATE TABLE a_htl_bookings (
  id INTEGER NOT NULL PRIMARY KEY,
  num_rooms INTEGER NOT NULL,
  property_id INTEGER NOT NULL,
  booking_via VARCHAR(255) NOT NULL,
  customer_id INTEGER NOT NULL,
  customer_name VARCHAR(255) NOT NULL,
  group_profile_id VARCHAR(255),
  group_profile_name VARCHAR(255),
  allotment_block_id VARCHAR(255),
  booking_date DATETIME NOT NULL,
  checkin_date DATE NOT NULL,
  checkout_date DATE NOT NULL,
  created_at DATETIME  NOT NULL,
  updated_at DATETIME NOT NULL
);

INSERT INTO a_htl_bookings(id, num_rooms, property_id, booking_via, customer_id, customer_name, booking_date, checkin_date, checkout_date, created_at, updated_at)
VALUES (1, 2, 6, 'third-party', 1, 'Klay Thompson', '2021-01-15 14:15:18', '2021-01-12','2021-01-15', '2020-11-09 14:15:18.980992', '2021-01-17 20:14:20.470139'),
  (2, 2, 5, 'third-party', 2, 'Klay Thompson', '2021-04-17 14:15:19', '2021-04-14','2021-04-17', '2020-11-09 14:15:19.429280', '2021-04-16 00:01:10.572264'),
  (3, 2, 8, 'third-party', 3, 'Klay Thompson', '2021-01-15 14:15:20', '2021-01-12','2021-01-15', '2020-11-09 14:15:20.633804', '2021-01-17 21:24:08.916786'),
  (4, 2, 12, 'third-party', 4, 'Klay Thompson', '2021-04-18 14:15:21', '2021-04-15','2021-04-18', '2020-11-09 14:15:21.424748', '2021-04-16 00:01:10.954154'),
  (5, 2, 7, 'third-party', 5, 'Klay Thompson', '2021-04-17 14:15:22', '2021-04-14','2021-04-17', '2020-11-09 14:15:22.093570', '2021-04-16 00:01:10.761139'),
  (6, 2, 11, 'third-party', 6, 'Klay Thompson', '2021-01-31 14:15:22', '2021-01-28','2021-01-31', '2020-11-09 14:15:22.290042', '2021-02-03 09:24:56.783975'),
  (7, 2, 13, 'third-party', 7, 'Klay Thompson', '2021-04-18 14:15:53', '2021-04-15','2021-04-18', '2020-11-09 14:15:53.049641', '2021-04-16 00:01:11.141327'),
  (8, 2, 15, 'third-party', 8, 'Klay Thompson', '2021-02-15 14:15:53', '2021-02-12','2021-02-15', '2020-11-09 14:15:53.806233', '2021-03-31 07:17:18.909877'),
  (9, 1, 6, 'third-party', 9, 'Neymar Jr', '2021-01-15 14:16:19', '2021-01-13','2021-01-15', '2020-11-09 14:16:19.564716', '2021-01-17 20:14:20.548814'),
  (10, 1, 5, 'third-party', 10, 'Neymar Jr', '2021-04-17 14:16:19', '2021-04-15','2021-04-17', '2020-11-09 14:16:19.612971', '2021-04-16 00:01:10.572264'),
  (11, 2, 16, 'third-party', 11, 'Klay Thompson', '2021-04-17 14:16:23', '2021-04-14','2021-04-17', '2020-11-09 14:16:23.760963', '2021-04-16 00:01:11.336663'),
  (12, 1, 7, 'third-party', 12, 'Neymar Jr', '2021-04-17 14:16:47', '2021-04-15','2021-04-17', '2020-11-09 14:16:47.933747', '2021-04-16 00:01:10.761139');

# Create and populate our financial transactions using a single insert with many rows
CREATE TABLE a_htl_financial_transactions (
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  property_id INTEGER NOT NULL,
  datetime_created DATETIME  NOT NULL,
  datetime_updated DATETIME NOT NULL
);

INSERT INTO a_htl_financial_transactions(id, property_id, datetime_created, datetime_updated)
VALUES ('5fa94ef99a94f9.13617271.049a8ef6e5225ed94.23366', 6, '2021-01-15 14:15:21', '2021-01-13 02:00:00'),
    ('5fa94ef99d5290.73689096.049a8ef6e5225ed94.23366', 6, '2021-01-15 14:15:21', '2021-01-14 02:00:00'),
    ('5fa94ef9a00204.96599959.049a8ef6e5225ed94.23366', 6, '2021-01-15 14:15:21', '2021-01-15 02:00:00'),
    ('5fa94ef9a7d223.89871538.049a8ef6e5225ed94.23366', 6, '2021-01-15 14:15:21', '2021-01-13 02:00:00'),
    ('5fa94ef9a813d7.22131455.049a8ef6e5225ed94.23366', 6, '2021-01-15 14:15:21', '2021-01-14 02:00:00'),
    ('5fa94ef9aac014.75218816.049a8ef6e5225ed94.23366', 6, '2021-01-15 14:15:21', '2021-01-15 02:00:00'),
    ('5fa94ef9f3c2d6.60883497.049a8ef6e5225ed94.23363', 5, '2021-04-17 14:15:21', '2021-04-15 02:00:00'),
    ('5fa94ef9f3ec06.97746592.049a8ef6e5225ed94.23363', 5, '2021-04-17 14:15:21', '2021-04-16 02:00:00'),
    ('5fa94ef9f41343.06720532.049a8ef6e5225ed94.23363', 5, '2021-04-17 14:15:21', '2021-04-17 02:00:00');
