<!-- Read-only source snapshot captured 2026-11-08 from bookajones/python-strategy main. Python milestone statuses do not apply to this Godot port. -->

# Python Strategy — Development Milestones

> Living roadmap. This document records the **planned scope, sequence, status and acceptance criteria** of development milestones. It can be revised as the project evolves; changes to scope should be explicit rather than silently replacing previous decisions.
>
> **Source of truth:** `MILESTONES.md` = forward plan and milestone progress; `project_context/PROJECT_CONTEXT_v*.md` = technical state, design reasoning, constraints and handoff; `CHANGELOG.md` = changes actually delivered; `BACKLOG.md` = known bugs, technical debt and deferred ideas; `README.md` = setup and current user-facing features.

## Working rules

- Develop in milestone order, completing and verifying a milestone before moving to the next. Exceptions require an explicit decision and an updated plan.
- Keep changes small, testable and reversible. Add regression tests for gameplay behavior; run `python -m pytest` and targeted manual checks.
- Use the statuses **Planned**, **In progress**, **Release candidate**, **Released**, **Deferred**. Do not mark features complete merely because they were discussed.
- The roadmap is provisional: release numbers express a sequence, **not** delivery dates or guarantees. Scope can be split into minor milestones when appropriate.
- Each release should have a clear acceptance check, an updated changelog and a Git tag after tests pass.
- Track art, sound, UI, performance and testing continuously rather than postponing all of them to one late release.
- Track every confirmed bug, deferred improvement and non-trivial design uncertainty in `BACKLOG.md` under a **stable ID**. Reference IDs from milestones; do not duplicate full descriptions.
- At the beginning and end of each milestone, review backlog items assigned to that version; when deferred, always record a new target or mark `Unscheduled`.
- Mark backlog entries `Done` only after implementation and relevant verification; update the changelog for shipped changes.

## Milestone overview

| Milestone | Theme | Status |
| --- | --- | --- |
| v0.1.0 | Initial tactical prototype | Released / historical |
| v0.2.0 | Fatigue and Morale Foundation | Released / historical |
| v0.3.0 | Code & Test Foundation | Released / historical |
| v0.4.0 | Orders & Combat Control | Implemented; final Git tag status to verify |
| **v0.5.0** | **Battlefield & Terrain** | **Released — 2026-10-11 (`83c5ff3`)** |
| **v0.6.0** | **Historical Map Art & Rendering** | **Released — 2026-10-13** |
| v0.6.1 | Counter Scale & Deployment Polish | Planned |
| v0.7.0 | Line of Sight & Battlefield Awareness | Planned |
| v0.8.0 | Formations & Advanced Combat | Planned |
| v0.9.0 | Command & Control | Planned |
| v0.10.0 | Logistics, Ammunition & Tactical AI | Planned |
| v0.11.0 | Historical Scenarios & Scenario Framework | Planned |
| v0.12.0 | Art, Audio & Game Presentation | Planned |
| v0.13.0 | Steam Demo Candidate | Planned |
| v0.14.0 | Steam Demo Release | Planned |
| v0.15.0–v0.20.0 | Full Game Development | Planned |
| v1.0.0 | Steam Full Release | Planned |

## v0.1.0–v0.4.0 — Foundations and combat prototype

Detailed historical delivery is recorded in `CHANGELOG.md`.

- **v0.1.0:** basic selection, movement, formations, ranged combat, melee, UI and victory conditions.
- **v0.2.0:** fatigue, morale, routing and foundational debug controls.
- **v0.3.0:** pytest, deterministic randomness, gameplay rules and logging foundations.
- **v0.4.0:** explicit infantry assault/cavalry charge, controlled disengagement, emergency melee facing, independent automatic attack/fire behavior, orders/waypoints, game-speed and debug testing improvements.

**Release housekeeping:** confirm that the `v0.4.0` tag exists, reconcile release status in README/context, and retain known limitations rather than expanding its scope.

---

## v0.5.0 — Battlefield & Terrain

**Goal:** progress from a small fixed-screen test arena to a larger battlefield where geography shapes tactics.

