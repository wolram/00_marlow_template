# Design: 00_marlow_template

**Data:** 2026-05-26
**Autor:** Marlow Sousa
**Status:** Aprovado

---

## Problema

Cada projeto novo começa do zero: sem contexto de agente, sem estrutura de docs, sem CI, sem padrão de commit. O template anterior era centrado em monorepo Node.js/Next.js — stack que o Marlow não quer como padrão.

---

## Solução

Template stack-neutro com duas camadas:

1. **Camada AIOS** — sempre presente, conecta o projeto ao ecossistema wolram
2. **Camada app** — gerada pelo `bootstrap.sh` conforme o tipo de projeto

---

## Arquitetura

### Camada 1 — AIOS (no template)

```
00_marlow_template/
├── CLAUDE.md                  ← instruções + contexto para Claude
├── AGENTS.md                  ← instruções para Codex e outros agentes
├── GEMINI.md                  ← instruções para Gemini CLI
├── prd.md                     ← o que é este produto
├── design.md                  ← arquitetura e decisões técnicas
├── memory.md                  ← decisões tomadas, contexto acumulado
├── PROJECT_STATUS.md          ← estado atual do projeto
│
├── .claude/
│   └── commands/              ← slash commands específicos do projeto
│
├── .github/
│   ├── workflows/
│   │   ├── ci.yml             ← fmt + clippy + test (adaptado por tipo)
│   │   └── security.yml       ← cargo audit + gitleaks (semanal)
│   ├── pull_request_template.md
│   └── CONTRIBUTING.md        ← conventional commits + fluxo de branch
│
├── docs/
│   ├── adr/                   ← Architecture Decision Records
│   └── superpowers/specs/     ← specs geradas no brainstorming
│
├── tests/
│   ├── bootstrap.bats         ← testes unitários do bootstrap por tipo
│   ├── sync-context.bats      ← testes do sync-context.sh
│   └── integration.sh         ← roda bootstrap em sandbox + cargo build
│
└── scripts/
    ├── bootstrap.sh           ← gera esqueleto por tipo de projeto
    └── sync-context.sh        ← atualiza contexto do aios-context
```

### Camada 2 — App (gerada pelo bootstrap.sh)

O template **não contém código de app**. O `bootstrap.sh` pergunta o tipo e gera o esqueleto correto:

| Tipo | Stack | Gera |
|------|-------|------|
| `api` | Rust + Axum | `src/`, `Cargo.toml`, `Dockerfile`, `.env.example` |
| `mobile` | Swift/SwiftUI + Axum | `ios/`, `api/src/`, `Cargo.toml` |
| `lab` | Leptos | `src/main.rs`, `Cargo.toml`, `index.html` |
| `tool` | Rust CLI (clap) | `src/main.rs`, `src/cli.rs`, `Cargo.toml` |

O bootstrap também pergunta:

```
"Incluir ML service? [s/n]"
```

Se sim, gera um serviço Python independente ao lado do app principal:

```
meu-produto/
├── api/              ← app Rust (tipo escolhido)
└── ml/               ← Python service independente
    ├── src/
    │   ├── main.py           ← FastAPI — serve modelos e pipelines
    │   ├── models/           ← PyTorch — treino e inferência
    │   ├── chains/           ← LangChain — RAG, agentes, pipelines GenAI
    │   └── data/             ← ETL, loaders, processamento
    ├── notebooks/            ← Jupyter para exploração
    ├── tests/
    │   └── test_health.py    ← pytest
    ├── requirements.txt
    ├── Dockerfile
    └── .env.example
```

Os serviços comunicam via HTTP — Rust chama o ML service para inferência e pipelines GenAI. Cada um sobe e escala de forma independente.

O bootstrap também:
- Preenche `prd.md` com nome e tipo do projeto
- Registra a escolha em `memory.md`
- Configura `CLAUDE.md` com o slug do contexto AIOS correto

---

## Integração AIOS

### CLAUDE.md gerado

```markdown
## Contexto global
/library use context-global
/library use context-priorities

## Contexto deste projeto
/library use context-<slug>

## Regras deste repo
- Backend: Rust (Axum)
- Não usar Node.js no servidor
- PRD em prd.md, decisões em memory.md
- Antes de implementar: ler design.md
```

### sync-context.sh

Puxa o contexto correto do `aios-context` e atualiza os arquivos de agente:

```bash
bash scripts/sync-context.sh agnostix
# → atualiza CLAUDE.md com /library use context-agnostix
# → atualiza AGENTS.md com link correto
```

---

## Testes

| Suite | Ferramenta | Cobre |
|-------|-----------|-------|
| `tests/bootstrap.bats` | bats | cada tipo de projeto, ML service, substituição de placeholders |
| `tests/sync-context.bats` | bats | atualização de slug, falha sem argumento |
| `tests/integration.sh` | bash | bootstrap completo em sandbox + `cargo build` |

---

## CI/CD

### ci.yml (adaptado por tipo)

- `api / mobile / tool` → `cargo fmt --check` + `cargo clippy` + `cargo test`
- `lab` → `cargo build` (sem exigir testes — é experimento)
- `ml/` presente → `ruff check` + `pytest` no serviço Python
- Roda em todo PR

### security.yml (todos os tipos)

- `cargo audit` — CVEs nas dependências
- `gitleaks` — secrets no histórico git
- Roda semanalmente

---

## Padrões de Commit e PR

### Conventional Commits

```
feat:     nova funcionalidade
fix:      correção de bug
chore:    manutenção, dependências
docs:     documentação
refactor: refatoração sem mudança de comportamento
test:     testes
ci:       mudanças no CI/CD
```

### Fluxo de branch

```
main           ← protegido, só via PR
feat/<slug>    ← nova funcionalidade
fix/<slug>     ← correção
chore/<slug>   ← manutenção
```

---

## Critérios de sucesso

- Novo projeto criado em menos de 5 minutos com `bootstrap.sh`
- `CLAUDE.md` aponta para o contexto AIOS correto sem edição manual
- CI verde em todo PR sem configuração adicional
- Contexto de agente atualizado com um comando (`sync-context.sh`)
- Suite bats passa localmente antes de qualquer PR
