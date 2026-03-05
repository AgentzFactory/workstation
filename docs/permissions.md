# Permissions in Workstation

Workstation no implementa un sistema de permisos propio. Usa **GitHub nativo**.

## Principio

Cada componente (Central, Seat, KB, Project) es un repositorio GitHub. Los permisos se manejan via:
- **Colaboradores** del repo
- **GitHub Teams** (organizaciones)
- **Branch protection** (opcional)

## Niveles de Acceso

### Central (SSOT)

El SSOT es un repo. Quien tiene acceso:

| Rol GitHub | Puede hacer |
|------------|-------------|
| **Admin/Owner** | Todo: crear Seats, agregar KBs, gestionar estructura |
| **Write** | Modificar Projects, commit changes |
| **Read** | Ver estructura, leer documentación |

**Setup**:
```bash
# En GitHub, Settings > Manage Access
# Agregar admins del SSOT
```

### Seat

Cada Seat es un repo independiente. Ejemplo: `Seat-Developer-Acme`

| Acceso | Descripción |
|--------|-------------|
| **Write** | El agente puede modificar su `.openclaw/workspace/` |
| **Read** | Solo lectura (útil para auditors) |

**Setup**:
```bash
# Repo > Settings > Manage Access
# Agregar colaboradores al Seat
```

**Nota**: Un agente típicamente solo accede a su Seat. No necesita ver el SSOT.

### Knowledge Base

Las KBs son repos compartidos.

| KB | Acceso típico |
|----|---------------|
| **KB-Core** | Todos (read) |
| **KB-Engineering** | Equipos técnicos (read/write) |
| **KB-Compliance** | Legal (write), otros (read) |
| **KB-Security** | Security team (write) |

**Con GitHub Teams**:
```
Team: @engineering
  → KB-Engineering: write
  → KB-Core: read

Team: @legal  
  → KB-Compliance: write
  → KB-Core: read
```

### Project

Projects son repos. Acceso según equipo:

```
Project-ApiV2-Acme:
  Colaboradores:
    - @backend-team (write)
    - @product-team (write)
    - @qa-team (read)
```

## Escenarios Comunes

### Escenario 1: Freelancer / Individual

```
Central: MiOrg
├── SSOT-MiOrg (admin: yo)
├── Seat-Developer-MiOrg (admin: yo)
└── Project-Website-MiOrg (admin: yo)
```

Todo es tuyo. Simple.

### Escenario 2: Equipo pequeño

```
Central: StartupCo
├── SSOT-StartupCo 
│   └── Admins: founder1, founder2
├── Seat-Dev1-StartupCo 
│   └── Colaboradores: dev1
├── Seat-Dev2-StartupCo
│   └── Colaboradores: dev2
└── KB-Engineering
    └── Colaboradores: dev1, dev2 (write)
```

- Cada dev solo ve su Seat
- Ambos devs ven la KB de Engineering
- Los founders ven todo (admin del SSOT)

### Escenario 3: Enterprise

```
Central: AcmeCorp
├── SSOT-AcmeCorp
│   └── Admins: CTO, Architect
├── KB-Compliance
│   └── Write: @legal-team
│   └── Read: @all-employees
├── Seat-Backend-AcmeCorp
│   └── Write: backend1, backend2
├── Seat-Frontend-AcmeCorp
│   └── Write: frontend1, frontend2
└── Project-Platform-AcmeCorp
    └── Write: @platform-team
```

- Legal controla KB-Compliance
- Developers solo ven su área
- Platform team ve el project cross-functional

## Workflows de Acceso

### Dar acceso a un nuevo Seat

```bash
# 1. Crear el Seat
workstation seat create NewAnalyst

# 2. En GitHub, ir al repo Seat-NewAnalyst-MiOrg
# 3. Settings > Manage Access
# 4. Invite collaborator: analyst@company.com (Write)
```

### Dar acceso read-only a una KB

```bash
# GitHub > Repo KB-Engineering
# Settings > Manage Access
# Add team: @interns (Read)
```

### Restrict access (quitar acceso)

Simplemente remover colaborador en GitHub. El repo sigue existiendo pero el usuario no puede acceder.

## Seguridad por Diseño

- **Un Seat, un agente**: Cada agente tiene su propio repo
- **KBs granulares**: Separar conocimiento sensitivo
- **Audit trail**: Git history muestra quién cambió qué
- **No secrets en repos**: Usar `.env` + `.gitignore` + GitHub Secrets si es necesario

## Tips

1. **Usar Teams**: En organizaciones grandes, usar GitHub Teams en vez de individuos
2. **Branch protection**: Proteger `main` en SSOT y KBs críticas
3. **CODEOWNERS**: Definir owners en cada repo para reviews automáticas

---

Los permisos son **GitHub nativo**. No hay magia. Si sabes usar GitHub, sabes usar Workstation.
