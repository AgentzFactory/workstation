# Workstation 🏗️

**Agent-Ready Organizational Workspaces**

Workstation crea SSOTs modulares donde todo es un submódulo git: KBs, Seats y Projects.

## 🎯 Concepto

Todo es modular:

```
workstation/              ← Herramienta (tú estás aquí)
    └── install.sh
    
SSOT-$ORG/                ← Tu SSOT (creado por install.sh)
    ├── KBs/
    │   └── KB-Core/      ← submódulo
    ├── Seats/
    │   └── Seat-Dev-$ORG/   ← submódulo
    └── Projects/
        └── Project-Api-$ORG/  ← submódulo

kb-core/                  ← KB compartida
Seat-Dev-$ORG/            ← Seat independiente  
Project-Api-$ORG/         ← Project independiente
```

## 🚀 Quick Start

```bash
# 1. Clona la herramienta
git clone https://github.com/yourorg/workstation.git
cd workstation

# 2. Configura
echo "ORG_NAME=Acme" > .env
echo "GITHUB_OWNER=acmeorg" >> .env

# 3. Instala (crea SSOT y kb-core)
bash install.sh

# 4. Crea un Seat
bash scripts/create-seat.sh Developer
# Crea: ../Seat-Developer-Acme/

# 5. Agrégalo al SSOT
cd ../SSOT-Acme
git submodule add ../Seat-Developer-Acme Seats/Developer

# 6. Crea un Project
bash ../workstation/scripts/create-project.sh api-v2
# Crea: ../Project-ApiV2-Acme/

# 7. Agrégalo al SSOT
git submodule add ../Project-ApiV2-Acme Projects/ApiV2
```

## 📁 Naming Convention

| Tipo | Formato | Ejemplo |
|------|---------|---------|
| SSOT | `SSOT-$ORG` | `SSOT-Acme` |
| Seat | `Seat-$Name-$ORG` | `Seat-Developer-Acme` |
| Project | `Project-$Name-$ORG` | `Project-ApiV2-Acme` |
| KB | `KB-$Name` | `KB-Core`, `KB-Engineering` |

## 📁 Estructura de un Seat

```
Seat-Developer-Acme/      ← Repo git independiente
├── .openclaw/
│   └── workspace/
│       ├── AGENT.md      # Identidad
│       ├── MEMORY.md     # Memoria
│       └── TOOLS.md      # Herramientas
├── .gitignore            # Ignora .env
└── README.md
```

## 📁 Estructura de un Project

```
Project-ApiV2-Acme/       ← Repo git independiente
├── docs/
│   └── README.md
├── .gitignore
└── README.md             # Objetivos, scope, deliverables
```

## 🔧 Scripts

| Script | Uso | Crea |
|--------|-----|------|
| `install.sh` | Setup inicial | `SSOT-$ORG/`, `kb-core/` |
| `create-seat.sh` | Nuevo agente | `Seat-$Name-$ORG/` |
| `create-project.sh` | Nuevo proyecto | `Project-$Name-$ORG/` |

## 🔄 Flujo de Trabajo

```bash
# Setup
cd workstation
bash install.sh  # Crea ../SSOT-MiOrg/

# Crear Seat
bash scripts/create-seat.sh Analyst
# → Crea ../Seat-Analyst-MiOrg/

# Integrar
cd ../SSOT-MiOrg
git submodule add ../Seat-Analyst-MiOrg Seats/Analyst

# Crear Project  
bash ../workstation/scripts/create-project.sh dashboard
# → Crea ../Project-Dashboard-MiOrg/

git submodule add ../Project-Dashboard-MiOrg Projects/Dashboard
git commit -m "Add Analyst seat and Dashboard project"
```

## 📖 Docs

- [Getting Started](docs/getting-started.md) — Guía completa
- [Architecture](docs/architecture.md) — Diseño detallado
- [Best Practices](docs/best-practices.md) — Consejos

## 🎓 Examples

- [minimal-team](examples/minimal-team/) — Equipo pequeño
- [startup](examples/startup/) — Startup creciente  
- [enterprise](examples/enterprise/) — Gran organización

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📜 License

MIT — [LICENSE](LICENSE).
