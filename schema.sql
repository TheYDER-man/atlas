-- Atlas schema for Supabase
-- Run in Supabase SQL Editor.

-- Maps: one row per map, doc holds the whole map as JSON.
create table if not exists public.maps (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default 'Untitled map',
  doc jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.maps enable row level security;

drop policy if exists "own maps select" on public.maps;
create policy "own maps select" on public.maps for select using (auth.uid() = user_id);
drop policy if exists "own maps insert" on public.maps;
create policy "own maps insert" on public.maps for insert with check (auth.uid() = user_id);
drop policy if exists "own maps update" on public.maps;
create policy "own maps update" on public.maps for update using (auth.uid() = user_id);
drop policy if exists "own maps delete" on public.maps;
create policy "own maps delete" on public.maps for delete using (auth.uid() = user_id);

-- Shares: read-only snapshots, readable by anyone who has the unguessable id.
create table if not exists public.shares (
  id uuid primary key default gen_random_uuid(),
  doc jsonb not null,
  created_at timestamptz not null default now()
);
alter table public.shares enable row level security;

drop policy if exists "shares public read" on public.shares;
create policy "shares public read" on public.shares for select using (true);
drop policy if exists "shares public insert" on public.shares;
create policy "shares public insert" on public.shares for insert with check (true);
drop policy if exists "shares public update" on public.shares;
create policy "shares public update" on public.shares for update using (true);
