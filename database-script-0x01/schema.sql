CREATE TABLE `user` (
  `user_id` UUID UNIQUE PRIMARY KEY COMMENT 'Primary key for the user',
  `first_name` VARCHAR NOT NULL,
  `last_name` VARCHAR NOT NULL,
  `email` VARCHAR UNIQUE NOT NULL,
  `password_hash` VARCHAR NOT NULL,
  `phone_number` VARCHAR,
  `role` ENUM ('guest', 'host', 'admin') NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE `property` (
  `property_id` UUID UNIQUE PRIMARY KEY COMMENT 'Primary key for properties',
  `host_id` UUID NOT NULL COMMENT 'Foreign key to users.user_id',
  `name` VARCHAR NOT NULL COMMENT 'Listing title',
  `description` TEXT NOT NULL COMMENT 'Detailed description of the property',
  `location` VARCHAR NOT NULL COMMENT 'City, state, or address',
  `pricepernight` DECIMAL(10,2) NOT NULL COMMENT 'Cost per night in USD',
  `created_at` TIMESTAMP NOT NULL DEFAULT (now()) COMMENT 'Record creation timestamp',
  `updated_at` TIMESTAMP NOT NULL DEFAULT (now()) COMMENT 'Auto-updates on modification (ON UPDATE CURRENT_TIMESTAMP)'
);

CREATE TABLE `booking` (
  `booking_id` UUID UNIQUE PRIMARY KEY COMMENT 'Primary key for bokings made',
  `property_id` UUID NOT NULL COMMENT 'Foreign key to properties.property_id',
  `user_id` UUID NOT NULL COMMENT 'FK to users.user_id (guest)',
  `start_date` DATE NOT NULL COMMENT 'Check-in date',
  `end_date` DATE NOT NULL COMMENT 'Check-out date',
  `total_price` DECIMAL(10,2) NOT NULL COMMENT 'Total price for the stay',
  `status` ENUM ('pending', 'confirmed', 'canceled') NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT (now()) COMMENT 'Booking creation timestamp'
);

CREATE TABLE `payment` (
  `payment_id` UUID UNIQUE PRIMARY KEY COMMENT 'Primary key for payment',
  `booking_id` UUID NOT NULL COMMENT 'Foreign key to bookings.booking_id',
  `amount` DECIMAL(10,2) NOT NULL COMMENT 'Total payment amount',
  `payment_date` TIMESTAMP NOT NULL DEFAULT (now()) COMMENT 'Time payment was made',
  `payment_method` ENUM ('credit_card', 'paypal', 'stripe') NOT NULL
);

CREATE TABLE `reviews` (
  `review_id` UUID UNIQUE PRIMARY KEY,
  `property_id` UUID NOT NULL,
  `user_id` UUID NOT NULL,
  `rating` INTEGER NOT NULL,
  `comment` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE `messages` (
  `message_id` UUID UNIQUE PRIMARY KEY COMMENT 'Primary key for the message',
  `sender_id` UUID NOT NULL COMMENT 'User who sent the message',
  `recipient_id` UUID NOT NULL COMMENT 'User who received the message',
  `message_body` TEXT NOT NULL COMMENT 'Content of the message',
  `sent_at` TIMESTAMP NOT NULL DEFAULT (now()) COMMENT 'Timestamp when the message was sent'
);

ALTER TABLE `property` ADD FOREIGN KEY (`host_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `booking` ADD FOREIGN KEY (`property_id`) REFERENCES `property` (`property_id`);

ALTER TABLE `booking` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `payment` ADD FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`property_id`) REFERENCES `property` (`property_id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `messages` ADD FOREIGN KEY (`sender_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `messages` ADD FOREIGN KEY (`recipient_id`) REFERENCES `user` (`user_id`);
