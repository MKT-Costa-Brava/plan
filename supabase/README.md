# Supabase — Esquema e Policies

Esta pasta mantém **versionado** o estado do projeto Supabase (`cxlwkqsxzozfarrmqrfd`).

Toda vez que alteramos schema (tabelas, colunas), policies RLS, Edge Function ou bucket, **registramos aqui antes ou junto com a aplicação via SQL Editor**.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `schema.sql` | DDL das tabelas principais do app |
| `policies.sql` | Policies de Row Level Security |
| `storage.sql` | Buckets e policies de Storage |
| `functions/insights-ia.ts` | Edge Function Insights & Reviews |
| `functions/diario-ia.ts` | Edge Function Diário de Bordo (revisar/dividir texto) |

## Convenções

- Nome de policy: `<tabela>_<ação>_<escopo>` (ex.: `diario_cats_insert_auth`).
- Todas as tabelas de domínio têm prefixo `cb_`.
- RLS **sempre ligado**. Sem policy = tudo bloqueado (bom padrão para quem não vê, mas lembrar de criar policies antes de usar a tabela no frontend).
