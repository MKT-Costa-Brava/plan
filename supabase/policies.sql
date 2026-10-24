-- =========================================================================
-- Policies RLS do Cockpit MKT
-- =========================================================================
-- Toda policy aplicada em produção deve ESTAR AQUI VERSIONADA.
-- Rodar via SQL Editor do Supabase (modo destrutivo).
--
-- Última revisão: 2026-10-24
-- =========================================================================


-- -------------------------------------------------------------------------
-- cb_diario_categorias — categorias/tags do Diário de Bordo
-- CRUD liberado para qualquer usuário autenticado. SELECT público.
-- Aplicado em 2026-10-22.
-- -------------------------------------------------------------------------

alter table cb_diario_categorias enable row level security;

drop policy if exists "diario_cats_select_all"  on cb_diario_categorias;
drop policy if exists "diario_cats_insert_auth" on cb_diario_categorias;
drop policy if exists "diario_cats_update_auth" on cb_diario_categorias;
drop policy if exists "diario_cats_delete_auth" on cb_diario_categorias;

create policy "diario_cats_select_all"
  on cb_diario_categorias for select
  using (true);

create policy "diario_cats_insert_auth"
  on cb_diario_categorias for insert
  to authenticated
  with check (true);

create policy "diario_cats_update_auth"
  on cb_diario_categorias for update
  to authenticated
  using (true) with check (true);

create policy "diario_cats_delete_auth"
  on cb_diario_categorias for delete
  to authenticated
  using (true);


-- -------------------------------------------------------------------------
-- Outras tabelas (cb_diario_entries, cb_insights_edicoes, cb_concorrentes,
-- cb_user_profiles) — policies aplicadas direto no banco antes da existência
-- deste arquivo. Documentar aqui conforme forem reescritas/revisadas.
-- -------------------------------------------------------------------------
