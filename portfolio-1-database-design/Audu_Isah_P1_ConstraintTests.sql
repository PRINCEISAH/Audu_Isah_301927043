-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. guest duplicate pk. Expected: pk_guest, SQLSTATE 23505.
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email")
VALUES (1, 'Jordan Park', 'jordan.park@example.test');

-- 2. guest duplicate email. Expected: uq_guest_0, SQLSTATE 23505.
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email")
VALUES (100, 'Taylor Reed', 'avery.morgan@example.test');

-- 3. guest null id. Expected: guest_id, SQLSTATE 23502.
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email")
VALUES (NULL, 'Casey Lane', 'casey.lane@example.test');

-- 4. guest null name. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email")
VALUES (102, NULL, 'sam.ellis@example.test');

-- 5. guest null email. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."guest" ("guest_id", "full_name", "email")
VALUES (103, 'Jamie Fox', NULL);

-- 6. room duplicate pk. Expected: pk_room, SQLSTATE 23505.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate")
VALUES (3, '303', 'Suite', 240);

-- 7. room duplicate number. Expected: uq_room_0, SQLSTATE 23505.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate")
VALUES (104, '101', 'Standard', 130);

-- 8. room null id. Expected: room_id, SQLSTATE 23502.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate")
VALUES (NULL, '304', 'Suite', 240);

-- 9. room null number. Expected: room_number, SQLSTATE 23502.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate")
VALUES (106, NULL, 'Standard', 130);

-- 10. room null type. Expected: room_type, SQLSTATE 23502.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate")
VALUES (107, '305', NULL, 150);

-- 11. room null rate. Expected: nightly_rate, SQLSTATE 23502.
INSERT INTO portfolio."room" ("room_id", "room_number", "room_type", "nightly_rate")
VALUES (108, '306', 'Standard', NULL);

-- 12. reservation duplicate pk. Expected: pk_reservation, SQLSTATE 23505.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (5, 1, 3, 'HTL-C300', '2026-12-10', '2026-12-12', 'confirmed');

-- 13. reservation duplicate confirmation. Expected: uq_reservation_0, SQLSTATE 23505.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (110, 1, 3, 'HTL-A100', '2026-12-10', '2026-12-12', 'confirmed');

-- 14. reservation duplicate room checkin. Expected: uq_reservation_1, SQLSTATE 23505.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (111, 1, 3, 'HTL-C301', '2026-12-01', '2026-12-03', 'confirmed');

-- 15. reservation missing guest. Expected: fk_reservation_0, SQLSTATE 23503.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (112, 900, 3, 'HTL-C302', '2026-12-10', '2026-12-12', 'confirmed');

-- 16. reservation missing room. Expected: fk_reservation_1, SQLSTATE 23503.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (113, 1, 901, 'HTL-C303', '2026-12-10', '2026-12-12', 'confirmed');

-- 17. reservation null id. Expected: reservation_id, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (NULL, 1, 3, 'HTL-C304', '2026-12-10', '2026-12-12', 'confirmed');

-- 18. reservation null guest. Expected: guest_id, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (115, NULL, 3, 'HTL-C305', '2026-12-10', '2026-12-12', 'confirmed');

-- 19. reservation null room. Expected: room_id, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (116, 1, NULL, 'HTL-C306', '2026-12-10', '2026-12-12', 'confirmed');

-- 20. reservation null confirmation. Expected: confirmation_code, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (117, 1, 3, NULL, '2026-12-10', '2026-12-12', 'confirmed');

-- 21. reservation null checkin. Expected: check_in_date, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (118, 1, 3, 'HTL-C307', NULL, '2026-12-12', 'confirmed');

-- 22. reservation null checkout. Expected: check_out_date, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (119, 1, 3, 'HTL-C308', '2026-12-10', NULL, 'confirmed');

-- 23. reservation null status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (120, 1, 3, 'HTL-C309', '2026-12-10', '2026-12-12', NULL);

-- 24. reservation dates reversed. Expected: reservation_dates_ordered, SQLSTATE 23514.
INSERT INTO portfolio."reservation" ("reservation_id", "guest_id", "room_id", "confirmation_code", "check_in_date", "check_out_date", "status")
VALUES (121, 1, 3, 'HTL-C310', '2026-12-12', '2026-12-10', 'confirmed');
