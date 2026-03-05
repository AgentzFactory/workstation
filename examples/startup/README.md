# Startup Example

Startup en crecimiento con múltiples KBs, Seats y Projects.

## Estructura

```
~/work/
├── workstation/
├── SSOT-StartupCo/
│   ├── KBs/
│   │   ├── KB-Core/
│   │   ├── KB-Engineering/
│   │   └── KB-Brand/
│   ├── Seats/
│   │   ├── Seat-Backend-StartupCo/
│   │   ├── Seat-Frontend-StartupCo/
│   │   ├── Seat-DevOps-StartupCo/
│   │   └── Seat-ProductManager-StartupCo/
│   └── Projects/
│       ├── Project-ApiV2-StartupCo/
│       ├── Project-MobileApp-StartupCo/
│       └── Project-Landing-StartupCo/
│
├── kb-core/
├── kb-engineering/
├── kb-brand/
├── Seat-Backend-StartupCo/
├── Seat-Frontend-StartupCo/
├── Seat-DevOps-StartupCo/
├── Seat-ProductManager-StartupCo/
├── Project-ApiV2-StartupCo/
├── Project-MobileApp-StartupCo/
└── Project-Landing-StartupCo/
```

## Setup

```bash
# 1. Workstation
cd workstation
echo "ORG_NAME=StartupCo" > .env
echo "GITHUB_OWNER=startupco" >> .env
bash install.sh

# 2. KBs adicionales
cd ~/
for kb in kb-engineering kb-brand; do
    git init $kb
cd $kb
    echo "# $kb" > README.md
    git add -A && git commit -m "Initial"
done

# 3. Seats
cd ~/work/workstation
for seat in Backend Frontend DevOps ProductManager; do
    bash scripts/create-seat.sh "$seat"
done

# 4. Projects
for proj in api-v2 mobile-app landing; do
    bash scripts/create-project.sh "$proj"
done

# 5. Integra en SSOT
cd ../SSOT-StartupCo

# KBs
git submodule add ~/kb-engineering KBs/KB-Engineering
git submodule add ~/kb-brand KBs/KB-Brand

# Seats
git submodule add ~/Seat-Backend-StartupCo Seats/Backend
git submodule add ~/Seat-Frontend-StartupCo Seats/Frontend
git submodule add ~/Seat-DevOps-StartupCo Seats/DevOps
git submodule add ~/Seat-ProductManager-StartupCo Seats/ProductManager

# Projects
git submodule add ~/Project-ApiV2-StartupCo Projects/ApiV2
git submodule add ~/Project-MobileApp-StartupCo Projects/MobileApp
git submodule add ~/Project-Landing-StartupCo Projects/Landing

git add -A
git commit -m "Complete startup setup"
```

## Cross-Functional Projects

El Project `ApiV2` usa múltiples Seats:

```markdown
# Project-ApiV2-StartupCo/README.md

## Related

- **Seats**: Backend, Frontend, ProductManager
- **KBs**: KB-Core, KB-Engineering
```

Cada Seat contribuye desde su perspectiva.

## Escalando

Agregar nuevo miembro:

```bash
cd workstation
bash scripts/create-seat.sh DataScientist

cd ../SSOT-StartupCo
git submodule add ~/Seat-DataScientist-StartupCo Seats/DataScientist
git commit -m "Add DataScientist"
```
