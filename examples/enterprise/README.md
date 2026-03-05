# Enterprise Example

Organización grande con múltiples departamentos.

## Arquitectura Multi-SSOT

```
~/org/
├── workstation/              # Herramienta
│
├── kb-registry/              # Catálogo central de KBs
│   ├── KB-Core/
│   ├── KB-Compliance/
│   ├── KB-Security/
│   ├── KB-Engineering/
│   └── KB-Brand/
│
├── ssot-engineering/         # SSOT Departamento
│   ├── KBs/
│   │   ├── KB-Core/
│   │   ├── KB-Engineering/
│   │   └── KB-Security/
│   ├── Seats/
│   │   ├── Seat-SWEngineerL1-Engineering/
│   │   ├── Seat-SWEngineerL2-Engineering/
│   │   ├── Seat-SeniorEngineer-Engineering/
│   │   └── Seat-EngineeringManager-Engineering/
│   └── Projects/
│       ├── Project-PlatformV2-Engineering/
│       └── Project-Migration-Engineering/
│
├── ssot-marketing/           # SSOT Departamento
│   ├── KBs/
│   │   ├── KB-Core/
│   │   └── KB-Brand/
│   ├── Seats/
│   │   ├── Seat-ContentWriter-Marketing/
│   │   └── Seat-SEOSpecialist-Marketing/
│   └── Projects/
│       └── Project-Rebrand-Marketing/
│
└── seats/                    # Todos los Seats centralizados
    ├── Seat-SWEngineerL1-Engineering-alice/
    ├── Seat-SWEngineerL1-Engineering-bob/
    └── ...
```

## KB Registry

Repositorio central de KBs aprobadas:

```bash
cd ~/org/kb-registry
git init

# KBs como submódulos del registry
git submodule add https://github.com/enterprise/kb-core.git
git submodule add https://github.com/enterprise/kb-compliance.git
git submodule add https://github.com/enterprise/kb-security.git
git submodule add https://github.com/enterprise/kb-engineering.git

git add -A
git commit -m "KB Registry v1.0"
```

## SSOT Departamental

```bash
cd ~/org/workstation
echo "ORG_NAME=Engineering" > .env
echo "GITHUB_OWNER=enterprise" >> .env
bash install.sh

cd ../SSOT-Engineering

# KBs desde registry
git submodule add https://github.com/enterprise/kb-core.git KBs/KB-Core
git submodule add https://github.com/enterprise/kb-engineering.git KBs/KB-Engineering
git submodule add https://github.com/enterprise/kb-security.git KBs/KB-Security

# Seats con naming claro
for engineer in alice bob charlie; do
    bash ../workstation/scripts/create-seat.sh "SWEngineerL1-${engineer}"
    git submodule add "~/Seat-SWEngineerL1-${engineer}-Engineering" "Seats/SWEngineerL1-${engineer}"
done

# Projects
bash ../workstation/scripts/create-project.sh platform-v2
bash ../workstation/scripts/create-project.sh migration

git submodule add ~/Project-PlatformV2-Engineering Projects/PlatformV2
git submodule add ~/Project-Migration-Engineering Projects/Migration

git add -A
git commit -m "Engineering department setup"
```

## Gobernanza

### Control de Versiones KB

```bash
# SSOT solo usa versiones aprobadas
cd SSOT-Engineering/KBs/KB-Engineering
git fetch
git checkout v2.1.0-approved

cd ../..
git add KBs/KB-Engineering
git commit -m "Update KB-Engineering to v2.1.0 (approved)"
```

### Onboarding Automatizado

```bash
#!/bin/bash
# onboard-engineer.sh

NAME=$1
LEVEL=$2  # L1, L2, Senior

cd ~/org/workstation
bash scripts/create-seat.sh "SWEngineer${LEVEL}-${NAME}"

cd ~/org/SSOT-Engineering
git submodule add "~/Seat-SWEngineer${LEVEL}-${NAME}-Engineering" \
    "Seats/SWEngineer${LEVEL}-${NAME}"
git commit -m "Onboard: $NAME as $LEVEL"
```

## Seguridad

### Niveles de Acceso

| Recurso | Acceso |
|---------|--------|
| KB-Core, KB-Compliance | Org-wide read |
| KB-Security internals | Security team only |
| Project internals | Team only |
| Seat memory | Owner + manager |

## Coordinación Cross-Dept

```markdown
# Project-PlatformV2-Engineering/README.md

## Cross-Department

- **Legal**: Privacy review (due: 2026-04-15)
- **Marketing**: Launch coordination (target: 2026-05-01)
- **HR**: 3 new engineers joining
```
