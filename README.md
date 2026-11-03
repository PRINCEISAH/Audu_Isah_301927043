# MIT 8103 Advanced Database Systems — Portfolio

**Student:** Isah Audu · **Student ID:** 301927043
**Programme:** Master of Information Technology · 2026/2027 Academic Session, First Semester
**GitHub repository:** https://github.com/PRINCEISAH/Audu_Isah_301927043

---

## 1. Selected Case Study: Hotel Reservation System

| Item | Description |
| --- | --- |
| **Organisation / scenario** | A simulated hotel that takes room reservations. All records are fictional. |
| **Nature of the system** | A reservation system that records guests, the hotel's bookable rooms and each guest's booking of a room for a date range. |
| **Users of the database** | Front-desk staff (record guests and reservations) and hotel managers (review bookings and room charges). |
| **Major data stored** | Guests (name, unique email), rooms (unique room number, room type, nightly rate), reservations (confirmation code, guest, room, check-in and check-out dates, status), and reservation events in MongoDB. |
| **Key operations** | Record a guest and room reservation; find reservations by status and check-in date; summarise reservation counts and estimated room charges by guest. |

The same case study is used in all five portfolio activities.

---

## 2. Repository Structure

```
Audu_Isah_301927043/
├── Audu_Isah_README.md               ← this file
├── Audu_Isah_FinalSummary.md / .pdf  ← 2–3 page LMS documentation
├── images/                           ← ER diagram used in the summary
├── portfolio-1-database-design/
├── portfolio-2-query-optimisation/
├── portfolio-3-transactions-concurrency/
├── portfolio-4-nosql/
└── portfolio-5-distributed-cloud/
```

Each portfolio folder has its own README, scripts and a `screenshots/` folder with output evidence.

---

## 3. Portfolio Activities

### Portfolio 1 — Database Design and Modelling
**What was done:** Designed three relational tables: `guest`, `room` and `reservation`. Primary keys identify each record, and foreign keys link each reservation to one guest and one room. Unique keys cover guest email, room number, confirmation code, and (room, check-in date). A CHECK constraint makes the check-out date later than the check-in date. The normalisation document takes the sample data through 1NF, 2NF and 3NF.
**How it was tested:** Ran `Audu_Isah_P1_ConstraintTests.sql`, which contains 24 deliberately invalid inserts. All 24 were rejected by the expected constraint, and the valid sample rows (2 guests, 2 rooms, 2 reservations) were unchanged.
**Evidence:** [Design](portfolio-1-database-design/Audu_Isah_P1_Design.md) · [ER diagram](portfolio-1-database-design/Audu_Isah_P1_ERDiagram.md) · [Normalisation](portfolio-1-database-design/Audu_Isah_P1_Normalisation.md) · [Schema](portfolio-1-database-design/Audu_Isah_P1_Schema.sql) · [Sample data](portfolio-1-database-design/Audu_Isah_P1_SampleData.sql) · [Constraint tests](portfolio-1-database-design/Audu_Isah_P1_ConstraintTests.sql) · [Screenshot](portfolio-1-database-design/screenshots/Audu_Isah_P1_DatabaseResults.png)

### Portfolio 2 — Query Processing and Optimisation
**What was done:** Wrote three queries: a three-table join (reservation, guest, room), a status filter, and a count grouped by guest. For optimisation, a separate 20,000-row performance table was queried three times before and three times after adding an index (`p2_filter_idx`), using `EXPLAIN (ANALYZE, BUFFERS)`.
**How it was tested:** Compared execution plans, timings and buffer hits, and checked that both phases returned the same rows.
**Result:** The plan changed from *Seq Scan* to *Bitmap Index Scan*. Median execution time fell from **1.125 ms to 0.187 ms**, and buffer hits fell from 131 to 25. An index also adds storage and write-maintenance costs, and these timings apply only to this lookup and environment.
**Evidence:** [Queries](portfolio-2-query-optimisation/Audu_Isah_P2_Queries.sql) · [Optimisation](portfolio-2-query-optimisation/Audu_Isah_P2_Optimisation.sql) · [README with plans](portfolio-2-query-optimisation/Audu_Isah_P2_README.md) · [Query results](portfolio-2-query-optimisation/screenshots/Audu_Isah_P2_QueryResults.png) · [Index comparison](portfolio-2-query-optimisation/screenshots/Audu_Isah_P2_IndexComparison.png)

### Portfolio 3 — Transactions and Concurrency
**What was done:** Added a temporary counter (`p3_processed_count`) to reservation 5 so transaction behaviour could be tested without changing real business fields. Demonstrated COMMIT, ROLLBACK and READ COMMITTED isolation, and then a two-session lost-update problem and its fix.
**How it was tested:**
- *Commit/rollback:* an uncommitted change (counter = 1) was not visible to the other session, which still saw 0. After COMMIT, the value was 1. A second transaction failed a CHECK constraint (error 23514), and ROLLBACK restored the committed value of 1.
- *Concurrency:* without locking, both sessions read 1 and wrote 2, so one increment was lost (result 2, expected 3). With `SELECT ... FOR UPDATE`, Session B waited on a row lock until Session A committed, then read 2 and wrote **3** (correct).
**Evidence:** [Transactions](portfolio-3-transactions-concurrency/Audu_Isah_P3_Transactions.sql) · [Session A](portfolio-3-transactions-concurrency/Audu_Isah_P3_SessionA.sql) · [Session B](portfolio-3-transactions-concurrency/Audu_Isah_P3_SessionB.sql) · [Commit/rollback screenshot](portfolio-3-transactions-concurrency/screenshots/Audu_Isah_P3_CommitRollback.png) · [Concurrency screenshot](portfolio-3-transactions-concurrency/screenshots/Audu_Isah_P3_ConcurrencyResult.png)

