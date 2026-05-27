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
