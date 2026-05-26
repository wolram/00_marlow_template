# 00_marlow_template Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir a estrutura completa do `00_marlow_template` — template stack-neutro integrado ao AIOS, com bootstrap que gera esqueletos Rust por tipo e suite de testes bats + integração.

**Architecture:** Camada AIOS (arquivos de contexto para agentes, sempre presentes) + scripts bash (bootstrap.sh, sync-context.sh) + suite de testes (bats unitário + integration.sh) + CI/CD GitHub Actions.

**Tech Stack:** Bash, bats, YAML (GitHub Actions), Rust targets (Axum/Leptos/Clap), Python targets (FastAPI/PyTorch/LangChain), Swift targets (SwiftUI).

---

## Mapa de arquivos

```
Criados neste plano:
CLAUDE.md
AGENTS.md
GEMINI.md
prd.md
design.md
memory.md
PROJECT_STATUS.md
.claude/commands/.gitkeep
docs/adr/.gitkeep
.github/CONTRIBUTING.md
.github/pull_request_template.md
.github/workflows/ci.yml
.github/workflows/security.yml
scripts/sync-context.sh
scripts/bootstrap.sh
tests/sync-context.bats
tests/bootstrap.bats
tests/integration.sh

Atualizados:
README.md
```

---

## Task 1: AIOS Layer — Arquivos de Contexto

**Files:**
- Create: `CLAUDE.md`
- Create: `AGENTS.md`
- Create: `GEMINI.md`
- Create: `prd.md`
- Create: `design.md`
- Create: `memory.md`
- Create: `PROJECT_STATUS.md`
- Create: `.claude/commands/.gitkeep`
- Create: `docs/adr/.gitkeep`

- [ ] **Step 1: Criar CLAUDE.md**

```markdown
# CLAUDE.md

> Lido automaticamente pelo Claude Code ao iniciar uma sessão neste projeto.

## Contexto Global (AIOS)

/library use context-global
/library use context-priorities

## Contexto deste Projeto

/library use context-{{PROJECT_SLUG}}

## Stack

**Tipo:** {{PROJECT_TYPE}}

## Regras

- Não usar Node.js no servidor
- PRD em `prd.md`, decisões em `memory.md`, arquitetura em `design.md`
- Ler `design.md` antes de implementar qualquer feature
- Commits em Conventional Commits — ver `.github/CONTRIBUTING.md`

## Sincronizar Contexto

```bash
bash scripts/sync-context.sh <slug>
```

## Estado Atual

Ver `PROJECT_STATUS.md`
```

- [ ] **Step 2: Criar AGENTS.md**

```markdown
# AGENTS.md

> Instruções para Codex, Gemini CLI e outros agentes sem acesso ao /library.

## Contexto do Projeto

**Nome:** {{PROJECT_NAME}}
**Tipo:** {{PROJECT_TYPE}}
**Stack:** Rust backend (Axum)

## Regras

1. Não usar Node.js no servidor
2. Seguir Conventional Commits — ver `.github/CONTRIBUTING.md`
3. Ler `design.md` antes de implementar qualquer feature
4. Registrar decisões em `memory.md`
5. Estado atual em `PROJECT_STATUS.md`

## Sobre o Marlow

Engenheiro/founder que opera múltiplos produtos. Tom direto, técnico, sem frescura.
Stack preferida: Rust (backend), Swift (iOS nativo), Python (ML/dados).
Não quer: monorepos Node.js, jargão corporativo, emojis em excesso.

## Contexto AIOS

Este projeto faz parte do ecossistema AIOS (wolram/aios-library).
Contexto completo: https://github.com/wolram/aios-context/blob/main/projects/{{PROJECT_SLUG}}.md
```

- [ ] **Step 3: Criar GEMINI.md**

```markdown
# GEMINI.md

> Instruções para Gemini CLI.

## Contexto

**Projeto:** {{PROJECT_NAME}}
**Tipo:** {{PROJECT_TYPE}}

## Regras

- Backend em Rust (Axum) — não usar Node.js no servidor
- Conventional Commits — ver `.github/CONTRIBUTING.md`
- Registrar decisões em `memory.md`
- Arquitetura em `design.md`

## Stack

Ver `design.md` para arquitetura detalhada deste projeto.
```

- [ ] **Step 4: Criar prd.md**

```markdown
# PRD — {{PROJECT_NAME}}

**Tipo:** {{PROJECT_TYPE}}
**Data:** {{DATE}}
**Status:** Em construção

---

## O que é

[Descreva o produto em uma frase]

## Problema que resolve

[Qual dor do usuário este produto ataca]

## ICP (Cliente Ideal)

[Quem usa, demografía, contexto de uso]

## Funcionalidades principais

- [ ] Feature 1
- [ ] Feature 2

## Fora do escopo

[O que este produto NÃO faz]

## Métricas de sucesso

- [ ] Métrica 1 — como medir
- [ ] Métrica 2 — como medir
```

