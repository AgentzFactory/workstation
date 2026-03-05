# Workstation Web Architecture

## Vision

Evolucionar Workstation CLI a una **aplicación web SaaS** con:
- Dashboard visual para gestión de Centrals, Seats, KBs y Projects
- Autenticación GitHub nativa
- Control de acceso granular
- Deploy serverless en Cloudflare

## Tech Stack

```
┌─────────────────────────────────────────────────────────────┐
│                      CLOUDFLARE                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Workers   │  │    Pages    │  │   D1 (SQLite)       │ │
│  │   (API)     │  │  (Frontend) │  │   (Metadata)        │ │
│  └──────┬──────┘  └─────────────┘  └─────────────────────┘ │
│         │                                                   │
│         ▼                                                   │
│  ┌─────────────┐  ┌─────────────┐                          │
│  │   R2        │  │   KV        │  (Opcional para cache)   │
│  │  (Assets)   │  │  (Session)  │                          │
│  └─────────────┘  └─────────────┘                          │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      SUPABASE                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Auth      │  │  PostgreSQL │  │    Realtime         │ │
│  │  (GitHub)   │  │  (Extended) │  │    (WebSockets)     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      GITHUB API                             │
│         (Repos, Permissions, Webhooks, Actions)             │
└─────────────────────────────────────────────────────────────┘
```

### Componentes

| Componente | Uso | Por qué |
|------------|-----|---------|
| **Cloudflare Workers** | API Backend | Serverless, edge deployment, integración nativa con GitHub |
| **Cloudflare Pages** | Frontend (Vite) | Hosting estático, CI/CD automático desde GitHub |
| **Supabase Auth** | Autenticación | GitHub OAuth nativo, JWT tokens |
| **Supabase PostgreSQL** | Datos extendidos | Perfiles, permisos, metadata de relaciones |
| **Cloudflare D1** | Cache/Metadata | SQLite serverless para queries rápidas |
| **GitHub API** | Fuente de verdad | Repos, colaboradores, permisos, webhooks |

## Arquitectura de Datos

### Modelo de Relaciones

```sql
-- En Supabase PostgreSQL

-- Organizaciones (mapean a SSOT repos en GitHub)
create table orgs (
    id uuid primary key default gen_random_uuid(),
    github_repo text unique not null, -- e.g., "acme/SSOT-Acme"
    name text not null,
    owner_id uuid references auth.users,
    created_at timestamptz default now()
);

-- Miembros de Org con roles
create table org_members (
    id uuid primary key default gen_random_uuid(),
    org_id uuid references orgs,
    user_id uuid references auth.users,
    role text check (role in ('admin', 'member', 'viewer')),
    github_username text not null,
    unique(org_id, user_id)
);

-- Seats (mapean a Seat repos en GitHub)
create table seats (
    id uuid primary key default gen_random_uuid(),
    github_repo text unique not null, -- e.g., "user/Seat-Dev-Acme"
    org_id uuid references orgs,
    user_id uuid references auth.users, -- dueño del Seat
    name text not null, -- e.g., "Developer"
    status text default 'pending', -- pending, active, archived
    created_at timestamptz default now()
);

-- Knowledge Bases
create table kbs (
    id uuid primary key default gen_random_uuid(),
    github_repo text unique not null,
    org_id uuid references orgs,
    name text not null,
    is_public boolean default false,
    access_level text default 'read' -- read, write, admin
);

-- Projects
create table projects (
    id uuid primary key default gen_random_uuid(),
    github_repo text unique not null,
    org_id uuid references orgs,
    name text not null,
    status text default 'planning'
);

-- Acceso a Projects (relación muchos-a-muchos)
create table project_members (
    project_id uuid references projects,
    seat_id uuid references seats,
    role text default 'contributor', -- owner, contributor, viewer
    primary key (project_id, seat_id)
);

-- Acceso a KBs por Project (qué KBs puede ver un proyecto)
create table project_kbs (
    project_id uuid references projects,
    kb_id uuid references kbs,
    access_type text default 'read', -- read, write
    primary key (project_id, kb_id)
);
```

