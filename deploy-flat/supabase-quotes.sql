-- ============================================================
-- FlowHub 報價短碼（通路專屬專案連結）
-- 在 Supabase SQL Editor 執行一次即可
-- ============================================================

create table if not exists public.quotes (
  id              uuid        primary key default gen_random_uuid(),
  short_code      text        unique not null,
  channel         text        not null default 'FlowPay',
  company_name    text,
  customer_name   text        not null,
  customer_phone  text        not null,
  amount          integer     not null,
  periods         jsonb       not null,  -- [{periods:12, monthly:5000}, ...]
  note            text,
  created_at      timestamptz default now(),
  used_at         timestamptz,
  application_id  uuid
);

create index if not exists quotes_short_code_idx on public.quotes (short_code);
create index if not exists quotes_channel_idx on public.quotes (channel);
create index if not exists quotes_created_at_idx on public.quotes (created_at desc);

-- RLS：允許匿名金鑰（anon）建立、讀取、更新（業務需求）
alter table public.quotes enable row level security;

drop policy if exists "quotes_anon_insert" on public.quotes;
drop policy if exists "quotes_anon_select" on public.quotes;
drop policy if exists "quotes_anon_update" on public.quotes;

create policy "quotes_anon_insert" on public.quotes
  for insert to anon
  with check (true);

create policy "quotes_anon_select" on public.quotes
  for select to anon
  using (true);

create policy "quotes_anon_update" on public.quotes
  for update to anon
  using (true)
  with check (true);
