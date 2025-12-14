# Global Superstore – Business-led SQL Analysis (SQLite)

This repo is designed as a **recruitment-style** SQL project: short, clean, and focused on **business questions** rather than “SQL tricks”.

## What this project demonstrates
- Translating business questions into SQL queries
- Aggregations, grouping, filtering, bucketing
- Basic profitability analysis (profit, margin)
- Turning results into action-oriented insights

## Dataset
Global Superstore transactions dataset (CSV).

## How to run (SQLite)
1. Install **DB Browser for SQLite** (easy UI) or use `sqlite3`.
2. Create a new database: `superstore.db`
3. Run `00_create_table.sql`
4. Import `global_superstore_clean.csv` into the `orders` table
   - In DB Browser: *File → Import → Table from CSV*
   - Make sure the target table is `orders`
5. Run `01_analysis_queries.sql`

## Files
- `global_superstore_clean.csv` – cleaned CSV (ISO dates + standardised column names)
- `00_create_table.sql` – table + indexes
- `01_analysis_queries.sql` – the analysis queries

## Notes
- Dates are stored as ISO text (`YYYY-MM-DD`) for portability.
- This is intentionally **SQL-first** (no Python notebooks).
