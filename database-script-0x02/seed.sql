-- ───────────────────────────────────────────────────────────
-- 1) Users
-- ───────────────────────────────────────────────────────────
INSERT INTO user (
  user_id, first_name, last_name, email,
  password_hash, phone_number, role
) VALUES
  ('a1b2c3d4-1111-4411-8111-abcdefabcdef', 'Alice',   'Hostson',  'alice@bnbclone.com', 'hashed_pwd1', '08012345678', 'host'),
  ('a1b2c3d4-2222-4422-8222-fedcbafedcba', 'Bob',     'Guestman', 'bob@bnbclone.com',   'hashed_pwd2', '08023456789', 'guest'),
  ('a1b2c3d4-3333-4433-8333-0123456789ab', 'Carol',   'Traveller','carol@bnbclone.com', 'hashed_pwd3', '08034567890', 'guest');

-- ───────────────────────────────────────────────────────────
-- 2) Properties
-- ───────────────────────────────────────────────────────────
INSERT INTO property (
  property_id, host_id, name, description,
  location, pricepernight
) VALUES
  ('b1b2c3d4-1111-4411-8111-abcdefabcdef',
   'a1b2c3d4-1111-4411-8111-abcdefabcdef',
   'Cozy Loft in Downtown',
   'A bright, modern loft in the heart of the city.',
   'Lagos, NG', 100.00),

  ('b1b2c3d4-2222-4422-8222-fedcbafedcba',
   'a1b2c3d4-1111-4411-8111-abcdefabcdef',
   'Beachside Bungalow',
   'Relax by the ocean in this charming bungalow.',
   'Calabar, NG', 150.00);

-- ───────────────────────────────────────────────────────────
-- 3) Bookings
-- ───────────────────────────────────────────────────────────
INSERT INTO booking (
  booking_id, property_id, user_id,
  start_date, end_date, total_price, status
) VALUES
  ('c1b2c3d4-1111-4411-8111-abcdefabcdef',
   'b1b2c3d4-1111-4411-8111-abcdefabcdef',
   'a1b2c3d4-2222-4422-8222-fedcbafedcba',
   '2025-07-01', '2025-07-05', 400.00, 'pending'),

  ('c1b2c3d4-2222-4422-8222-fedcbafedcba',
   'b1b2c3d4-2222-4422-8222-fedcbafedcba',
   'a1b2c3d4-3333-4433-8333-0123456789ab',
   '2025-07-10', '2025-07-15', 750.00, 'confirmed'),

  ('c1b2c3d4-3333-4433-8333-0123456789ab',
   'b1b2c3d4-2222-4422-8222-fedcbafedcba',
   'a1b2c3d4-2222-4422-8222-fedcbafedcba',
   '2025-08-01', '2025-08-03', 300.00, 'canceled');

-- ───────────────────────────────────────────────────────────
-- 4) Payments
-- ───────────────────────────────────────────────────────────
INSERT INTO payment (
  payment_id, booking_id, amount, payment_method
) VALUES
  ('d1b2c3d4-1111-4411-8111-abcdefabcdef',
   'c1b2c3d4-1111-4411-8111-abcdefabcdef', 400.00, 'credit_card'),
  ('d1b2c3d4-2222-4422-8222-fedcbafedcba',
   'c1b2c3d4-2222-4422-8222-fedcbafedcba', 750.00, 'paypal'),
  ('d1b2c3d4-3333-4433-8333-0123456789ab',
   'c1b2c3d4-3333-4433-8333-0123456789ab', 300.00, 'stripe');

-- ───────────────────────────────────────────────────────────
-- 5) Reviews
-- ───────────────────────────────────────────────────────────
INSERT INTO review (
  review_id, property_id, user_id, rating, comment
) VALUES
  ('e1b2c3d4-1111-4411-8111-abcdefabcdef',
   'b1b2c3d4-1111-4411-8111-abcdefabcdef',
   'a1b2c3d4-2222-4422-8222-fedcbafedcba',
   5, 'Amazing stay! Highly recommend.'),

  ('e1b2c3d4-2222-4422-8222-fedcbafedcba',
   'b1b2c3d4-2222-4422-8222-fedcbafedcba',
   'a1b2c3d4-3333-4433-8333-0123456789ab',
   4, 'Great location, but a bit noisy.');


