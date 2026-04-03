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
│   ├── README.md          ← Flutter setup & development guide
│   └── .gitkeep
└── supabase/
    ├── README.md          ← Supabase setup, schema, and storage guide
    └── .gitkeep
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
| `name` | `text` | Handset name/model |
| `cash_price_cents` | `integer` | Cash price in cents |
| `deposit_percent` | `numeric(5,4)` | e.g. `0.2000` for 20% |
| `interest_rate` | `numeric(5,4)` | e.g. `0.2500` for 25% |
| `created_at` | `timestamptz` | Default `now()` |

**Derived / computed fields** (calculated in the UI and displayed to the user, not stored):

| Field | Formula |
|-------|---------|
| `loan_principal` | `cash_price_cents × (1 − deposit_percent)` |
| `loan_amount` | `loan_principal × (1 + interest_rate)` |
| `daily_price` | `loan_amount ÷ 360` |

### `applications`

One row per submitted application.

| Column | Type | Notes |
|--------|------|-------|
| `id` | `uuid` | Primary key, default `gen_random_uuid()` — also used as the storage key for the proof document |
| `full_name` | `text NOT NULL` | Applicant's full name |
| `sa_id_number` | `text NOT NULL UNIQUE` | 13-digit South African ID — **unique constraint** prevents duplicates |
| `date_of_birth` | `date NOT NULL` | Derived from SA ID and confirmed before submission |
| `income_monthly_cents` | `integer NOT NULL CHECK (income_monthly_cents > 0)` | Monthly income in cents |
| `proof_path` | `text NOT NULL` | Supabase Storage object path, e.g. `proofs/<application_id>/<filename>` |
| `proof_mime` | `text NOT NULL` | MIME type of the uploaded file (`image/jpeg`, `image/png`, `application/pdf`, etc.) |
| `phone_id` | `uuid NOT NULL REFERENCES phones(id)` | Selected handset |
| `created_at` | `timestamptz` | Default `now()` |

**Constraints summary:**

- `UNIQUE(sa_id_number)` — the database is the final authority on duplicate applications.
- `CHECK(income_monthly_cents > 0)` — basic sanity guard.
- `NOT NULL` on all user-supplied fields.

---

## File Upload Design

The proof-of-income document is uploaded **before** the application record is created, using a pre-generated application ID as the storage key. This ensures the storage path is always traceable to an application.

**Flow:**

1. **Generate** a UUID client-side (`applicationId = uuid()`).
2. **Upload** the file to Supabase Storage at path `proofs/<applicationId>/<filename>`.
3. **Store** the returned path in the form state (`proof_path`) along with the MIME type.
4. **Submit** the application record to the `applications` table, including `id = applicationId` and `proof_path`.

**Why upload-first?**

- Avoids orphaned storage objects that aren't linked to any application row.
- Lets the user confirm the upload succeeded before they commit the form.
- The application `id` is deterministic at insert time (we supply the UUID), so the storage object and database row are always in sync.

**Accepted file types:** `image/*` and `application/pdf` only. All other MIME types are rejected with a clear message.

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
2. Run the SQL migrations in `supabase/migrations/` via the Supabase SQL Editor or the Supabase CLI.
3. Create a Storage bucket named `proofs` (public or with appropriate policies).
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

- **Row-level security (RLS) is disabled** for demo simplicity. In production, RLS policies and proper authentication would be required to restrict read/write access.
- **No server-side validation** beyond database constraints. A production system would add a Supabase Edge Function (or equivalent) for authoritative SA ID and age validation.
- **No authentication** — the application is intentionally anonymous for this take-home demo.
