# Startup Example

Equipo en crecimiento con múltiples KBs y Seats especializados.

## Estructura

```
~/work/
├── workstation/              # Herramienta
├── SSOT-AcmeStartup/         # SSOT principal
│   ├── KBs/
│   │   ├── KB-Core/          # ← submódulo (semántica)
│   │   ├── KB-Engineering/   # ← submódulo (estándares)
│   │   └── KB-Brand/         # ← submódulo (marca)
│   ├── Seats/
│   │   ├── Backend-Dev/      # ← submódulo
│   │   ├── Frontend-Dev/     # ← submódulo
│   │   ├── DevOps/           # ← submódulo
│   │   ├── Product-Manager/  # ← submódulo
│   │   └── Marketing/        # ← submódulo
│   ├── Projects/
│   │   ├── api-v2/
│   │   ├── mobile-app/
│   │   └── marketing-site/
│   └── Sprints/
│       ├── 2026-q1-foundation/
│       └── 2026-q1-scale/
│
├── kb-core/                  # Repo compartido
├── kb-engineering/           # Repo compartido
├── kb-brand/                 # Repo compartido
└── seat-*/                   # Repos de cada agente
```

## Setup Completo

```bash
# 1. Workstation
cd workstation
echo "ORG_NAME=AcmeStartup" > .env
echo "GITHUB_OWNER=acmestartup" >> .env
bash install.sh

# 2. Crea KBs adicionales
cd ~/

# KB-Engineering
git init kb-engineering
cd kb-engineering
cat > README.md <>'EOF'
# KB-Engineering

## Standards

### Code Style
- Python: PEP 8 + Black
- TypeScript: ESLint + Prettier

### Testing
- Minimum 80% coverage
- Unit + Integration tests

### CI/CD
- GitHub Actions
- Docker for deployments
EOF
git add -A && git commit -m "Initial"

# KB-Brand
cd ~/
git init kb-brand
cd kb-brand
cat > README.md <>'EOF'
# KB-Brand

## Voice & Tone

Professional but approachable.

## Visual Identity

- Primary: #0066CC
- Secondary: #FF6600
- Font: Inter
EOF
git add -A && git commit -m "Initial"

# 3. Crea Seats
cd ~/workstation
for seat in Backend-Dev Frontend-Dev DevOps Product-Manager Marketing; do
    bash scripts/create-seat.sh "$seat"
done

# 4. Configura SSOT
cd ../SSOT-AcmeStartup

# Agrega KBs como submódulos
git submodule add ~/kb-engineering KBs/KB-Engineering
git submodule add ~/kb-brand KBs/KB-Brand

# Agrega Seats como submódulos
git submodule add ~/seat-backend-dev Seats/Backend-Dev
git submodule add ~/seat-frontend-dev Seats/Frontend-Dev
git submodule add ~/seat-devops Seats/DevOps
git submodule add ~/seat-product-manager Seats/Product-Manager
git submodule add ~/seat-marketing Seats/Marketing

# 5. Crea Projects
bash ../workstation/scripts/create-project.sh api-v2
bash ../workstation/scripts/create-project.sh mobile-app
bash ../workstation/scripts/create-project.sh marketing-site

# 6. Crea Sprints
bash ../workstation/scripts/create-sprint.sh 2026-q1-foundation
bash ../workstation/scripts/create-sprint.sh 2026-q1-scale

# 7. Commit
git add -A
git commit -m "Initial startup setup"
```

## Cross-Functional Work

El Project `api-v2` usa múltiples Seats:

```markdown
# Projects/api-v2/README.md

## Related

- **Seats**: Backend-Dev, Frontend-Dev, Product-Manager
- **KBs**: KB-Core, KB-Engineering
```

Cada Seat ve el mismo proyecto pero desde su perspectiva:

```bash
# Backend-Dev ve: arquitectura, endpoints, DB
# Frontend-Dev ve: API contract, UI integration
# Product-Manager ve: roadmap, prioridades
```

## Escalando el equipo

Para agregar un nuevo miembro:

```bash
# Crea su Seat
cd ~/workstation
bash scripts/create-seat.sh Data-Scientist

# Configura su entorno
cd ~/seat-data-scientist/.openclaw/workspace/
nano AGENT.md  # Define rol: ML, analytics, etc.

# Agrega al SSOT
cd ~/SSOT-AcmeStartup
git submodule add ~/seat-data-scientist Seats/Data-Scientist
git commit -m "Add Data-Scientist seat"
```

## Beneficios de esta arquitectura

- 🔁 **KBs reutilizables**: KB-Engineering puede usarse en otros SSOTs
- 🪑 **Seats versionados**: Cada agente evoluciona independientemente
- 📦 **Proyectos locales**: Solo el equipo relevante accede
- 🔒 **Seguridad**: Seats sensibles (DevOps) pueden tener acceso restringido
