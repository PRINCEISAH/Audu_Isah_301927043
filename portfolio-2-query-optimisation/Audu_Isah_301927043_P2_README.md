# Hotel Reservation System — SQL queries

## 1. Show related reservation, guest, room records (up to 20).

```sql
SELECT t0."reservation_id" AS "reservation_reservation_id",
       t0."confirmation_code" AS "reservation_confirmation_code",
       t1."guest_id" AS "guest_guest_id",
       t1."full_name" AS "guest_full_name",
       t2."room_id" AS "room_room_id",
       t2."room_number" AS "room_room_number"
FROM portfolio."reservation" t0
JOIN portfolio."guest" t1 ON t0."guest_id" = t1."guest_id"
JOIN portfolio."room" t2 ON t0."room_id" = t2."room_id"
ORDER BY t0."reservation_id", t1."guest_id", t2."room_id"
LIMIT 20;
```

| reservation_reservation_id | reservation_confirmation_code | guest_guest_id | guest_full_name | room_room_id | room_room_number |
| --- | --- | --- | --- | --- | --- |
| 5 | HTL-A100 | 1 | Avery Morgan | 3 | 101 |
| 6 | HTL-B200 | 2 | Riley Chen | 4 | 202 |

## 2. Find reservation records where status matches "confirmed" (up to 20).

```sql
SELECT * FROM portfolio."reservation"
WHERE "status" IS NOT DISTINCT FROM 'confirmed'
ORDER BY "reservation_id"
LIMIT 20;
```

| reservation_id | guest_id | room_id | confirmation_code | check_in_date | check_out_date | status |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 1 | 3 | HTL-A100 | 2026-12-01 | 2026-12-04 | confirmed |

## 3. Count reservation records for each guest_id (up to 20 groups).

```sql
SELECT "guest_id", count(*) AS record_count
FROM portfolio."reservation"
GROUP BY "guest_id"
ORDER BY record_count DESC, "guest_id" NULLS LAST
LIMIT 20;
```

| guest_id | record_count |
| --- | --- |
| 1 | 1 |
| 2 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.125 | 1.125, 1.132, 1.112 | Sort → Seq Scan | 131 |
| After index | 0.187 | 0.211, 0.187, 0.179 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.125 ms to 0.187 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.091..1.101 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.016..1.058 rows=20 loops=1)
Planning Time: 0.37 ms
Execution Time: 1.125 ms
```

### Before index, run 2

```text
Sort (actual time=1.103..1.105 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.017..1.066 rows=20 loops=1)
Planning Time: 0.408 ms
Execution Time: 1.132 ms
```

### Before index, run 3

```text
Sort (actual time=1.085..1.087 rows=20 loops=1)
  Seq Scan on reservation (actual time=0.016..1.051 rows=20 loops=1)
Planning Time: 0.377 ms
Execution Time: 1.112 ms
```

### After index, run 1

```text
Sort (actual time=0.154..0.156 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.034..0.11 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=20 loops=1)
Planning Time: 0.851 ms
Execution Time: 0.211 ms
```

### After index, run 2

```text
Sort (actual time=0.124..0.126 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.028..0.086 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.529 ms
Execution Time: 0.187 ms
```

### After index, run 3

```text
Sort (actual time=0.138..0.139 rows=20 loops=1)
  Bitmap Heap Scan on reservation (actual time=0.026..0.086 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=20 loops=1)
Planning Time: 0.54 ms
Execution Time: 0.179 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Audu_Isah_301927043_P2_Queries.sql, then Audu_Isah_301927043_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Audu_Isah_301927043_P2_QueryResults.png) · [Index comparison](screenshots/Audu_Isah_301927043_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

