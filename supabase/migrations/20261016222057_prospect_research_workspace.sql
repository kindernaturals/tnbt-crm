create table public.tnbt_crm_preferences (
 user_id uuid primary key references auth.users(id) on delete cascade,
 data jsonb not null default '{}'::jsonb,
 updated_at timestamptz not null default now()
);
alter table public.tnbt_crm_preferences enable row level security;
revoke all on public.tnbt_crm_preferences from public,anon,authenticated;
grant select,insert,update on public.tnbt_crm_preferences to authenticated;
create policy "Read own approved preferences" on public.tnbt_crm_preferences for select to authenticated using ((select auth.uid())=user_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
create policy "Insert own approved preferences" on public.tnbt_crm_preferences for insert to authenticated with check ((select auth.uid())=user_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
create policy "Update own approved preferences" on public.tnbt_crm_preferences for update to authenticated using ((select auth.uid())=user_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid()))) with check ((select auth.uid())=user_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
create table public.tnbt_crm_research_requests (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 data jsonb not null check(jsonb_typeof(data)='object' and length(coalesce(data->>'url','')||coalesce(data->>'text','')) between 1 and 18000),
 status text not null default 'pending' check(status in ('pending','working','complete','needs_input','failed')),
 lead_id uuid references public.tnbt_crm_leads(id) on delete set null,
 result_note text not null default '',
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index tnbt_crm_research_owner_created on public.tnbt_crm_research_requests(owner_id,created_at desc);
create index tnbt_crm_research_pending on public.tnbt_crm_research_requests(created_at) where status in ('pending','working');
alter table public.tnbt_crm_research_requests enable row level security;
revoke all on public.tnbt_crm_research_requests from public,anon,authenticated;
grant select,insert on public.tnbt_crm_research_requests to authenticated;
create policy "Read own approved requests" on public.tnbt_crm_research_requests for select to authenticated using ((select auth.uid())=owner_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
create policy "Submit own approved requests" on public.tnbt_crm_research_requests for insert to authenticated with check ((select auth.uid())=owner_id and status='pending' and lead_id is null and result_note='' and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
