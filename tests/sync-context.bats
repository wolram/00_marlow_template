#!/usr/bin/env bats
# Testes unitários do sync-context.sh

TEMPLATE_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

setup() {
  TEST_DIR=$(mktemp -d)
  cp -r "$TEMPLATE_DIR/scripts" "$TEST_DIR/"
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

@test "falha sem argumento" {
  run bash scripts/sync-context.sh
  [ "$status" -eq 1 ]
}

@test "mostra uso quando sem argumento" {
  run bash scripts/sync-context.sh
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
