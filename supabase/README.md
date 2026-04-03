# Supabase — Backend & Storage

This directory will contain the database schema (SQL migrations), Supabase configuration, and related documentation for Yellow Loan Signup.

## Contents (planned)

```
supabase/
├── migrations/
│   ├── 00001_create_phones.sql
│   └── 00002_create_applications.sql
├── seed/
│   └── phones.sql          # Sample phone catalogue data
├── config.toml             # Supabase CLI project config
└── README.md
```

## Prerequisites

- A [Supabase](https://supabase.com) account (free tier is sufficient)
- [Supabase CLI](https://supabase.com/docs/guides/cli) (for local development)

## Hosted Setup (Supabase Dashboard)

1. Create a new Supabase project at [app.supabase.com](https://app.supabase.com).
2. Open the **SQL Editor** in the dashboard.
3. Run each migration file in `migrations/` in numbered order.
4. Run `seed/phones.sql` to populate the phone catalogue.
5. Create a Storage bucket named **`proofs`**:
   - Navigate to **Storage → New bucket**.
   - Name: `proofs`
   - Public: leave as per your preference (signed URLs recommended for production).
6. Copy your **Project URL** and **anon public key** from **Settings → API** into the frontend environment configuration.

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

### `phones` table

Seeded reference data for the phone catalogue.

| Column | Type | Notes |
|--------|------|-------|
| `id` | `uuid` | PK, `gen_random_uuid()` |
| `name` | `text NOT NULL` | Handset model name |
| `cash_price_cents` | `integer NOT NULL` | Cash price in cents |
| `deposit_percent` | `numeric(5,4) NOT NULL` | e.g. `0.2000` = 20% |
| `interest_rate` | `numeric(5,4) NOT NULL` | e.g. `0.2500` = 25% |
| `created_at` | `timestamptz` | Default `now()` |

### `applications` table

One row per submitted loan application.

| Column | Type | Notes |
|--------|------|-------|
| `id` | `uuid` | PK (supplied by client — pre-generated before file upload) |
| `full_name` | `text NOT NULL` | Applicant's full name |
| `sa_id_number` | `text NOT NULL UNIQUE` | 13-digit SA ID — **unique constraint** |
| `date_of_birth` | `date NOT NULL` | Derived from SA ID |
| `income_monthly_cents` | `integer NOT NULL CHECK (> 0)` | Monthly income in cents |
| `proof_path` | `text NOT NULL` | Storage path: `proofs/<id>/<filename>` |
| `proof_mime` | `text NOT NULL` | MIME type of uploaded file |
| `phone_id` | `uuid NOT NULL` | FK → `phones(id)` |
| `created_at` | `timestamptz` | Default `now()` |

## Storage

**Bucket:** `proofs`

**Path convention:** `proofs/<application_id>/<original_filename>`

The application UUID is generated client-side before the upload occurs, so the storage path and the database row share the same `id`. See the root [README.md](../README.md#file-upload-design) for the full upload flow.

Accepted MIME types: `image/jpeg`, `image/png`, `image/webp`, `application/pdf`.

## Row-Level Security (RLS)

RLS is **disabled** in this demo for simplicity. In a production deployment:

- Enable RLS on both tables.
- Add policies to allow anonymous inserts (or require authentication).
- Restrict reads to authenticated users / service role only.
- Apply Storage policies to limit who can read proof documents.

## Notes

- All monetary values are stored as **integer cents**.
- Percentages are stored as `numeric(5,4)` decimals.
- The `UNIQUE(sa_id_number)` constraint is the authoritative guard against duplicate applications.
