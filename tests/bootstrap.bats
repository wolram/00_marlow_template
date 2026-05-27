#!/usr/bin/env bats
# Testes unitários do bootstrap.sh — cada teste roda em sandbox isolado.

TEMPLATE_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

setup() {
  TEST_DIR=$(mktemp -d)
  cp -r "$TEMPLATE_DIR/scripts" "$TEST_DIR/"
  for f in CLAUDE.md AGENTS.md GEMINI.md prd.md design.md memory.md PROJECT_STATUS.md; do
    [[ -f "$TEMPLATE_DIR/$f" ]] && cp "$TEMPLATE_DIR/$f" "$TEST_DIR/"
  done
  cd "$TEST_DIR"
}

teardown() {
  rm -rf "$TEST_DIR"
}

# ── Validação de input ────────────────────────────────────────────

@test "tipo inválido retorna exit 1" {
  run bash -c "printf 'meu-projeto\n5\n' | bash scripts/bootstrap.sh"
  [ "$status" -eq 1 ]
}

@test "tipo inválido mostra mensagem de erro" {
  run bash -c "printf 'meu-projeto\n5\n' | bash scripts/bootstrap.sh"
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

@test "ml cria ml/requirements.txt quando resposta é s" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  [ -f "ml/requirements.txt" ]
}

@test "ml cria ml/src/main.py quando resposta é s" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  [ -f "ml/src/main.py" ]
}

@test "ml cria ml/tests/test_health.py" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  [ -f "ml/tests/test_health.py" ]
}

@test "ml cria ml/Dockerfile" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  [ -f "ml/Dockerfile" ]
}

@test "ml NAO criado quando resposta e n" {
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

@test "CLAUDE.md não contém PROJECT_SLUG após bootstrap" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  ! grep -q "{{PROJECT_SLUG}}" CLAUDE.md
}

@test "CLAUDE.md contém o slug correto" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "test-slug" CLAUDE.md
}

@test "CLAUDE.md não contém PROJECT_TYPE após bootstrap" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  ! grep -q "{{PROJECT_TYPE}}" CLAUDE.md
}

@test "prd.md não contém PROJECT_NAME após bootstrap" {
  printf 'meu-projeto\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  ! grep -q "{{PROJECT_NAME}}" prd.md
}

@test "prd.md contém o nome do projeto" {
  printf 'meu-projeto\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "meu-projeto" prd.md
}

@test "memory.md registra bootstrap com tipo correto" {
  printf 'meu-api\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh
  grep -q "Bootstrap" memory.md
  grep -q "api" memory.md
}

@test "memory.md registra ml service quando presente" {
  printf 'meu-api\n1\ntest-slug\ns\n' | bash scripts/bootstrap.sh
  grep -q "LangChain" memory.md
}