**v0.5 acceptance review (2026-10-11):** Core battlefield, terrain, crossings and camera features have passed automated regression tests and targeted manual smoke tests. The v0.5.0 release was verified and tagged on 2026-10-11 (`v0.5.0`, commit `83c5ff3`).

- [x] Separate **world** coordinates from **screen** coordinates in input, rendering, selection and order indicators.
- [x] Implement camera panning, zooming and centering on a unit/group (`C` key).
- [x] Support maps substantially larger than the viewport and different **startup-configured** display resolutions (manual check at 1600 × 900). Runtime window resizing is deferred to later presentation/settings work.
- [x] Define reusable terrain types and map-data representation.
- [x] Create a fictional test map with a river, bridges, fords, hills, villages, forests, roads and marshes.
- [x] Apply terrain effects to movement speed, fatigue and maneuverability where implemented. Advanced terrain combat modifiers/cover remain future work (v0.7–v0.8, as applicable).
- [x] Add impassable river obstacles and limited, traversable bridge/ford crossing points.
- [ ] Implement explicit elevation/height data and its tactical implications; deferred to v0.7 LOS/high-ground work, with combat effects considered in v0.8.
- [x] Make roads and bridges matter for movement and route selection.
- [x] Introduce basic route finding respecting terrain and crossings, including group orders and conflicting traffic, without full tactical AI redesign.
- [x] Keep counter/frontage previews, order arrows and selection accurate through zoom/pan (manual acceptance).
- [x] Experiment with staff-map, SVG, raster and pixel-art previews (exploration only; historical map art pipeline deferred to v0.6.0).
- [x] Add camera, coordinate, movement, crossing and terrain regression tests; pass targeted manual battlefield smoke tests.
- [x] Record a basic performance baseline: ~60 FPS idle, ~50 FPS with several moving units, ~40–50 FPS with combat and camera movement, no reported stutter. This is **not** a large-battle benchmark.

**Crossing acceptance:** Bridge and ford stop/wait/retreat/resume; group infantry+cavalry traversal; and opposing-direction orders were manually checked. Automated regressions cover crossing traffic, reservation cleanup, route completion, melee interruptions and disengagement. See `BUG-002`, `BUG-003`, `BUG-004` in `BACKLOG.md` for closure evidence.

**Known limitations and deliberately deferred scope:** Dynamic window resizing and settings UI are later presentation/demo work (v0.12–v0.13); explicit terrain elevation and LOS are v0.7 work; advanced cover, high-ground and combat effects are later combat/LOS work (v0.7–v0.8); historical map art is v0.6. Crossing traffic does not promise FIFO/fair scheduling or measured large-scale throughput; the movement/order architecture cleanup remains tracked as `TECH-005`. Periodic FPS/frame-time logging is `TECH-006` (v0.11). These are not claimed as implemented v0.5 features.

**Release verification:** final automated tests and manual smoke checks passed; documentation was reviewed, the repository was clean after commit, and annotated tag `v0.5.0` was created on commit `83c5ff3`. This later documentation-only correction does not move the release tag.


## v0.6.0 — Historical Map Art & Rendering

**Goal:** Introduce a historical battlefield illustration, a reusable
map-art workflow and a consistent family of historical unit counters,
without changing existing combat and movement mechanics.

**Status:** Released — 2026-10-13.
Automated regression: 858 passed. Manual smoke checks passed.

### Delivered

- [x] Established a raster PNG-based historical map-art workflow
  using JSON terrain annotations, masks and editor tools.
- [x] Added a historical battlefield loader and standalone preview,
  including camera navigation and terrain/art comparison.
- [x] Added a playable historical map option:
  `python main.py --map historical`.
- [x] Preserved the original terrain-enabled test battlefield:
  `python main.py --map test`.
- [x] Added a separate temporary historical battle deployment,
  independent of the test battlefield scenario.
- [x] Implemented eight historical cardboard-style unit counters:
  infantry, cavalry, artillery and HQ for both factions.
- [x] Applied navy/blue friendly and burgundy/red enemy accents,
  with clear front markers.
- [x] Added dynamic strength bars and selection highlighting.
- [x] Rendered counters directly in screen space, with cached
  scaled artwork and camera-aware rotation.
- [x] Kept visual counter dimensions separate from mechanical
  formation footprints.
