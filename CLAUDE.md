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
