# Workstation 🏗️

**Agent-Ready Organizational Workspaces**

[![CI](https://github.com/AgentzFactory/workstation/actions/workflows/ci.yml/badge.svg)](https://github.com/AgentzFactory/workstation/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](CHANGELOG.md)

> **Cost-Efficient**: Fork-based contributions to optimize org resources. See [Contributing](CONTRIBUTING.md).

Workstation creates modular, secure Single Sources of Truth (SSOT) where humans and AI agents collaborate with clear boundaries and reusable knowledge.

## 🎯 Concepto Central vs Seat

Workstation organiza el trabajo en dos niveles:

- **Central (SSOT)**: El hub organizacional. Contiene el mapa completo: KBs, Seats y Projects.
- **Seat**: Un workspace de agente. Contiene `.openclaw/workspace/` con la identidad, memoria y herramientas del agente.

### Permisos (via GitHub)

No reinventamos permisos. Usamos lo que GitHub ya tiene:

| Recurso | Permiso GitHub | Quién accede |
|---------|---------------|--------------|
| **Central/SSOT** | Admin/Owner del repo | Quien gestiona la organización |
| **Seat** | Colaborador del repo del Seat | El agente (humano o IA) asignado |
| **KB** | Colaborador del repo de la KB | Quien necesite ese conocimiento |
| **Project** | Colaborador del repo del Project | El equipo del proyecto |

**Ejemplo**: Un Seat `Seat-Developer-Acme` es un repo. Solo los colaboradores de ese repo acceden a ese agente. El SSOT es otro repo. Los equipos pueden tener acceso de solo lectura a ciertas KBs usando GitHub Teams.

## 🚀 Quick Start

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/AgentzFactory/workstation/main/install-cli.sh | bash
```

### Onboard

```bash
workstation onboard
```

Wizard interactivo que configura:
1. Autenticación GitHub
2. Tu Central (organización)
3. KB-Core (conocimiento base)
4. Primer Seat (opcional)

### Uso Diario

```bash
# Configurar Central activa
workstation central use MiOrg

# Crear un nuevo Seat (agente)
workstation seat create Developer

# Crear un proyecto
workstation project create api-v2

# Ver estado
workstation status
```

## 📁 Estructura

```
~/.workstation/
├── config
└── centrals/
    └── Acme/
        ├── config
        ├── SSOT-Acme/          # Central (hub)
        │   ├── KBs/
        │   ├── Seats/          # Submódulos
        │   └── Projects/
        ├── kb-core/
        ├── Seat-Developer-Acme/    # Seat independiente
        └── Project-ApiV2-Acme/     # Project independiente
```

## 🎭 Central vs Seat

### Central (Administradores)
Quienes gestionan la organización:
```bash
# Tienen acceso al SSOT
workstation central use MiOrg
workstation seat create Analyst
workstation kb add compliance
```

### Seat (Agentes)
Un Seat es un repo independiente. El agente (humano o IA) trabaja ahí:
```
Seat-Developer-Acme/
├── .openclaw/
│   └── workspace/
│       ├── AGENT.md      # Identidad
│       ├── MEMORY.md     # Memoria
│       └── TOOLS.md      # Herramientas
└── .gitignore
```

**Acceso**: El agente solo necesita acceso a su Seat. No necesita ver el SSOT completo.

### Escenarios de Permisos (GitHub nativo)

**Escenario 1**: Dev tiene su Seat
- Repo: `Seat-Dev-Acme`
- Colaboradores: `dev1` (write)
- El dev clona su repo y trabaja. No ve el SSOT.

**Escenario 2**: KB de Compliance (sensitive)
- Repo: `KB-Compliance`
- Colaboradores: `legal-team` (write), `managers` (read)
- Los devs no tienen acceso.

**Escenario 3**: Project cross-team
- Repo: `Project-Platform-Acme`
- Colaboradores: `backend-team`, `frontend-team`
- Ambos equipos contribuyen.

## 📚 Documentación

- [Architecture](docs/architecture.md) — Diseño y filosofía
- [Getting Started](docs/getting-started.md) — Guía completa
- [CLI Reference](docs/cli.md) — Referencia de comandos
- [Permissions](docs/permissions.md) — Cómo manejar accesos

## 🎓 Examples

- [minimal](examples/minimal/) — 1 Central, 2 Seats
- [multi-team](examples/multi-team/) — Varios equipos, KBs compartidas
- [enterprise](examples/enterprise/) — Múltiples Centrales, gobernanza

## 🛣️ Roadmap

### Current (v1.0.x)
- ✅ CLI with `onboard`, `central`, `seat`, `project`, `kb` commands
- ✅ GitHub-native permissions (no custom auth)
- ✅ Modular architecture (everything is a submodule)
- ✅ Trunk-based development CI/CD

### Next (v1.1.x)
- [ ] `workstation seat sync` - Sync Seat changes to Central
- [ ] `workstation kb update` - Update KB submodules to latest
- [ ] Template system for Seats (pre-configured agent types)
- [ ] Validation commands (`workstation validate`)

### Future (v2.0)
- [ ] **npm package**: `npm install -g @agentz/workstation`
  - Makes installation easier for Node.js environments
  - Enables programmatic API usage
  - Integration with other Node-based tools
- [ ] Web UI for visualizing Central structure
- [ ] GitHub App for automated Seat provisioning
- [ ] Multi-Central federation (cross-organization collaboration)

### Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow. We use **fork-based contributions** to optimize costs.

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📜 License

MIT — [LICENSE](LICENSE).

---

**Workstation** — Estructura para organizaciones agentizadas.
