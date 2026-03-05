# Enterprise Example

Organización grande con múltiples departamentos y gobernanza.

## Arquitectura Multi-SSOT

```
~/org/
├── workstation/              # Herramienta
│
├── kb-registry/              # Repositorio central de KBs
│   ├── KB-Core/
│   ├── KB-Compliance/
│   ├── KB-Security/
│   ├── KB-Engineering/
│   └── KB-Brand/
│
├── ssot-engineering/         # SSOT del departamento
│   ├── KBs/
│   │   ├── KB-Core/          # ← submódulo → kb-registry/KB-Core
│   │   ├── KB-Engineering/   # ← submódulo
│   │   └── KB-Security/      # ← submódulo
│   ├── Seats/
│   │   ├── SW-Engineer-L1/   # ← submódulos
│   │   ├── SW-Engineer-L2/
│   │   ├── Senior-Engineer/
│   │   ├── Staff-Engineer/
│   │   └── Engineering-Manager/
│   └── Projects/
│
├── ssot-marketing/           # SSOT de Marketing
│   ├── KBs/
│   │   ├── KB-Core/
│   │   └── KB-Brand/
│   ├── Seats/
│   │   ├── Content-Writer/
│   │   ├── SEO-Specialist/
│   │   └── Marketing-Manager/
│   └── Projects/
│
├── ssot-legal/
├── ssot-hr/
└── seats/                    # Todos los Seats centralizados
    ├── seat-sw-engineer-l1-alice/
    ├── seat-sw-engineer-l1-bob/
    ├── seat-senior-charlie/
    └── seat-content-diana/
```

## KB Registry

Repositorio central que aloja todas las KBs aprobadas:

```bash
# Estructura del kb-registry
cd ~/org/kb-registry

git init
git remote add origin https://github.com/enterprise/kb-registry.git

# Cada KB es un subdirectorio con su propio repo
git submodule add https://github.com/enterprise/kb-core.git
git submodule add https://github.com/enterprise/kb-compliance.git
git submodule add https://github.com/enterprise/kb-security.git
git submodule add https://github.com/enterprise/kb-engineering.git

git add -A
git commit -m "KB Registry v1.0"
```

Los departamentos solo usan KBs aprobadas del registry.

## Creación de SSOT Departamental

```bash
cd ~/org/workstation
echo "ORG_NAME=Engineering" > .env
echo "GITHUB_OWNER=enterprise" >> .env
bash install.sh

# Ahora tenemos ~/org/SSOT-Engineering/
cd ~/org/SSOT-Engineering

# Usa KBs del registry en lugar de crear nuevas
git submodule add https://github.com/enterprise/kb-core.git KBs/KB-Core
git submodule add https://github.com/enterprise/kb-engineering.git KBs/KB-Engineering
git submodule add https://github.com/enterprise/kb-security.git KBs/KB-Security

# Crea Seats desde templates aprobados
bash ../workstation/scripts/create-seat.sh SW-Engineer-L1
bash ../workstation/scripts/create-seat.sh SW-Engineer-L2
bash ../workstation/scripts/create-seat.sh Senior-Engineer
bash ../workstation/scripts/create-seat.sh Staff-Engineer

# Configura cada Seat según template corporativo
for seat in ~/org/seats/seat-sw-engineer-l1-*; do
    # Aplica configuración estándar
    cp ~/org/templates/seat-l1-defaults/* "$seat/.openclaw/workspace/"
done

# Agrega al SSOT
git submodule add ~/org/seats/seat-sw-engineer-l1-alice Seats/SW-Engineer-L1-Alice
git submodule add ~/org/seats/seat-sw-engineer-l1-bob Seats/SW-Engineer-L1-Bob
# ...
```

## Gobernanza

### Aprobación de KBs

```
KB Registry
    ↓ (versión aprobada)
Compliance Team revisa
    ↓
Security Team valida
    ↓
Publicado para SSOTs
```

Los SSOTs NO pueden modificar KBs, solo actualizar a versiones aprobadas:

```bash
cd ~/org/SSOT-Engineering/KBs/KB-Engineering
git fetch
git checkout v2.1.0  # Versión aprobada

cd ../..
git add KBs/KB-Engineering
git commit -m "Update KB-Engineering to v2.1.0 (approved)"
```

### Onboarding Automatizado

```bash
#!/bin/bash
# /org/scripts/onboard-engineer.sh

NEW_HIRE=$1
LEVEL=$2  # L1, L2, Senior, etc.

# Crea Seat desde template
cd ~/org/seats
bash ~/org/workstation/scripts/create-seat.sh "$NEW_HIRE"

# Aplica configuración según nivel
cp -r ~/org/templates/seat-$LEVEL/* "seat-$NEW_HIRE/.openclaw/workspace/"

# Agrega a SSOT-Engineering
cd ~/org/SSOT-Engineering
git submodule add "~/org/seats/seat-$NEW_HIRE" "Seats/$NEW_HIRE"
git commit -m "Onboard: $NEW_HIRE as $LEVEL"

# Notifica
echo "Seat created for $NEW_HIRE. Configure GitHub remote:"
echo "  cd ~/org/seats/seat-$NEW_HIRE"
echo "  git remote add origin https://github.com/enterprise/seat-$NEW_HIRE.git"
```

### CI/CD para Compliance

```yaml
# .github/workflows/ssot-compliance.yml
name: SSOT Compliance Check
on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      
      - name: Check KB versions
        run: |
          # Solo versiones aprobadas
          ./scripts/validate-kb-versions.sh
      
      - name: Check Seat compliance
        run: |
          # Verifica configuración requerida
          ./scripts/validate-seat-config.sh
      
      - name: Security scan
        run: |
          # No secrets en repos
          ./scripts/scan-secrets.sh
```

## Coordinación Cross-Departamental

### Quarterly Planning

```markdown
# SSOT-Engineering/Sprints/2026-Q2/README.md

## Cross-Department Dependencies

- **Legal**: Privacy review for new analytics feature
  - Contact: @legal-team
  - Due: 2026-04-15
  
- **Marketing**: Launch coordination for API v2
  - Contact: @marketing-team
  - Launch date: 2026-05-01
  
- **HR**: New hires onboarding
  - 3 engineers starting in April
  - Seats: seat-alice, seat-bob, seat-charlie
```

### KBs Compartidas

| KB | Mantenedor | Usado por |
|---|---|---|
| KB-Core | Architecture | Todos |
| KB-Compliance | Legal | Todos |
| KB-Security | Security | Todos |
| KB-Engineering | Engineering | Engineering |
| KB-Brand | Marketing | Marketing, Product |

## Seguridad

### Niveles de Acceso

```
KB-Core, KB-Compliance      →  Org-wide read
KB-Security                 →  Security team write
KB-Engineering internals    →  Engineering only
Project internals           →  Team only
Seat memory                 →  Owner + manager
```

### Audit Trail

Cambios trazables:

```bash
# Quién cambió qué, cuándo
git log --all --source --full-history -- SSOT-Engineering/KBs/
git log --all --source --full-history -- SSOT-Engineering/Seats/Developer
```

## Escalado

| Tamaño | SSOTs | Seats | KBs |
|---|---|---|---|
| 100 personas | 5-8 departamentos | 20-30 | 5-10 |
| 500 personas | 15-20 equipos | 100-150 | 10-20 |
| 1000+ personas | 30+ equipos | 300+ | 20+ |

La arquitectura de submódulos permite:
- Cada equipo gestiona su SSOT
- KBs compartidas y versionadas
- Seats independientes y auditables
- Escalado sin cuellos de botella
