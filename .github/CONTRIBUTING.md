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
