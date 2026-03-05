# Getting Started with Workstation

This guide walks you through setting up your first Workstation from scratch.

## Prerequisites

- Git (2.30+)
- Bash (Linux/macOS/WSL)
- GitHub account (optional, for remote storage)
- GitHub CLI `gh` (optional, for automation)

## Installation

### 1. Clone Workstation

```bash
git clone https://github.com/yourorg/workstation.git
cd workstation
```

### 2. Run the Installer

```bash
bash install.sh
```

The installer will:
- Check dependencies
- Ask for organization details
- Create the SSOT structure
- Set up utility scripts
- Make the initial git commit

### 3. Configure Environment

Edit `.env` to set your organization details:

```bash
ORG_NAME=MyOrg
GITHUB_OWNER=myusername
```

## Your First Workstation

After installation, your structure looks like:

```
workstation/
├── SSOT/
│   ├── KBs/
│   │   └── KB-Core/          # Semantic foundation
│   ├── Seats/                # (empty, ready for agents)
│   ├── Projects/             # (empty, ready for work)
│   └── Sprints/              # (empty, ready for planning)
├── scripts/
│   ├── create-seat.sh
│   ├── create-project.sh
│   └── create-sprint.sh
├── .env
├── .gitignore
└── README.md
```

## Creating Your First Seat

A Seat is an agent workspace. Let's create one:

```bash
bash scripts/create-seat.sh Developer
```

This creates:

```
SSOT/Seats/Developer/
├── AGENT.md      # Define the agent
├── MEMORY.md     # Long-term memory
└── TOOLS.md      # Available capabilities
```

Edit `AGENT.md`:

```markdown
# Developer

**Role**: Software development and code review
**Created**: 2026-03-05

## Purpose

Write, review, and maintain code across projects.

## Boundaries

- ✅ Can: Write code, run tests, review PRs
- ❌ Cannot: Deploy to production, access customer data

## Tools

- Code editor
- Git
- Test runners
- Linters

## Memory

- Preferred code style: Clean, documented
- Tech stack: Python, TypeScript
```

Commit your Seat:

```bash
git add SSOT/Seats/Developer
git commit -m "Add Developer seat"
```

## Creating Your First Project

```bash
bash scripts/create-project.sh api-v2
```

Edit `SSOT/Projects/api-v2/README.md`:

```markdown
# Project: api-v2

**Status**: In Progress
**Created**: 2026-03-05

## Objective

Redesign the public API for better developer experience.

## Scope

**In scope**:
- REST endpoints
- GraphQL layer
- Documentation

**Out of scope**:
- Authentication changes
- Database schema changes

## Related

- **Seats**: Developer
- **KBs**: KB-Core, KB-Engineering

## Deliverables

- [ ] API specification
- [ ] Implementation
- [ ] Documentation
- [ ] Migration guide
```

## Creating Your First Sprint

```bash
bash scripts/create-sprint.sh 2026-03-foundation
```

Edit `SSOT/Sprints/2026-03-foundation/README.md`:

```markdown
# Sprint: 2026-03-foundation

**Status**: Active
**Start**: 2026-03-01
**End**: 2026-03-31

## Goals

1. Complete API v2 foundation
2. Set up CI/CD pipeline
3. Document development workflows

## Projects

- api-v2

## Deliverables

- [x] Project scaffolding
- [ ] Core endpoints
- [ ] Test suite
```

## Pushing to GitHub

Make your Workstation accessible to your team:

```bash
# Create repository on GitHub
git remote add origin https://github.com/myusername/MyOrg-SSOT.git
git push -u origin main
```

## Adding a Knowledge Base

Knowledge Bases are shared via git submodules:

```bash
# Add a domain-specific KB
git submodule add https://github.com/myorg/kb-engineering.git SSOT/KBs/KB-Engineering

# Initialize the submodule
git submodule update --init

# Commit the changes
git add .gitmodules SSOT/KBs/KB-Engineering
git commit -m "Add KB-Engineering submodule"
```

## Daily Workflow

### Morning Standup

1. Check current sprint: `cat SSOT/Sprints/2026-03-foundation/README.md`
2. Review your Seat's MEMORY.md
3. Pick up tasks from Projects

### During Work

1. Update Project deliverables
2. Document decisions in Project DECISIONS.md
3. Update Seat MEMORY.md with new context

### End of Day

1. Commit changes: `git add -A && git commit -m "Update progress"`
2. Push to remote: `git push`
3. Review tomorrow's priorities

## Collaboration

### Team Members

Each team member:
1. Clones the SSOT repo
2. Creates their own Seat
3. Contributes to shared Projects

### Agents

AI agents:
1. Read their Seat configuration
2. Access referenced KBs
3. Work within defined boundaries
4. Update their MEMORY.md

## Next Steps

- [Managing Seats](seats.md): Advanced Seat configuration
- [Managing Projects](projects.md): Project organization
- [Best Practices](best-practices.md): Tips for success

## Troubleshooting

### Git Submodule Issues

```bash
# Submodules not populated
git submodule update --init --recursive

# Update all submodules to latest
git submodule update --remote
```

### Permission Issues

```bash
# Make scripts executable
chmod +x scripts/*.sh
```
