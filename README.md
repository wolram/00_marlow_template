# 00_marlow_template

Template stack-neutro integrado ao ecossistema AIOS.
Gera esqueletos Rust (api/mobile/lab/tool) com contexto de agente pré-configurado.

## Uso

### 1. Criar novo repo a partir deste template

```bash
gh repo create wolram/<projeto> --template wolram/00_marlow_template --private --clone
cd <projeto>
```

### 2. Rodar bootstrap

```bash
bash scripts/bootstrap.sh
```

O script pergunta:
- Nome do projeto
- Tipo: `api` (Rust+Axum) · `mobile` (Swift+Axum) · `lab` (Leptos) · `tool` (CLI Rust)
- Slug do contexto AIOS
- Incluir ML service (FastAPI + PyTorch + LangChain)?

### 3. Commitar esqueleto gerado

```bash
git add -A
git commit -m "chore: bootstrap <tipo> project"
git push
```

## Estrutura

```
├── CLAUDE.md          ← contexto para Claude Code
├── AGENTS.md          ← contexto para Codex/outros agentes
├── GEMINI.md          ← contexto para Gemini CLI
├── prd.md             ← Product Requirements Document
├── design.md          ← arquitetura e decisões técnicas
├── memory.md          ← decisões e contexto acumulado
├── PROJECT_STATUS.md  ← estado atual
│
├── .claude/commands/  ← slash commands do projeto
├── .github/           ← CI/CD, PR template, padrões de commit
├── docs/adr/          ← Architecture Decision Records
├── tests/             ← bats + integration test
└── scripts/
    ├── bootstrap.sh       ← gera esqueleto por tipo
    └── sync-context.sh    ← atualiza contexto AIOS
```

## Testes

```bash
# Unitários (bats)
bats tests/bootstrap.bats
bats tests/sync-context.bats

# Integração (roda bootstrap em sandbox + cargo build)
bash tests/integration.sh
```

## Sincronizar contexto AIOS

```bash
bash scripts/sync-context.sh <slug>
```

## CI/CD

- **ci.yml** — `cargo fmt` + `cargo clippy` + `cargo test` em todo PR
- **security.yml** — `cargo audit` + gitleaks toda segunda-feira

Se ML service presente: `ruff check` + `pytest` no job Python.

## Stack suportada

| Tipo | Stack |
|------|-------|
| `api` | Rust + Axum |
| `mobile` | Swift/SwiftUI + Axum |
| `lab` | Leptos (WASM) |
| `tool` | Rust + Clap |
| `+ ml` | FastAPI + PyTorch + LangChain |

## Ecossistema AIOS

```
aios-library           ← catálogo de skills e contexto
aios-context           ← contexto global + por projeto
00_marlow_template     ← este repo
```
