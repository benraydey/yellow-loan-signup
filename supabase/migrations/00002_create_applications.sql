-- Migration: create applications table
-- Stores one row per submitted loan application.
-- monthly_income is stored in integer cents.
-- id_number must be unique to prevent duplicate applications per SA ID.
-- proof_document holds the filename of the uploaded file in the proof-documents bucket.

create table if not exists applications (
  id             uuid    primary key default gen_random_uuid(),
  full_name      text    not null,
  monthly_income integer not null,
  proof_document text    not null,
  phone_id       uuid    not null references phones(id),
  id_number      text    not null
);

create unique index if not exists applications_id_number_unique
  on applications(id_number);
