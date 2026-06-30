-- VM Agro - estrutura inicial para sincronizar os dados entre dispositivos.
-- Rode este SQL no editor SQL do Supabase.

create extension if not exists pgcrypto;

create table if not exists public.vm_agro_data (
  id uuid primary key default gen_random_uuid(),
  app_id text not null default 'vm-agro',
  user_key text not null,
  user_id uuid null references auth.users(id) on delete cascade,
  key text not null,
  value jsonb not null default 'null'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (app_id, user_key, key)
);

create index if not exists vm_agro_data_user_idx
  on public.vm_agro_data (app_id, user_key);

create or replace function public.vm_agro_touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists vm_agro_data_touch_updated_at on public.vm_agro_data;

create trigger vm_agro_data_touch_updated_at
before update on public.vm_agro_data
for each row
execute function public.vm_agro_touch_updated_at();

alter table public.vm_agro_data enable row level security;

-- Política aberta para fase de testes com login interno do app.
-- Quando o app migrar para Supabase Auth, substitua por políticas usando auth.uid().
drop policy if exists "vm_agro_data_select_test" on public.vm_agro_data;
drop policy if exists "vm_agro_data_insert_test" on public.vm_agro_data;
drop policy if exists "vm_agro_data_update_test" on public.vm_agro_data;
drop policy if exists "vm_agro_data_delete_test" on public.vm_agro_data;

create policy "vm_agro_data_select_test"
on public.vm_agro_data
for select
to anon, authenticated
using (true);

create policy "vm_agro_data_insert_test"
on public.vm_agro_data
for insert
to anon, authenticated
with check (true);

create policy "vm_agro_data_update_test"
on public.vm_agro_data
for update
to anon, authenticated
using (true)
with check (true);

create policy "vm_agro_data_delete_test"
on public.vm_agro_data
for delete
to anon, authenticated
using (true);