- [ ] **Step 5: Criar design.md**

```markdown
# Design — {{PROJECT_NAME}}

**Tipo:** {{PROJECT_TYPE}}

---

## Arquitetura

[Diagrama ou descrição da arquitetura]

## Stack

| Camada | Tecnologia | Motivo |
|--------|-----------|--------|
| Backend | Rust (Axum) | Performance, segurança de tipos |

## Decisões técnicas

[ADRs ou decisões importantes — ver também `docs/adr/`]

## Fluxo de dados

[Como os dados fluem no sistema]

## Integrações externas

[APIs, serviços, dependências externas]
```

- [ ] **Step 6: Criar memory.md**

```markdown
# Memory — {{PROJECT_NAME}}

> Decisões tomadas, contexto acumulado, aprendizados.
> Atualizar sempre que uma decisão importante for tomada.

---

## Configuração inicial

- **Tipo:** {{PROJECT_TYPE}}
- **AIOS slug:** {{PROJECT_SLUG}}
- **Criado em:** {{DATE}}

## Decisões

[Registre aqui decisões importantes e o motivo]

## O que não fazer novamente

[Aprendizados negativos — erros evitáveis]
```

- [ ] **Step 7: Criar PROJECT_STATUS.md**

```markdown
# Project Status — {{PROJECT_NAME}}

**Status:** 🟡 Em construção
**Tipo:** {{PROJECT_TYPE}}
**Atualizado:** {{DATE}}

---

## O que está funcionando

- [ ] Nada ainda

## Próximo passo

- [ ] Definir MVP mínimo

## Bloqueios

Nenhum

## Links

- Repo: [GitHub]()
- PRD: [prd.md](prd.md)
- Design: [design.md](design.md)
```

- [ ] **Step 8: Criar diretórios de suporte**

```bash
mkdir -p .claude/commands && touch .claude/commands/.gitkeep
mkdir -p docs/adr && touch docs/adr/.gitkeep
```

- [ ] **Step 9: Commit**

```bash
git add CLAUDE.md AGENTS.md GEMINI.md prd.md design.md memory.md PROJECT_STATUS.md .claude/ docs/adr/
git commit -m "feat: add AIOS context layer template files"
```

---

## Task 2: GitHub Standards

**Files:**
- Create: `.github/CONTRIBUTING.md`
- Create: `.github/pull_request_template.md`

- [ ] **Step 1: Criar .github/CONTRIBUTING.md**

```bash
mkdir -p .github
```

```markdown
# Contributing

## Conventional Commits

Formato: `<tipo>(<escopo opcional>): <descrição>`

| Tipo | Quando usar |
|------|------------|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `chore` | Manutenção, dependências, configuração |
| `docs` | Documentação |
| `refactor` | Refatoração sem mudança de comportamento |
| `test` | Testes |
| `ci` | Mudanças no CI/CD |

**Exemplos:**
```
feat: add user authentication endpoint
fix: correct token expiry calculation
chore: update axum to 0.7.5
docs: add API reference for /health route
```

## Fluxo de Branch

```
main            ← protegido, merge só via PR aprovado
feat/<slug>     ← nova funcionalidade
fix/<slug>      ← correção de bug
chore/<slug>    ← manutenção, dependências
```

## Tamanho de PR

Prefira PRs pequenos e focados. Um PR = uma mudança lógica.
CI deve estar verde antes de solicitar revisão.
```

- [ ] **Step 2: Criar .github/pull_request_template.md**

```markdown
## O que muda

<!-- Descreva a mudança em 1-3 frases -->

## Motivação

<!-- Por que esta mudança é necessária? -->

## Como testar

<!-- Passos para verificar que a mudança funciona -->

1. 
2. 

## Checklist

- [ ] `cargo fmt` sem erros
- [ ] `cargo clippy` sem warnings
- [ ] `cargo test` passou
- [ ] Suite bats passou: `bats tests/`
- [ ] Documentação atualizada (se aplicável)
- [ ] `memory.md` atualizado com decisões importantes (se aplicável)
```

- [ ] **Step 3: Commit**

```bash
git add .github/CONTRIBUTING.md .github/pull_request_template.md
git commit -m "feat: add conventional commits standard and PR template"
```

---

## Task 3: CI/CD Workflows

**Files:**
- Create: `.github/workflows/ci.yml`
- Create: `.github/workflows/security.yml`