### Sincronización GitHub ↔ Supabase

```
GitHub (Source of Truth)
    ├── Org/SSOT repo
    │   ├── Collaborators → org_members
    │   └── Submodules (Seats) → seats
    ├── KB repos
    │   └── Access → kbs table
    └── Project repos
        └── Collaborators → project_members
                │
                │ Webhooks / API polling
                ▼
        Supabase (Cache + Extended data)
            ├── Permisos granulares
            ├── Dashboard metadata
            └── Relaciones complejas
```

## Control de Acceso Granular

### Niveles de Acceso

| Nivel | Descripción | Implementación |
|-------|-------------|----------------|
| **Org Admin** | Gestiona SSOT, incorpora Seats | GitHub: Admin del repo SSOT |
| **Org Member** | Ve estructura, accede a KBs | GitHub: Read access a SSOT |
| **Seat Owner** | Control total sobre su Seat | GitHub: Admin del repo Seat |
| **Project Owner** | Gestiona proyecto | GitHub: Admin del repo Project + Supabase record |
| **Project Contributor** | Trabaja en proyecto | GitHub: Write access + Supabase record |
| **KB Reader** | Lee KB específica | GitHub: Read access al repo KB |

### Ejemplo: Acceso por Proyecto

```typescript
// En Cloudflare Worker API

async function checkProjectAccess(user: User, projectId: string) {
  // 1. Verificar en Supabase
  const membership = await supabase
    .from('project_members')
    .select('role')
    .eq('project_id', projectId)
    .eq('user_id', user.id)
    .single();
  
  if (membership.data) {
    return membership.data.role; // 'owner', 'contributor', 'viewer'
  }
  
  // 2. Fallback: Verificar en GitHub API
  const hasAccess = await githubApi.checkRepoAccess(
    user.githubToken,
    project.github_repo
  );
  
  return hasAccess ? 'contributor' : null;
}

// Uso en endpoint
app.get('/api/projects/:id/kbs', async (c) => {
  const user = c.get('user');
  const projectId = c.param('id');
  
  const role = await checkProjectAccess(user, projectId);
  if (!role) return c.json({ error: 'Forbidden' }, 403);
  
  // Obtener KBs accesibles para este proyecto
  const kbs = await getAccessibleKBs(projectId, role);
  return c.json(kbs);
});
```

## Dashboard Experience

### Vistas por Rol