- [x] Preserved legacy unit rendering as a fallback.
- [x] Added automated counter asset/mapping tests and renderer
  cache tests.
- [x] Verified counter visibility and basic movement, selection,
  camera controls and orders on the historical battlefield.
- [x] Prevented the historical camera from zooming out beyond
  the map boundaries.

### Known limitations and deferred work

- The playable historical map currently uses an obstacle-free
  logical BattlefieldMap. Its illustrated forests, rivers, roads,
  bridges and fords do not yet affect gameplay.
- Historical annotation geometry is available through the loader,
  editor and standalone preview, but generalized polygon collision,
  route planning and crossing traffic are deferred (DESIGN-004).
- Terrain annotations are provisional and require further editing.
- Historical counters remain too large relative to map details.
  Map-specific scale and consistent previews are tracked in
  DESIGN-005 for v0.6.1.
- Initial facing is not configurable through scenario data.
  This is tracked in FEATURE-010 for v0.6.1.
- HQ counters are visual prototypes, not implemented command units.
  Command hierarchy and officers belong to FEATURE-007 in v0.9.
- Commander insignia overlays and further UI refinements remain
  outside the completed v0.6.0 scope.
- Detailed performance profiling and final gameplay/art alignment
  remain future work; no completed polygon-terrain gameplay
  integration is claimed.

### Release verification

- Release verification: 858 automated tests passed; compilation successful.
- Manual smoke tests: passed.
- Release tag: `v0.6.0`.

## v0.7.0 — Line of Sight & Battlefield Awareness

**Goal:** units and commanders no longer have perfect information.

- [ ] Implement terrain- and distance-dependent visibility, including height.
- [ ] Block/restrict observation with hills, forests and buildings.
- [ ] Distinguish detection/observation from eligibility for ranged fire.
- [ ] Implement discovery, loss of contact and reacquisition.
- [ ] Keep authoritative true terrain, unit observation, and player-side knowledge as separate concepts (DESIGN-006).
- [ ] Limit automatic AI target selection to legitimately detected targets; also filter rendering and mouse targeting.
- [ ] Maintain separate per-side **currently visible** (transient) and **discovered terrain** (persistent) state. An unseen enemy disappears, even over already-discovered terrain.
- [ ] Prepare a fog/discovery compositor interface capable of showing a recon sketch on unknown terrain and true-map artwork on discovered terrain (FEATURE-014). Do not promise the full scenario editor in v0.7.
- [ ] Record last-seen enemy data only if needed for future command/intelligence mechanics; displaying ghost counters is deferred, not required for v0.7.
- [ ] Test LOS edge cases, hidden units, high ground, rediscovery, mouse selection, AI knowledge and information leaks.
- [ ] **BUG-006 / A15.4.4b-LOS-01:** Diagnose restricted observation when the observer itself is inside a forest. Verify forest-interior range, edge-of-forest outward sight, occlusion through remaining forest depth, and consistency between terrain Fog of War cells and enemy-counter detection. Add deterministic tests before modifying LOS; observed during manual fog visualization (2026-10-14).

**Acceptance:** a hidden enemy cannot be rendered, clicked, or targeted through true engine coordinates; terrain discovery persists after friendly units leave. Visibility/fog and terrain knowledge are distinct; the design supports an optional scenario reconnaissance sketch.

### Deferred dependency — knowledge-aware orders (FEATURE-015)

**Target:** After v0.7, scheduled only after reviewing the polygon terrain/crossing dependency (DESIGN-004). Not part of the v0.7 release gate.

- [ ] Accept commands to coordinates on the scout sketch without exposing unknown true-map obstacles through immediate rejection, route previews or omniscient detours.
- [ ] Keep collision, roads, crossing availability and actual movement governed EXCLUSIVELY by true terrain annotations.
- [ ] On physically encountering previously unknown obstacles, reveal local terrain, stop/report or replan only from information available to the unit.
- [ ] Regression-test false sketch roads/bridges, missing rivers, no-safe-route behavior, crossing traffic, disengagement and non-leaking status messages.

**Invariant:** Scout/recon JSON is presentation and incomplete knowledge, never an alternate physics map. Plan routes against knowledge; execute and validate against truth.


