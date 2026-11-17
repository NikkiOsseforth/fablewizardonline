-- Starvale Town Hall: shared decorations and star gifts, kept even when nobody is online.
-- Run this once in the Supabase SQL editor (project mwhdvrxbyklisglpgnmw).
-- Without this table the game still works: players then only share the hall with whoever is online.
--
-- Rows:  k = 'i:<itemId>'          v = { k, x, z, a, c, by, n, t }  or  { del: 1, by, t }
--        k = 'd:<playerId>:<proj>' v = number of stars that player gave to that project
--        k = 'g:p<n>'              v = { s, by, n, t, b, w, wn, u }  or  { e: 1, by, u }   (a plot in the community garden)

create table if not exists public.starvale_town (
  k text primary key check (char_length(k) <= 64 and k ~ '^(i|d|g):[a-z0-9:-]+$'),
  v jsonb not null check (pg_column_size(v) <= 1024),
  updated_at timestamptz not null default now()
);

-- a table made with an older version of this file: let it hold the garden plots ('g:') too
alter table public.starvale_town drop constraint if exists starvale_town_k_check;
alter table public.starvale_town add constraint starvale_town_k_check check (char_length(k) <= 64 and k ~ '^(i|d|g):[a-z0-9:-]+$');

alter table public.starvale_town enable row level security;

drop policy if exists "starvale town read" on public.starvale_town;
drop policy if exists "starvale town add" on public.starvale_town;
drop policy if exists "starvale town change" on public.starvale_town;
create policy "starvale town read" on public.starvale_town for select to anon using (true);
create policy "starvale town add" on public.starvale_town for insert to anon with check (true);
create policy "starvale town change" on public.starvale_town for update to anon using (true) with check (true);
-- no delete policy: things are removed by writing { del: 1 } instead