- [ ] **Step 1: Criar .github/workflows/ci.yml**

```bash
mkdir -p .github/workflows
```

```yaml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  rust:
    name: Rust
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt, clippy

      - uses: Swatinem/rust-cache@v2

      - name: Format
        run: cargo fmt --check

      - name: Lint
        run: cargo clippy -- -D warnings

      - name: Test
        run: cargo test

  python:
    name: Python (ML)
    runs-on: ubuntu-latest
    if: ${{ hashFiles('ml/requirements.txt') != '' }}
    defaults:
      run:
        working-directory: ml
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Lint
        run: ruff check src/

      - name: Test
        run: pytest
```

- [ ] **Step 2: Criar .github/workflows/security.yml**

```yaml
name: Security

on:
  schedule:
    - cron: '0 9 * * 1'
  workflow_dispatch:

jobs:
  audit:
    name: Cargo Audit
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - name: Install cargo-audit
        run: cargo install cargo-audit --locked
      - name: Audit
        run: cargo audit

  secrets:
    name: Gitleaks
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/
git commit -m "ci: add Rust CI and weekly security workflow"
```

---

## Task 4: sync-context.sh

**Files:**
- Create: `scripts/sync-context.sh`

- [ ] **Step 1: Criar scripts/sync-context.sh**

```bash
mkdir -p scripts
```

```bash
#!/usr/bin/env bash
# Sincroniza o contexto AIOS para este projeto.
# Uso: bash scripts/sync-context.sh <slug>
set -euo pipefail

SLUG="${1:-}"

if [[ -z "$SLUG" ]]; then
  echo "Uso: bash scripts/sync-context.sh <slug>"
  echo "Exemplo: bash scripts/sync-context.sh agnostix"
  exit 1
fi

replace_in_file() {
  local file="$1" from="$2" to="$3"
  if [[ ! -f "$file" ]]; then return; fi
  local tmp
  tmp=$(mktemp)
  sed "s|${from}|${to}|g" "$file" > "$tmp" && mv "$tmp" "$file"
}

replace_in_file CLAUDE.md \
  "/library use context-[a-z0-9_-]*" \
  "/library use context-${SLUG}"

replace_in_file AGENTS.md \
  "/projects/[a-z0-9_-]*\.md" \
  "/projects/${SLUG}.md"

echo "Contexto sincronizado: ${SLUG}"
echo "Para carregar no Claude: /library use context-${SLUG}"
```

- [ ] **Step 2: Tornar executável**

```bash
chmod +x scripts/sync-context.sh
```

- [ ] **Step 3: Validar com shellcheck**

```bash
shellcheck scripts/sync-context.sh
```

Resultado esperado: sem erros.

- [ ] **Step 4: Commit**

```bash
git add scripts/sync-context.sh
git commit -m "feat: add sync-context.sh for AIOS context updates"
```

---

## Task 5: bootstrap.sh

**Files:**
- Create: `scripts/bootstrap.sh`

- [ ] **Step 1: Criar scripts/bootstrap.sh**