## v0.7.1 — Tactical Map Readability & Counter LOD

**Status:** Planned.

**Goal:** Make units recognizable at different camera zoom levels while preserving gameplay geometry.

- [ ] Introduce two counter Level of Detail (LOD) modes:
  - Strategic: simplified military symbols at distant zoom.
  - Tactical: existing historical PNG counter assets at closer zoom.
- [ ] Infantry: rectangle with X.
- [ ] Cavalry: rectangle with diagonal line.
- [ ] Artillery: rectangle with dot.
- [ ] HQ: rectangle with star.
- [ ] Preserve faction colors: navy/gold for friendly units, burgundy for enemies.
- [ ] Preserve a readable front-facing indicator in both modes.
- [ ] Add a pure function for determining LOD from camera zoom.
- [ ] Start with provisional thresholds: symbolic below 0.65, detailed at or above 0.65.
- [ ] Consider hysteresis (e.g. 0.60 / 0.70) to prevent switching near the threshold.
- [ ] Keep visual counter dimensions and mechanical unit footprints independent.
- [ ] Ensure LMB selection, drag selection, enemy targeting and RMB orders use the currently displayed visual bounds.
- [ ] Keep selection outlines, previews and strength indicators consistent with the active LOD.
- [ ] Render simplified symbols using Pygame primitives initially; do not require additional PNG assets.
- [ ] Keep LOD changes rendering-only: no effect on movement, combat, LOS, unit state or determinism.
- [ ] Add automated tests for thresholds, rotation, selection and compatibility with existing counters.
- [ ] Run manual regression on test and historical maps at minimum, intermediate and maximum zoom.
- [ ] Check rendering performance with larger numbers of units.

**Implementation notes:**
Introduce an independent counter LOD helper and extend the existing counter rendering pipeline rather than modifying Unit gameplay logic. Determine LOD from camera.zoom. Reuse counter_selection geometry and avoid introducing new mechanical footprints. Cache static visual assets if necessary. Begin with two levels; evaluate a third level or animated transitions only after manual readability tests.

**Acceptance:** Zooming out replaces detailed counters with readable tactical symbols; zooming in restores existing artwork. Selection, facing, orders and gameplay mechanics remain unchanged.

**Backlog:** FEATURE-013.



## v0.8.0 — Formations & Advanced Combat

**Goal:** frontage, cohesion and multi-directional contact create meaningful tactical decisions.

- [ ] Improve line/column mechanics and implement **square** formation.
- [ ] Model formation frontage/depth tactically while keeping map counters fixed-size unless a deliberate design revision is approved.
- [ ] Make formation changes costly or unsafe under pressure.
- [ ] Replace one-to-one melee with multi-contact melee, **incrementally and test-first**.
- [ ] Support front, left/right flank and rear contacts based on actual counter geometry.
- [ ] Share defensive capacity among attackers; avoid unrealistic damage multiplication and stacking.
- [ ] Add flank/rear morale effects and multi-contact disengagement.
- [ ] Improve cavalry charges, charge preparation, defensive fire and anti-cavalry square interactions.
- [ ] Introduce disorder/suppression and separate **cohesion** from morale/fatigue.
- [ ] Model nearby routing/panic effects.
- [ ] Implement **rallying and reforming** after routing, with safety/time/strength conditions, vulnerability and lasting impairment. Routed-off-map units do not automatically return.
- [ ] Balance and regression-test melee lifecycle, routing, charge impacts and all contact cleanup paths.

**Acceptance:** two attackers can flank one defender without invalid state; prepared infantry can meaningfully resist cavalry; routed units may recover only under defined conditions.

**Scope caution:** this is large. Split into v0.8.x internal increments rather than one massive refactor.

- [ ] Investigate visual/mechanical footprint mismatch and
  rotated contact geometry (BUG-005).
- [ ] Ensure melee and charge contact remain consistent with
  formation geometry, crossing traffic and disengagement.


## v0.9.0 — Command & Control

**Goal:** tactical orders and subordinate initiative replace constant micro-management.

