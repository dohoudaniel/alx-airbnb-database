CREATE TABLE user (
  user_id CHAR(36) UNIQUE PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(100) NOT NULL,
  phone_number VARCHAR(100),
  role ENUM ('guest', 'host', 'admin') NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE property (
  property_id CHAR(36) UNIQUE PRIMARY KEY,
  host_id CHAR(36) NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  location VARCHAR(100) NOT NULL,
  pricepernight DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT (now()),
  updated_at TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE booking (
  booking_id CHAR(36) UNIQUE PRIMARY KEY,
  property_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  status ENUM ('pending', 'confirmed', 'canceled') NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE payment (
  payment_id CHAR(36) UNIQUE PRIMARY KEY,
  booking_id CHAR(36) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_date TIMESTAMP NOT NULL DEFAULT (now()),
  payment_method ENUM ('credit_card', 'paypal', 'stripe') NOT NULL
);

CREATE TABLE reviews (
  review_id CHAR(36) UNIQUE PRIMARY KEY,
  property_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  rating INTEGER NOT NULL,
  comment TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE messages (
  message_id CHAR(36) UNIQUE PRIMARY KEY,
  sender_id CHAR(36) NOT NULL,
  recipient_id CHAR(36) NOT NULL,
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP NOT NULL DEFAULT (now())
);

ALTER TABLE property ADD FOREIGN KEY (host_id) REFERENCES user (user_id);

ALTER TABLE booking ADD FOREIGN KEY (property_id) REFERENCES property (property_id);

ALTER TABLE booking ADD FOREIGN KEY (user_id) REFERENCES user (user_id);

ALTER TABLE payment ADD FOREIGN KEY (booking_id) REFERENCES booking (booking_id);

ALTER TABLE reviews ADD FOREIGN KEY (property_id) REFERENCES property (property_id);

ALTER TABLE reviews ADD FOREIGN KEY (user_id) REFERENCES user (user_id);

ALTER TABLE messages ADD FOREIGN KEY (sender_id) REFERENCES user (user_id);

ALTER TABLE messages ADD FOREIGN KEY (recipient_id) REFERENCES user (user_id);
