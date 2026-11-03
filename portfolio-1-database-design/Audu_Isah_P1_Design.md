# Hotel Reservation System — database design

My case study records guest, room, reservation.

## Users

- Front-desk staff
- Hotel managers

## Main operations

- Record a guest and room reservation
- Find reservations by status and check-in date
- Summarize reservation counts and estimated room charges by guest

## Entities

| Entity | Information stored |
| --- | --- |
| guest | Stores a hotel's guest contact details. |
| room | Stores bookable hotel room details and nightly rate. |
| reservation | Records one guest's booking of one room for a date range. |

## guest

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| guest_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
- Unique key: (email).

## room

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| room_id | BIGINT | PK | Yes |
| room_number | TEXT | Unique | Yes |
| room_type | TEXT |  | Yes |
| nightly_rate | NUMERIC(18,2) |  | Yes |
- Unique key: (room_number).

## reservation

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| reservation_id | BIGINT | PK | Yes |
| guest_id | BIGINT | FK | Yes |
| room_id | BIGINT | FK | Yes |
| confirmation_code | TEXT | Unique | Yes |
| check_in_date | DATE |  | Yes |
| check_out_date | DATE |  | Yes |
| status | TEXT |  | Yes |
- guest_id → guest.guest_id
- room_id → room.room_id
- Unique key: (confirmation_code).
- Unique key: (room_id, check_in_date).

## Relationships and business rules

- Each guest email address identifies at most one guest.
- Each room number identifies at most one room.
- Every reservation references an existing guest through guest_id.
- Every reservation references an existing room through room_id.
- A reservation's check-out date must be later than its check-in date.
- Each reservation confirmation code is unique.
- A room has at most one reservation for a given check-in date.

## Assumptions

- Each reservation is for one guest and one room.
- A room may have at most one reservation with a given check-in date; conflicts across different check-in dates are outside this model.
- Confirmation codes and guest email addresses are unique.
- All records and benchmark data are synthetic.

