# Workstation + OpenClaw Integration

**Agent-Native Organizational Workspaces**

## Vision

Combine Workstation's organizational structure with OpenClaw's agent runtime to create a seamless experience where:

- **Agents self-configure** their Seat within an Organization
- **Agents access org KBs** automatically
- **Agents sync work** with the organizational Central
- **Humans approve** via familiar GitHub workflows

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        OPENCLAW INSTANCE                        │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    AGENT CONTEXT                        │   │
│  │                                                         │   │
│  │  .openclaw/workspace/                                   │   │
│  │  ├── AGENT.md          ← My identity & purpose          │   │
│  │  ├── MEMORY.md         ← My learnings & context         │   │
│  │  ├── TOOLS.md          ← My capabilities                │   │
│  │  └── imports/          ← Organizational KBs (read-only) │   │
│  │      └── AcmeCorp/                                    │   │
│  │          └── KB-Core/  ← Org standards                 │   │
│  │                                                         │   │
│  │  .openclaw/.workstation/                               │   │
│  │  └── org               ← "AcmeCorp"                    │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                              │ git push                          │
│                              ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              SEAT REPO (GitHub)                         │   │
│  │  github.com/user/Seat-Agent-AcmeCorp                   │   │
│  │  ├── .openclaw/workspace/                               │   │
│  │  └── .workstation/org    ← Vinculation record          │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              │                                  │
└──────────────────────────────┼──────────────────────────────────┘
                               │
                               │ git submodule
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│              ORGANIZATION CENTRAL (SSOT)                        │
│  github.com/acme/SSOT-AcmeCorp                                 │
│  ├── Seats/                                                     │
│  │   └── Agent/         ← submodule to Seat repo               │
│  ├── KBs/                                                       │
│  │   └── KB-Core/       ← Org standards                       │
│  └── Projects/                                                  │
│      └── Project-A/    ← Work streams                          │
└─────────────────────────────────────────────────────────────────┘
```

## Agent Setup Flow

### 1. Agent Creates Seat (Self-Service)

```bash
# From agent's OpenClaw instance
mkdir Seat-Consultant-AcmeCorp
cd Seat-Consultant-AcmeCorp
mkdir -p .openclaw/workspace

