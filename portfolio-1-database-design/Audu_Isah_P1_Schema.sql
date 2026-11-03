-- Hotel Reservation System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."guest" (
  "guest_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  CONSTRAINT "pk_guest" PRIMARY KEY ("guest_id"),
  CONSTRAINT "uq_guest_0" UNIQUE ("email")
);
CREATE TABLE portfolio."room" (
  "room_id" bigint NOT NULL,
  "room_number" text NOT NULL,
  "room_type" text NOT NULL,
  "nightly_rate" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_room" PRIMARY KEY ("room_id"),
  CONSTRAINT "uq_room_0" UNIQUE ("room_number")
);
CREATE TABLE portfolio."reservation" (
  "reservation_id" bigint NOT NULL,
  "guest_id" bigint NOT NULL,
  "room_id" bigint NOT NULL,
  "confirmation_code" text NOT NULL,
  "check_in_date" date NOT NULL,
  "check_out_date" date NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_reservation" PRIMARY KEY ("reservation_id"),
  CONSTRAINT "uq_reservation_0" UNIQUE ("confirmation_code"),
  CONSTRAINT "uq_reservation_1" UNIQUE ("room_id", "check_in_date")
);
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "fk_reservation_0" FOREIGN KEY ("guest_id") REFERENCES portfolio."guest" ("guest_id");
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "fk_reservation_1" FOREIGN KEY ("room_id") REFERENCES portfolio."room" ("room_id");
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "reservation_dates_ordered" CHECK ("check_out_date" > "check_in_date");
COMMIT;