### Portfolio 4 — NoSQL and Advanced Data Models
**What was done:** Built a MongoDB document model, the `reservation_events` collection, for `reservation_created` and `reservation_confirmed` events from the same case study. Each event document embeds snapshots of the related guest and room, so it can be read on its own. Its `details` field can vary by event type. A JSON Schema validator enforces the common fields, and a compound index covers `eventType` and `occurredAt`.
**How it was tested:** Inserted 4 sample events and ran 4 queries: by event type, by nested source key, by date range, and an aggregation count per event type. Each returned the expected documents. Validation rejected an invalid date type (code 121) and a duplicate event ID (code 11000), and the collection kept its 4 valid documents.
**Why it suits this case:** Events are append-only and can be read independently. Embedding keeps one event in one document. The trade-off is duplicated data: snapshots do not update when SQL records change. PostgreSQL remains the authoritative store.
**Evidence:** [MongoDB script](portfolio-4-nosql/Audu_Isah_P4_MongoDB.js) · [README](portfolio-4-nosql/Audu_Isah_P4_README.md) · [Screenshot](portfolio-4-nosql/screenshots/Audu_Isah_P4_DocumentsAndQueries.png)

### Portfolio 5 — Distributed and Cloud Database Exercise
**What was done:** Took the discussion option the brief allows and proposed a distributed design. It is a three-member MongoDB replica set for `reservation_events`, spread across three availability zones, with PostgreSQL given its own high-availability setup. The discussion covers:
- primary elections and majority write and read concern
- secondary lag
- idempotent retries
- sharding trade-offs: a hashed source-record key compared with a time-based key
- security, monitoring, and why replication does not replace backups

**Scope:** This is a design discussion. No live replica set, failover or sharding test was deployed.
**Evidence:** [README](portfolio-5-distributed-cloud/Audu_Isah_P5_README.md) · [Proposed architecture diagram](portfolio-5-distributed-cloud/screenshots/Audu_Isah_P5_ProposedDesign.png)

---

## 4. How to Run the Work

**Requirements:** PostgreSQL with `psql`, and MongoDB with `mongosh`.

1. Create a fresh PostgreSQL database.
2. Run `portfolio-1-database-design/Audu_Isah_P1_Schema.sql`, then `Audu_Isah_P1_SampleData.sql`.
3. Run each statement in `Audu_Isah_P1_ConstraintTests.sql` on its own, outside a transaction. Each one should fail with a constraint error.
4. Run `portfolio-2-query-optimisation/Audu_Isah_P2_Queries.sql`, then `Audu_Isah_P2_Optimisation.sql`.
5. Run `portfolio-3-transactions-concurrency/Audu_Isah_P3_Transactions.sql`. Then open two `psql` terminals on the same database and follow steps 1–9 across `Audu_Isah_P3_SessionA.sql` and `Audu_Isah_P3_SessionB.sql`.
6. Connect `mongosh` to a fresh database and run `portfolio-4-nosql/Audu_Isah_P4_MongoDB.js`.

---

## 5. Final Documentation

The 2–3 page summary with the individual technical reflection is in [Audu_Isah_FinalSummary.md](Audu_Isah_FinalSummary.md) and [Audu_Isah_FinalSummary.pdf](Audu_Isah_FinalSummary.pdf).

---

## 6. AI Use Declaration

- **AI tools used:** GitHub Copilot and Claude (Anthropic).
- **What they were used for:** Help drafting the database model, SQL and MongoDB scripts, and the written explanations, including this README.
- **How the output was reviewed and verified:** I ran the scripts myself against PostgreSQL and MongoDB, checked that the outputs matched the results reported here, and took the screenshots from those runs. I remain responsible for the accuracy of the submitted work and can explain it.

---

## 7. References

- PostgreSQL Documentation — Constraints: https://www.postgresql.org/docs/17/ddl-constraints.html
- PostgreSQL Documentation — Using EXPLAIN: https://www.postgresql.org/docs/17/using-explain.html
- PostgreSQL Documentation — Transaction Isolation: https://www.postgresql.org/docs/17/transaction-iso.html
- PostgreSQL Documentation — Explicit Locking: https://www.postgresql.org/docs/17/explicit-locking.html
- MongoDB Manual — Data Modeling: https://www.mongodb.com/docs/manual/data-modeling/
- MongoDB Manual — Replication: https://www.mongodb.com/docs/manual/replication/
- MongoDB Manual — Sharding: https://www.mongodb.com/docs/manual/sharding/
- Mermaid — Entity Relationship Diagrams: https://mermaid.js.org/syntax/entityRelationshipDiagram.html
