# Hotel Reservation System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| guest_id | reservation records (list) |
| --- | --- |
| 1 | [5] |
| 2 | [6] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| reservation.reservation_id | reservation.guest_id | reservation.room_id | reservation.confirmation_code | guest.guest_id | guest.full_name | room.room_id | room.room_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | 1 | 3 | HTL-A100 | 1 | Avery Morgan | 3 | 101 |
| 6 | 2 | 4 | HTL-B200 | 2 | Riley Chen | 4 | 202 |

Key: reservation_id.

## 2NF: depend on the whole key

reservation: room_id is a proper part of candidate key (room_id, check_in_date), and determines room details.

## room_example

| room.room_id | room.room_number |
| --- | --- |
| 3 | 101 |
| 4 | 202 |

## reservation_example

| reservation.reservation_id | reservation.guest_id | reservation.room_id | reservation.confirmation_code | guest.guest_id | guest.full_name |
| --- | --- | --- | --- | --- | --- |
| 5 | 1 | 3 | HTL-A100 | 1 | Avery Morgan |
| 6 | 2 | 4 | HTL-B200 | 2 | Riley Chen |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## guest

| guest_id | full_name | email |
| --- | --- | --- |
| 1 | Avery Morgan | avery.morgan@example.test |
| 2 | Riley Chen | riley.chen@example.test |

## room

| room_id | room_number | room_type | nightly_rate |
| --- | --- | --- | --- |
| 3 | 101 | Standard | 120 |
| 4 | 202 | Deluxe | 185 |

## reservation

| reservation_id | guest_id | room_id | confirmation_code | check_in_date | check_out_date | status |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 1 | 3 | HTL-A100 | 2026-12-01 | 2026-12-04 | confirmed |
| 6 | 2 | 4 | HTL-B200 | 2026-12-02 | 2026-12-05 | pending |

## Dependencies

- guest: (guest_id) → full_name, email
- room: (room_id) → room_number, room_type, nightly_rate
- reservation: (reservation_id) → guest_id, room_id, confirmation_code, check_in_date, check_out_date, status

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
