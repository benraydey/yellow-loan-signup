-- Migration: create phones table
-- Stores the phone catalogue. Each row represents a handset available for loan.
-- Monetary values are stored as integer cents to avoid floating-point rounding errors.
-- Percentages are stored as numeric decimals (e.g. 0.15 = 15%).

create table if not exists phones (
  id              uuid        primary key default gen_random_uuid(),
  image           text        not null,
  title           text        not null,
  cash_price      integer     not null,
  deposit_percent numeric     not null,
  interest_rate   numeric     not null
);
