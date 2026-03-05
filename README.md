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

# Sincronizar trabajo (actualiza KBs + push)
workstation sync

# Ver KBs disponibles
workstation kb list

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

## 🔗 Federated Model

Un usuario puede trabajar para múltiples organizaciones, cada una con su propio Seat:

```
Usuario
├── Seat-Developer-Acme     → Trabaja para Acme
├── Seat-Analyst-Beta       → Trabaja para Beta
└── Seat-Researcher-Gamma   → Trabaja para Gamma
```

### Flujo: Seat Independiente → Org

**Desde tu Seat** (tienes `.openclaw/workspace/`):
```bash
# Vincular Seat a una Org
workstation seat join --org Acme --url https://github.com/acme/SSOT-Acme

# La Org incorpora tu Seat a su Central
# (El admin de Acme ejecuta:)
workstation seat incorporate --url https://github.com/tu/Seat-Dev-Acme
```

**Reglas**:
- Un Seat pertenece a **UNA** Org
- Un usuario puede tener **múltiples Seats** (uno por Org)
- El Seat importa KBs de su Org para trabajar con sus estándares

## 📚 Documentación

- [Architecture](docs/architecture.md) — Diseño y filosofía
- [Getting Started](docs/getting-started.md) — Guía completa
- [CLI Reference](docs/cli.md) — Referencia de comandos
- [Permissions](docs/permissions.md) — Cómo manejar accesos
- [Federation](docs/federation.md) — Modelo federado

## 🎓 Examples

- [minimal](examples/minimal/) — 1 Central, 2 Seats
- [multi-team](examples/multi-team/) — Varios equipos, KBs compartidas
- [enterprise](examples/enterprise/) — Múltiples Centrales, gobernanza

## 🛣️ Roadmap

### Phase 1: CLI Foundation (Current - v1.0.x) ✅
- [x] CLI with `onboard`, `central`, `seat`, `project`, `kb` commands
- [x] GitHub-native permissions (no custom auth)
- [x] Modular architecture (everything is a submodule)
- [x] Trunk-based development CI/CD
- [x] Federated model (Seat ↔ Org relationship)

### Phase 2: CLI Enhancements (v1.1.x)
- [ ] `workstation seat sync` - Sync Seat changes to Central
- [ ] `workstation kb update` - Update KB submodules to latest
- [ ] Template system for Seats (pre-configured agent types)
- [ ] Validation commands (`workstation validate`)
- [ ] npm package: `npm install -g @agentz/workstation`

### Phase 3: Web Platform (v2.0) 🚀
**Architecture**: Supabase + Cloudflare + Vite

- [ ] **Authentication**: GitHub OAuth via Supabase Auth
- [ ] **Dashboard**: Vite + React + Tailwind CSS
- [ ] **API**: Cloudflare Workers (Hono.js)
- [ ] **Database**: Supabase PostgreSQL + Cloudflare D1 cache
- [ ] **Deploy**: Cloudflare Pages (global edge)

**Features**:
- [ ] Visual dashboard for Org management
- [ ] Project-based access control ("qué KBs ve cada proyecto")
- [ ] Real-time collaboration
- [ ] GitHub integration (repos, webhooks, actions)
- [ ] Invite system for new members

### Phase 4: SaaS Features (v2.1+)
- [ ] Multi-org visibility (usuario ve todas sus Seats/orgs)
- [ ] Analytics y reporting
- [ ] GitHub App oficial
- [ ] API pública para integraciones
- [ ] Marketplace de templates

### Architecture Decisions
See [docs/web-architecture.md](docs/web-architecture.md) for detailed technical design.

### Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow. We use **fork-based contributions** to optimize costs.

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📜 License

MIT — [LICENSE](LICENSE).

---

**Workstation** — Estructura para organizaciones agentizadas.