```bash
#!/usr/bin/env bash
# Gera o esqueleto do projeto com base no tipo escolhido.
# Uso: bash scripts/bootstrap.sh
set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

TODAY=$(date +%Y-%m-%d)

echo -e "${BOLD}${CYAN}Wolram Bootstrap${RESET}"
echo ""

read -rp "Nome do projeto: " PROJECT_NAME
PROJECT_SLUG=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo ""
echo "Tipo de projeto:"
echo "  1) api    — Rust + Axum"
echo "  2) mobile — Swift/SwiftUI + Axum"
echo "  3) lab    — Leptos (experimental)"
echo "  4) tool   — Rust CLI (clap)"
read -rp "Escolha [1-4]: " TYPE_CHOICE

case $TYPE_CHOICE in
  1) PROJECT_TYPE="api" ;;
  2) PROJECT_TYPE="mobile" ;;
  3) PROJECT_TYPE="lab" ;;
  4) PROJECT_TYPE="tool" ;;
  *) echo "Opção inválida. Use 1, 2, 3 ou 4."; exit 1 ;;
esac

echo ""
read -rp "Slug do contexto AIOS (ex: agnostix, cltxpj): " AIOS_SLUG

echo ""
read -rp "Incluir ML service (FastAPI + PyTorch + LangChain)? [s/n]: " ML_ANSWER

# ── Esqueletos ────────────────────────────────────────────────────

generate_api() {
  mkdir -p src/routes src/models

  cat > Cargo.toml <<EOF
[package]
name = "${PROJECT_SLUG}"
version = "0.1.0"
edition = "2021"

[[bin]]
name = "${PROJECT_SLUG}"
path = "src/main.rs"

[dependencies]
axum = "0.7"
tokio = { version = "1", features = ["full"] }
serde = { version = "1", features = ["derive"] }
serde_json = "1"
dotenvy = "0.15"
EOF

  cat > src/main.rs <<'RUST'
use axum::{routing::get, Router};

mod models;
mod routes;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    let app = Router::new().route("/health", get(|| async { "ok" }));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("Listening on :3000");
    axum::serve(listener, app).await.unwrap();
}
RUST

  printf '// routes module\n' > src/routes/mod.rs
  printf '// models module\n' > src/models/mod.rs

  cat > Dockerfile <<'DOCKER'
FROM rust:1.77-slim AS builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/* /usr/local/bin/
ENTRYPOINT ["/bin/sh", "-c", "exec $(ls /usr/local/bin/ | head -1)"]
DOCKER

  cat > .env.example <<'ENV'
DATABASE_URL=postgres://user:password@localhost:5432/dbname
PORT=3000
ENV
}

generate_mobile() {
  mkdir -p "ios/Sources/${PROJECT_SLUG}" api/src

  cat > ios/Package.swift <<EOF
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "${PROJECT_SLUG}",
    platforms: [.iOS(.v17)],
    targets: [
        .target(name: "${PROJECT_SLUG}", path: "Sources/${PROJECT_SLUG}")
    ]
)
EOF

  cat > "ios/Sources/${PROJECT_SLUG}/App.swift" <<'SWIFT'
import SwiftUI

@main
struct App: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
SWIFT

  cat > "ios/Sources/${PROJECT_SLUG}/ContentView.swift" <<'SWIFT'
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}
SWIFT

  cat > api/Cargo.toml <<EOF
[package]
name = "${PROJECT_SLUG}-api"
version = "0.1.0"
edition = "2021"

[dependencies]
axum = "0.7"
tokio = { version = "1", features = ["full"] }
serde = { version = "1", features = ["derive"] }
serde_json = "1"
dotenvy = "0.15"
EOF

  cat > api/src/main.rs <<'RUST'
use axum::{routing::get, Router};

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    let app = Router::new().route("/health", get(|| async { "ok" }));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("API listening on :3000");
    axum::serve(listener, app).await.unwrap();
}
RUST

  cat > .env.example <<'ENV'
API_URL=http://localhost:3000
PORT=3000
ENV
}

generate_lab() {
  mkdir -p src

  cat > Cargo.toml <<EOF
[package]
name = "${PROJECT_SLUG}"
version = "0.1.0"
edition = "2021"

[dependencies]
leptos = { version = "0.6", features = ["csr"] }
console_error_panic_hook = "0.1"
EOF

  cat > src/main.rs <<'RUST'
use leptos::*;

#[component]
fn App() -> impl IntoView {
    let (count, set_count) = create_signal(0);
    view! {
        <h1>"Lab"</h1>
        <button on:click=move |_| set_count.update(|n| *n += 1)>
            "Count: " {count}
        </button>
    }
}

fn main() {
    console_error_panic_hook::set_once();
    mount_to_body(App)
}
RUST

  cat > index.html <<'HTML'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Lab</title>
</head>
<body></body>
</html>
HTML
}

generate_tool() {
  mkdir -p src

  cat > Cargo.toml <<EOF
[package]
name = "${PROJECT_SLUG}"
version = "0.1.0"
edition = "2021"

[[bin]]
name = "${PROJECT_SLUG}"
path = "src/main.rs"

[dependencies]
clap = { version = "4", features = ["derive"] }

[dev-dependencies]
assert_cmd = "2"
predicates = "3"
EOF

  cat > src/main.rs <<'RUST'
mod cli;
use clap::Parser;

fn main() {
    let args = cli::Cli::parse();
    args.run();
}
RUST

  cat > src/cli.rs <<'RUST'
use clap::Parser;

#[derive(Parser, Debug)]
#[command(author, version, about)]
pub struct Cli {
    #[arg(short, long)]
    pub verbose: bool,
}

impl Cli {
    pub fn run(&self) {
        if self.verbose {
            println!("Verbose mode");
        }
        println!("Tool running.");
    }
}
RUST
}

generate_ml() {
  mkdir -p ml/src/models ml/src/chains ml/src/data ml/notebooks ml/tests

  cat > ml/src/main.py <<'PY'
from fastapi import FastAPI

app = FastAPI(title="ML Service")

@app.get("/health")
def health() -> dict:
    return {"status": "ok"}
PY

  touch ml/src/__init__.py ml/src/models/__init__.py
  touch ml/src/chains/__init__.py ml/src/data/__init__.py
  touch ml/tests/__init__.py

  cat > ml/tests/test_health.py <<'PY'
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
PY

  cat > ml/requirements.txt <<'TXT'
fastapi>=0.110.0
uvicorn[standard]>=0.29.0
torch>=2.2.0
langchain>=0.1.0
langchain-openai>=0.1.0
python-dotenv>=1.0.0
pytest>=8.0.0
ruff>=0.4.0
httpx>=0.27.0
TXT

  cat > ml/Dockerfile <<'DOCKER'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ ./src/
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
DOCKER

  cat > ml/.env.example <<'ENV'
OPENAI_API_KEY=sk-...
MODEL_NAME=gpt-4o
PORT=8000
ENV

  touch ml/notebooks/.gitkeep
}

# ── Executar esqueleto ────────────────────────────────────────────

case $PROJECT_TYPE in
  api)    generate_api ;;
  mobile) generate_mobile ;;
  lab)    generate_lab ;;
  tool)   generate_tool ;;
esac

[[ "$ML_ANSWER" =~ ^[Ss]$ ]] && generate_ml

# ── Substituir placeholders ───────────────────────────────────────

replace_in_file() {
  local file="$1" from="$2" to="$3"
  [[ -f "$file" ]] || return
  local tmp
  tmp=$(mktemp)
  sed "s|${from}|${to}|g" "$file" > "$tmp" && mv "$tmp" "$file"
}

replace_in_file CLAUDE.md         "{{PROJECT_SLUG}}" "$AIOS_SLUG"
replace_in_file CLAUDE.md         "{{PROJECT_TYPE}}" "$PROJECT_TYPE"
replace_in_file AGENTS.md         "{{PROJECT_NAME}}" "$PROJECT_NAME"
replace_in_file AGENTS.md         "{{PROJECT_TYPE}}" "$PROJECT_TYPE"
replace_in_file AGENTS.md         "{{PROJECT_SLUG}}" "$AIOS_SLUG"
replace_in_file GEMINI.md         "{{PROJECT_NAME}}" "$PROJECT_NAME"
replace_in_file GEMINI.md         "{{PROJECT_TYPE}}" "$PROJECT_TYPE"
replace_in_file prd.md            "{{PROJECT_NAME}}" "$PROJECT_NAME"
replace_in_file prd.md            "{{PROJECT_TYPE}}" "$PROJECT_TYPE"
replace_in_file prd.md            "{{DATE}}"         "$TODAY"
replace_in_file design.md         "{{PROJECT_NAME}}" "$PROJECT_NAME"
replace_in_file design.md         "{{PROJECT_TYPE}}" "$PROJECT_TYPE"
replace_in_file memory.md         "{{PROJECT_NAME}}" "$PROJECT_NAME"
replace_in_file memory.md         "{{PROJECT_TYPE}}" "$PROJECT_TYPE"
replace_in_file memory.md         "{{PROJECT_SLUG}}" "$AIOS_SLUG"
replace_in_file memory.md         "{{DATE}}"         "$TODAY"
replace_in_file PROJECT_STATUS.md "{{PROJECT_NAME}}" "$PROJECT_NAME"
replace_in_file PROJECT_STATUS.md "{{PROJECT_TYPE}}" "$PROJECT_TYPE"
replace_in_file PROJECT_STATUS.md "{{DATE}}"         "$TODAY"

# ── Registrar no memory.md ────────────────────────────────────────

ML_STATUS="não"
[[ "$ML_ANSWER" =~ ^[Ss]$ ]] && ML_STATUS="sim (FastAPI + PyTorch + LangChain)"

cat >> memory.md <<EOF

## Bootstrap — ${TODAY}

- Tipo: ${PROJECT_TYPE}
- AIOS slug: ${AIOS_SLUG}
- ML service: ${ML_STATUS}
EOF

# ── Resultado ─────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}${BOLD}✓ ${PROJECT_NAME} pronto${RESET}"
echo ""
echo "Próximos passos:"
echo "  git add -A"
echo "  git commit -m 'chore: bootstrap ${PROJECT_TYPE} project'"
echo ""
if [[ "$ML_ANSWER" =~ ^[Ss]$ ]]; then
  echo "Para rodar:"
  echo "  Rust → cargo run"
  echo "  ML   → cd ml && uvicorn src.main:app --reload"
else
  echo "Para rodar: cargo run"
fi
```

