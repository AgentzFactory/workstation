# Federated Workstation Model

## Concepto Corregido

### Relación Seat ↔ Org

```
Usuario
├── Seat-Developer-Acme     → Vinculado a Acme (SSOT-Acme)
├── Seat-Analyst-Beta       → Vinculado a Beta (SSOT-Beta)  
└── Seat-Researcher-Gamma   → Vinculado a Gamma (SSOT-Gamma)
```

**Reglas:**
- Un Seat pertenece a **UNA sola Org**
- Un usuario puede tener **múltiples Seats** (uno por Org)
- La Org registra el Seat en su SSOT para seguimiento
- El Seat importa KBs de su Org asignada

### Flujos de Trabajo

#### 1. Crear Seat y Vincular a Org (desde usuario)

```bash
# El usuario tiene su .openclaw/ y quiere trabajar para Acme
workstation seat create Developer --org Acme

# Esto:
# 1. Crea Seat-Developer-Acme
# 2. Lo vincula a la Org Acme (registra en ~/.openclaw/.workstation/org)
# 3. Importa KBs de Acme
# 4. El usuario debe solicitar que Acme incorpore el Seat
```

#### 2. Incorporar Seat a Org (desde Org admin)

```bash
# Desde la Central de Acme
workstation seat incorporate --url https://github.com/user/Seat-Developer-Acme

# Esto:
# 1. Agrega el Seat como submódulo al SSOT-Acme
# 2. Valida que el Seat esté vinculado a Acme
# 3. La Org ahora ve el Seat en su estructura
```

#### 3. Unir Seat a Org (Seat existente no vinculado)

```bash
# Si tengo un Seat sin Org y quiero vincularlo
workstation seat join --org Acme --url https://github.com/acme/SSOT-Acme

# Esto:
# 1. Vincula el Seat actual a la Org Acme
# 2. Importa KBs de Acme
# 3. Prepara para ser incorporado
```

### Estructura de un Seat Vinculado

```
Seat-Developer-Acme/
├── .openclaw/
│   ├── workspace/           # AGENT.md, MEMORY.md, TOOLS.md
│   │   └── imports/         # KBs importados de la Org
│   │       └── Acme/
│   │           └── KB-Core/ # Clone de la KB de Acme
│   └── .workstation/
│       └── org              # Registro de vinculación: Acme=<url>
├── .gitignore               # Ignora imports/ y .workstation/
└── README.md
```

### Permisos

| Acción | Quién puede |
|--------|-------------|
| Crear Seat | Cualquier usuario con GitHub |
| Vincular Seat a Org | El dueño del Seat |
| Incorporar Seat a SSOT | Admin de la Org |
| Ver Seat en SSOT | Colaboradores del SSOT |
| Acceder a KBs importadas | El Seat (localmente) |

### Comandos

```bash
# DESDE UN SEAT (con .openclaw/workspace/)
workstation seat join --org Acme --url <SSOT_URL>    # Vincular a Org
workstation kb sync                                   # Actualizar KBs importadas
workstation status                                    # Ver vinculación actual

# DESDE CENTRAL (admin)
workstation seat incorporate --url <SEAT_URL>        # Incorporar Seat existente
```

### Git Ignore Importante

El Seat debe ignorar los imports para no commitearlos:

```gitignore
# Workstation imports
.openclaw/workspace/imports/
.openclaw/.workstation/
```

Las KBs importadas son **locales** al workspace del agente, no parte del repo.

### Ventajas

1. **Simple**: Un Seat, una Org
2. **Claro**: No hay confusión de a quién pertenece el trabajo
3. **Flexible**: Usuario puede tener múltiples Seats para diferentes Orgs
4. **Seguro**: La Org solo ve los Seats que ha incorporado
5. **Desconectado**: El Seat puede trabajar offline con las KBs importadas
