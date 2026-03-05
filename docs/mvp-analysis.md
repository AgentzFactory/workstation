# Workstation MVP Analysis

## Current State vs MVP Requirements

### ✅ What's Working

1. **CLI Installation** - `install-cli.sh` works
2. **Onboarding** - `workstation onboard` creates Central + KB-Core
3. **Seat Creation** - Both `workstation seat create` and git-native + `join`
4. **Seat Incorporation** - `workstation seat incorporate` adds to Central
5. **Agent-friendly scripts** - Auto-setup for agents

### ❌ Missing for MVP

## 1. Configuration Files

### Current Gap
Only basic config files exist. Missing structured metadata.

### Proposed Structure

```
~/.workstation/
├── config.json                    # Global config (vs current flat file)
│   {
│     "version": "1.0.0",
│     "default_central": "AcmeCorp",
│     "github_user": "cxto21",
│     "last_sync": "2024-03-05T13:00:00Z"
│   }
│
└── centrals/
    └── AcmeCorp/
        ├── config.json            # Central metadata
        │   {
        │     "name": "AcmeCorp",
│     "github_owner": "acme",
        │     "ssot_repo": "SSOT-AcmeCorp",
        │     "created_at": "2024-03-05T10:00:00Z",
        │     "seats": ["Developer", "Analyst"],
        │     "kbs": ["KB-Core", "KB-Engineering"],
        │     "projects": ["Platform-v2"]
        │   }
        │
        └── seats/
            └── Seat-Developer-AcmeCorp/
                └── .workstation.json    # Seat metadata (in Seat repo)
                    {
                      "central": "AcmeCorp",
                      "linked_at": "2024-03-05T11:00:00Z",
                      "status": "active",
                      "imports": ["KB-Core", "KB-Engineering"]
                    }
```

## 2. Repository Structure After Complete Setup

```
GitHub Org: github.com/acme/
│
├── SSOT-AcmeCorp/              # Central (SSOT)
│   ├── .workstation.json       # Central metadata
│   ├── README.md
│   ├── Seats/
│   │   ├── Developer/          # git submodule → Seat-Developer-AcmeCorp
│   │   │   └── (linked to github.com/dev1/Seat-Developer-AcmeCorp)
│   │   └── Analyst/            # git submodule → Seat-Analyst-AcmeCorp
│   │       └── (linked to github.com/dev2/Seat-Analyst-AcmeCorp)
│   ├── KBs/
│   │   ├── KB-Core/            # git submodule → KB-Core
│   │   │   ├── .workstation.json
│   │   │   └── README.md
│   │   └── KB-Engineering/     # git submodule → KB-Engineering
│   └── Projects/
│       └── Platform-v2/        # git submodule → Project-Platform-v2-AcmeCorp
│
├── Seat-Developer-AcmeCorp/    # Individual agent workspace
│   ├── .openclaw/
│   │   ├── workspace/
│   │   │   ├── AGENT.md
│   │   │   ├── MEMORY.md
│   │   │   ├── TOOLS.md
│   │   │   └── imports/
│   │   │       └── AcmeCorp/
│   │   │           └── KB-Core/     # cloned (not submodule)
│   │   └── .workstation/
│   │       ├── org                   # "AcmeCorp"
│   │       ├── ssot_url              # "https://github.com/acme/SSOT-AcmeCorp"
│   │       └── workstation.json      # Seat metadata
│   └── .gitignore                    # ignores imports/
│
├── Seat-Analyst-AcmeCorp/      # Another agent workspace
│   └── (same structure)
│
├── KB-Core/                    # Shared knowledge
│   ├── .workstation.json
│   └── README.md
│
├── KB-Engineering/             # Engineering standards
│   └── README.md
│
└── Project-Platform-v2-AcmeCorp/   # Project workspace
    ├── README.md
    └── docs/
```

## 3. Use Cases Identified

### UC1: Organization Setup (Admin)
**Actor**: Org Admin  
**Goal**: Create organizational workspace

```bash
# Current ✓
workstation onboard
# Input: Org name
# Output: SSOT repo, KB-Core repo
```

**Missing**: 
- Config validation
- Template selection (org type)
- Initial KB population

### UC2: Agent Joins Organization (Agent/User)
**Actor**: Agent or Developer  
**Goal**: Create Seat and link to Org

**Option A - Workstation managed**:
```bash
# Current ✓
workstation central use AcmeCorp
workstation seat create Developer
# Creates + links + pushes to GitHub
```

**Option B - Independent + link**:
```bash
# Current ✓
git init Seat-Developer-AcmeCorp
# ... setup ...
workstation seat join --org AcmeCorp --url <SSOT_URL>
```

**Missing**:
- Automatic GitHub repo creation for Option B
- Template selection (role-based)

### UC3: Admin Incorporates Seat
**Actor**: Org Admin  
**Goal**: Add existing Seat to Central

```bash
# Current ✓
workstation seat incorporate --url https://github.com/user/Seat-Dev-AcmeCorp
```

**Missing**:
- Validate Seat is properly linked
- Check Seat follows org standards
- Approve/deny workflow

