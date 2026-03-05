# Startup Example

A growing startup with multiple teams and projects.

## Structure

```
SSOT/
├── KBs/
│   ├── KB-Core/
│   ├── KB-Engineering/
│   ├── KB-Brand/
│   └── KB-Security/
├── Seats/
│   ├── Backend-Dev/
│   ├── Frontend-Dev/
│   ├── DevOps/
│   ├── Product-Manager/
│   └── Marketing/
├── Projects/
│   ├── api-v2/
│   ├── mobile-app/
│   ├── onboarding-flow/
│   └── marketing-site/
└── Sprints/
    ├── 2026-q1-foundation/
    └── 2026-q1-scale/
```

## Quick Setup

```bash
cd examples/startup
bash ../../install.sh

# Add domain KBs
git submodule add https://github.com/company/kb-engineering.git SSOT/KBs/KB-Engineering
git submodule add https://github.com/company/kb-brand.git SSOT/KBs/KB-Brand

# Create seats for each role
for seat in Backend-Dev Frontend-Dev DevOps Product-Manager Marketing; do
    bash ../../scripts/create-seat.sh "$seat"
done

# Create projects
for project in api-v2 mobile-app onboarding-flow marketing-site; do
    bash ../../scripts/create-project.sh "$project"
done
```

## Key Features

- **Domain KBs**: Shared engineering standards and brand guidelines
- **Role-Based Seats**: Each team member has clear responsibilities
- **Cross-Functional Projects**: Mix of engineering and marketing work
- **Quarterly Sprints**: Aligned with business quarters

## Collaboration

- Weekly sync reviews Project status
- Sprint planning references KBs for standards
- Seats document their own workflows
