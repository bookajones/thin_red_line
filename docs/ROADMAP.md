# Roadmap — Godot port of Python Strategy

**Product roadmap is unchanged. Delivery status resets on this engine migration.** This plan has two tracks: (A) prove the Godot implementation reproduces previously delivered Python behavior, and (B) resume the existing feature milestones. Source: [read-only original MILESTONES.md](reference/PYTHON_STRATEGY_MILESTONES.md), with fine-grained acceptance criteria and the original [backlog](reference/PYTHON_STRATEGY_BACKLOG.md).

## Port gates (new engineering stages, not new gameplay)

| Gate | Deliverable | Acceptance |
| --- | --- | --- |
| **G0 — Foundation** | Godot project, test map and scenario data, basic counters, select/order/camera, per-side visible/discovered state, separate target detection, test harness and docs | Open project; deterministic headless smoke; no undeclared gameplay redesign; manual QA |
| **G1 — Core tactical parity** | Same original formation footprint and turning, LINE/COLUMN, queue/deployment previews, combat/hit/reload/shot smoke, morale/fatigue/routing, pause/speed, debug | Reproduce Python functional tests and representative player-level scenarios; same source parameters |
| **G2 — Terrain and crossings parity** | Historical/test map rendering, movement effects, routes, bridges/fords with traffic and retreat, opposite-direction collision safety | Equivalent edge-case tests and manual crossings, not just visible terrain |
| **G3 — Battlefield awareness parity** | Accurate terrain/forest mask LOS, concealment by rotated unit footprint, distinct detection/fire, enemy selection/rendering security, visual fog and cache | Tests for boundary/forest interior, concealment, 0.5–4×/pause, history/reacquisition, 60 FPS stress target |
| **G4 — Art and release parity review** | Approved/licensed map and counter art, counter scaling/LOD, map annotation/editor workflow where useful, compatibility matrix and end-to-end QA | Python baseline behaviors available without regressions; owner signs off |

**G0 current PR:** foundation code exists, but no locally executed Godot headless or Windows manual validation is claimed. G0 becomes accepted only after review. G1–G4 are pending.

## Original milestone progression (preserved)

| Original milestone | Product scope | Port status / future |
| --- | --- | --- |
| v0.1.0 | Initial counter strategy, movement/selection, ranged/melee, victory | Source released; **port incomplete** |
| v0.2.0 | Morale, fatigue, routing and debugging | Source released; **port incomplete** |
| v0.3.0 | Determinism, tests, gameplay rules and logging | Source released; **port incomplete** |
| v0.4.0 | Assault/charge, disengagement, control orders, fire policies and speed | Source implemented; source tag to verify; **port incomplete** |
| v0.5.0 | Battlefield & Terrain, camera, roads, rivers, bridges/fords, route/crossing coordination | Source released 2026-10-11; **port incomplete** |
| v0.6.0 | Historical battlefield art, counters, JSON annotations, map variants | Source released 2026-10-13; **port incomplete** |
| v0.6.1 | Smaller counter art, deployment facing | Python follow-up; **port incomplete** |
| v0.7.0 | LOS, observation, concealment, discovery, Fog of War and AI/player awareness | Source partial and not formally released; **port incomplete** |
| v0.7.1 | Strategic/tactical LOD: X, diagonal, dot, star; zoom threshold ~0.65, possible hysteresis | **Future feature** |
| v0.8.0 | SQUARE, multi-contact melee, flank/rear, cohesion, rally, defensive fire, cavalry interactions | **Future feature** |
| v0.9.0 | HQ & brigades, command propagation, officer attachment, autonomy, Ctrl+1..9 groups and fire doctrine | **Future feature** |
| v0.10.0 | Ammunition, supply, flank/reserve/defense AI, terrain-aware decisions and victory objectives | **Future feature** |
| v0.11.0 | Scenario framework/editor, scout maps, multi-map authoring, historical battles, big-map benchmarks | **Future feature** |
| v0.12.0 | Cartographic art, HUD, audio, menu/scenario/battle/results, status overlays | **Future feature** |
| v0.13.0 | Windows Steam demo candidate, tutorial, one polished battle, settings and saves, closed testing | **Future feature** |
| v0.14.0 | Public Steam demo, feedback and iterative stabilization | **Future feature** |
| v0.15.0–0.20.0 | Full-game content, deeper tactics/AI and robust save/performance | **Future feature** |
| v1.0.0 | Full Steam release | **Future feature** |

Legacy versions above are **historical source milestones, not Godot releases**. Do not tag Godot with a Python version number simply because a roadmap row exists. Versioning of the new implementation is a release-management decision for the owner.

## Continuity and dependencies

- Before adding SQUARE, implement/verify the original LINE/COLUMN, formation footprint, fatigue and delayed formation change.
- Before adding information-aware routes, migrate true terrain geometry, route planning, bridge/ford traffic and pause/stop/retreat states. Never expose unknown terrain through route errors.
- Before claiming LOS parity, implement proper raster-mask depth tests and full-footprint concealment, not only target-center checks. Keep target detection authoritative even if fog display updates at a lower rate.
- Before major AI work, preserve the actual enemy detection/target selection contract; source AI must not act on unseen units.
- Before any Steam deliverable, finish demo menu/battle/results/save/settings/performance QA and asset/license inventory.

## Backlog carry-over

The original backlog remains preserved verbatim in the reference snapshot. Priority carry-overs: **BUG-006** forest observer origin, **BUG-005** rotated footprint mismatch, **TECH-005** movement/order ownership, **TECH-007** retired LOS/TCOD prototype review, **FEATURE-014/015** imperfect reconnaissance and knowledge-aware orders, **DESIGN-004/006** true historical terrain integration and separated intelligence. All those are **pending review in the Godot codebase**, regardless of their source issue status. Do not pretend a Python fix has been ported automatically.

## Done definition per port gate

1. Original behavior identified in Python with a source test or design document.
2. Godot mechanic implemented with fixed-step rules and authoritative data boundaries.
3. Headless deterministic regression passes, including failure/edge cases.
4. Manual Windows smoke with camera, input, 0.5×/1×/2×/4× and pause passes.
5. FPS and p95/peak frame time measured on representative map and moving observers.
6. Parity matrix and changelog updated, PR reviewed and merged **by the owner**.
