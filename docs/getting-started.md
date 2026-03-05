# Getting Started

Guía paso a paso para configurar Workstation.

## Instalación

```bash
# 1. Clona la herramienta
git clone https://github.com/yourorg/workstation.git
cd workstation

# 2. Configura
cat > .env <>EOF
ORG_NAME=MiOrg
GITHUB_OWNER=miusuario
EOF

# 3. Ejecuta instalador
bash install.sh
```

Esto crea:
```
workstation/           ← Herramienta
cd ..
SSOT-MiOrg/            ← Tu SSOT (nuevo)
kb-core/               ← KB semántica (nuevo)
```

## Crear un Seat

```bash
# Desde workstation/
bash scripts/create-seat.sh Developer

# Crea: ../Seat-Developer-MiOrg/
```

Estructura creada:
```
Seat-Developer-MiOrg/
├── .openclaw/workspace/
│   ├── AGENT.md
│   ├── MEMORY.md
│   └── TOOLS.md
├── .gitignore
└── README.md
```

### Configurar

```bash
cd ../Seat-Developer-MiOrg

# Edita identidad
nano .openclaw/workspace/AGENT.md
```

```markdown
# Developer

**Organization**: MiOrg
**Role**: Full-stack developer

## Purpose

Write and maintain code.

## Boundaries

- ✅ Can: Write code, review PRs
- ❌ Cannot: Deploy to production
```

### Inicializar

```bash
git add -A
git commit -m "Initial Developer seat for MiOrg"

# Push opcional
git remote add origin https://github.com/miusuario/Seat-Developer-MiOrg.git
git push -u origin main
```

## Integrar Seat en SSOT

```bash
cd ../SSOT-MiOrg

# Agrega como submódulo
git submodule add ../Seat-Developer-MiOrg Seats/Developer

# Commit referencia
git add -A
git commit -m "Add Developer seat"
```

## Crear un Project

```bash
# Desde workstation/
bash scripts/create-project.sh api-v2

# Crea: ../Project-ApiV2-MiOrg/
```

### Integrar Project

```bash
cd ../SSOT-MiOrg
git submodule add ../Project-ApiV2-MiOrg Projects/ApiV2
git commit -m "Add ApiV2 project"
```

## Estructura Final

```
~/work/
├── workstation/              # Herramienta
│
├── SSOT-MiOrg/               # SSOT
│   ├── .git/
│   ├── KBs/
│   │   └── KB-Core/          # submódulo → ../kb-core/
│   ├── Seats/
│   │   └── Developer/        # submódulo → ../Seat-Developer-MiOrg/
│   ├── Projects/
│   │   └── ApiV2/            # submódulo → ../Project-ApiV2-MiOrg/
│   └── SSOT.md
│
├── kb-core/                  # Repo KB
├── Seat-Developer-MiOrg/     # Repo Seat
└── Project-ApiV2-MiOrg/      # Repo Project
```

## Clonar en Otra Máquina

```bash
# Clona SSOT con todos los submódulos
git clone --recurse-submodules https://github.com/miusuario/SSOT-MiOrg.git

cd SSOT-MiOrg
# Todo está listo: KBs, Seats, Projects
```

## Actualizar Submódulos

```bash
cd SSOT-MiOrg

# Actualiza todos los submódulos a última versión
git submodule update --remote

# Commit referencias actualizadas
git add -A
git commit -m "Update submodules"
```

## Trabajar en un Seat

```bash
cd SSOT-MiOrg/Seats/Developer/.openclaw/workspace/

# Edita memoria
nano MEMORY.md

# Commit en el repo del Seat
cd ../..
git add -A
git commit -m "Update memory"

# Actualiza referencia en SSOT
cd ../..
git add Seats/Developer
git commit -m "Update Developer reference"
```

## Tips

- **Commits en dos pasos**: Primero en el Seat/Project, luego en el SSOT
- **Nombres**: Siempre incluyen la org (`Seat-Name-Org`, `Project-Name-Org`)
- **Compartir**: Los Seats y Projects pueden usarse en múltiples SSOTs
