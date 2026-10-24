# Arquitetura — Costa Brava · Cockpit MKT

> Documento de arquitetura do projeto. Mantido vivo junto com o código: a cada mudança estrutural, atualize aqui.
> Última revisão: **2026-10-24**

---

## 1. Visão geral

O **Cockpit MKT** é a plataforma interna do time de Marketing da Costa Brava para planejar, operar e documentar iniciativas de todas as BUs (Business Travel, Live Marketing, YOU, Tech, etc.).

É um **web app single-page** servido pelo GitHub Pages, consumindo diretamente o Supabase (Postgres + Auth + Storage + Edge Functions) e a API da Anthropic (Claude) para funcionalidades de IA.

### Stack

| Camada | Tecnologia | Observação |
|---|---|---|
| Hosting | GitHub Pages (`MKT-Costa-Brava/plan`) | Branch `main`, atualização por upload direto no site |
| Frontend | HTML/CSS/JS **puro, single-file** | Um único `index.html` (~950 KB) |
| Backend | Supabase (projeto `cxlwkqsxzozfarrmqrfd`) | Postgres + Auth + RLS + Storage + Edge Functions |
| IA | Claude (Sonnet 4.5) via Edge Functions | `insights-ia`, `diario-ia` |
| Font/UI | Montserrat (Google Fonts), SVG inline, Material-ish | Sem framework |

### Entidades principais (Supabase)

- `cb_diario_entries` — edições do Diário de Bordo (newsletters internas).
- `cb_diario_categorias` — categorias (tags coloridas) usadas nas matérias.
- `cb_insights_edicoes` — edições de "Insights & Reviews" (BT e LM).
- `cb_concorrentes` — empresas a serem **evitadas** nas newsletters IA.
- `cb_user_profiles` — mapeia `auth.users` ao papel, nome, gênero, e-mail.
- Storage bucket `cb-diario-imgs` — imagens das edições.

### Edge Functions

- `insights-ia` — gera edições Insights & Reviews via Claude (Business Travel ou Live Marketing).
- `diario-ia` — revisa e divide texto do Diário via Claude.
- `claude-proxy` — proxy simples para chamadas Claude.

---

## 2. Estrutura do `index.html`

O arquivo está dividido em **blocos funcionais** (às vezes chamados internamente de "Ondas"). Cada bloco é tipicamente uma IIFE auto-contida que injeta sua própria view no DOM.

Veja **MODULES.md** para o mapa linha-a-linha.

### Convenções de CSS por módulo

| Prefixo | Módulo |
|---|---|
| `cbk-*` | Componentes genéricos (botões, cards, modais) |
| `nl-*` | Newsletter / Diário de Bordo (editor + render) |
| `cbp-*` | Painel de categorias do Diário |
| `cbir-*` | Insights & Reviews |
| `cb-foco-*` | Modal de ajuste de foco/zoom de imagem |
| `.seg`, `.gantt-*`, `.roadmap-*` | Planejamento (Gantt, RACI, Roadmap) |

### Convenções JavaScript

- **Globais via `window.*`** — helpers reusáveis entre blocos (`window.cbImgUrl`, `window.cbImgPos`, `window.cbImgZoom`, `window.sb`, `window._cbRole`, `window._cbUserName`, `window._cbUserGenero`).
- **IIFEs independentes** — alguns helpers são redeclarados em escopos distintos (ex.: `canEdit()`). **Se mudar comportamento, mudar em todos os pontos.**
- **Nenhum build step** — alterações no `index.html` são editadas diretamente e enviadas por upload no GitHub.

### Padrão de imagens com foco/zoom

Imagens em matérias do Diário podem ser:
- **string**: `"https://..."` (compat retroativa, zoom 1×, foco `50% 25%`)
- **objeto**: `{ url: "...", pos: "30% 70%", zoom: 1.5 }`

Helpers:
- `window.cbImgUrl(x)`, `window.cbImgPos(x)`, `window.cbImgZoom(x)`
- `imgTag(x, cls)` — renderiza a `<img>` com `object-position` e `transform: scale(z)` corretos.
- `cbAbrirAjusteFoco(imgData, onSave)` — modal interativo de posicionamento e zoom.

Containers `.nl-media` têm `overflow: hidden` + `aspect-ratio` fixo por layout, para que o zoom não vaze no texto adjacente.

---

## 3. Autenticação e permissões

- Login via Supabase Auth (e-mail+senha).
- Papel do usuário vem de `cb_user_profiles.role`: `master`, `adm`, `edit`, `view`.
- Flag JS: `window._cbRole`.
- Helper: `canEdit()` (declarado em cada IIFE que precisa).

### Controle de acesso atual

| Ação | Permissão |
|---|---|
| Ver cockpit | Qualquer autenticado |
| Editar edição do Diário | `master` ou `adm` |
| **Criar/editar/excluir categorias do Diário** | **Qualquer autenticado** (a partir de 2026-10-22) |
| Gerar edições IA | `master` ou `adm` |

---

## 4. Deploy

1. Editar `index.html` localmente (em `/Users/.../Downloads/`).
2. Ir em https://github.com/MKT-Costa-Brava/plan
3. "Add file" → "Upload files" → arrastar o `index.html` (confirmar tamanho ~950 KB)
4. Rolar até o fim e **clicar em "Commit changes"** (branch `main`)
5. Aguardar 1–2 min o GitHub Pages republicar
6. Hard refresh no cockpit (Cmd+Shift+R)

**Erros comuns:**
- Esquecer de clicar em "Commit changes" ao fim do upload.
- Arrastar um arquivo errado (sempre confira o tamanho antes).
- Cache do browser — hard refresh sempre.

Edge Functions são atualizadas pela UI do Supabase (ou futuramente via CLI).

Mudanças de schema/RLS: sempre registrar o SQL em `supabase/` neste repo antes de aplicar via SQL Editor.

---

## 5. Pontos de melhoria técnica (dívida)

Lista honesta de coisas a melhorar quando houver tempo:

1. **Index monolítico** — Em algum momento vale quebrar em arquivos (`modules/diario.js`, `modules/insights.js`, etc.) e usar um bundler simples.
2. **`canEdit()` duplicado** em 3 IIFEs — centralizar em `window.canEdit()`.
3. **Nenhum teste automatizado** — ao menos smoke tests manuais via Playwright caberiam.
4. **Secrets** da Anthropic e Service Role vivem apenas em Supabase Secrets — ok, mas documentar o processo de rotação.
5. **Falta migração de schema versionada** — por isso introduzimos `supabase/` neste repo.
6. **CSS misturado** por módulo — manter prefixos (`cbir-`, `cbp-`, `nl-`) consistentes.

---

## 6. Como manter esta documentação

- Toda mudança **estrutural** → atualizar seção relevante aqui.
- Toda mudança **funcional** → entrada no `CHANGELOG.md`.
- Toda mudança de **schema/RLS/Edge Function** → arquivo correspondente em `supabase/`.
- Novo módulo ou renomeação → atualizar `MODULES.md`.