```
┌─────────────────────────────────────────────────────────────┐
│  Workstation Dashboard              [User] [Org: Acme] [⚙️]  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ADMIN VIEW (org admin)                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Seats     │  │    KBs      │  │     Projects        │ │
│  │   (12)      │  │    (5)      │  │       (8)           │ │
│  │             │  │             │  │                     │ │
│  │ ● Active: 8 │  │ Public: 2   │  │ Active: 5           │ │
│  │ ○ Pending: 3│  │ Private: 3  │  │ Completed: 3        │ │
│  │ ✕ Inactive:1│  │             │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
│                                                             │
│  SEAT OWNER VIEW (regular user)                             │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ My Seat: Seat-Developer-Acme                           ││
│  │ ┌─────────────┐ ┌─────────────┐ ┌───────────────────┐  ││
│  │ │ AGENT.md    │ │ MEMORY.md   │ │ TOOLS.md          │  ││
│  │ │ [Edit]      │ │ [Edit]      │ │ [Edit]            │  ││
│  │ └─────────────┘ └─────────────┘ └───────────────────┘  ││
│  │                                                        ││
│  │ Projects I'm in:                                       ││
│  │ ● Platform V2 (contributor)                            ││
│  │ ● API Redesign (viewer)                                ││
│  │                                                        ││
│  │ Available KBs:                                         ││
│  │ 📚 KB-Core (Acme)   📚 KB-Engineering                  ││
│  └─────────────────────────────────────────────────────────┘│
│                                                             │
│  PROJECT VIEW                                               │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ Project: Platform V2                                    ││
│  │ Status: In Progress                                     ││
│  │                                                         ││
│  │ Team:                                                   ││
│  │ ● @dev1 (owner)  ● @dev2 (contrib)  ● @pm1 (viewer)    ││
│  │                                                         ││
│  │ KBs for this Project:                                   ││
│  │ ✅ KB-Core (read)  ✅ KB-Engineering (write)            ││
│  │ ❌ KB-Security (no access - request)                    ││
│  └─────────────────────────────────────────────────────────┘│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Autenticación Flow

```
┌─────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  User   │────▶│  Dashboard  │────▶│   GitHub    │────▶│  Supabase   │
│         │     │  (Vite)     │     │    OAuth    │     │    Auth     │
└─────────┘     └─────────────┘     └─────────────┘     └──────┬──────┘
     │                                                         │
     │◀────────────────────────────────────────────────────────┘
     │                    JWT Token + GitHub Token
     │
     │     ┌─────────────┐     ┌─────────────┐
     └────▶│  Worker     │────▶│  GitHub     │
           │  API        │     │  API        │
           │  (Validate) │     │  (Repos)    │
           └─────────────┘     └─────────────┘
```

## Implementación

### Fase 1: Auth + Basic API
- [ ] Setup Supabase con GitHub Auth
- [ ] Cloudflare Worker con Hono.js
- [ ] Endpoint `/auth/callback` para GitHub
- [ ] Sync inicial de orgs/repos del usuario

### Fase 2: Dashboard
- [ ] Vite + React + Tailwind
- [ ] Vista "My Seats" (listado de Seats del usuario)
- [ ] Vista "My Orgs" (orgs donde es miembro)
- [ ] Integración CLI ↔ Web (sync de estado)

### Fase 3: Gestión Granular
- [ ] Gestión de accesos por Proyecto
- [ ] Asignación de KBs a Projects
- [ ] Invite system (enviar link para unirse a Org)

### Fase 4: Real-time
- [ ] WebSockets para cambios en tiempo real
- [ ] Notificaciones de actualizaciones
- [ ] Collaborative editing (opcional)

## Costos Estimados (Cloudflare + Supabase)

| Servicio | Plan | Costo Mensual |
|----------|------|---------------|
| Cloudflare Workers | Free tier | $0 |
| Cloudflare Pages | Free tier | $0 |
| Cloudflare D1 | Free tier | $0 |
| Supabase Auth | Free tier (50K users) | $0 |
| Supabase DB | Free tier (500MB) | $0 |
| **Total inicial** | | **$0** |

Escalado:
- Supabase Pro: $25/mes (8GB DB, 100K users)
- Cloudflare Workers Paid: $5/mes (10M requests)

## Ventajas de esta Arquitectura

1. **Serverless**: No servers que mantener
2. **Edge deployment**: Baja latencia global
3. **GitHub native**: Autenticación y permisos en la fuente
4. **Costo eficiente**: Free tier generoso
5. **Escalable**: De 0 a miles de usuarios sin cambios
6. **CLI + Web**: Mismo backend, múltiples interfaces

## Decisiones de Diseño

### ¿Por qué Supabase y no solo Cloudflare?
- Supabase Auth tiene integración nativa con GitHub OAuth
- PostgreSQL es mejor para relaciones complejas (many-to-many)
- Realtime subscriptions para updates en vivo

### ¿Por qué D1 si tenemos Supabase?
- Cache de metadata frecuente (más rápido que round-trip a Supabase)
- Redundancia si Supabase está down
- Queries simples sin joins complejos

### ¿Por qué Workers sobre Pages Functions?
- Más control sobre routing
- Mejor integración con D1 y R2
- Posibilidad de usar edge caching
