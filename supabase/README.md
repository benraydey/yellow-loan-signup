# Supabase — Backend & Storage

This directory contains the database schema SQL migrations and documentation for Yellow Loan Signup.

## Contents

```
supabase/
├── migrations/
│   ├── 00001_create_phones.sql
│   ├── 00002_create_applications.sql
│   └── 00003_enable_rls_and_policies.sql
└── README.md
```

## Prerequisites

- A [Supabase](https://supabase.com) account (free tier is sufficient)
- [Supabase CLI](https://supabase.com/docs/guides/cli) (for local development)

## Hosted Setup (Supabase Dashboard)

1. Create a new Supabase project at [app.supabase.com](https://app.supabase.com).
2. Open the **SQL Editor** in the dashboard.
3. Run each migration file in `migrations/` in numbered order:
   - `00001_create_phones.sql`
   - `00002_create_applications.sql`
   - `00003_enable_rls_and_policies.sql`
4. Create two Storage buckets:
   - **`phone-images`** — stores phone product images (PNG/WebP). Set to **Public**.
   - **`proof-documents`** — stores applicant proof-of-income uploads. Set to **Public**.
5. Copy your **Project URL** and **anon public key** from **Settings → API** into the frontend environment configuration.

## Local Development (Supabase CLI)

```bash
# Start a local Supabase stack (Postgres + Studio + Storage emulator)
supabase start

# Apply all migrations
supabase db reset

# Open local Studio
# http://localhost:54323
```

Stop the local stack:

```bash
supabase stop
```

## Database Schema

All monetary values are stored as **integer cents** to avoid floating-point rounding errors.  
Percentages are stored as **numeric decimals** (e.g. `0.20` = 20%).

### `phones` table

Seeded reference data for the phone catalogue.

| Column | Type | Notes |
|--------|------|-------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `image` | `text NOT NULL` | Image filename in the `phone-images` bucket (e.g. `galaxy_a24.png`) |
| `title` | `text NOT NULL` | Handset display name (e.g. `Samsung Galaxy A24`) |
| `cash_price` | `integer NOT NULL` | Cash price in cents (e.g. `3799000` = R37 990.00) |
| `deposit_percent` | `numeric NOT NULL` | Deposit as a decimal (e.g. `0.15` = 15%) |
| `interest_rate` | `numeric NOT NULL` | Interest rate as a decimal (e.g. `0.21` = 21%) |

### `applications` table

One row per submitted loan application.

| Column | Type | Notes |
|--------|------|-------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `full_name` | `text NOT NULL` | Applicant's full name |
| `monthly_income` | `integer NOT NULL` | Monthly income in cents |
| `proof_document` | `text NOT NULL` | Filename of the uploaded file in the `proof-documents` bucket |
| `phone_id` | `uuid NOT NULL` | FK → `phones(id)` |
| `id_number` | `text NOT NULL UNIQUE` | South African ID number — **unique constraint** prevents duplicate applications |

**Relationships:**

- `applications.phone_id` → `phones.id`

## Storage

### `phone-images` bucket

Stores product images for phones in the catalogue.

- **Visibility:** Public
- **Filename convention:** `<model_slug>.png` (e.g. `galaxy_a24.png`, `iphone_13.png`)
- Images are referenced by the `image` column in the `phones` table.
- Public URL format: `https://<project>.supabase.co/storage/v1/object/public/phone-images/<filename>`

### `proof-documents` bucket

Stores proof-of-income documents uploaded by applicants.

- **Visibility:** Public
- **Filename convention:** any original filename (e.g. `payslip_jan.pdf`, `bank_statement.png`)
- The stored filename is saved in the `proof_document` column of the `applications` table.
- Accepted file types: `image/*` and `application/pdf`.

## Row-Level Security (RLS)

RLS is **enabled** on both tables. The following policies are in place:

### `applications`

| Policy | Operation | Expression |
|--------|-----------|------------|
| `Allow insert for all` | `INSERT` | `WITH CHECK (true)` |
| `Allow select for all` | `SELECT` | `USING (true)` |

### `phones`

| Policy | Operation | Expression |
|--------|-----------|------------|
| `Allow select for all` | `SELECT` | `USING (true)` |

> **Note:** `INSERT` policies in Postgres must use `WITH CHECK`, not `USING`. `SELECT`, `UPDATE`, and `DELETE` policies use `USING`.

All RLS SQL is in `migrations/00003_enable_rls_and_policies.sql`.

## Notes

- All monetary values are stored as **integer cents**.
- Percentages and rates are stored as plain **numeric** decimals.
- The `UNIQUE` index on `applications.id_number` is the authoritative guard against duplicate applications.
