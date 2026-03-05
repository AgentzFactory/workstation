# Workstation Documentation

Welcome to the Workstation documentation. This guide will help you understand and use Workstation effectively.

## Table of Contents

1. [Architecture Overview](architecture.md)
2. [Getting Started](getting-started.md)
3. [Core Concepts](concepts.md)
4. [Managing Seats](seats.md)
5. [Managing Projects](projects.md)
6. [Managing Sprints](sprints.md)
7. [Knowledge Bases](kbs.md)
8. [Best Practices](best-practices.md)
9. [Troubleshooting](troubleshooting.md)

## Quick Reference

### Create a Seat
```bash
bash scripts/create-seat.sh AgentName
```

### Create a Project
```bash
bash scripts/create-project.sh project-name
```

### Create a Sprint
```bash
bash scripts/create-sprint.sh 2026-03-foundation
```

### Add a Knowledge Base
```bash
git submodule add <repo-url> SSOT/KBs/my-kb
git submodule update --init
```

## Architecture at a Glance

```
┌─────────────────────────────────────────────────────────┐
│                      WORKSTATION                         │
│                    (This Repository)                     │
├─────────────────────────────────────────────────────────┤
│                         SSOT                             │
│              (Single Source of Truth)                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
│  │   KBs/   │  │  Seats/  │  │ Projects/│  │ Sprints/│ │
│  │          │  │          │  │          │  │         │ │
│  │ KB-Core  │  │  Agent1  │  │  Proj-A  │  │ Sprint1 │ │
│  │   (sub)  │  │  Agent2  │  │  Proj-B  │  │ Sprint2 │ │
│  └──────────┘  └──────────┘  └──────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Why Workstation?

- **Structured Context**: Agents know where to find information
- **Modular Knowledge**: Reusable KBs across organizations
- **Clear Boundaries**: Each agent has defined permissions
- **Version Controlled**: Everything is tracked in git
- **Human + AI**: Designed for collaboration, not replacement

## Need Help?

- [Issues](https://github.com/yourorg/workstation/issues)
- [Discussions](https://github.com/yourorg/workstation/discussions)
- [Contributing Guide](../CONTRIBUTING.md)