- [ ] **Step 2: Tornar executável**

```bash
chmod +x scripts/bootstrap.sh
```

- [ ] **Step 3: Validar com shellcheck**

```bash
shellcheck scripts/bootstrap.sh
```

Resultado esperado: sem erros.

- [ ] **Step 4: Commit**

```bash
git add scripts/bootstrap.sh
git commit -m "feat: add bootstrap.sh for project skeleton generation"
```

---

## Task 6: Test Suite (bats + integração)

**Files:**
- Create: `tests/bootstrap.bats`
- Create: `tests/sync-context.bats`
- Create: `tests/integration.sh`

- [ ] **Step 1: Verificar se bats está instalado**

```bash
bats --version 2>/dev/null || brew install bats-core
```

Resultado esperado: `Bats x.y.z`

- [ ] **Step 2: Criar tests/bootstrap.bats**

```bash
mkdir -p tests
```

```bash
#!/usr/bin/env bats
# Testes unitários do bootstrap.sh — roda em sandbox isolado por teste.

TEMPLATE_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

setup() {
  TEST_DIR=$(mktemp -d)
  cp -r "$TEMPLATE_DIR"/scripts "$TEST_DIR/"
  # Copiar arquivos de contexto que o bootstrap modifica
  for f in CLAUDE.md AGENTS.md GEMINI.md prd.md design.md memory.md PROJECT_STATUS.md; do
    [[ -f "$TEMPLATE_DIR/$f" ]] && cp "$TEMPLATE_DIR/$f" "$TEST_DIR/"
  done
  cd "$TEST_DIR"
}

teardown() {
  rm -rf "$TEST_DIR"
}

# ── Validação de input ────────────────────────────────────────────

@test "tipo inválido retorna erro e exit 1" {
  run bash -c "printf 'meu-projeto\n5\nslug\nn\n' | bash scripts/bootstrap.sh"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Opção inválida"* ]]
}

# ── Tipo api ─────────────────────────────────────────────────────

@test "api cria Cargo.toml" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "Cargo.toml" ]
}

@test "api Cargo.toml inclui axum" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "axum" Cargo.toml
}

@test "api cria src/main.rs" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "src/main.rs" ]
}

@test "api cria src/routes/mod.rs" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "src/routes/mod.rs" ]
}

@test "api cria src/models/mod.rs" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "src/models/mod.rs" ]
}

@test "api cria Dockerfile" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "Dockerfile" ]
}

@test "api cria .env.example" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f ".env.example" ]
}

# ── Tipo tool ─────────────────────────────────────────────────────

@test "tool cria src/cli.rs" {
  printf 'meu-tool\n4\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "src/cli.rs" ]
}

@test "tool Cargo.toml inclui clap" {
  printf 'meu-tool\n4\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "clap" Cargo.toml
}

@test "tool Cargo.toml inclui assert_cmd em dev-dependencies" {
  printf 'meu-tool\n4\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "assert_cmd" Cargo.toml
}

# ── Tipo lab ──────────────────────────────────────────────────────

@test "lab cria index.html" {
  printf 'meu-lab\n3\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "index.html" ]
}

@test "lab Cargo.toml inclui leptos" {
  printf 'meu-lab\n3\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "leptos" Cargo.toml
}

# ── Tipo mobile ───────────────────────────────────────────────────

@test "mobile cria ios/Package.swift" {
  printf 'meu-app\n2\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "ios/Package.swift" ]
}

@test "mobile cria api/Cargo.toml" {
  printf 'meu-app\n2\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ -f "api/Cargo.toml" ]
}

@test "mobile cria ContentView.swift" {
  printf 'meu-app\n2\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  find ios/ -name "ContentView.swift" | grep -q "ContentView.swift"
}

# ── ML service ────────────────────────────────────────────────────

@test "ml service cria ml/requirements.txt quando resposta é s" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  [ -f "ml/requirements.txt" ]
}

@test "ml service cria ml/src/main.py quando resposta é s" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  [ -f "ml/src/main.py" ]
}

@test "ml service cria ml/tests/test_health.py" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  [ -f "ml/tests/test_health.py" ]
}

@test "ml service cria ml/Dockerfile" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  [ -f "ml/Dockerfile" ]
}

@test "ml service NÃO criado quando resposta é n" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  [ ! -d "ml" ]
}

@test "ml requirements.txt inclui fastapi" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  grep -q "fastapi" ml/requirements.txt
}

@test "ml requirements.txt inclui torch" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  grep -q "torch" ml/requirements.txt
}

@test "ml requirements.txt inclui langchain" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  grep -q "langchain" ml/requirements.txt
}

# ── Substituição de placeholders ──────────────────────────────────

@test "CLAUDE.md não contém {{PROJECT_SLUG}} após bootstrap" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  ! grep -q "{{PROJECT_SLUG}}" CLAUDE.md
}

@test "CLAUDE.md contém o slug correto após bootstrap" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "test-slug" CLAUDE.md
}

@test "CLAUDE.md não contém {{PROJECT_TYPE}} após bootstrap" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  ! grep -q "{{PROJECT_TYPE}}" CLAUDE.md
}

@test "prd.md não contém {{PROJECT_NAME}} após bootstrap" {
  printf 'meu-projeto\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  ! grep -q "{{PROJECT_NAME}}" prd.md
}

@test "prd.md contém o nome do projeto" {
  printf 'meu-projeto\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "meu-projeto" prd.md
}

@test "memory.md registra o bootstrap com tipo correto" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "Bootstrap" memory.md
  grep -q "api" memory.md
}

@test "memory.md registra ml service quando presente" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  grep -q "LangChain" memory.md
}
```

