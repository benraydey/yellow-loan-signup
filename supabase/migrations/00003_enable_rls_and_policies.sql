-- Migration: enable Row-Level Security and create access policies
--
-- applications: public INSERT (with check) and public SELECT
-- phones:       public SELECT only (catalogue is read-only for app users)

alter table applications enable row level security;
alter table phones        enable row level security;

-- Allow anyone to insert a new application (INSERT uses WITH CHECK, not USING)
create policy "Allow insert for all"
  on applications
  for insert
  with check (true);

-- Allow anyone to read applications
create policy "Allow select for all"
  on applications
  for select
  using (true);

-- Allow anyone to read the phone catalogue
create policy "Allow select for all"
  on phones
  for select
  using (true);
