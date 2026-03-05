# Minimal Team Example

Equipo de 2-3 personas.

## Estructura

```
~/work/
├── workstation/
├── SSOT-Acme/
│   ├── KBs/
│   │   └── KB-Core/
│   ├── Seats/
│   │   ├── Seat-Developer-Acme/
│   │   └── Seat-Designer-Acme/
│   └── Projects/
│       └── Project-Website-Acme/
│
├── kb-core/
├── Seat-Developer-Acme/
├── Seat-Designer-Acme/
└── Project-Website-Acme/
```

## Setup

```bash
cd workstation

# Configura
echo "ORG_NAME=Acme" > .env
echo "GITHUB_OWNER=acmeorg" >> .env

# Instala
bash install.sh

# Crea Seats
bash scripts/create-seat.sh Developer
bash scripts/create-seat.sh Designer

# Crea Project
bash scripts/create-project.sh website

# Integra todo
cd ../SSOT-Acme
git submodule add ../Seat-Developer-Acme Seats/Developer
git submodule add ../Seat-Designer-Acme Seats/Designer
git submodule add ../Project-Website-Acme Projects/Website

git add -A
git commit -m "Initial setup"
```

## Ventajas

- Cada miembro tiene su Seat independiente
- El Project es compartido vía submódulo
- Fácil agregar/quitar miembros
