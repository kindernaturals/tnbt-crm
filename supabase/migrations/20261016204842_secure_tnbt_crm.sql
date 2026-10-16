create table public.tnbt_crm_members (
 user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.tnbt_crm_members enable row level security;
revoke all on public.tnbt_crm_members from public,anon,authenticated;
grant select on public.tnbt_crm_members to authenticated;
create policy "Read own CRM approval" on public.tnbt_crm_members for select to authenticated using ((select auth.uid())=user_id);
create table public.tnbt_crm_leads (
 id uuid primary key,
 owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 data jsonb not null,
 updated_at timestamptz not null default now(),
 constraint valid_crm_lead check (
 jsonb_typeof(data)='object'
 and coalesce(jsonb_typeof(data->'company')='string' and length(trim(data->>'company'))>0,false)
 and coalesce(data->>'stage' in ('New lead','Contacted','Discovery','Proposal','Won','Lost'),false)
 and coalesce(jsonb_typeof(data->'value')='number' and (data->>'value')::numeric>=0,false)
 )
);
create index tnbt_crm_leads_owner_idx on public.tnbt_crm_leads(owner_id);
alter table public.tnbt_crm_leads enable row level security;
revoke all on public.tnbt_crm_leads from public,anon,authenticated;
grant select,insert,update,delete on public.tnbt_crm_leads to authenticated;
create policy "Approved owner reads leads" on public.tnbt_crm_leads for select to authenticated using ((select auth.uid())=owner_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
create policy "Approved owner inserts leads" on public.tnbt_crm_leads for insert to authenticated with check ((select auth.uid())=owner_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
create policy "Approved owner updates leads" on public.tnbt_crm_leads for update to authenticated using ((select auth.uid())=owner_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid()))) with check ((select auth.uid())=owner_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
create policy "Approved owner deletes leads" on public.tnbt_crm_leads for delete to authenticated using ((select auth.uid())=owner_id and exists(select 1 from public.tnbt_crm_members where user_id=(select auth.uid())));
