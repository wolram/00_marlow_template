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

cp -r "$TEMPLATE_DIR"/* "$TEST_DIR/" 2>/dev/null || true
cd "$TEST_DIR"

printf 'test-project\n1\ntest-slug\nn\n' | bash scripts/bootstrap.sh > /dev/null 2>&1

echo "Verificando arquivos gerados..."
[[ -f "Cargo.toml" ]]        && pass "Cargo.toml"         || fail "Cargo.toml não criado"
[[ -f "src/main.rs" ]]       && pass "src/main.rs"        || fail "src/main.rs não criado"
[[ -f "src/routes/mod.rs" ]] && pass "src/routes/mod.rs"  || fail "src/routes/mod.rs não criado"
[[ -f "Dockerfile" ]]        && pass "Dockerfile"         || fail "Dockerfile não criado"
[[ -f ".env.example" ]]      && pass ".env.example"       || fail ".env.example não criado"
[[ ! -d "ml" ]]              && pass "ml/ não criado (correto)" || fail "ml/ não deveria existir"

echo ""
echo "Verificando substituição de placeholders..."
! grep -q "{{PROJECT_SLUG}}" CLAUDE.md  && pass "CLAUDE.md sem placeholders"  || fail "CLAUDE.md ainda tem placeholders"
! grep -q "{{PROJECT_NAME}}" prd.md     && pass "prd.md sem placeholders"      || fail "prd.md ainda tem placeholders"
! grep -q "{{PROJECT_TYPE}}" memory.md  && pass "memory.md sem placeholders"   || fail "memory.md ainda tem placeholders"
grep -q "test-slug" CLAUDE.md           && pass "CLAUDE.md tem slug correto"   || fail "CLAUDE.md não tem slug"
grep -q "Bootstrap" memory.md           && pass "memory.md registra bootstrap" || fail "memory.md sem registro"

echo ""
echo "Verificando cargo build..."
if command -v cargo &>/dev/null; then
  cargo build --quiet 2>&1 && pass "cargo build" || fail "cargo build falhou"
else
  echo "  SKIP cargo build (cargo não encontrado)"
fi

echo ""
echo -e "${GREEN}${BOLD}✓ Integration test passou${RESET}"
