# Módulos — Mapa do `index.html`

Mapa aproximado dos blocos do `index.html` (linhas podem variar após edições — este documento mostra ordem lógica, usar `Ctrl+F` para localizar).

> Última revisão: **2026-10-24**

---

## 1. Base e utilitários globais

**Papel:** CSS raiz, variáveis de cor (`--cb-navy`, `--cb-coral`, etc.), fontes, estrutura do `<app>`, topbar, filter bar.
**Linhas aproximadas:** 1 – 5000

- Variáveis CSS da identidade visual.
- `window._cbRole`, `window._cbUserName`, `window._cbUserGenero` são setados aqui pelo bootstrap de auth.
- Topbar com logo, nome do usuário e saudação "Bem-vindo(a)".

---

## 2. Menu lateral (RAIL) + navegação

**Papel:** Rail de ícones principais (Home, Plano, Dashboard, Inteligência, Conteúdos, **Comercial**), roteador de views (`setView`, `VIEWS`).
**Linhas aproximadas:** 7700 – 8400

- Array `RAIL` com os botões.
- Objeto `GROUPS` com as sub-abas de cada grupo.
- Objeto `VIEWS` mapeia chave de view → id do `<section>` correspondente.

**Nota:** há **duas declarações** do RAIL (uma na primeira versão, outra fallback como `CB_RAIL`) e uma terceira na "Onda B". **Qualquer novo item do menu precisa ser adicionado nos 3 lugares.**

---

## 3. Plano (Gantt, RACI, Equipe, Sprints, Cadência, Roadmap)

**Papel:** Gestão de projetos.
**Linhas aproximadas:** ~ 8500 – 9200 (CSS) + lógica JS espalhada.

- Gantt interativo com drag de segmentos.
- RACI com filtros por fase, categoria, BU.
- Roadmap tabular por mês.
- `canEdit()` restringe edição a `master`/`adm`.

---

## 4. Diário de Bordo

**Papel:** Newsletter editorial interna. Permite criar, editar, duplicar, excluir e visualizar edições, com matérias configuráveis em múltiplos layouts (img-esq, img-dir, img-full, grade, carrossel, texto-only).

**Linhas aproximadas:** 9200 – 10400

### Submódulos

- **Feed de edições (cards)** — `loadDiario()`. Cada card tem botões Editar / Duplicar / Excluir.
- **Leitor** — `openDiarioReader(post)` — modal fullscreen de leitura.
- **Editor (split view)** — `openDiarioEditorView(post)` — editor com canvas à direita, lateral à esquerda.
- **Render de matéria** — `renderMateriaHTML(m)` + helpers `imgTag`, `cbImgUrl`, `cbImgPos`, `cbImgZoom`.
- **Modal de ajuste de foco/zoom** — `cbAbrirAjusteFoco(imgData, onSave)`.
- **Modal de gerenciamento de categorias** — `abrirModalCategorias()` + `renderCategoriasModal()`.
- **IA de revisão/divisão** — chama Edge Function `diario-ia`.

### Tabelas
- `cb_diario_entries` (edições)
- `cb_diario_categorias` (categorias/tags)
- Storage: `cb-diario-imgs`

### Formato de imagem

```json
// legado (string)
"https://exemplo.com/foto.jpg"

// atual (objeto)
{ "url": "https://exemplo.com/foto.jpg", "pos": "40% 25%", "zoom": 1.5 }
```

---

## 5. Insights & Reviews

**Papel:** Newsletters externas tematizadas (Business Travel e Live Marketing), com geração assistida por IA. Export em HTML para e-mail marketing / RD Station.

**Linhas aproximadas:** 11800 – 14100

### Submódulos
- **Lista de edições** por vertical (BT / LM).
- **Editor** — campos editáveis por matéria (título, resumo, texto, destaque, big_numbers, categoria, imagem com foco+zoom, fonte, URL, comentário CB).
- **Export HTML** — `cbirGerarHTML(ed)` monta o HTML completo da newsletter com `cbirTheme(ed)` definindo paleta por vertical.
- **Gráficos** — `bigNumsSvg(bns, theme, tipo)` com 6 formatos (barra_vertical, barra_horizontal, donut, comparacao, progresso, waffle).
- **Geração IA** — chama Edge Function `insights-ia` (modo `gerar` ou `revisar`).

### Tabelas
- `cb_insights_edicoes`
- `cb_concorrentes` (empresas a evitar)

### Theme por vertical (`cbirTheme`)
- **BT**: navy `#201747` + azul `#4A90E2`
- **LM**: navy `#201747` + verde `#5BBA47`

---

## 6. Comercial (placeholder)

**Papel:** Aba de pipeline, propostas e oportunidades.
**Status:** Apenas item no RAIL — view ainda não implementada (planejado).

---

## 7. Perfil / Dashboard do usuário

**Papel:** Avatar, saudação ("Bem-vindo, Muriel"), status e configurações rápidas.
**Observação:** Saudação é gender-aware usando `window._cbUserGenero`.

---

## Convenções de nomes JS

| Padrão | Uso |
|---|---|
| `openXxxReader` | Abre modal de leitura |
| `openXxxEditor` | Abre editor (split view ou wizard) |
| `renderXxxHTML` | Gera HTML renderizado |
| `loadXxx` / `carregarXxx` | Consulta Supabase |
| `cbirXxx` | Insights & Reviews |
| `cbpXxx` | Painel/Categorias Diário |
| `cbkXxx` | UI genérica |

## Variáveis globais relevantes

| Nome | Significado |
|---|---|
| `window.sb` | Cliente Supabase |
| `window._cbRole` | Papel do usuário logado |
| `window._cbUserName` | Nome completo |
| `window._cbUserGenero` | masculino / feminino / nao_binario |
| `window.cbImgUrl/Pos/Zoom` | Helpers de imagem |
| `window.cbAbrirAjusteFoco` | Modal de foco/zoom |
