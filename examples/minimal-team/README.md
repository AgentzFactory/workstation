# Minimal Team Example

A simple Workstation setup for a 2-3 person team.

## Structure

```
SSOT/
├── KBs/
│   └── KB-Core/
├── Seats/
│   ├── Developer/
│   └── Designer/
├── Projects/
│   └── website-redesign/
└── Sprints/
    └── 2026-03-foundation/
```

## Quick Setup

```bash
# 1. Initialize
cd examples/minimal-team
bash ../../install.sh

# 2. Create team seats
bash ../../scripts/create-seat.sh Developer
bash ../../scripts/create-seat.sh Designer

# 3. Create project
bash ../../scripts/create-project.sh website-redesign

# 4. Create sprint
bash ../../scripts/create-sprint.sh 2026-03-foundation
```

## Usage

Both team members share the same SSOT. They:
- Update their respective Seat's MEMORY.md
- Collaborate on Projects
- Track work in Sprints

## Files

- `Developer/AGENT.md`: Full-stack development focus
- `Designer/AGENT.md`: UI/UX and visual design
- `website-redesign/`: Simple project with clear deliverables
