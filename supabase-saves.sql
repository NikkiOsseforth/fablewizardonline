-- Starvale accounts: everyone's progress (stars, things they own, quests, fish...) kept online.
-- Run this once in the Supabase SQL editor (project mwhdvrxbyklisglpgnmw).
--
-- Accounts use Supabase Auth with a name + password. The game turns the name into a made-up
-- email address (<name>@players.starvale.game), so in the Supabase dashboard you must turn OFF
-- Authentication > Sign In / Providers > Email > "Confirm email". Otherwise new accounts can't log in.
--
-- Rows: one per account per character (slot = 'Nikki', 'Kevin', '*custom', ...) plus slot 'wizard'
-- for the look of your own wizard. data is the game's save object.

create table if not exists public.starvale_saves (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  slot text not null check (char_length(slot) between 1 and 40),
  data jsonb not null check (pg_column_size(data) <= 65536),
  updated_at timestamptz not null default now(),
  primary key (user_id, slot)
);

alter table public.starvale_saves enable row level security;

-- you can only ever see and change your own saves
drop policy if exists "starvale saves read own" on public.starvale_saves;
drop policy if exists "starvale saves add own" on public.starvale_saves;
drop policy if exists "starvale saves change own" on public.starvale_saves;
create policy "starvale saves read own" on public.starvale_saves for select to authenticated using (auth.uid() = user_id);
create policy "starvale saves add own" on public.starvale_saves for insert to authenticated with check (auth.uid() = user_id);
create policy "starvale saves change own" on public.starvale_saves for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