- [ ] **Step 3: Rodar bats para verificar que os testes falham (arquivos ainda não existem nos sandboxes corretamente)**

```bash
bats tests/bootstrap.bats 2>&1 | head -20
```

Resultado esperado: testes passam se scripts/bootstrap.sh e arquivos de contexto existem. Se algum falhar, investigar antes de continuar.

- [ ] **Step 4: Criar tests/sync-context.bats**

```bash
#!/usr/bin/env bats
# Testes unitários do sync-context.sh

TEMPLATE_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

setup() {
  TEST_DIR=$(mktemp -d)
  cp -r "$TEMPLATE_DIR"/scripts "$TEST_DIR/"
  cd "$TEST_DIR"

  cat > CLAUDE.md <<'EOF'
/library use context-old-slug
EOF

  cat > AGENTS.md <<'EOF'
https://github.com/wolram/aios-context/blob/main/projects/old-slug.md
EOF
}

teardown() {
  rm -rf "$TEST_DIR"
}

@test "falha sem argumento e mostra uso" {
  run bash scripts/sync-context.sh
  [ "$status" -eq 1 ]
  [[ "$output" == *"Uso:"* ]]
}

@test "atualiza slug em CLAUDE.md" {
  bash scripts/sync-context.sh new-slug
  grep -q "new-slug" CLAUDE.md
}

@test "remove slug antigo de CLAUDE.md" {
  bash scripts/sync-context.sh new-slug
  ! grep -q "old-slug" CLAUDE.md
}

@test "atualiza link do projeto em AGENTS.md" {
  bash scripts/sync-context.sh new-slug
  grep -q "new-slug.md" AGENTS.md
}

@test "remove link antigo de AGENTS.md" {
  bash scripts/sync-context.sh new-slug
  ! grep -q "old-slug.md" AGENTS.md
}

@test "retorna exit 0 com slug válido" {
  run bash scripts/sync-context.sh new-slug
  [ "$status" -eq 0 ]
}
```