- [ ] Model **one unique Commander-in-Chief HQ per army/side** as the root of the command graph, with a visually distinct HQ counter. The HQ need not directly contact every frontline unit.
- [ ] Model subordinate brigade commanders as **officer entities assigned/attached to existing troop units** (infantry, cavalry or artillery, including escorted cavalry), shown by a small badge on that unit's normal counter. Do not force a separate on-map counter per brigade commander; allow transfer, loss and succession later.
- [ ] Model explicit army > brigade > subordinate-unit hierarchy and persistent organizational assignments independent of keyboard selection groups.
- [ ] Add **UI control groups** (`Ctrl+1`–`Ctrl+9` to store selection, `1`–`9` to recall; optionally double-press to center), separate from formal brigade hierarchy and command rules.
- [ ] Add commanders, command groups and hierarchy.
- [ ] Propagate orders automatically through the appropriate commander chain/relay nodes; use distance, terrain and interruption for delay/availability rather than hard-radius instant paralysis. Keep couriers abstract, not individually micro-managed.
- [ ] Introduce command range/availability and order propagation delays.
- [ ] Reconnaissance reports may be delayed or filtered through the command chain; extend immediate side-shared intelligence from v0.7 only when tested (DESIGN-006).
- [ ] Preserve last orders and sensible local autonomy when contact is lost; automate brigade-commander positioning/follow behavior with manual override, and support command loss and succession without freezing the army.
- [ ] Let the player issue commands to individual units directly in the UI while the game applies chain-of-command delivery rules transparently; avoid mandatory click-through via HQ.
- [ ] Support group orders: march, attack, defend, hold, retreat.
- [ ] Implement bounded unit autonomy and reactions to threats, fire and flanking.
- [ ] Consolidate ranged fire behavior into **Fire at Will / Return Fire / Hold Fire** with explicit priority rules.
- [ ] Keep **Attack at Will** separate as permission to initiate melee.
- [ ] Ensure Hold Fire stops ranged responses until canceled, while every unit can defend itself in melee.
- [ ] Resolve whether an explicit fire order cancels Hold Fire (design decision required).
- [ ] Display current orders and fire policy conspicuously, especially Hold Fire.
- [ ] Avoid automatic turning or target-switching that undermines a deliberate player-facing order.
- [ ] Improve formation-front previews, including deferred enemy debug-mode stationary rotation visualization.
- [ ] Account for experience, morale and cohesion when handling orders.

**Acceptance:** a commander can assign coherent orders to groups and understand why units act, wait or refuse to fire.

## v0.10.0 — Logistics, Ammunition & Tactical AI

**Goal:** endurance, resources and credible battlefield decisions matter.

- [ ] Track infantry and artillery ammunition and expenditure.
- [ ] Provide reliable per-unit resource values for a future ammunition status overlay; overlay rendering/UI is tracked in v0.12 (FEATURE-009).
- [ ] Introduce basic ammunition types and resupply sources.
- [ ] Apply shortages to combat effectiveness and choices.
- [ ] Make AI use roads, fords, bridges, cover and high ground.
- [ ] Add positional defense, flanking maneuvers and reserves.
- [ ] Make AI account for morale, fatigue, ammunition and withdrawal opportunities.
- [ ] Add scenario goals other than annihilation: hold, seize, delay, break through, evacuate.
- [ ] Run tactical AI evaluations across varied terrain and force compositions.

**Acceptance:** AI demonstrates at least several recognizable plans and reacts to resource shortages instead of only charging the closest enemy.

## v0.11.0 — Historical Scenarios & Scenario Framework

**Goal:** make historical content primarily data-driven instead of hard-coded.

- [ ] Define scenarios using maps, unit definitions, sides, deployments, goals and seeds.
- [ ] Add historical weapons, unit strengths and parameters with documented balance choices.
- [ ] Support time/position/loss-based victory conditions and scenario events.
- [ ] Provide tools for placing units and editing scenario configurations.
- [ ] Support scenario-authored reconnaissance JSON using the true terrain annotation schema, including accurate, incomplete and deliberately incorrect scout sketches (FEATURE-014).
- [ ] Extend the editor with true-terrain versus reconnaissance-terrain authoring; preserve map/scenario separation and avoid edits to authoritative terrain during play.
- [ ] Add a Terrain Editor Map Manager for selecting maps,
  importing PNG/JPG assets and managing terrain annotations
  independently of scenario deployments (FEATURE-011).
