# KB-Core
version: 1.0.0
role: structural semantics root of the Organization

## PURPOSE

KB-Core defines the formal semantics and foundational knowledge of the Organization.

It establishes:
- Core entities
- Their relationships
- Formal definitions used across SSOT, Seats, Projects, and Sprints

KB-Core does **not** execute workflows or manage persistence.  
It only defines **what things mean** and their **structural rules**.

---

## CONTAINS

KB-Core contains:

- Entity definitions
- Knowledge domains
- Base semantics for Seats, Projects, and Sprints
- Templates for submodules

It may be referenced or extended by KBS in SSOT.

---

## RULES

1. Entities defined here are **canonical**.  
2. Naming must be **unique** across the Organization.  
3. Ownership must be explicit and formal.  
4. KB-Core is **immutable in semantics**: extensions allowed only via SSOT or submodules.  
5. Must remain **implementation-agnostic**.

---

## RELATION TO SSOT

- SSOT instantiates structure using KB-Core definitions.  
- SSOT may extend KB-Core via KBS submodules.  
- SSOT must **not redefine** KB-Core entities or semantics.

---

## VERSIONING

- **MAJOR** — semantic breaking change  
- **MINOR** — additive extension of entities  
- **PATCH** — wording clarification, no semantic change
