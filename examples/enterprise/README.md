# Enterprise Example

Large organization with multiple departments and strict governance.

## Structure

```
organization/
├── ssot-engineering/
├── ssot-marketing/
├── ssot-legal/
├── ssot-hr/
└── kb-registry/          # Central KB catalog
    ├── KB-Core/
├── KB-Compliance/
├── KB-Security/
├── KB-Engineering/
├── KB-Brand/
└── KB-HR/
```

## Governance

### KB Registry

Central repository of approved Knowledge Bases:

```bash
# Teams reference approved KBs
git submodule add https://github.com/company/kb-compliance.git SSOT/KBs/KB-Compliance

# KB versions are controlled centrally
# Teams update only when approved
```

### Seat Templates

Standardized Seat templates for each department:

```
Seats/
├── Software-Engineer/      # From template
├── Senior-Engineer/        # From template
├── Engineering-Manager/    # From template
└── Principal-Engineer/     # From template
```

### Project Templates

Project types with predefined structures:

```
Projects/
├── feature-[name]/         # New feature template
├── migration-[name]/       # Migration template
├── research-[name]/        # R&D template
└── incident-[name]/        # Incident response template
```

## Automation

### Provisioning

New team members get standardized setups:

```bash
# HR triggers provisioning
./provision-seat.sh \
  --name "john-doe" \
  --role "software-engineer" \
  --department "engineering"
```

### Compliance Checks

CI validates all changes:

```yaml
- name: Check Security KB Compliance
  run: |
    ./scripts/validate-security-kb.sh
    
- name: Check Documentation Standards
  run: |
    ./scripts/validate-docs.sh
```

## Multi-SSOT Coordination

Quarterly planning across departments:

```markdown
# SSOT: ssot-engineering/Sprints/2026-q2/README.md

## Cross-Department Dependencies

- **Legal**: Privacy review for new feature
- **Marketing**: Launch coordination
- **HR**: Team capacity planning
```

## Security

### Access Control

- KB-Compliance: Org-wide read
- KB-Security: Security team write
- Project internals: Team only

### Audit Trail

All changes logged:
- Who modified what
- When changes occurred
- Approval chain

## Scale Considerations

- 100+ engineers across teams
- Multiple SSOTs per department
- Central KB registry
- Automated governance
- Regular KB updates
