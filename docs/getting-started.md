# Getting Started with Workstation

Guía paso a paso para configurar tu primer Workstation.

## ¿Qué es Workstation?

Workstation es una **herramienta** que crea:
- **SSOT-$ORGNAME/** → Tu repositorio organizacional
- **kb-core/** → Conocimiento semántico compartido  
- **seat-** → Workspaces independientes para agentes

## Prerrequisitos

- Git 2.30+
- Bash (Linux/macOS/WSL)
- GitHub account

## Instalación

### 1. Clona Workstation (la herramienta)

```bash
git clone https://github.com/yourorg/workstation.git
cd workstation
```

### 2. Configura el entorno

```bash
# Copia el ejemplo
cp .env.example .env

# Edita con tus datos
nano .env
```

```bash
ORG_NAME=MiOrganizacion
GITHUB_OWNER=miusuario
```

### 3. Ejecuta el instalador

```bash
bash install.sh
```

Esto crea:
```
workstation/          ← Herramienta (donde estás)
SSOT-MiOrganizacion/  ← Tu SSOT (nuevo, al lado)
kb-core/              ← KB semántica (nuevo, al lado)
```

## Tu Primer Seat (Agente)

Un Seat es un **repositorio independiente** con `.openclaw/workspace/`:

```bash
# Desde workstation/
bash scripts/create-seat.sh Developer
```

Esto crea:
```
seat-developer/
├── .openclaw/
│   └── workspace/
│       ├── AGENT.md      # ← Define el agente
│       ├── MEMORY.md     # ← Memoria persistente
│       └── TOOLS.md      # ← Configuración
├── .gitignore            # ← Ignora .env
└── README.md
```

### Configura el Seat

```bash
cd ../seat-developer

# Edita la identidad del agente
nano .openclaw/workspace/AGENT.md
```

```markdown
# Developer

**Role**: Software Developer
**Created**: 2026-03-05

## Purpose

Write, review, and maintain code.

## Boundaries

- ✅ Can: Write code, run tests
- ❌ Cannot: Deploy to production

## Tools

- VS Code
- Git
- Docker
```

### Inicializa el Seat

```bash
# Haz el primer commit
git add -A
git commit -m "Initial Developer seat"

# Conecta a GitHub (opcional)
git remote add origin https://github.com/miusuario/seat-developer.git
git push -u origin main
```

## Integra el Seat en tu SSOT

```bash
# Ve a tu SSOT
cd ../SSOT-MiOrganizacion

# Agrega el Seat como submódulo
git submodule add ../seat-developer Seats/Developer

# Commit
git add -A
git commit -m "Add Developer seat"
```

## Crea tu Primer Proyecto

Los proyectos son **locales** al SSOT:

```bash
# Desde SSOT-MiOrganizacion/
bash ../workstation/scripts/create-project.sh api-v2
```

Esto crea:
```
Projects/api-v2/
├── README.md
└── .gitignore
```

Edita `Projects/api-v2/README.md`:
```markdown
# Project: api-v2

**Status**: In Progress

## Objective

Redesign the public API.

## Related

- **Seats**: Developer
- **KBs**: KB-Core

## Deliverables

- [ ] API spec
- [ ] Implementation
- [ ] Docs
```

Commit:
```bash
git add Projects/api-v2
git commit -m "Add api-v2 project"
```

## Crea tu Primer Sprint

```bash
bash ../workstation/scripts/create-sprint.sh 2026-03-foundation
```

Edita `Sprints/2026-03-foundation/README.md` con fechas y metas.

## Estructura Final

```
~/work/
├── workstation/              ← Herramienta
│   ├── scripts/
│   ├── docs/
│   └── install.sh
│
├── SSOT-MiOrganizacion/      ← Tu SSOT
│   ├── .git/
│   ├── KBs/
│   │   └── KB-Core/          ← submódulo → ../kb-core/
│   ├── Seats/
│   │   └── Developer/        ← submódulo → ../seat-developer/
│   ├── Projects/
│   │   └── api-v2/
│   ├── Sprints/
│   │   └── 2026-03-foundation/
│   └── SSOT.md
│
├── kb-core/                  ← KB semántica
│   ├── README.md
│   └── .git/
│
└── seat-developer/           ← Seat independiente
    ├── .openclaw/
    │   └── workspace/
    │       ├── AGENT.md
    │       ├── MEMORY.md
    │       └── TOOLS.md
    └── .git/
```

## Flujo de Trabajo Diario

### Mañana

```bash
cd ~/work/SSOT-MiOrganizacion

# Actualiza submódulos
git submodule update --remote

# Revisa el sprint actual
cat Sprints/2026-03-foundation/README.md
```

### Durante el día

```bash
# Trabaja en el Seat
cd Seats/Developer/.openclaw/workspace/
nano MEMORY.md

# O en un proyecto
cd ~/work/SSOT-MiOrganizacion
nano Projects/api-v2/README.md
```

### Commit de cambios

```bash
# Si modificaste el Seat
cd Seats/Developer
git add -A
git commit -m "Update Developer memory"

# Luego en el SSOT
cd ../..
git add Seats/Developer  # Actualiza referencia del submódulo
git commit -m "Update Developer seat"
```

## Agregar una Knowledge Base

```bash
# Crea la KB como repo independiente
cd ~/
git init kb-marketing
cd kb-marketing
echo "# KB-Marketing" > README.md
git add -A && git commit -m "Initial"
git remote add origin https://github.com/miusuario/kb-marketing.git
git push -u origin main

# Agrega al SSOT
cd ~/work/SSOT-MiOrganizacion
git submodule add ~/kb-marketing KBs/KB-Marketing
git commit -m "Add KB-Marketing"
```

## Push a GitHub

```bash
# SSOT
cd ~/work/SSOT-MiOrganizacion
git remote add origin https://github.com/miusuario/SSOT-MiOrganizacion.git
git push -u origin main

# KB-Core
cd ~/work/kb-core
git remote add origin https://github.com/miusuario/kb-core.git
git push -u origin main

# Seats (por cada uno)
cd ~/work/seat-developer
git remote add origin https://github.com/miusuario/seat-developer.git
git push -u origin main
```

## Clonar en otra máquina

```bash
# Clona el SSOT con todos los submódulos
git clone --recurse-submodules https://github.com/miusuario/SSOT-MiOrganizacion.git

# O si ya clonaste sin --recurse-submodules:
git submodule update --init --recursive
```

## Siguientes Pasos

- [Architecture](architecture.md) — Entiende el diseño
- [Best Practices](best-practices.md) — Consejos útiles
- [Examples](../examples/) — Ver casos de uso

## Solución de Problemas

### Los submódulos están vacíos

```bash
git submodule update --init --recursive
```

### Cambios en el Seat no se reflejan

```bash
# Asegúrate de hacer commit en el Seat PRIMERO
cd Seats/Developer
git add -A && git commit -m "Update"

# Luego en el SSOT
cd ../..
git add Seats/Developer
git commit -m "Update Developer reference"
```

### Conflictos en submódulos

```bash
# Entra al submódulo y resuelve
cd Seats/Developer
git pull
git push

# Vuelve al SSOT
cd ../..
git add Seats/Developer
git commit -m "Resolve Developer submodule"
```
