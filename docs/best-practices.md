# Best Practices

Tips and recommendations for getting the most out of Workstation.

## General Principles

### 1. Commit Often

Small, frequent commits are better than large, infrequent ones:

```bash
# Good
git add SSOT/Seats/Developer/MEMORY.md
git commit -m "Developer: Update tech stack preferences"

# Less good
git add -A
git commit -m "Updates"
```

### 2. Document Decisions

When you make a significant decision, document it:

```markdown
# In Projects/my-project/DECISIONS.md

## 2026-03-05: Chose PostgreSQL over MongoDB

**Context**: Needed ACID compliance for financial data

**Decision**: Use PostgreSQL

**Consequences**: 
- + Strong consistency
- - More complex scaling
```

### 3. Keep KBs Focused

Each KB should have a single, clear purpose:

✅ **Good**:
- KB-Engineering: Code standards and practices
- KB-Brand: Visual identity and voice
- KB-Compliance: Regulatory requirements

❌ **Avoid**:
- KB-Everything: A grab bag of unrelated topics

## Seat Management

### Define Clear Boundaries

Ambiguous boundaries lead to confusion:

```markdown
# Good AGENT.md

## Boundaries

- ✅ Can access: Development databases, staging environments
- ❌ Cannot access: Production databases, customer PII
- ⚠️ Needs approval: API key rotation, infrastructure changes
```

### Use MEMORY.md Effectively

MEMORY.md is for persistent context:

```markdown
# MEMORY.md

## Preferences
- Code style: PEP 8, Black formatter
- Testing: pytest with 80% coverage minimum
- Documentation: Google docstrings

## Active Context
- Current focus: API v2 redesign
- Blocked on: Database schema approval

## Learned
- 2026-03-05: GraphQL adds ~200ms latency vs REST
- 2026-03-04: New linter catches 90% of common bugs
```

### Version Seat Changes

When a Seat's role changes significantly, document it:

```bash
git tag seat-developer-v2
git push origin seat-developer-v2
```

## Project Organization

### Project Naming

Use consistent naming:

```
Projects/
├── api-redesign/           # kebab-case for multi-word
├── mobile-app-v2/          # version suffixes when relevant
├── migrate-to-postgres/    # action-oriented names
└── infra-cost-optimization/# descriptive names
```

### Project Lifecycle

```
Planning → Active → Maintenance → Archived
```

Update status in README.md:

```markdown
**Status**: Active
**Started**: 2026-03-01
**Target Completion**: 2026-04-15
```

### Link Related Resources

Always link related components:

```markdown
## Related

- **Seats**: Developer, DevOps
- **KBs**: KB-Core, KB-Engineering, KB-Security
- **Projects**: Depends on api-v1-refactor
- **Sprints**: 2026-03-foundation, 2026-04-scale
```

## Sprint Planning

### Sprint Duration

Recommended: 2-4 weeks

- **2 weeks**: Fast feedback, good for discovery
- **4 weeks**: More substantial deliverables

### Sprint Structure

```markdown
# Sprint README.md

## Goals (3-5 max)

1. Launch feature X
2. Reduce error rate by 50%
3. Complete migration Y

## Capacity

- Developer: 80% (20% maintenance)
- Designer: 100%
- DevOps: 40% (other commitments)
```

### Retrospectives

Always do a retrospective:

```markdown
## Retrospective

### What Went Well
- Clear goals helped prioritize
- Daily standups caught blockers early

### What Could Improve
- Underestimated testing time by 50%
- Need better documentation handoff

### Actions for Next Sprint
- [ ] Add testing buffer to estimates
- [ ] Create documentation checklist
```

## Knowledge Base Management

### KB-Core Stability

KB-Core defines your organization's semantics. Change carefully:

- **MAJOR version**: Breaking semantic changes
- **MINOR version**: New entities
- **PATCH version**: Clarifications only

### Domain KBs

Create KBs for shared knowledge:

```bash
# Create a new KB repository
git init kb-marketing
cd kb-marketing

# Add structure
echo "# KB-Marketing" > README.md
echo "Brand voice, guidelines, assets" >> README.md

git add -A
git commit -m "Initial commit"

# Push to remote and add as submodule
git remote add origin https://github.com/myorg/kb-marketing.git
git push -u origin main

cd ../workstation
git submodule add https://github.com/myorg/kb-marketing.git SSOT/KBs/KB-Marketing
```

### Updating KBs

Keep KBs current:

```bash
# Update to latest
git submodule update --remote SSOT/KBs/KB-Engineering

# Update to specific version
cd SSOT/KBs/KB-Engineering
git checkout v1.2.3
cd ../../..
git add SSOT/KBs/KB-Engineering
git commit -m "Update KB-Engineering to v1.2.3"
```

## Git Workflow

### Branching Strategy

```
main
├── feature/add-auth
├── feature/api-v2
└── hotfix/security-patch
```

### Commit Messages

Follow conventional commits:

```bash
# Format: type(scope): description
git commit -m "feat(projects): add api-v2 project"
git commit -m "fix(seats): update Developer boundaries"
git commit -m "docs(kb): clarify entity definitions"
git commit -m "chore: update submodules"
```

### Syncing Changes

Pull before you push:

```bash
git pull --rebase origin main
# Resolve any conflicts
git push origin main
```

## Automation

### Git Hooks

Add pre-commit validation:

```bash
# .git/hooks/pre-commit
#!/bin/bash
# Validate markdown files
for file in $(git diff --cached --name-only | grep '\.md$'); do
    if ! grep -q "^# " "$file"; then
        echo "Error: $file missing H1 header"
        exit 1
    fi
done
```

### CI/CD

Automate checks:

```yaml
# .github/workflows/validate.yml
name: Validate
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive
      - name: Check structure
        run: |
          test -d SSOT/KBs/KB-Core
          test -d SSOT/Seats
          test -d SSOT/Projects
          test -d SSOT/Sprints
```

## Common Pitfalls

### ❌ Avoid

1. **Monolithic MEMORY.md**: Split into sections
2. **Outdated status**: Update status fields regularly
3. **Orphaned Seats**: Archive Seats no longer in use
4. **Circular references**: Project A → Project B → Project A
5. **Secrets in repos**: Use TOOLS.md to reference, not store

### ✅ Do

1. **Link everything**: Connect related components
2. **Document rationale**: Explain why, not just what
3. **Review periodically**: Clean up monthly
4. **Share KBs**: Reuse knowledge across teams
5. **Automate checks**: CI validates structure

## Scaling Tips

### Small Team (2-5)
- Single SSOT
- Direct collaboration
- Informal processes

### Growing Team (5-15)
- Document processes in KBs
- Regular structure reviews
- Clear Seat responsibilities

### Multiple Teams (15+)
- SSOT per team
- Shared KB registry
- Automated provisioning

## Resources

- [Architecture Overview](architecture.md)
- [Managing Seats](seats.md)
- [Managing Projects](projects.md)
- [Troubleshooting](troubleshooting.md)