- [ ] Expand the fictional test map into repeatable tactical test cases.
- [ ] Build several small historical/history-inspired battles before larger ones.
- [ ] Prepare for future large battles such as **Maiwand**.
- [ ] Profile/test battles with more formations and larger battlefields.

**Acceptance:** a meaningful new battle can be authored predominantly in data files and played start-to-finish.

## v0.12.0 — Art, Audio & Game Presentation

**Goal:** unify prototypes into a recognizable 19th-century military-map visual identity.

- [ ] Refine staff-map terrain, ink/cartographic details and military counter presentation.
- [ ] Improve facing/order/LOS/combat readability and HUD.
- [ ] Integrate infantry volleys, artillery, cavalry and environmental audio.
- [ ] Implement basic main menu, scenario selection,
  pause menu and battle-results screens (FEATURE-012).
- [ ] Separate menu, scenario-selection and battle states
  from gameplay simulation and rendering.
- [ ] Refine help, unit inspection, display scaling and accessibility.
- [ ] Add a bottom unit-inspection panel: selected-unit details and, later, compact multi-selection unit tiles; do not crowd the battlefield counters with detailed numbers.
- [ ] Add optional dedicated map overlays for ammunition, morale, fatigue, and command status (green/yellow/red and neutral/not-applicable where appropriate); use colored outlines/markers rather than obscuring the base counter. Decide keybindings around existing F1/F8 controls when implementing.
- [ ] Consider contextual tooltip, flank/threat indications and status badges as optional later readability improvements.
- [ ] Polish visual/audio prototypes started **before** this milestone.

**Acceptance:** the game has a consistent presentation and new players can identify formations, fronts and active orders without developer explanations.

## v0.13.0 — Steam Demo Candidate

**Goal:** deliver a self-contained, externally testable desktop demo.

- [ ] Polish at least one historical scenario.
- [ ] Deliver tutorial covering navigation, orders, formation, combat, terrain and morale.
- [ ] Complete menu → scenario → battle → results flow.
- [ ] Add graphics/audio/control settings, suitable resolution scaling and basic save/resume.
- [ ] Package a Windows desktop build that does not need a local Python installation.
- [ ] Provide opt-in crash diagnostics and privacy-conscious log/error submission (provider TBD, e.g. Rollbar).
- [ ] Test installation, stability, performance and settings on other computers.
- [ ] Run closed external playtests and prioritize blocker fixes.
- [ ] Prepare basic Steam store materials.

**Acceptance:** external testers can install, learn, play, finish and report issues without developer assistance.

## v0.14.0 — Steam Demo Release

**Goal:** publish and improve the public Steam demo.

- [ ] Release the public demo on Steam.
- [ ] Collect user feedback, crash reports and usability observations.
- [ ] Improve onboarding, tactical UI, performance and stability.
- [ ] Refine AI and combat balance using playtest evidence.
- [ ] Deliver measured demo updates.

**Acceptance:** the public demo is stable and maintains an actionable feedback backlog.

## v0.15.0–v0.20.0 — Full Game Development

**Goal:** expand content and depth without sacrificing reliability.

- [ ] More historical maps/scenarios and larger formations/battles.
- [ ] Deeper tactical AI and command structures.
- [ ] Broader morale, logistics, intelligence and battlefield systems where justified.
- [ ] More complete art/audio, accessibility and onboarding.
- [ ] Performance optimization and robust saved-game compatibility.
- [ ] Full-game content completion and release validation.

## v1.0.0 — Steam Full Release

**Goal:** release the complete, stable game.

- [ ] Curated polished historical scenario set.
- [ ] Complete tutorial, UX and core tactical mechanics.
- [ ] Stable enemy AI, command systems and save/settings functionality.
- [ ] Selected Steam integration features, potentially including achievements.
- [ ] Release QA, deployment and post-launch support plan.

---

## Continuous tracks (every milestone)