### UC4: Agent Accesses KBs
**Actor**: Agent in Seat  
**Goal**: Read organizational knowledge

```bash
# Current: Manual
cd .openclaw/workspace/imports/AcmeCorp/KB-Core/

# Missing:
workstation kb list          # List available KBs
workstation kb read Core     # Read KB-Core
workstation kb sync          # Update all imported KBs
```

### UC5: Cross-Project Collaboration
**Actor**: Developer in Project  
**Goal**: Access specific KBs for Project

**Not implemented**:
```bash
workstation project use Platform-v2
workstation project kbs      # List KBs for this project
```

### UC6: Agent Syncs Work
**Actor**: Agent  
**Goal**: Push changes + pull KB updates

```bash
# Current ✗ (not implemented)
workstation sync
# Should:
# - git pull on imported KBs
# - git commit + push Seat changes
```

### UC7: GitHub Auth Integration
**Actor**: User  
**Goal**: Seamless auth without manual gh setup

```bash
# Current: Requires pre-installed gh CLI authenticated
# Missing: Integrated auth flow

workstation auth login
# → Opens browser for GitHub OAuth
# → Stores token securely
```

## 4. GitHub Auth Integration

### Current State
Requires `gh` CLI pre-installed and authenticated.

### MVP Solution
Integrate with `gh auth` or direct OAuth:

```bash
# Option 1: Use gh if available
if command -v gh >/dev/null; then
    gh auth login
fi

# Option 2: Direct OAuth (for web/MVP)
# Open browser: https://github.com/login/oauth/authorize
# Callback to localhost or cloudflare worker
# Store token in ~/.workstation/.env
```

### For CLI MVP
Keep using `gh` CLI but add check:

```bash
workstation auth check
# ✓ Authenticated as cxto21

workstation auth login
# Launches: gh auth login
# Or: Opens browser if gh not installed
```

## 5. Priority Fixes for MVP

### P0 (Critical - Blocks Usage)
1. ✅ ~~Fix `cmd_seat_join` function order~~ DONE
2. ✅ ~~Fix argument parsing (--org, --url)~~ DONE
3. **Config validation** - Validate JSON configs exist
4. **Error handling** - Better messages when GitHub fails

### P1 (High - Polishes Flow)
5. **Sync command** - `workstation sync` for daily use
6. **KB list/read** - Access organizational knowledge
7. **Status improvements** - Show linked org, imported KBs
8. **Auto-detect Central** - If in Central dir, auto-use it

### P2 (Medium - Nice to Have)
9. **Template system** - `workstation seat create --template backend`
10. **Project management** - Link Projects to KBs
11. **Validation** - Check Seat follows org standards

### P3 (Low - Future)
12. Web dashboard
13. Real-time sync
14. Multi-seat management

## 6. Minimal CLI Command Set (MVP)

```bash
# Setup
workstation onboard                    # Create org
workstation auth [login|check]         # GitHub auth

# Central (Admin)
workstation central use <name>         # Switch context
workstation central list               # List my centrals
workstation seat create <name>         # Create + link seat
workstation seat incorporate --url <>  # Add external seat
workstation kb add <name>              # Add knowledge base

# Seat (Agent/User)
workstation seat join --org <> --url <> # Link seat to org
workstation sync                       # Update KBs + push work
workstation kb list                    # Show available KBs
workstation status                     # Current context

# Help
workstation help                       # Show commands
workstation help <command>             # Detailed help
```

## 7. Quick Wins (30 min implementation)

1. **Add `workstation sync`**
```bash
cmd_sync() {
    # Pull imported KBs
    for kb in .openclaw/workspace/imports/*/*/; do
        (cd "$kb" && git pull)
    done
    # Push seat changes
    git add -A && git commit -m "sync" && git push
}
```

2. **Add `workstation kb list`**
```bash
cmd_kb_list() {
    ls .openclaw/workspace/imports/*/
}
```

3. **Auto-detect Central**
```bash
# In main(), if PWD is inside a Central, auto-set it
if [[ "$PWD" =~ /.workstation/centrals/([^/]+)/ ]]; then
    export CURRENT_CENTRAL="${BASH_REMATCH[1]}"
fi
```

4. **Better error messages**
```bash
# Instead of: "Could not add submodule"
# Show: "Could not link seat. Common causes:
#        - Seat URL is incorrect
#        - You don't have access to the Seat repo
#        - Seat already linked to another org"
```

## 8. Summary: What to Build Next

**For MVP Release**:
1. ✅ Core flow works (onboard → create seat → link)
2. 🔄 Add `sync` command
3. 🔄 Add `kb list` command
4. 🔄 Better error handling
5. 🔄 Config validation
6. 🔄 Documentation

**Post-MVP**:
- Web layer with Supabase
- Project-KB access control
- Template system
- Real-time features

## Recommendation

**Build P0 + P1 items (~2 hours)** = Solid MVP

Then **stop** and gather feedback before building web layer.

The CLI MVP should be:
- ✅ Installable via curl
- ✅ Creates orgs and seats
- ✅ Links seats to orgs
- ✅ Syncs work
- ✅ Well documented

This is enough for early adopters to use and give feedback.
