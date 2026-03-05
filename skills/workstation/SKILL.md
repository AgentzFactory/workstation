# Skill: Workstation

**ID**: `workstation`  
**Description**: Integrate agents with organizational workspaces via Workstation CLI  
**Version**: 1.0.0  

## Overview

This skill enables agents to:
1. Detect if running within a **Seat** (agent workspace)
2. Link their Seat to an **Organization** 
3. Access organizational Knowledge Bases
4. Collaborate within projects
5. Sync work with the organizational Central

## Context Detection

### Am I in a Seat?

```bash
# Check for .openclaw/workspace structure
if [[ -d ".openclaw/workspace" ]]; then
    echo "Running in Seat context"
    # This is my workspace
fi
```

### What's my Seat name?

```bash
# Extract from current directory or git remote
seat_name=$(basename "$PWD")
# Format: Seat-{Role}-{Organization}
```

## Quick Commands

### Link Seat to Organization (One-time setup)

```bash
# From within your Seat directory
workstation seat join --org {ORG_NAME} --url {SSOT_URL}

# Example:
workstation seat join --org AcmeCorp --url https://github.com/acme/SSOT-AcmeCorp
```

This:
- Registers your Seat with the Organization
- Imports the Org's KB-Core locally
- Prepares for admin approval

### Check Organization Status

```bash
workstation status
```

Shows:
- Which Org you're linked to
- Which KBs are available
- Sync status

### Access Knowledge Bases

Once linked, access org KBs at:
```
.openclaw/workspace/imports/{ORG_NAME}/KB-Core/
```

Or via symlink:
```
.openclaw/workspace/KB-Core/
```

### Sync with Organization

```bash
# Update imported KBs and push changes
workstation sync
```

## Working with Projects

### List Available Projects

The Organization admin will grant access to Projects via GitHub permissions.

Projects are repositories. Access depends on GitHub collaborator status.

### Reference Projects

In your work, reference the Project:
```markdown
## Current Work
- **Project**: Project-API-v2-AcmeCorp
- **Status**: In Progress
- **Related KBs**: KB-Core, KB-Engineering
```

## Agent Configuration Template

When setting up a new Seat, configure your AGENT.md:

```markdown
# {Role}

**Organization**: {ORG_NAME}  
**Role**: {Your Role}  
**Seat**: {SEAT_NAME}

## Organizational Context

I work within {ORG_NAME}, accessing:
- KB-Core: Foundational knowledge
- KB-{Domain}: Domain-specific standards
- Projects: Assigned work streams

## Boundaries

- ✅ Can: Access linked KBs, work on assigned Projects
- ❌ Cannot: Access other Seats' private data
- ⚠️  Must: Follow org standards from KBs

## Tools

Standard OpenClaw tools apply, plus:
- workstation sync
- workstation status
```

## Integration with MEMORY.md

Track organizational context:

```markdown
# Memory: {Role}

## Organization
- **Name**: {ORG_NAME}
- **SSOT**: {SSOT_URL}
- **Linked**: {DATE}

## Current Projects
- {Project} - {Status}

## Learned Standards
- From KB-{Name}: {Key insights}

## Relationships
- Working with: @other-agent (Seat-{Role}-{ORG})
```

## Automated Setup Flow

### Scenario: Agent Joins Organization

```
1. Human provides: Org name and SSOT URL
2. Agent executes: workstation seat join --org {name} --url {url}
3. System: Creates .openclaw/.workstation/org file
4. System: Imports KB-Core
5. Agent updates: AGENT.md with org context
6. Human action: Requests admin to incorporate Seat
7. Admin executes: workstation seat incorporate --url {seat_url}
8. Result: Seat visible in Org's SSOT
```

## Troubleshooting

### "Not in a Seat context"

Ensure you're running from a directory with `.openclaw/workspace/`

### "Organization not found"

The Org may not exist. Verify the SSOT_URL with your admin.

### "Cannot access KB"

KB may be private. Request access from Org admin.

## Best Practices

1. **Link once**: A Seat belongs to one Org. Create new Seat for different Org.
2. **Sync regularly**: Run `workstation sync` to get latest KB updates.
3. **Reference KBs**: Always check organizational standards before work.
4. **Document in MEMORY**: Track org-specific learnings.
5. **Respect boundaries**: Your Seat is private; KBs are shared.

## Dependencies

- workstation CLI installed
- GitHub authentication configured
- Git configured

## Related Skills

- `github`: Repository management
- `git`: Version control
- `markdown`: Documentation format
