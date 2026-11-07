-- Ejecuta este archivo en Supabase > SQL Editor > New query.
create table if not exists public.prayer_counter (
  id integer primary key,
  total bigint not null default 0
);

insert into public.prayer_counter (id, total)
values (1, 0)
on conflict (id) do nothing;

alter table public.prayer_counter enable row level security;

create or replace function public.get_prayer_count()
returns bigint
language sql
security definer
set search_path = public
as $$
  select total from public.prayer_counter where id = 1;
$$;

create or replace function public.add_prayer()
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare new_total bigint;
begin
  update public.prayer_counter
  set total = total + 1
  where id = 1
  returning total into new_total;
  return new_total;
end;
$$;

revoke all on function public.get_prayer_count() from public;
revoke all on function public.add_prayer() from public;
grant execute on function public.get_prayer_count() to anon, authenticated;
grant execute on function public.add_prayer() to anon, authenticated;
