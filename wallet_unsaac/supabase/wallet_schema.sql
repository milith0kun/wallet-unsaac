-- Wallet UNSAAC: tablas propias (prefijo wallet_) en el esquema public.
-- No toca las tablas de otros proyectos (aula_sesiones, participaciones, ...).
-- Ejecutar una vez en Supabase Studio -> SQL Editor.

create table if not exists public.wallet_movimientos (
  id         uuid primary key default gen_random_uuid(),
  titulo     text        not null,
  categoria  text        not null,
  monto      numeric(12,2) not null check (monto > 0),
  tipo       text        not null check (tipo in ('income', 'expense')),
  fecha      date        not null,
  creado_en  timestamptz not null default now()
);

alter table public.wallet_movimientos enable row level security;

-- Version de demostracion sin login: la app usa la clave anon y solo lee.
-- (Cuando exista autenticacion, agregar user_id y filtrar con auth.uid().)
drop policy if exists wallet_movimientos_lectura on public.wallet_movimientos;
create policy wallet_movimientos_lectura
  on public.wallet_movimientos for select
  to anon, authenticated
  using (true);

grant select on public.wallet_movimientos to anon, authenticated;

insert into public.wallet_movimientos (titulo, categoria, monto, tipo, fecha) values
  ('Sueldo de prácticas',    'Trabajo',       1200.00, 'income',  '2026-11-02'),
  ('Beca de comedor',        'Beca',           450.00, 'income',  '2026-11-03'),
  ('Venta de apuntes',       'Ingreso extra',  120.00, 'income',  '2026-11-05'),
  ('Pensión universitaria',  'Educación',      350.00, 'expense', '2026-11-04'),
  ('Pasajes al campus',      'Transporte',      48.00, 'expense', '2026-11-06'),
  ('Almuerzo en el comedor', 'Alimentación',     7.50, 'expense', '2026-11-06'),
  ('Plan de internet',       'Servicios',       89.90, 'expense', '2026-11-07');
