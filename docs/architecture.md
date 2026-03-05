# Architecture Overview

Workstation implements a **modular, agent-ready organizational architecture** based on the principle of Single Source of Truth (SSOT).

## Design Principles

### 1. Separation of Concerns
Each component has a single, well-defined responsibility:
- **KBs** define *what things mean*
- **Seats** provide *who acts*
- **Projects** define *what to achieve*
- **Sprints** bound *when to deliver*

### 2. Composability
Components are designed to work together:
- A Project references multiple Seats
- A Sprint includes multiple Projects
- KBs provide shared semantics across all components

### 3. Version Control Everything
All state is stored in git:
- Reversible changes
- Audit trail
- Collaborative editing
- Branching for experiments

### 4. Agent-First Design
Structure optimizes for AI consumption:
- Clear file naming
- Consistent schemas
- Explicit relationships
- Machine-readable formats

## Component Deep Dive

### KBs (Knowledge Bases)

```
KBs/
├── KB-Core/           # Canonical semantics (submodule)
├── KB-Domain/         # Domain knowledge (submodule)
└── KB-Internal/       # Organization-specific (local)
```

**KB-Core** is special:
- Defines base entities (Organization, Seat, Project, Sprint)
- Establishes naming conventions
- Immutable semantics (extend, don't modify)
- Shared across all Workstation instances

**KB-Domain** examples:
- `KB-Engineering`: Code standards, tech stack
- `KB-Legal`: Contracts, compliance requirements
- `KB-Marketing`: Brand guidelines, voice/tone

### Seats

```
Seats/
├── Developer/
│   ├── AGENT.md       # Identity and purpose
│   ├── MEMORY.md      # Long-term context
│   └── TOOLS.md       # Capabilities
├── Researcher/
└── Writer/
```

A Seat is an **agent context container**:
- Can be a dedicated AI agent
- Can be a human role
- Can be a hybrid team

**AGENT.md** fields:
```markdown
# SeatName
**Role**: Primary function
**Owner**: Who manages this seat
**Permissions**: What it can do
**Boundaries**: What it cannot do
```

### Projects

```
Projects/
├── api-redesign/
│   ├── README.md      # Project definition
│   ├── DECISIONS.md   # Architecture decisions
│   └── docs/          # Project documentation
└── migration-v2/
```

Projects are **scoped work streams**:
- Clear objectives
- Defined scope (inclusions/exclusions)
- Associated Seats
- Linked KBs

### Sprints

```
Sprints/
├── 2026-03-foundation/
│   ├── README.md      # Sprint goals
│   ├── DELIVERABLES.md
│   └── RETROSPECTIVE.md
└── 2026-04-scale/
```

Sprints provide **time boundaries**:
- Start/end dates
- Sprint goals
- Deliverable checklist
- Retrospective for learning

## Data Flow

```
┌─────────┐     references      ┌─────────┐
│  KBs    │◄────────────────────│  Seats  │
└────┬────┘                     └────┬────┘
     │                               │
     │         defines semantics     │
     └──────────────►┌─────────┐◄────┘
                     │ Projects│
                     └────┬────┘
                          │
                          │ bounds time
                          ▼
                     ┌─────────┐
                     │ Sprints │
                     └─────────┘
```

1. **KBs** provide shared language
2. **Seats** use KBs to understand context
3. **Projects** assign work to Seats
4. **Sprints** time-box Project execution

## Git Submodules Strategy

Workstation uses git submodules for:
- **KBs**: Share knowledge across organizations
- **Seats**: Isolate agent contexts (optional)

### Why Submodules?

✅ **Benefits**:
- Independent versioning
- Reusable components
- Clear boundaries
- Selective updates

⚠️ **Tradeoffs**:
- Learning curve
- Extra commands (`git submodule update`)
- Potential for stale references

### Best Practices

```bash
# Clone with all submodules
git clone --recurse-submodules <url>

# Update submodules
git submodule update --remote

# Add a new KB
git submodule add <url> SSOT/KBs/my-kb
```

## Security Model

### Seat Boundaries
- Each Seat has explicit permissions
- Sensitive tools in dedicated Seats
- TOOLS.md can reference external secrets (not commit them)

### Knowledge Access
- KB-Core: Universal read access
- KB-Domain: Role-based access
- KB-Internal: Organization-only

### Audit Trail
- Git history shows all changes
- Who changed what, when
- Rollback capability

## Scaling Considerations

### Small Team (2-5 people)
- Single SSOT
- Few Seats (3-5)
- KB-Core + 1-2 domain KBs

### Medium Organization (10-50 people)
- Multiple SSOTs per department
- Many Seats (10-20)
- Shared KBs via submodules

### Large Enterprise (100+ people)
- SSOT per team
- Central KB registry
- Automated Seat provisioning

## Next Steps

- [Getting Started](getting-started.md): Set up your first Workstation
- [Managing Seats](seats.md): Create agent workspaces
- [Best Practices](best-practices.md): Tips for effective use
