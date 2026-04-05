# Yellow Loan Signup

A mobile-first web application that allows customers to apply for a phone-loan product. Applicants select a handset, enter their personal details, upload proof of income, and receive an application reference — all in a clean three-step wizard.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Tech Stack](#tech-stack)
3. [Repository Structure](#repository-structure)
4. [Database Schema](#database-schema)
5. [File Upload Design](#file-upload-design)
6. [Quickstart](#quickstart)
   - [Frontend](#frontend-quickstart)
   - [Supabase (Backend / Storage)](#supabase-quickstart)
7. [Deployment Notes](#deployment-notes)
8. [Known Limitations / Demo Notes](#known-limitations--demo-notes)

---

## Project Overview

Yellow Loan Signup lets a customer:

- Browse a catalogue of phones (cash price, deposit percentage, interest rate, computed loan figures).
- Enter personal details — full name and a South African ID number — with real-time validation of the ID format, checksum, derived date-of-birth, and age (must be 18–65 inclusive).
- Capture their monthly income and upload a proof-of-income document (image or PDF).
- Review a summary and submit their application.
- Receive a unique application reference number on success.

Duplicate SA ID numbers are rejected both in the frontend and at the database level (unique constraint), providing a clear user-facing error message.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter Web |
| Backend / Database | Supabase (hosted PostgreSQL) |
| File Storage | Supabase Storage |
| Hosting (frontend) | Firebase Hosting / Vercel / Netlify |

**Why these choices?**

- **Flutter Web** — familiar, cross-platform, produces a single deployable web build.
- **Supabase** — managed Postgres with built-in storage, no server infrastructure to maintain, instant REST and realtime APIs, generous free tier.

---

## Repository Structure

```
yellow-loan-signup/
├── README.md              ← you are here
├── frontend/
│   └── README.md          ← Flutter setup & development guide
└── supabase/
    ├── migrations/
    │   ├── 00001_create_phones.sql
    │   ├── 00002_create_applications.sql
    │   └── 00003_enable_rls_and_policies.sql
    └── README.md          ← Supabase setup, schema, and storage guide
```

Frontend code lives in `frontend/`; database schema, migrations, and Supabase configuration live in `supabase/`.

---

## Database Schema

All monetary values are stored in **integer cents** to avoid floating-point rounding errors.
Percentages are stored as decimals (e.g. `0.20` = 20%).

### `phones`

Seeded reference data — one row per handset option.

| Column | Type | Notes |
|--------|------|-------|
| `id` | `uuid` | Primary key, default `gen_random_uuid()` |
| `image` | `text NOT NULL` | Image filename in the `phone-images` bucket (e.g. `galaxy_a24.png`) |
| `title` | `text NOT NULL` | Handset display name (e.g. `Samsung Galaxy A24`) |
| `cash_price` | `integer NOT NULL` | Cash price in cents (e.g. `3799000` = R37 990.00) |
| `deposit_percent` | `numeric NOT NULL` | Deposit as a decimal (e.g. `0.15` = 15%) |
| `interest_rate` | `numeric NOT NULL` | Interest rate as a decimal (e.g. `0.21` = 21%) |

**Derived / computed fields** (calculated in the UI and displayed to the user, not stored):

| Field | Formula |
|-------|---------|
| `loan_principal` | `cash_price × (1 − deposit_percent)` |
| `loan_amount` | `loan_principal × (1 + interest_rate)` |
| `daily_price` | `loan_amount ÷ 360` |

### `applications`

One row per submitted application.

| Column | Type | Notes |
|--------|------|-------|
| `id` | `uuid` | Primary key, default `gen_random_uuid()` |
| `full_name` | `text NOT NULL` | Applicant's full name |
| `id_number` | `text NOT NULL UNIQUE` | South African ID number — **unique constraint** prevents duplicate applications |
| `monthly_income` | `integer NOT NULL` | Monthly income in cents |
| `proof_document` | `text NOT NULL` | Filename of the uploaded file in the `proof-documents` bucket |
| `phone_id` | `uuid NOT NULL REFERENCES phones(id)` | Selected handset |

**Relationships:** `applications.phone_id` → `phones.id`

**Constraints summary:**

- `UNIQUE(id_number)` — the database is the final authority on duplicate applications.
- `NOT NULL` on all user-supplied fields.

---

## File Upload Design

The proof-of-income document is uploaded to the **`proof-documents`** Supabase Storage bucket. The stored filename is saved in `applications.proof_document`.

**Flow:**

1. **Pick** a proof-of-income file (image or PDF) in the app.
2. **Upload** the file to the `proof-documents` bucket.
3. **Store** the returned filename in the form state (`proof_document`).
4. **Submit** the application record to the `applications` table, including `proof_document`.

**Accepted file types:** `image/*` and `application/pdf` only. All other MIME types are rejected with a clear message.

**Phone images** are stored in the **`phone-images`** bucket. Each `phones` row references the image by filename in the `image` column. Both buckets are currently set to **public**.

---

## Quickstart

### Frontend Quickstart

> See [`frontend/README.md`](frontend/README.md) for full details.

**Prerequisites:** Flutter SDK ≥ 3.x with web support enabled.

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

Environment variables (Supabase credentials) are configured via a `.env` file or compile-time `--dart-define` flags — see `frontend/README.md`.

### Supabase Quickstart

> See [`supabase/README.md`](supabase/README.md) for full details.

1. Create a free project at [supabase.com](https://supabase.com).
2. Run the SQL migrations in `supabase/migrations/` via the Supabase SQL Editor (in numbered order):
   - `00001_create_phones.sql`
   - `00002_create_applications.sql`
   - `00003_enable_rls_and_policies.sql`
3. Create two Storage buckets: **`phone-images`** and **`proof-documents`** (both public).
4. Copy the project URL and anon key into your frontend environment configuration.

**Local development** with the Supabase CLI:

```bash
cd supabase
supabase start          # starts local Postgres + Studio
supabase db reset       # applies all migrations
```

---

## Deployment Notes

| Component | Recommended host |
|-----------|-----------------|
| Flutter Web build (`flutter build web`) | Firebase Hosting, Vercel, or Netlify |
| Database + Storage | Supabase (hosted, free tier) |

Steps:

1. Run `flutter build web --release` in `frontend/`.
2. Deploy the `build/web/` output to your chosen static host.
3. Ensure the Supabase project URL and anon key are injected at build time.
4. Confirm CORS settings in Supabase allow your deployed domain.

---

## Known Limitations / Demo Notes

- **Row-level security (RLS) is enabled** on both tables. Public insert and select policies are in place for `applications`; public select is in place for `phones`. No authentication is required for this demo.
- **Storage buckets are public** — `phone-images` and `proof-documents` are both accessible via public URL. In a production deployment, buckets should be set to private and files accessed via signed URLs.
- **No server-side validation** beyond database constraints. A production system would add a Supabase Edge Function (or equivalent) for authoritative SA ID and age validation.
- **No authentication** — the application is intentionally anonymous for this take-home demo.
