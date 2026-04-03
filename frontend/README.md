# Frontend — Flutter Web

This directory will contain the Flutter Web application for Yellow Loan Signup.

## Tech

- **Flutter** ≥ 3.x (web target)
- **Supabase Flutter client** (`supabase_flutter`) for database and storage access

## Project Structure (planned)

```
frontend/
├── lib/
│   ├── main.dart
│   ├── models/          # Phone, Application data models
│   ├── screens/         # Wizard steps (Bio, Income, Review)
│   ├── widgets/         # Shared UI components
│   └── services/        # Supabase client, validation helpers
├── web/
├── pubspec.yaml
└── README.md
```

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.x
- Web support enabled (`flutter config --enable-web`)
- A Supabase project (see [`../supabase/README.md`](../supabase/README.md))

## Local Setup

1. **Install dependencies**

   ```bash
   flutter pub get
   ```

2. **Configure environment**

   Create a `.env` file (or use `--dart-define` at build time) with:

   ```
   SUPABASE_URL=https://<your-project>.supabase.co
   SUPABASE_ANON_KEY=<your-anon-key>
   ```

   These values are available in your Supabase project dashboard under **Settings → API**.

3. **Run in Chrome**

   ```bash
   flutter run -d chrome
   ```

## Build for Production

```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=https://<your-project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
```

The output is in `build/web/` — deploy this directory to Firebase Hosting, Vercel, Netlify, or any static host.

## Application Flow

The app is a three-step wizard:

| Step | Content |
|------|---------|
| 1 — Bio | Full name, SA ID number (validated in real-time), derived DOB + age display |
| 2 — Income | Monthly income, proof-of-income upload (image or PDF) |
| 3 — Review | Phone selection with computed pricing, summary, submit |

On successful submission the user sees a confirmation screen with their application reference ID.

## Validation Rules

- SA ID must be exactly 13 digits, pass checksum (Luhn-style), and yield an age of **18–65 inclusive**.
- Date of birth is derived from the SA ID number automatically.
- Monthly income must be a positive number.
- Proof document is required; accepted MIME types: `image/*` and `application/pdf`.
- Duplicate SA ID numbers are caught by a database unique constraint and surfaced as a friendly error message.

## Notes

- All monetary values are handled in **integer cents** internally; displayed as ZAR with 2 decimal places.
- Pricing formulas:
  - `loanPrincipal = cashPrice × (1 − depositPercent)`
  - `loanAmount = loanPrincipal × (1 + interestRate)`
  - `dailyPrice = loanAmount ÷ 360`