| Track | Approach |
| --- | --- |
| Testing | Keep `pytest` green; add targeted regressions and manual smoke coverage for each feature. |
| Performance | Profile progressively larger maps and unit counts; avoid introducing fixed-step timing without evidence and bounded design. |
| Interface | Improve readability and control affordances when a mechanic is introduced, not years later. |
| Art & audio | Historical map art is parked for v0.6; general art/audio polishing continues in v0.12. |
| Architecture | Refactor incrementally with tests; keep simulation, input and rendering boundaries clear. |
| Documentation | Update `MILESTONES.md` for planning, `BACKLOG.md` for tracked issues, `CHANGELOG.md` for delivery and `PROJECT_CONTEXT` for decisions/technical handoff. |
| Distribution | Desktop/Steam first; browser build is only an optional compatibility/sharing experiment. |

## Tracked issues and deferred decisions

The detailed, authoritative issue register is [`BACKLOG.md`](BACKLOG.md). It contains stable IDs, status, priority, milestone target, evidence and resolution criteria. This roadmap links only the issues relevant to each milestone.

| Milestone / review point | Backlog IDs | Purpose |
| --- | --- | --- |
| v0.5 closeout | `BUG-002`, `BUG-003`, `BUG-004` | Crossing, group routing and opposing traffic resolved in tested cases |
| Next cleanup | `TECH-005` | Incremental movement/order state ownership refactoring |
| After v0.7 acceptance / before v0.8 | `TECH-007` | Cleanup retired tcod/FOV and older LoS experiments, dead code and dependencies; keep regression coverage |
| v0.9 | `BUG-001`, `TECH-001` | Enemy-facing preview and developer input consistency |
| v0.5 or later, after profiling | `TECH-002`, `TECH-003` | Variable timestep performance; input architecture |
| v0.8 | `FEATURE-001`, `FEATURE-002`, `FEATURE-003` | Multi-contact melee, rally and cohesion |
| v0.9 | `FEATURE-004`, `DESIGN-001` | Fire policy and priority between Hold Fire and explicit attack |
| v0.7 / v0.11 | `FEATURE-014`, `DESIGN-006` | Visibility/discovery architecture; scout JSON and authoring later |
| After v0.7 (Unscheduled) | `FEATURE-015`, `DESIGN-004` | Knowledge-aware planning depends on true polygon terrain integration |
| v0.11 | `TECH-006` | Low-frequency FPS and frame-time logging |
| v0.11–v0.13 | `FEATURE-005`, `DESIGN-002` | Save/load foundations; choice of Steam demo scenario |
| Unscheduled | `TECH-004` | Legacy formation geometry cleanup |

**Milestone closure gate:** review all issues targeted for the version; either resolve them with evidence, or deliberately move them to a new target with a reason. No silent disappearing tasks.

## Change log for this roadmap

- **2026-10-14 — Post-v0.7 repository cleanup gate.** Added TECH-007: audit and remove obsolete LoS/FOV experiments and dependencies after v0.7 acceptance, before starting v0.8, while preserving tests and local map assets.

- **2026-10-14 — Reconnaissance intelligence design.** True terrain and optional imperfect scout JSON share the annotation schema. Terrain discovery is persistent; spotting enemies is transient. Movement physics always uses true terrain. Non-omniscient order planning depends on later terrain/crossing integration; see FEATURE-014, FEATURE-015, DESIGN-006.

- **2026-10-11 — v0.5 acceptance review.** Core terrain, camera, crossing and manual performance acceptance recorded; explicit elevation, advanced combat modifiers and dynamic window resizing retargeted. BUG-002/003/004 closed in backlog; TECH-005 and TECH-006 remain future work. Release status unchanged pending final QA/tag.

- **2026-10-11 — Scope realignment.** Complete terrain gameplay and crossings in v0.5, move historic map art to v0.6 and shift existing later milestones one minor version. Documentation update only, no release status implied.

- **2026-10-10 — Added tracked backlog integration.** Stable IDs, milestone cross-references and closure review gate.
- **2026-10-10 — Initial consolidated plan.** Merges the terrain-first milestone sequence with later multi-unit melee, cohesion/rally, fire-control policy, command systems, scenario tools and Steam-readiness work. Statuses are provisional and should be revised only when verified against the repository and releases.
