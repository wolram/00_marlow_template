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
