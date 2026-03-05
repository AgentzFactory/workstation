# CLI Reference

Complete reference for the `workstation` command.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/AgentzFactory/workstation/main/install-cli.sh | bash
```

## Global Options

None currently. All configuration is managed via `~/.workstation/`.

## Commands

### `workstation onboard`

Interactive setup wizard for new users.

**Steps:**
1. GitHub authentication (via `gh auth login`)
2. Organization name input
3. SSOT repository creation
4. KB-Core creation
5. Optional first Seat creation

**Example:**
```bash
workstation onboard
# ? Organization name: AcmeCorp
# ? Create SSOT repository? [Y/n]: Y
# ? Create first Seat now? [y/N]: Y
# ? Seat name: Developer
```

---

### `workstation org`

Organization management.

#### `workstation org list`

List all configured organizations.

```bash
workstation org list
# • AcmeCorp (owner: johndoe)
# • Personal (owner: johndoe)
```

#### `workstation org use <name>`

Switch to an organization. This sets it as the default for subsequent commands.

```bash
workstation org use AcmeCorp
# Switched to organization: AcmeCorp
```

#### `workstation org info [name]`

Show organization details. If no name provided, uses current org.

```bash
workstation org info AcmeCorp
# Organization: AcmeCorp
# Owner: johndoe
# SSOT: SSOT-AcmeCorp
# Path: ~/.workstation/orgs/AcmeCorp/SSOT-AcmeCorp
```

---

### `workstation seat`

Seat (agent workspace) management.

#### `workstation seat create [name]`

Create a new Seat. If name not provided, prompts interactively.

Creates:
- Git repository: `Seat-{Name}-{Org}`
- Structure: `.openclaw/workspace/` with `AGENT.md`, `MEMORY.md`, `TOOLS.md`
- GitHub repo (if authenticated)
- Submodule link in SSOT

```bash
workstation seat create Developer
# Creating Seat: Developer
# Repository: Seat-Developer-AcmeCorp
# ✓ Seat repository created
# ✓ Seat linked to SSOT
```

#### `workstation seat list`

List all seats in current organization.

```bash
workstation seat list
# Seats in AcmeCorp:
#   • Developer
#   • Researcher
#   • Manager
```

---

### `workstation project`

Project management.

#### `workstation project create [name]`

Create a new Project.

Creates:
- Git repository: `Project-{Name}-{Org}`
- README.md with project structure
- GitHub repo (if authenticated)
- Submodule link in SSOT

```bash
workstation project create api-v2
# Creating Project: api-v2
# Repository: Project-ApiV2-AcmeCorp
# ✓ Project created
```

#### `workstation project list`

List all projects in current organization.

```bash
workstation project list
# Projects in AcmeCorp:
#   • ApiV2
#   • MobileApp
#   • Landing
```

---

### `workstation kb`

Knowledge base management.

#### `workstation kb add [name]`

Add a new Knowledge Base.

Creates:
- Git repository: `KB-{Name}`
- README.md
- GitHub repo (if authenticated)
- Submodule link in SSOT

```bash
workstation kb add engineering
# Creating KB: engineering
# Repository: KB-Engineering
# ✓ KB added
```

---

### `workstation status`

Show workstation status and configuration.

```bash
workstation status
# Workstation Status
# 
# Version: 1.0.0
# Config: ~/.workstation
# 
# GitHub: Authenticated as johndoe
# 
# Current Org: AcmeCorp
# 
# Organizations:
#   → AcmeCorp (active)
#   • Personal
```

---

## Environment Variables

| Variable | Description |
|----------|-------------|
| `ORG_NAME` | Default organization name |
| `GITHUB_TOKEN` | GitHub personal access token |
| `WORKSTATION_DIR` | Config directory (default: `~/.workstation`) |

## Configuration Files

```
~/.workstation/
├── config              # Current org: CURRENT_ORG=AcmeCorp
└── orgs/
    └── AcmeCorp/
        └── config      # Org settings
            # ORG_NAME=AcmeCorp
            # GITHUB_OWNER=johndoe
            # SSOT_REPO=SSOT-AcmeCorp
            # SSOT_PATH=...
            # KB_CORE_REPO=kb-core
            # KB_CORE_PATH=...
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Missing dependency |
| 3 | Authentication failed |

## Tips

- Always run `workstation org use <name>` before creating resources
- Use tab completion (if available in your shell)
- All git operations use your existing GitHub credentials
- Seats and Projects are created as public repos by default
