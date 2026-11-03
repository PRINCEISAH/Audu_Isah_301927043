-- Fictional sample records for Hotel Reservation System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email") VALUES (1, 'Avery Morgan', 'avery.morgan@example.test');
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email") VALUES (2, 'Riley Chen', 'riley.chen@example.test');
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate") VALUES (3, '101', 'Standard', 120);
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate") VALUES (4, '202', 'Deluxe', 185);
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status") VALUES (5, 1, 3, 'HTL-A100', '2026-12-01', '2026-12-04', 'confirmed');
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status") VALUES (6, 2, 4, 'HTL-B200', '2026-12-02', '2026-12-05', 'pending');
COMMIT;