# Initialize as Seat
workstation seat init  # or git init + structure
```

### 2. Agent Links to Organization

```bash
# Interactive onboarding
bash <(curl -fsSL https://workstation.dev/agent-onboard.sh)

# Or manual:
workstation seat join --org AcmeCorp --url https://github.com/acme/SSOT-AcmeCorp
```

This:
- Creates `.openclaw/.workstation/org` file
- Imports KB-Core from AcmeCorp
- Updates AGENT.md with org context

### 3. Agent Publishes Seat

```bash
git init
git remote add origin https://github.com/user/Seat-Consultant-AcmeCorp
git push -u origin main
```

### 4. Human Admin Approves

```bash
# From org's Central
workstation seat incorporate --url https://github.com/user/Seat-Consultant-AcmeCorp
```

### 5. Agent Works with Org Context

```bash
# Daily workflow
workstation sync  # Update KBs, push changes

# Access org knowledge
cat .openclaw/workspace/imports/AcmeCorp/KB-Core/README.md
```

## OpenClaw Skill: Workstation

### Installation

```bash
# In your OpenClaw workspace
curl -fsSL https://workstation.dev/install-skill.sh | bash
```

Or manually:
```bash
mkdir -p ~/.openclaw/skills/workstation
curl -o ~/.openclaw/skills/workstation/SKILL.md \
  https://raw.githubusercontent.com/AgentzFactory/workstation/main/skills/workstation/SKILL.md
```

### Usage

Once installed, agents can:

```
Human: "Connect this agent to AcmeCorp organization"

Agent:
1. Detects current Seat context
2. Runs: workstation seat join --org AcmeCorp --url <SSOT_URL>
3. Imports KB-Core
4. Updates AGENT.md
5. Reports: "Linked to AcmeCorp. KBs available. Ready for admin approval."
```

## Agent Manifest

Agents in OpenClaw can expose their Seat configuration:

```json
{
  "agent": {
    "name": "Consultant",
    "seat": "Seat-Consultant-AcmeCorp",
    "organization": {
      "name": "AcmeCorp",
      "ssot": "https://github.com/acme/SSOT-AcmeCorp",
      "linked": "2024-03-05",
      "status": "active"
    },
    "kbs": [
      "KB-Core",
      "KB-Engineering"
    ],
    "projects": [
      "Project-Platform-v2"
    ]
  }
}
```

## Human-in-the-Loop

Critical operations require human approval:

| Action | Agent Can | Human Must |
|--------|-----------|------------|
| Create Seat | ✅ Yes | - |
| Link to Org | ✅ Yes | Approve SSOT_URL |
| Access KBs | ✅ Auto (if public) | Grant permissions |
| Incorporate to Central | ❌ No | Run `seat incorporate` |
| Change Project access | ❌ No | GitHub collaborator settings |

## Benefits

### For Agents
- **Self-configuring**: Detect context, auto-link to orgs
- **Knowledge access**: Auto-import organizational standards
- **Clear boundaries**: One Seat = One Org, no confusion

### For Organizations
- **Visibility**: See all agent Seats in SSOT
- **Standardization**: Distribute KBs to all agents
- **Control**: Approve which agents join via GitHub permissions

### For Humans
- **Familiar workflow**: GitHub PRs, issues, reviews
- **No new tools**: Use existing GitHub collaboration
- **Audit trail**: Full git history of agent work

## Example: Complete Agent Lifecycle

### Day 0: Agent Creation

```bash
# Human spins up new agent
openclaw agent create Consultant

# Agent initializes
mkdir Seat-Consultant-AcmeCorp/.openclaw/workspace
# ... creates AGENT.md, MEMORY.md ...
```

### Day 1: Joining Organization

```bash
# Agent runs auto-onboard
./agent-onboard.sh
# → Enters Org: AcmeCorp
# → Enters SSOT: https://github.com/acme/SSOT-AcmeCorp
# → Links Seat
# → Imports KB-Core

# Agent reports: "Linked to AcmeCorp. Pending admin approval."
```

### Day 2: Admin Approval

```bash
# Human admin reviews
cd ~/centrals/AcmeCorp/SSOT-AcmeCorp
workstation seat incorporate --url https://github.com/consultant/Seat-Consultant-AcmeCorp

# Agent is now visible in Central
```

### Day 3+: Working

```bash
# Agent daily sync
workstation sync

# Agent works with org context
cat .openclaw/workspace/imports/AcmeCorp/KB-Core/coding-standards.md
# → Follows org standards

# Agent commits work
git commit -m "Analysis complete per KB-Standards"
git push
```

## Configuration

### Agent Environment Variables

```bash
# In ~/.openclaw/.env or Seat's .env
WORKSTATION_ORG=AcmeCorp
WORKSTATION_AUTO_SYNC=true
WORKSTATION_SYNC_INTERVAL=3600  # seconds
```

### Auto-Sync on Commit

```bash
# In Seat's .git/hooks/post-commit
#!/bin/bash
workstation sync --quiet
```

## Security Considerations

1. **Seat Privacy**: Agent's Seat is private repo (unless explicitly public)
2. **KB Access**: Only org-approved KBs are imported
3. **Central Visibility**: Org only sees Seat metadata, not private work
4. **Audit**: All actions via git, full history preserved

## Future Enhancements

- [ ] **Web Dashboard**: Visual agent management
- [ ] **Real-time Sync**: WebSocket updates vs periodic pull
- [ ] **Agent Marketplace**: Pre-configured agent templates
- [ ] **Multi-Org Coordination**: Cross-org projects
- [ ] **Agent Reputation**: Track contributions across orgs

---

**Result**: Agents are first-class citizens in organizational workspaces, with humans retaining control via familiar GitHub workflows.
