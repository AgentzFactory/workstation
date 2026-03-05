# Workstation 🏗️

**Agent-Ready Organizational Workspaces**

[![CI](https://github.com/yourorg/workstation/actions/workflows/ci.yml/badge.svg)](https://github.com/yourorg/workstation/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](CHANGELOG.md)

Workstation creates structured, secure Single Sources of Truth (SSOT) where humans and AI agents collaborate across projects with clear boundaries and reusable knowledge.

## 🎯 Concepto

Workstation es una **herramienta**, no un repositorio de trabajo. Al ejecutar `install.sh`, crea:

- **SSOT-$ORGNAME/** → Tu repositorio organizacional
- **kb-core/** → Base de conocimiento semántica
- **seat-** → Workspaces de agentes (creados bajo demanda)

Cada **Seat** es un repositorio independiente con estructura `.openclaw/workspace/` para persistencia completa del entorno del agente.

## 🏛️ Arquitectura

```
┌─────────────────────────────────────────────────────────────────────┐
│                          WORKSTATION                                │
│                     (Esta herramienta)                              │
│                                                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                 │
│  │ install.sh  │  │  scripts/   │  │   docs/     │                 │
│  └─────────────┘  └─────────────┘  └─────────────┘                 │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼ crea
┌─────────────────────────────────────────────────────────────────────┐
│                    SSOT-$ORGNAME/                                   │
│              (Repositorio organizacional)                           │
│                                                                     │
│  ┌──────────────────┐  ┌──────────────────┐                        │
│  │      KBs/        │  │     Seats/       │                        │
│  │   (submódulos)   │  │   (submódulos)   │                        │
│  │                  │  │                  │                        │
│  │  ┌────────────┐  │  │  ┌───────────┐   │                        │
│  │  │  KB-Core   │  │  │  │ Developer │   │  ← .openclaw/workspace/│
│  │  │(kb-core/  )│  │  │  │  (seat/)  │   │     ├── AGENT.md      │
│  │  └────────────┘  │  │  └───────────┘   │     ├── MEMORY.md     │
│  │                  │  │                  │     └── TOOLS.md      │
│  │  ┌────────────┐  │  │  ┌───────────┐   │                        │
│  │  │KB-Domain/  │  │  │  │Researcher │   │                        │
│  │  └────────────┘  │  │  └───────────┘   │                        │
│  └──────────────────┘  └──────────────────┘                        │
│                                                                     │
│  ┌──────────────────┐  ┌──────────────────┐                        │
│  │    Projects/     │  │    Sprints/      │                        │
│  │     (local)      │  │     (local)      │                        │
│  └──────────────────┘  └──────────────────┘                        │
└─────────────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

```bash
# 1. Clona Workstation (la herramienta)
git clone https://github.com/yourorg/workstation.git
cd workstation

# 2. Ejecuta el instalador
bash install.sh
# Te pedirá ORG_NAME y GITHUB_OWNER
# Crea ../SSOT-$ORGNAME/ y ../kb-core/

# 3. Crea tu primer Seat (agente)
bash scripts/create-seat.sh Developer
# Crea ../seat-developer/ con .openclaw/workspace/

# 4. Agrega el Seat a tu SSOT
cd ../SSOT-$ORGNAME
git submodule add ../seat-developer Seats/Developer

# 5. Crea un Proyecto (local al SSOT)
bash ../workstation/scripts/create-project.sh api-v2
```

## 📁 Estructura de un Seat

Cada Seat es un **repositorio independiente**:

```
seat-developer/
├── .openclaw/
│   └── workspace/          # Workspace del agente
│       ├── AGENT.md        # Identidad y propósito
│       ├── MEMORY.md       # Memoria persistente
│       └── TOOLS.md        # Configuración de herramientas
├── .gitignore              # Ignora .env y archivos sensibles
└── README.md               # Documentación del Seat
```

Esto permite:
- ✅ Persistencia completa del entorno del agente
- ✅ Versionado independiente del agente
- ✅ Reutilización del Seat en múltiples SSOTs
- ✅ Backup y migración sencilla

## 📁 Estructura de una KB

Cada Knowledge Base es un **repositorio independiente**:

```
kb-engineering/
├── README.md               # Documentación de la KB
├── standards/              # Estándares y guías
├── templates/              # Plantillas
└── .gitignore
```

## 📖 Documentation

- [Architecture](docs/architecture.md) — Diseño profundo de la arquitectura
- [Getting Started](docs/getting-started.md) — Guía de inicio paso a paso
- [Best Practices](docs/best-practices.md) — Consejos y buenas prácticas

## 🎓 Examples

| Ejemplo | Descripción | Tamaño |
|---------|-------------|--------|
| [minimal-team](examples/minimal-team/) | 2-3 personas, 1 SSOT | Pequeño |
| [startup](examples/startup/) | Equipo creciente, múltiples KBs | Mediano |
| [enterprise](examples/enterprise/) | Múltiples SSOTs, gobernanza | Grande |

## 🔧 Scripts Disponibles

| Script | Descripción | Dónde ejecutar |
|--------|-------------|----------------|
| `install.sh` | Crea SSOT-$ORGNAME y kb-core | En workstation/ |
| `create-seat.sh` | Crea un nuevo Seat (repo independiente) | En workstation/ |
| `create-project.sh` | Crea un proyecto | En SSOT-$ORGNAME/ |
| `create-sprint.sh` | Crea un sprint | En SSOT-$ORGNAME/ |

## 🔄 Flujo de Trabajo

```bash
# 1. Setup inicial
bash install.sh

# 2. Desarrollo diario
cd ../SSOT-MiOrg

# 3. Crear un Seat para un nuevo agente
bash ../workstation/scripts/create-seat.sh Analista

# 4. El Seat es un repo independiente
cd ../seat-analista
# ... trabaja en .openclaw/workspace/
git add -A && git commit -m "Update memory"

# 5. Agrega el Seat al SSOT
cd ../SSOT-MiOrg
git submodule add ../seat-analista Seats/Analista
git commit -m "Add Analista seat"

# 6. Crea proyectos locales
bash ../workstation/scripts/create-project.sh nuevo-proyecto
```

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📜 License

MIT License — see [LICENSE](LICENSE).

---

**Workstation** — Estructura para la era de los agentes.

[Docs](docs/) • [Examples](examples/) • [Contributing](CONTRIBUTING.md)