- [ ] **Step 5: Rodar suite de sync-context**

```bash
bats tests/sync-context.bats
```

Resultado esperado: 6/6 passed.

- [ ] **Step 6: Criar tests/integration.sh**

```bash
#!/usr/bin/env bash
# Teste de integração: roda bootstrap em sandbox e verifica cargo build.
# Uso: bash tests/integration.sh
set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR=$(mktemp -d)

cleanup() { rm -rf "$TEST_DIR"; }
trap cleanup EXIT

pass() { echo -e "  ${GREEN}PASS${RESET} $1"; }
fail() { echo -e "  ${RED}FAIL${RESET} $1"; exit 1; }

echo -e "${BOLD}Integration Test — bootstrap api${RESET}"
echo ""

# Copiar template para sandbox
cp -r "$TEMPLATE_DIR"/* "$TEST_DIR/"
cd "$TEST_DIR"

# Rodar bootstrap: api, sem ML
printf 'test-project\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh > /dev/null 2>&1

echo "Verificando arquivos gerados..."
[[ -f "Cargo.toml" ]]        && pass "Cargo.toml" || fail "Cargo.toml não criado"
[[ -f "src/main.rs" ]]       && pass "src/main.rs" || fail "src/main.rs não criado"
[[ -f "src/routes/mod.rs" ]] && pass "src/routes/mod.rs" || fail "src/routes/mod.rs não criado"
[[ -f "Dockerfile" ]]        && pass "Dockerfile" || fail "Dockerfile não criado"
[[ -f ".env.example" ]]      && pass ".env.example" || fail ".env.example não criado"
[[ ! -d "ml" ]]              && pass "ml/ não criado (correto)" || fail "ml/ não deveria existir"

echo ""
echo "Verificando substituição de placeholders..."
! grep -q "{{PROJECT_SLUG}}" CLAUDE.md  && pass "CLAUDE.md sem placeholders" || fail "CLAUDE.md ainda tem placeholders"
! grep -q "{{PROJECT_NAME}}" prd.md     && pass "prd.md sem placeholders" || fail "prd.md ainda tem placeholders"
! grep -q "{{PROJECT_TYPE}}" memory.md  && pass "memory.md sem placeholders" || fail "memory.md ainda tem placeholders"
grep -q "test-slug" CLAUDE.md           && pass "CLAUDE.md tem slug correto" || fail "CLAUDE.md não tem slug"
grep -q "Bootstrap" memory.md           && pass "memory.md registra bootstrap" || fail "memory.md sem registro de bootstrap"

echo ""
echo "Verificando cargo build..."
if command -v cargo &>/dev/null; then
  cargo build --quiet 2>&1 && pass "cargo build" || fail "cargo build falhou"
else
  echo "  SKIP cargo build (cargo não encontrado)"
fi

echo ""
echo -e "${GREEN}${BOLD}✓ Integration test passou${RESET}"
```

