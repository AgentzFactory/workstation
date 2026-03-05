# Workstation 🏗️

**Agent-Ready Organizational Workspaces for Enterprises**

[![CI](https://github.com/AgentzFactory/workstation/actions/workflows/ci.yml/badge.svg)](https://github.com/AgentzFactory/workstation/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](CHANGELOG.md)

Workstation is a CLI tool that creates modular, secure Single Sources of Truth (SSOT) where humans and AI agents collaborate across organizations with clear boundaries and reusable knowledge.

## 🎯 What Makes Workstation Different

Unlike other tools, Workstation is designed for **enterprise organizational structures**:

- **Hierarchical Access**: Admins manage the SSOT, employees only access their Seats
- **Agent-First Design**: Each Seat is a complete agent workspace with `.openclaw/workspace/`
- **Modular by Default**: Everything is a git submodule—KBs, Seats, Projects
- **Enterprise Ready**: Onboarding flows, GitHub integration, org management

## 🚀 Quick Start

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/AgentzFactory/workstation/main/install-cli.sh | bash
```

Or manually:
```bash
git clone https://github.com/AgentzFactory/workstation.git
cd workstation
bash install-cli.sh
```

### Onboard

```bash
workstation onboard
```

This interactive wizard will:
1. ✅ Authenticate with GitHub
2. ✅ Create your organization
3. ✅ Set up the SSOT repository
4. ✅ Create KB-Core (semantic foundation)
5. ✅ Optionally create your first Seat

### Daily Usage

```bash
# Switch to your org
workstation org use AcmeCorp

# Create a new agent Seat
workstation seat create Developer

# Create a project
workstation project create api-v2

# Check status
workstation status
```

## 📖 Documentation

- [Architecture](docs/architecture.md) — Design philosophy
- [Getting Started](docs/getting-started.md) — Complete guide
- [Enterprise Setup](docs/enterprise.md) — Multi-org, governance
- [CLI Reference](docs/cli.md) — All commands

## 🏛️ Architecture

```
~/.workstation/
├── config                    # Current org
└── orgs/
    └── AcmeCorp/
        ├── config            # Org settings
        ├── SSOT-AcmeCorp/    # SSOT (hub)
        │   ├── KBs/
        │   ├── Seats/        # Submodules
        │   └── Projects/     # Submodules
        ├── kb-core/
        ├── Seat-Developer-AcmeCorp/
        └── Project-ApiV2-AcmeCorp/
```

## 👥 User Roles

### Admin (Has SSOT Access)
```bash
workstation onboard                    # Create org
workstation seat create Developer      # Create seats
workstation project create api-v2      # Create projects
workstation kb add engineering         # Add knowledge bases
```

### Employee (Seat-only Access)
Employees typically:
1. Get invited to a Seat repository
2. Clone their Seat: `git clone https://github.com/org/Seat-Developer-AcmeCorp.git`
3. Work in `.openclaw/workspace/`
4. Push changes to their Seat

They **don't need** the SSOT or workstation CLI—they just need git.

## 🔧 CLI Commands

```
workstation onboard              # Interactive setup
workstation org list             # List organizations
workstation org use AcmeCorp     # Switch org
workstation seat create          # Create agent workspace
workstation seat list            # List seats
workstation project create       # Create project
workstation project list         # List projects
workstation kb add               # Add knowledge base
workstation status               # Show status
```

## 🎓 Examples

- [Minimal Team](examples/minimal-team/) — 2-3 people
- [Startup](examples/startup/) — Growing team
- [Enterprise](examples/enterprise/) — Multi-department

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📜 License

MIT — [LICENSE](LICENSE).

---

**Workstation** — Structure for the agent era.
