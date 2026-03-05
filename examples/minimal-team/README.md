# Minimal Team Example

Ejemplo para un equipo pequeño de 2-3 personas.

## Estructura

```
~/work/
├── workstation/              # Herramienta
├── SSOT-MinimalTeam/         # SSOT principal
│   ├── KBs/
│   │   └── KB-Core/          # ← submódulo
│   ├── Seats/
│   │   ├── Developer/        # ← submódulo
│   │   └── Designer/         # ← submódulo
│   ├── Projects/
│   │   └── website-redesign/
│   └── Sprints/
│       └── 2026-03-foundation/
│
├── kb-core/                  # Repo KB-Core
├── seat-developer/           # Repo Developer
└── seat-designer/            # Repo Designer
```

## Setup

```bash
# 1. Clona Workstation
git clone https://github.com/yourorg/workstation.git
cd workstation

# 2. Configura
echo "ORG_NAME=MinimalTeam" > .env
echo "GITHUB_OWNER=minimalteam" >> .env

# 3. Instala
bash install.sh
# Crea ../SSOT-MinimalTeam/ y ../kb-core/

# 4. Crea Seats
bash scripts/create-seat.sh Developer
bash scripts/create-seat.sh Designer

# 5. Agrega Seats al SSOT
cd ../SSOT-MinimalTeam
git submodule add ../seat-developer Seats/Developer
git submodule add ../seat-designer Seats/Designer

# 6. Crea Project
bash ../workstation/scripts/create-project.sh website-redesign

# 7. Crea Sprint
bash ../workstation/scripts/create-sprint.sh 2026-03-foundation

# 8. Commits
git add -A
git commit -m "Initial setup with Developer, Designer, and website project"
```

## Trabajo Colaborativo

Ambos miembros trabajan en el mismo SSOT:

```bash
# Clonar con submódulos
git clone --recurse-submodules https://github.com/minimalteam/SSOT-MinimalTeam.git
```

Cada uno desarrolla en su Seat:
```bash
# Developer trabaja en su Seat
cd SSOT-MinimalTeam/Seats/Developer/.openclaw/workspace/
nano MEMORY.md
git add -A && git commit -m "Update"

# Luego actualiza el SSOT
cd ../..
git add Seats/Developer
git commit -m "Update Developer memory"
```

## Ventajas de esta estructura

- ✅ Cada miembro tiene su espacio independiente (Seat)
- ✅ Persistencia completa del entorno en `.openclaw/workspace/`
- ✅ Los Seats pueden versionarse independientemente
- ✅ Fácil agregar/quitar miembros del equipo
