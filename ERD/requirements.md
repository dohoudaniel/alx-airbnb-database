```dbml
```

enum booking_roles {
  guest
  host
  admin
}

enum booking_status {
  pending
  confirmed
  canceled
}

enum payments_method {
  credit_card
  paypal
  stripe
}

Table user {
  user_id UUID [pk, unique, note: "Primary key for the user"]
  first_name VARCHAR [not null]
  last_name VARCHAR [not null]
  email VARCHAR [not null, unique]
  password_hash VARCHAR [not null]
  phone_number VARCHAR
  role booking_roles [not null]
  created_at TIMESTAMP [not null, default: `now()`]
}

Table property {
  property_id UUID [pk, unique, note: "Primary key for properties"]
  host_id UUID [not null, ref: > user.user_id, note: "Foreign key to users.user_id"]
  name VARCHAR [not null, note: "Listing title"]
  description TEXT [not null, note: "Detailed description of the property"]
  location VARCHAR [not null, note: "City, state, or address"]
  pricepernight DECIMAL(10,2) [not null, note: "Cost per night in USD"]
  created_at TIMESTAMP [not null, default: `now()`, note: "Record creation timestamp"]
  updated_at TIMESTAMP [not null, default: `now()`, note: "Auto-updates on modification (ON UPDATE CURRENT_TIMESTAMP)"]
}

Table booking {
  booking_id UUID [pk, unique, note: "Primary key for bokings made"]
  property_id UUID [not null, ref: > property.property_id, note: "Foreign key to properties.property_id"]
  user_id UUID [not null, ref: > user.user_id, note: "FK to users.user_id (guest)"]
  start_date DATE [not null, note: "Check-in date"]
  end_date DATE [not null, note: "Check-out date"]
  total_price DECIMAL(10,2) [not null, note: "Total price for the stay"]
  status booking_status [not null]
  created_at TIMESTAMP [not null, default: `now()`, note: "Booking creation timestamp"]
}

Table payment {
  payment_id UUID [pk, unique, note: "Primary key for payment"]
  booking_id UUID [not null, ref: > booking.booking_id, note: "Foreign key to bookings.booking_id"]
  amount DECIMAL(10,2) [not null, note: "Total payment amount"]
  payment_date TIMESTAMP [not null, default: `now()`, note: "Time payment was made"]
  payment_method payments_method [not null]
}

Table reviews {
  review_id UUID [pk, unique]
  property_id UUID [not null, ref: > property.property_id]
  user_id UUID [not null, ref: > user.user_id]
  rating INTEGER [not null]
  comment TEXT [not null]
  created_at TIMESTAMP [not null, default: `now()`]
}

Table messages {
  message_id UUID [pk, unique, note: "Primary key for the message"]
  sender_id UUID [not null, ref: > user.user_id, note: "User who sent the message"]
  recipient_id UUID [not null, ref: > user.user_id, note: "User who received the message"]
  message_body TEXT [not null, note: "Content of the message"]
  sent_at TIMESTAMP [not null, default: `now()`, note: "Timestamp when the message was sent"]
}
```
```
