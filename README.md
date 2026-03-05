# Workstation 🏗️

**Agent-Ready Organizational Workspaces**

[![CI](https://github.com/yourorg/workstation/actions/workflows/ci.yml/badge.svg)](https://github.com/yourorg/workstation/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](CHANGELOG.md)

Workstation creates structured, secure Single Sources of Truth (SSOT) where humans and AI agents collaborate across projects with clear boundaries and reusable knowledge.

## 🎯 What It Creates

```
YourOrg/
└── SSOT/                      # Single Source of Truth
    ├── KBs/                   # Knowledge Bases (submodules)
    │   └── KB-Core/          # Core semantics & definitions
    ├── Seats/                 # Agent contexts
    │   ├── Developer/
    │   ├── Researcher/
    │   └── Writer/
    ├── Projects/              # Active work streams
    │   ├── api-redesign/
    │   └── mobile-app/
    └── Sprints/               # Time-boxed iterations
        ├── 2026-03-foundation/
        └── 2026-04-scale/
```

## ✨ Key Features

- 🧠 **Structured Context** — Agents know exactly where to find information
- 📦 **Modular Knowledge** — Reusable KBs via git submodules
- 🪑 **Agent Seats** — Isolated workspaces with clear boundaries
- 📊 **Project Management** — Organized work streams with clear objectives
- 🏃 **Sprint Planning** — Time-boxed iterations for focused delivery
- 🔒 **Security-First** — Clear permissions and audit trails
- 🌐 **Human + AI** — Built for collaboration, not replacement

## 🚀 Quick Start

```bash
# 1. Clone Workstation
git clone https://github.com/yourorg/workstation.git
cd workstation

# 2. Run the installer
bash install.sh

# 3. Create your first Seat (agent workspace)
bash scripts/create-seat.sh Developer

# 4. Create a Project
bash scripts/create-project.sh api-v2

# 5. Create a Sprint
bash scripts/create-sprint.sh 2026-03-foundation
```

## 🏛️ Architecture

```
+====================================================================+
|                            WORKSTATION                             |
|                                                                    |
|  +--------------------------------------------------------------+  |
|  |                           SSOT/                              |  |
|  |                (Single Source of Truth)                      |  |
|  |                                                              |  |
|  |  +-------------------+    +-------------------------------+  |  |
|  |  |        KBs/       |    |            Seats/             |  |  |
|  |  |                   |    |                               |  |  |
|  |  |  +-------------+  |    |  +-----------+  +-----------+ |  |  |
|  |  |  |   KB-Core   |  |    |  | Developer |  | Researcher| |  |  |
|  |  |  | (submodule) |  |    |  +-----------+  +-----------+ |  |  |
|  |  |  +-------------+  |    |                               |  |  |
|  |  +-------------------+    +-------------------------------+  |  |
|  |                                                              |  |
|  |     +-------------+              +----------------------+    |  |
|  |     |  Projects/  |              |       Sprints/       |    |  |
|  |     +-------------+              +----------------------+    |  |
|  +--------------------------------------------------------------+  |
+====================================================================+
```

### Core Components

| Component | Purpose | Example |
|-----------|---------|---------|
| **KBs** | Knowledge Bases define *what things mean* | KB-Core, KB-Engineering |
| **Seats** | Agent contexts define *who acts* | Developer, Designer |
| **Projects** | Work streams define *what to achieve* | api-redesign |
| **Sprints** | Iterations define *when to deliver* | 2026-03-foundation |

## 📖 Documentation

- [Architecture Overview](docs/architecture.md) — Deep dive into design principles
- [Getting Started](docs/getting-started.md) — Complete setup guide
- [Best Practices](docs/best-practices.md) — Tips for effective use
- [Managing Seats](docs/seats.md) — Agent workspace management
- [Managing Projects](docs/projects.md) — Project organization
- [Managing Sprints](docs/sprints.md) — Sprint planning
- [Knowledge Bases](docs/kbs.md) — KB management

## 📁 Repository Structure

```
workstation/
├── blueprint/              # Template files for new SSOTs
├── docs/                  # Documentation
├── examples/              # Example configurations
│   ├── minimal-team/     # 2-3 person setup
│   ├── startup/          # Growing team
│   └── enterprise/       # Large organization
├── scripts/               # Utility scripts
│   ├── create-seat.sh
│   ├── create-project.sh
│   └── create-sprint.sh
├── tests/                 # Test suites
├── install.sh            # Main installer
├── LICENSE               # MIT License
├── CONTRIBUTING.md       # Contribution guide
└── CHANGELOG.md          # Version history
```

## 🎓 Examples

### Minimal Team (2-3 people)

Perfect for small teams getting started:

```bash
cd examples/minimal-team
bash ../../install.sh
bash ../../scripts/create-seat.sh Developer
bash ../../scripts/create-project.sh website
```

[See full example →](examples/minimal-team/)

### Startup (10-20 people)

Multiple teams with domain KBs:

```bash
cd examples/startup
bash ../../install.sh
git submodule add https://github.com/company/kb-engineering.git SSOT/KBs/KB-Engineering
```

[See full example →](examples/startup/)

### Enterprise (100+ people)

Multi-department with governance:

- Central KB registry
- Standardized templates
- Automated compliance
- Cross-department coordination

[See full example →](examples/enterprise/)

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Contributions

- 🐛 [Report bugs](../../issues/new?template=bug_report.yml)
- 💡 [Suggest features](../../issues/new?template=feature_request.yml)
- 📚 [Improve docs](../../issues/new?template=documentation.yml)
- 🔧 [Submit PRs](../../pulls)

## 🛣️ Roadmap

- [ ] GUI for visual SSOT management
- [ ] Plugin system for custom KB types
- [ ] Integration with popular AI platforms
- [ ] Migration tools from other systems
- [ ] Web-based collaboration features

See [Issues](../../issues) for detailed plans.

## 📜 License

MIT License — see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- Inspired by the need for structured human-AI collaboration
- Built for teams who value clear boundaries and reusable knowledge
- Designed with agents in mind from day one

---

**Workstation** — Structure for the agent era.

[Documentation](docs/) • [Examples](examples/) • [Contributing](CONTRIBUTING.md) • [Changelog](CHANGELOG.md)