- [ ] **Step 7: Tornar integration.sh executável e rodar**

```bash
chmod +x tests/integration.sh
bash tests/integration.sh
```

Resultado esperado: todos os checks passam, `cargo build` compila com sucesso.

- [ ] **Step 8: Rodar suite bats completa**

```bash
bats tests/bootstrap.bats tests/sync-context.bats
```

Resultado esperado: todos os testes passam.

- [ ] **Step 9: Commit**

```bash
git add tests/
git commit -m "test: add bats suite and integration test for bootstrap and sync-context"
```

---

## Task 7: README

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Reescrever README.md**

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: rewrite README with bootstrap usage, structure and tests"
```

---

## Task 8: Push e Pull Request

- [ ] **Step 1: Verificar estado final**

```bash
git log --oneline -10
git status
```

Esperado: working tree limpo, 8+ commits desde o início.

- [ ] **Step 2: Push**

```bash
git push origin main
```

- [ ] **Step 3: Criar PR**

```bash
gh pr create \
  --title "feat: complete AIOS-integrated stack-neutral template" \
  --body "$(cat <<'EOF'
## O que muda

Estrutura completa do `00_marlow_template` — template stack-neutro integrado ao ecossistema AIOS.

## Inclui

- **Camada AIOS:** CLAUDE.md, AGENTS.md, GEMINI.md, prd.md, design.md, memory.md, PROJECT_STATUS.md
- **bootstrap.sh** — gera esqueleto Rust por tipo (api/mobile/lab/tool) + ML service opcional (FastAPI + PyTorch + LangChain)
- **sync-context.sh** — atualiza contexto AIOS com um comando
- **Testes:** bats unitário (bootstrap + sync-context) + integration.sh (sandbox + cargo build)
- **CI/CD:** cargo fmt + clippy + test + ruff + pytest + cargo audit + gitleaks
- **Padrões:** Conventional Commits + PR template

## Como testar

```bash
bats tests/bootstrap.bats tests/sync-context.bats
bash tests/integration.sh
```

## Checklist

- [ ] shellcheck passa em bootstrap.sh e sync-context.sh
- [ ] bats: todos os testes passam
- [ ] integration.sh: cargo build com sucesso
- [ ] README descreve o fluxo completo
EOF
)"
```

---

## Self-Review

**Cobertura da spec:**
- ✅ CLAUDE.md, AGENTS.md, GEMINI.md com placeholders → Task 1
- ✅ prd.md, design.md, memory.md, PROJECT_STATUS.md → Task 1
- ✅ bootstrap.sh com 4 tipos → Task 5
- ✅ ML service opcional (FastAPI + PyTorch + LangChain) → Task 5 `generate_ml()`
- ✅ sync-context.sh → Task 4
- ✅ ci.yml (Rust + Python condicional) → Task 3
- ✅ security.yml (cargo audit + gitleaks semanal) → Task 3
- ✅ CONTRIBUTING.md + pull_request_template.md → Task 2
- ✅ bats unitário bootstrap.bats (32 testes) → Task 6
- ✅ bats unitário sync-context.bats (6 testes) → Task 6
- ✅ integration.sh (sandbox + cargo build) → Task 6
- ✅ README atualizado com seção de testes → Task 7
- ✅ Push + PR → Task 8

**Nomes consistentes:**
- `generate_api/mobile/lab/tool/ml` — definidas e chamadas em Task 5
- `replace_in_file` — definida uma vez, usada no mesmo task
- Placeholders `{{PROJECT_NAME/TYPE/SLUG/DATE}}` — mesmos nomes em Tasks 1 e 5
- `TEST_DIR`, `TEMPLATE_DIR` — consistentes entre Task 6 bats e integration.sh
