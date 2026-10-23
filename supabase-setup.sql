-- ============================================================================
--  Ramona Linktree · esquema de Supabase
--  Ejecutar una sola vez: Supabase → SQL Editor → New query → pegar → Run.
-- ============================================================================

-- ---------- 1. Tablas -------------------------------------------------------

create table if not exists public.site_config (
  id          text primary key default 'main',
  profile     jsonb not null default '{}'::jsonb,   -- { name, avatar_url }
  socials     jsonb not null default '[]'::jsonb,   -- [{ type, url }]
  links       jsonb not null default '[]'::jsonb,   -- [{ id,label,url,kind,thumb_url,sublabel,enabled }]
  updated_at  timestamptz not null default now()
);

create table if not exists public.events (
  id          uuid primary key default gen_random_uuid(),
  type        text not null check (type in ('view','click')),
  link_id     text,
  link_label  text,
  referrer    text,
  ua          text,
  created_at  timestamptz not null default now()
);

create index if not exists events_created_at_idx on public.events (created_at);
create index if not exists events_type_idx        on public.events (type);

-- ---------- 2. Permisos base (roles anónimo / autenticado) ----------------

grant select                 on public.site_config to anon;
grant select, insert, update on public.site_config to authenticated;
grant insert                 on public.events      to anon;
grant select, insert         on public.events      to authenticated;

-- ---------- 3. Row Level Security ----------------------------------------

alter table public.site_config enable row level security;
alter table public.events      enable row level security;

-- site_config: lectura pública, escritura sólo logueado (el admin)
drop policy if exists "config_public_read"  on public.site_config;
drop policy if exists "config_admin_write"  on public.site_config;
drop policy if exists "config_admin_update" on public.site_config;

create policy "config_public_read"  on public.site_config
  for select to anon, authenticated using (true);
create policy "config_admin_write"  on public.site_config
  for insert to authenticated with check (true);
create policy "config_admin_update" on public.site_config
  for update to authenticated using (true) with check (true);

-- events: cualquiera puede registrar (view/click), sólo el admin puede leer
drop policy if exists "events_anon_insert" on public.events;
drop policy if exists "events_admin_read"  on public.events;

create policy "events_anon_insert" on public.events
  for insert to anon, authenticated with check (type in ('view','click'));
create policy "events_admin_read"  on public.events
  for select to authenticated using (true);

-- ---------- 4. Storage: bucket público para imágenes --------------------

insert into storage.buckets (id, name, public)
values ('assets', 'assets', true)
on conflict (id) do update set public = true;

drop policy if exists "assets_public_read"   on storage.objects;
drop policy if exists "assets_admin_insert"  on storage.objects;
drop policy if exists "assets_admin_update"  on storage.objects;
drop policy if exists "assets_admin_delete"  on storage.objects;

create policy "assets_public_read"  on storage.objects
  for select to anon, authenticated using (bucket_id = 'assets');
create policy "assets_admin_insert" on storage.objects
  for insert to authenticated with check (bucket_id = 'assets');
create policy "assets_admin_update" on storage.objects
  for update to authenticated using (bucket_id = 'assets') with check (bucket_id = 'assets');
create policy "assets_admin_delete" on storage.objects
  for delete to authenticated using (bucket_id = 'assets');

-- ---------- 5. Semilla de contenido (Ramona) -----------------------------
-- kind: "link" | "pdf" | "heading" (título de sección). El Pixel de Meta se carga
-- después desde el panel (campo "Pixel ID"), no acá.

insert into public.site_config (id, profile, socials, links)
values (
  'main',
  '{"name":"ramona_uruguay","bio":"Comida del bien","avatar_url":"assets/avatar.jpg","show_pedidosya_logo":true,"meta_pixel_id":"","meta_click_event":"ClickPedidosYa"}'::jsonb,
  '[{"type":"instagram","url":"https://www.instagram.com/ramona_uruguay"},{"type":"tiktok","url":"https://www.tiktok.com/@ramona_uruguay"},{"type":"facebook","url":"https://www.facebook.com/ramonauruguay/"},{"type":"whatsapp","url":"https://api.whatsapp.com/send?phone=59898045054"}]'::jsonb,
  '[{"id":"h-centro","kind":"heading","label":"Ramona Centro","enabled":true},{"id":"py-centro-cafe","label":"PedidosYa Cafetería y Restaurante","url":"https://www.pedidosya.com.uy/restaurantes/montevideo/ramona-cafe-centro-gluten-free-menu","kind":"link","thumb_url":"","sublabel":"","enabled":true},{"id":"py-centro-pan","label":"PedidosYa Panadería","url":"https://www.pedidosya.com.uy/restaurantes/montevideo/la-panaderia-de-ramona-centro-gluten-free-9bd2fce6-7584-45ee-b9b2-7a7c35912253-menu","kind":"link","thumb_url":"","sublabel":"","enabled":true},{"id":"h-pocitos","kind":"heading","label":"Ramona Pocitos","enabled":true},{"id":"py-pocitos-cafe","label":"PedidosYa Cafetería y Restaurante","url":"https://www.pedidosya.com.uy/restaurantes/montevideo/ramona-cafe-wtc-gluten-free-837979eb-0844-4507-a73d-177263256817-menu","kind":"link","thumb_url":"","sublabel":"","enabled":true},{"id":"py-pocitos-pan","label":"PedidosYa Panadería","url":"https://www.pedidosya.com.uy/restaurantes/montevideo/la-panaderia-de-ramona-wtc-gluten-free-7315af1d-e293-46d7-814d-69380d2bdc02-menu","kind":"link","thumb_url":"","sublabel":"","enabled":true},{"id":"h-carrasco","kind":"heading","label":"Ramona Carrasco","enabled":true},{"id":"py-carrasco-pan","label":"PedidosYa Panadería","url":"https://www.pedidosya.com.uy/restaurantes/montevideo/la-panaderia-de-ramona-carrasco-glutenfree-20521c17-60a8-4b1a-a921-10e71cea9596-menu","kind":"link","thumb_url":"","sublabel":"","enabled":true}]'::jsonb
)
on conflict (id) do nothing;
