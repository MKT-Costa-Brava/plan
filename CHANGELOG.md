# Changelog — Cockpit MKT

Formato: data (AAAA-MM-DD) · módulo afetado · breve descrição.
Entradas mais recentes no topo.

---

## 2026-10-24

- **Diário · Imagens** — Adicionado controle de **zoom** (1×–3×) no modal de ajuste de foco das imagens. Pré-visualizações em tempo real nas 3 proporções (hero, quadrado, retrato). Modelo de dados agora aceita `{url, pos, zoom}` por imagem — totalmente retrocompatível com strings.
- **Diário · CSS** — Containers `.nl-media` passaram a usar `aspect-ratio` fixo + `overflow:hidden` em todos os layouts (img-full, img-esq/dir, grade, carrossel). Elimina vazamento de imagem com zoom sobre o texto.
- **Docs** — Criada documentação inicial do projeto: `ARCHITECTURE.md`, `CHANGELOG.md`, `MODULES.md`, pasta `supabase/`.

## 2026-10-23

- **Diário · Listagem** — Cards de edição agora têm botões **Editar / Duplicar / Excluir** diretos no card. Duplicar cria cópia com "(cópia)" no título e sem número de edição. Excluir pede confirmação.
- **Diário · Imagens** — Novo modal **Ajustar foco** por imagem (botão ◎ no thumb). Ponto focal arrastável sobre a imagem original, com presets (Centro, Topo, Base, Esquerda, Direita, Rosto) e preview em 3 proporções. Salva `object-position` por imagem.

## 2026-10-22

- **Diário · Categorias** — Botão "Categorias" (modal de CRUD) agora aparece para **todos os usuários autenticados** (antes era restrito a `master`/`adm`).
- **Supabase · RLS** — Policies de `cb_diario_categorias` liberadas para INSERT/UPDATE/DELETE por qualquer autenticado (SELECT público). Ver `supabase/policies.sql`.

## 2026-10-21

- **Cockpit · Menu** — Nova aba **Comercial** no menu lateral (ícone linha-tendência). Mantém o subtítulo "Pipeline, propostas e oportunidades".

## 2026-10-19

- **Insights & Reviews** — Prompt da Edge Function `insights-ia` passou a exigir que todas as matérias sejam de publicações dos **últimos 7 dias**, com preferência pelas mais recentes. Data atual é injetada em runtime. Prompt pede ao modelo referenciar explicitamente a data da publicação no texto.
- **Insights & Reviews** — Adicionado campo `tipo_grafico` por matéria (barra_vertical, barra_horizontal, donut, comparacao, progresso, waffle) com variedade obrigatória. 6 formatos novos de gráfico implementados no template de export HTML.

## 2026-10-15

- **Insights & Reviews** — Identidade visual específica para **Business Travel** (paleta navy + azul médio #4A90E2, substituindo o verde). Função `cbirTheme(ed)` centraliza o esquema de cores por vertical. LM mantém o verde.
- **Insights & Reviews** — BT editorial com 3 eixos (Inteligência de mercado, Insights de gestão, Segurança e risco). Prompt do system atualizado.
- **Insights & Reviews** — Hero da edição agora é apenas a imagem de capa limpa + bloco navy abaixo (sem overlay sobre a foto).
- **Insights & Reviews** — Comentários CB redistribuídos **inline nas matérias** (2–3 matérias com `comentario_cb`), bloco final removido.
- **Insights & Reviews** — Distribuição inteligente de big numbers (0 / 1 hero / 2 cards / 3+ chart) baseada em quantidade + campo `visualizacao_dados`.

## Antes de 2026-10-15

Histórico anterior não registrado em changelog estruturado. Ver histórico de commits do GitHub para detalhes.
