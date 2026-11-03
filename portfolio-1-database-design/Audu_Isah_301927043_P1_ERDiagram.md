# Hotel Reservation System — ER diagram

```mermaid
erDiagram
    direction LR
    guest {
        bigint guest_id PK
        text full_name
        text email UK
    }
    room {
        bigint room_id PK
        text room_number UK
        text room_type
        numeric nightly_rate
    }
    reservation {
        bigint reservation_id PK
        bigint guest_id FK
        bigint room_id FK
        text confirmation_code UK
        date check_in_date
        date check_out_date
        text status
    }
    guest ||--o{ reservation : "guest_id"
    room ||--o{ reservation : "room_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Audu_Isah_301927043_ERDiagram.png)
