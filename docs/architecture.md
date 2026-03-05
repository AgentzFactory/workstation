# Architecture

Diseño de Workstation: todo es modular.

## Principios

1. **Todo es Submódulo**: KBs, Seats, Projects son repos independientes
2. **Naming por Organización**: Cada recurso incluye `$ORG` en su nombre
3. **SSOT como Hub**: El SSOT solo contiene referencias (submódulos)
4. **Persistencia en Seats**: `.openclaw/workspace/` para contexto del agente

## Estructura

```
┌─────────────────────────────────────────────────────────────────┐
│                      workstation/                               │
│                        (Herramienta)                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ bash install.sh
                              
┌─────────────────────────────────────────────────────────────────┐
│                    SSOT-$ORG_NAME/                              │
│                     (Hub Central)                               │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │     KBs/     │  │    Seats/    │  │  Projects/   │          │
│  │  (submods)   │  │  (submods)   │  │  (submods)   │          │
│  │              │  │              │  │              │          │
│  │  KB-Core/    │  │ Seat-Dev/    │  │ Proj-Api/    │          │
│  │  KB-Eng/     │  │ Seat-Res/    │  │ Proj-Web/    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
   ┌─────────┐        ┌──────────┐        ┌──────────┐
   │kb-core/ │        │Seat-Dev  │        │Proj-Api  │
   │kb-eng/  │        │$ORG/     │        │$ORG/     │
   └─────────┘        │          │        │          │
                      │.openclaw/│        │          │
                      │  workspace/       │          │
                      │   - AGENT.md      │          │
                      │   - MEMORY.md     │          │
                      │   - TOOLS.md     │          │
                      └──────────┘        └──────────┘
```

## Naming Convention

| Tipo | Patrón | Ejemplo |
|------|--------|---------|
| SSOT | `SSOT-$ORG` | `SSOT-Acme` |
| Seat | `Seat-$Name-$ORG` | `Seat-Developer-Acme` |
| Project | `Project-$Name-$ORG` | `Project-ApiV2-Acme` |
| KB | `KB-$Name` | `KB-Core`, `KB-Engineering` |

## Componentes

### KB (Knowledge Base)

Repo independiente con conocimiento compartido.

```
kb-engineering/
├── README.md
├── standards/
├── templates/
└── .gitignore
```

### Seat

Repo independiente con entorno del agente.

```
Seat-Developer-Acme/
├── .openclaw/workspace/
│   ├── AGENT.md      # Identidad
│   ├── MEMORY.md     # Memoria
│   └── TOOLS.md      # Herramientas
├── .gitignore
└── README.md
```

### Project

Repo independiente con objetivos y scope.

```
Project-ApiV2-Acme/
├── docs/
├── .gitignore
└── README.md         # Objetivos, deliverables
```

## Flujo de Datos

```
┌─────────┐
│  KBs    │─────► Definen semántica
└────┬────┘
     │
     ▼
┌─────────┐     ┌─────────┐
│  Seats  │◄────│Projects │
└────┬────┘     └─────────┘
     │
     ▼
┌─────────┐
│  Agent  │
│  Work   │
└─────────┘
```

## Git Workflow

### Clonar SSOT

```bash
git clone --recurse-submodules https://github.com/org/SSOT-Org.git
```

### Actualizar Componentes

```bash
cd SSOT-Org

# Actualiza todos los submódulos
git submodule update --remote

# Commit referencias actualizadas
git add -A
git commit -m "Update components"
```

### Trabajar en un Seat

```bash
cd Seats/Developer/.openclaw/workspace/
nano MEMORY.md

cd ../..
git add -A
git commit -m "Update memory"

cd ../..
git add Seats/Developer
git commit -m "Update Developer ref"
```

## Ventajas

- **Modularidad**: Cada componente versionado independientemente
- **Reutilización**: Un Seat puede usarse en múltiples SSOTs
- **Aislamiento**: Cambios en un Seat no afectan otros
- **Escalabilidad**: Agregar componentes no complica el SSOT
- **Seguridad**: Seats sensibles pueden tener acceso restringido

## Comparación: Con vs Sin Workstation

| Aspecto | Sin Workstation | Con Workstation |
|---------|----------------|-----------------|
| Estructura | Ad-hoc, cada uno diferente | Estandarizada |
| Agent context | Disperso, difícil de encontrar | Centralizado en `.openclaw/workspace/` |
| Compartir conocimiento | Copy-paste | Submódulos git |
| Onboarding | Manual, explicar estructura | `bash install.sh` |
| Historia | Perdida o dispersa | Completa en git |
