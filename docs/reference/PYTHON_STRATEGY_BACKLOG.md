<!-- Read-only source snapshot captured 2026-11-08 from bookajones/python-strategy main. Python milestone statuses do not apply to this Godot port. -->

# Python Strategy — Backlog & Known Issues

> This is the **single register** of known defects, technical debt, deferred feature ideas and unresolved design choices. `MILESTONES.md` determines *when* work is planned; this file records *what remains* and *why*. Do not treat proposed features as implemented.

## Rules

- Every item keeps its ID permanently, even if its title, priority or target changes.
- Prefixes: `BUG` = observed defect; `TECH` = technical debt/risk; `FEATURE` = planned improvement; `DESIGN` = decision requiring investigation.
- Status: `Open`, `Planned`, `In progress`, `Blocked`, `Done`, `Won't do`.
- Priorities: `P0` blocks normal play/release; `P1` major problem; `P2` useful fix; `P3` polish.
- Target may be a version (`v0.8`), `Next cleanup` or `Unscheduled`. It is provisional, **not** a deadline.
- Each item has acceptance criteria and an evidence note; record the test/commit or milestone when closing.
- Never delete completed entries: move them into `Resolved` (or leave their entry with `Done`).
- At milestone start: inspect all items targeting it. At milestone closure: explicitly resolve or retarget remaining items.
- When a new issue is observed during development, add it here **immediately**, even if no fix is planned yet.

## Index

| ID | Type | Status | Priority | Target | Short description |
| --- | --- | --- | --- | --- | --- |
| BUG-001 | Bug | Open | P3 | v0.9 | Enemy debug-facing preview lacks readable counter/front |
| TECH-001 | Tech | Open | P2 | v0.9 | Debug-mode controls inconsistent across input paths |
| TECH-002 | Tech | Open | P2 | After v0.5 profiling | Variable-delta timing; earlier fixed-step experiment stuttered |
| TECH-003 | Tech | Open | P2 | v0.5 onward | Input/order handling in `main.py` is monolithic |
| TECH-004 | Tech | Open | P3 | Unscheduled | Audit legacy formation geometry multipliers |
| BUG-002 | Bug | Done | P1 | v0.5 | Interrupted movement and reverse orders in crossings |
| BUG-003 | Bug | Done | P1 | v0.5 | Group crossing movement bypasses crossing planner and can block on riverbanks |
| BUG-004 | Bug | Done | P1 | v0.5 | Opposing friendly units pass through each other on narrow crossing |
| TECH-005 | Tech | In progress | P1 | Next cleanup | Movement/order state ownership and architecture audit |
| TECH-006 | Tech | Planned | P3 | v0.11 | Periodic FPS/frame-time summaries in structured logs |
| FEATURE-006 | Feature | Planned | P2 | v0.6 | Historical map art and terrain-coordinate alignment |
| FEATURE-001 | Feature | Planned | P1 | v0.8 | Multi-contact melee and flank/rear effects |
| FEATURE-002 | Feature | Planned | P1 | v0.8 | Rally and reforming after rout |
| FEATURE-003 | Feature | Planned | P2 | v0.8 | Cohesion and disorder/suppression model |
| FEATURE-004 | Feature | Planned | P1 | v0.9 | Fire-policy states and visual feedback |
| FEATURE-005 | Feature | Planned | P1 | v0.11–v0.13 | Save/load foundation and stable save format |
| DESIGN-001 | Design | Open | P2 | v0.9 | Direct attack versus Hold Fire precedence |
| DESIGN-002 | Design | Open | P2 | v0.11–v0.13 | Choose Steam demo historical scenario |
| FEATURE-007 | Feature | Planned | P1 | v0.9 | HQ, attached brigade commanders, command relay and succession |
| FEATURE-008 | Feature | Planned | P2 | v0.9 | Keyboard control groups independent of army hierarchy |
| FEATURE-009 | Feature | Planned | P2 | v0.12 | Unit panel, information overlays and contextual tactical UI |
| DESIGN-003 | Design | Open | P2 | v0.6 | Board-game counter asset sizes, readability and footprint separation |
| DESIGN-004 | Design | Open | P1 | After v0.6 / Unscheduled | Polygonal terrain obstacles and generalized crossing planner |
| DESIGN-005 | Design | Done | P2 | v0.6.1 | Historical map counter scale and visual footprint |
| FEATURE-010 | Feature | Done | P2 | v0.6.1 | Configurable initial unit facing in scenario data |
| FEATURE-011 | Feature | Planned | P2 | v0.11 | Terrain Editor Map Manager: map selection, asset import and annotation management |
| FEATURE-012 | Feature | Planned | P2 | v0.12–v0.13 | Main menu, scenario selection and game flow |
| BUG-005 | Bug | Open | P2 | v0.8 | Visual and mechanical footprint mismatch during melee and charge; investigate rotated collision bounds |
| BUG-006 | Bug | Open | P1 | v0.7 | Observer inside forest reveals unexpectedly little terrain (A15.4.4b-LOS-01) |

| TECH-007 | Tech | Planned | P2 | After v0.7, before v0.8 | Repository cleanup: retired LoS/FOV experiments and dependencies |
| FEATURE-013 | Feature | Planned | P2 | v0.7.1 | Zoom-dependent counter LOD: strategic symbols and detailed historical assets |
| FEATURE-014 | Feature | Planned | P1 | v0.7 / v0.11 | Reconnaissance sketch JSON, discovered terrain mask and true-map compositing |
| FEATURE-015 | Feature | Planned | P1 | After v0.7 / Unscheduled | Knowledge-aware orders and movement without revealing unknown obstacles |
| DESIGN-006 | Design | Open | P1 | v0.7 architecture review | True terrain versus scout knowledge, discovery, collision and information leaks |

## Deferred design notes agreed 2026-10-13

### FEATURE-007 — HQ and brigade command hierarchy
- **Target:** v0.9; P1; Planned.
- **Design:** Exactly one Commander-in-Chief HQ per army/side as root. Subordinate officers can attach to ordinary troop units, represented by a small command badge, not a new base troop type; officers remain separate logical entities so they can transfer or be replaced. Explicit brigade affiliation is independent of Ctrl-number selection groups.
- **Gameplay:** Abstract courier/relay connectivity, delayed orders, local autonomy, automatic positioning/follow for subordinate officers, optional manual placement, command interruption and succession. Avoid constant manual movement or strict distance-circle cutoffs.
- **Acceptance:** Player issues orders normally; delivery time/availability reflects the chain; HQ and brigadiers matter without burdensome micromanagement.

### FEATURE-008 — Numbered selection groups
- **Target:** v0.9; P2; Planned.
- **Design:** Ctrl+1..9 saves the current unit selection; 1..9 restores it; consider double-tap recentering. Selection groups do not create brigades or bypass command propagation.
- **Acceptance:** Persistent during a battle, deterministic on unit destruction, no clash with existing orders/shortcuts.

### FEATURE-009 — Unit panel and information overlays
- **Target:** v0.12; P2; Planned. Underlying ammunition model in v0.10.
- **Design:** Detailed selected-unit status in a bottom panel (optionally multi-unit mini-tiles). Optional red/yellow/green status views for ammunition, morale and fatigue, and command/communication; preserve faction/front identification while overlay active. Consider tooltips and threat/exposure overlay as future options. Resolve keyboard assignments without colliding with F1/F8.
- **Acceptance:** Clear status without permanent counter clutter; neutral state for unavailable metrics, appropriate disabled handling.

### DESIGN-003 — Historical counter graphics and proportions
- **Target:** v0.6; P2; Open until in-game visual acceptance.
- **Decision:** Historical 19th-century parchment/cardboard, restrained beveled depth and shadows (not tall), polished non-flat texture; six base branch/side visuals plus unique HQ identity. Blue/navy friendly and burgundy enemy. Infantry crossed muskets, cavalry horse/sabre (not another X), artillery anatomically sensible field gun (wheel axle below barrel); front edge unmistakable. Large PNG source texture with dynamic insignia/strength/selection; avoid baked-in statistics. Prototype 72×36 versus 64×32 world pixels at multiple zoom levels; visual size and mechanical footprint remain separate until regression-tested.

### DESIGN-004 — Generalized obstacles and polygon crossings
- **Target:** After v0.6; Unscheduled pending scope decision; P1.
- **Design:** Obstacles (river, ravine) separate from crossing objects (bridge, ford); river remains continuous underneath a crossing. Bridges may span ravines; do not require a river under every bridge. Current legacy movement/crossing planners assume rectangles; point-segment traversal helper is groundwork only and must not be presented as full formation footprint, routing or traffic-controller integration. Defer unit-width checks, passability routes, traffic reservations, crossing destruction and polygon gameplay until dedicated acceptance tests.


### DESIGN-005 — Historical counter scale

- **Target:** v0.6.1; P2; Done.
- **Problem:** Counters are visually too large relative to
  the historical map, including the tested 48x24 size.
- **Scope:** Introduce map-specific visual counter scaling.
  Keep selection, facing markers, deployment previews and
  strength bars visually consistent.
- **Constraint:** Do not change mechanical unit footprints,
  combat ranges or collision geometry as part of this task.
- **Acceptance:** Readable counters at normal and zoomed views,
  consistent previews, no gameplay geometry regressions.

### FEATURE-010 — Initial unit facing

- **Target:** v0.6.1; P2; Done.
- **Problem:** Units currently spawn facing the same direction.
- **Scope:** Allow scenario data to define initial facing
  independently for each unit.
- **Implementation:** Introduce an optional `angle` field
  in scenario unit definitions, with backward-compatible defaults.
- **Acceptance:** Units spawn with their configured facing;
  existing test scenarios retain their previous behavior.

### TECH-007 — Repository cleanup after v0.7

- **Status:** Planned; **Priority:** P2; **Target:** after v0.7.0 acceptance and before v0.8.0 work begins.
- **Scope:** Audit experimental `tcod` FOV scripts/adapter/benchmarks, earlier LoS experiments, obsolete generated outputs, dead code, duplicate geometry helpers and temporary assets. Inspect imports and usage before deleting anything. Remove unused dependencies and review third-party license inventory.
- **Keep:** Current production LoS/concealment behavior, meaningful regression tests, useful benchmark baselines, and a short written record of the `python-tcod` spike (decision: do not adopt for now).
- **Safety:** No bulk deletion or automatic cleanup; review candidate files, changes and local untracked/modified map assets first. Keep cleanup changes small and reversible.
- **Acceptance:** A reviewed inventory of keep/remove items; removed code has no live references; `python -m pytest -q` passes; manual smoke tests succeed on test and historical maps; requirements and documentation match retained code. Track deletions in a dedicated cleanup commit.

### BUG-006 — Forest observer has severely restricted visibility

- **Status:** Open; **Priority:** P1; **Target:** v0.7.0 (A15.4.4b-LOS-01).
- **Observed (2026-10-14):** With visual Fog of War enabled on the test map, a friendly unit inside forest appeared to reveal only a very small area around itself. The screenshot and manual report suggest an LOS-observer-origin/forest-penetration issue; the precise cause is not yet verified.
- **Investigate:** LOS rays originating inside forest; permitted visibility within forest; outward observation near the forest boundary; remaining wooded depth; alignment of `get_visible_cells()` with `can_observe_unit()` / detected enemy counters. Avoid assuming a simple fixed-radius or unconditional forest bypass.
- **Acceptance:** Deterministic tests for a deep-forest observer, an observer near the forest edge looking outward, and blocking forest between observer and target. Visual FoW and enemy detection must be consistent with the documented LOS policy, without terrain leaks; verify by manual smoke and check FPS.
- **Evidence:** User screenshot and gameplay report, 2026-10-14; no code fix yet.

## Open items

### FEATURE-014 — Reconnaissance sketch map and discovery layers
- **Targets:** v0.7 establishes visibility/discovery data and rendering boundaries; v0.11 adds scenario-authored reconnaissance JSON and editing tools. Full two-map compositing can be delivered as a focused post-v0.7 increment if too large for v0.7.
- **Core rule:** Each battlefield has authoritative true terrain annotations and optionally a scout/recon JSON using the SAME schema and coordinate system. The scout file may match the truth exactly or intentionally move, omit or invent rivers, roads, hills, forests, villages, bridges and fords. Errors are authored/seeded scenario information, not runtime mutation of the true map.
- **Rendering:** Draw a simplified ink/parchment scout sketch from recon JSON (Pygame primitives); show original true-map PNG within discovered areas. Maintain separate per-side `discovered_terrain` (persistent) and `currently_visible` (transient) masks. Enemy units are rendered/targetable only if currently visible, even in discovered areas. Never draw enemies under a translucent fog overlay.
- **State ownership:** True terrain is authoritative for physical simulation; scout JSON is read-only scenario input. Discovered/visible masks are battle state, never edits to either source JSON. Keep initial fully accurate or already-discovered maps possible for simpler scenarios.
- **Acceptance:** Scenario with intentionally missing river and fictitious road initially shows scout sketch; exploration reveals the real terrain persistently and does not reveal unseen enemies. No true-map terrain information leaks through visuals, selection or commands. Deterministic tests and both-map regressions.

### FEATURE-015 — Knowledge-aware movement and obstacle discovery
- **Target:** After v0.7; Unscheduled until DESIGN-004 terrain integration and planner audit define safe scope.
- **Core rule:** Units ALWAYS move/collide/cross according to TRUE map annotations, irrespective of what the scout sketch says. The player can give orders anywhere on the visible sketch, including a location hiding a real river. Unknown obstacles must not cause omniscient immediate route rejection or automatic omniscient detours.
- **Design direction:** Separate order acceptance and tentative planning using available knowledge from physical movement validation using true terrain. During execution, local reconnaissance reveals real obstacles; halt, report, retry or replan using only discovered information. Expose meaningful order status without revealing unknown map objects.
- **Existing limitation:** Current movement/crossing code can reject `no_safe_route` / `impassable_destination` using real terrain. Historical annotated polygon obstacles are NOT yet active in normal historical gameplay (DESIGN-004). Do not describe this feature as currently working.
- **Acceptance:** Issuing an order toward an unknown river does not reveal it or leak a safe crossing; unit can approach, discovers the river locally, and respects real blocking/crossing rules. Roads/bridges falsely drawn on recon map confer NO movement permissions. Crossing queues, disengage, route cleanup and combat tests stay green.

### DESIGN-006 — Terrain intelligence and non-omniscient order semantics
- **Target:** v0.7 architecture review; P1; Open.
- **Decisions to document/test:** Sharing reconnaissance among friendly units immediately in v0.7 versus delayed reporting in v0.9; line-of-sight radius and discovered-terrain reveal granularity; treatment of unseen obstacles at order time; whether units stop versus locally replan; road/bridge/ford discovery; fog/debug toggles and tests for indirect information leaks.
- **Non-negotiable invariants:** True terrain geometry solely controls gameplay physics; recon and true JSON share schema and pixel coordinates; unit-level observation and player knowledge are separate from ground truth; spotting enemy units is not equivalent to terrain discovery. Map and scenario are separate resources.



### FEATURE-013 — Zoom-dependent Counter LOD

- **Target:** v0.7.1; P2; Planned.
- **Goal:** Improve unit readability on large maps at distant zoom.
- **Strategic mode:** Simple faction-colored rectangles with military branch symbols: infantry X, cavalry diagonal, artillery dot, HQ star.
- **Tactical mode:** Existing historical PNG counters.
- **Threshold:** Provisional zoom 0.65; consider hysteresis at 0.60/0.70.
- **Architecture:** Rendering-only feature. Keep LOD selection separate from gameplay Unit state; reuse counter rendering and visual selection helpers.
- **Constraints:** No changes to mechanical footprints, collision, combat, LOS, movement or deterministic simulation.
- **Interaction:** Selection, targeting, rotation, strength indicators and order previews must match the active visual mode.
- **Tests:** LOD boundaries, rotated hit testing, drag selection, enemy targeting, zoom transitions and both map modes.
- **Performance:** Compare frame time and renderer caching with many units.
- **Acceptance:** Smooth, readable switching between strategic symbols and historical assets without gameplay or input regressions.


### FEATURE-011 — Terrain Editor Map Manager

- **Target:** v0.11; P2; Planned.
- **Scope:** Add a Pygame menu for choosing map assets, importing PNG/JPG maps and managing associated terrain annotations.
- **Design:** Keep map data independent of scenario deployments. Preserve existing annotations and support multiple scenarios using the same map.
- **Acceptance:** Users can choose a supported map and open the correct annotation project without editing source paths.

### FEATURE-012 — Main Menu & Game Flow

- **Target:** v0.12–v0.13; P2; Planned.
- **Scope:** Add a basic main menu, scenario selection, pause menu and battle-results screen. Extend with settings and loading functionality before the Steam demo.
- **Design:** Separate menu, scenario selection and battle states from simulation logic.
- **Acceptance:** Players can navigate from the main menu into a scenario, complete a battle and return to the menu without restarting the application.

### BUG-005 — Visual and mechanical contact geometry

- **Target:** v0.8; P2; Open.
- **Observed:** Units can enter melee or complete charges while their visible counters remain separated.
- **Evidence:** Diagnostic overlays confirmed that mechanical collision footprints are much larger than rendered counters. Collision checks also use axis-aligned bounding rectangles of rotated formations.
- **Scope:** Investigate precise contact geometry and visual representation together. Preserve terrain crossing reservations, melee transitions and disengage behavior.
- **Acceptance:** Contact is visually understandable and mechanically consistent, including at intermediate facing angles, with automated combat and crossing regressions.



### TECH-005 — Movement/order architecture audit
- **2026-10-11 audit:** Reviewed world-position mutation paths, crossing-entry commits, melee, route, stop, order completion, facing, retreat and disengagement cleanup. Added behavior regressions for abandoned reservations.
- **Remaining:** Distributed state transitions and movement ownership still need narrowly scoped refactoring under tests; no v0.5 architectural rewrite planned.
- **Status/target:** In progress; Next cleanup.
- **Observed:** Unit movement state, crossing planners and main.py command dispatch span several modules; responsibilities and integration coverage need review.
- **Acceptance:** Document state ownership, execution paths and gaps; refactor incrementally only under regression tests.
- **Target:** v0.5.

### TECH-006 — Periodic performance telemetry

- **Idea (2026-10-11):** Add low-frequency FPS and frame-time statistics to the structured battle log, e.g. every 30–60 seconds; make the interval configurable rather than logging every N unrelated events.
- **Baseline:** Manual v0.5 smoke, 2026-10-11: approximately 60 FPS idle, 50 FPS with several moving units, 40–50 FPS during combat with camera zoom/pan, no reported stutter. These are observations under an FPS cap, not benchmark results.
- **Acceptance:** Log time window, average FPS, minimum or low-percentile FPS, frame-time summary, number of units and battle/session ID; avoid per-frame INFO spam and keep overhead negligible. Preserve pause/speed semantics and user privacy.
- **Target:** v0.11 (before scenario scaling and broader playtests); P3. Not required for v0.5 release.

### FEATURE-006 — Historical map art pipeline
- **Scope:** Revisit parked SVG, pixel, staff-map, terrain masks and illustrated assets. Choose a single maintainable visual workflow with exact logical alignment; improve unit-counter art.
- **Acceptance:** One repeatable and historically styled battlefield map with alignment and visual regression tests. Preserve free movement.
- **Target:** v0.6.


### BUG-001 — Enemy debug-facing preview

- **Retarget (2026-10-11):** v0.9, alongside command/debug previews; not required for v0.5 release.

- **Observed:** In `DEBUG_TEST_MODE=True`, rotating an enemy formation in place with RMB drag lacks a useful outline and clear front-facing indicator while dragging.
- **Expected:** Same preview quality as for player units: visible rotated counter outline, conspicuous front/arrow and resulting direction before releasing RMB.
- **Acceptance:** Manually validate enemy infantry and cavalry stationary facing preview; ordinary player controls remain unaffected.
- **Note:** Explicitly deferred by the user during v0.4 cleanup. Visual issue, not a combat logic failure.

### TECH-001 — Incomplete enemy debug input

- **Retarget (2026-10-11):** v0.9 developer controls cleanup; not required for v0.5 release.

- **Observed:** Selection and some RMB facing/deployment work for enemy units while debug mode is on, and their AI pauses while selected; some keyboard controls and Shift-waypoint paths remain player-only.
- **Acceptance:** Audit desired debug controls, document intentional exclusions, and test each enabled input consistently. Debug off must keep enemy units uncommandable.

### TECH-002 — Timing and simulation performance

- **Observed:** Current game speed scales variable delta time. An experimental fixed-timestep implementation caused major stuttering and was reverted.
- **Acceptance:** Profile with larger maps and unit counts; document findings before adopting any bounded fixed-step solution. Preserve speed and pause behavior.
- **Caution:** Do not blindly restore the old fixed-step version.

### TECH-003 — Centralized input/order handling

- **Observed:** `main.py` holds lengthy event handling, selection and command dispatch.
- **Acceptance:** Extract one stable, test-covered concern at a time without changing the game's controls or AI timing.

### TECH-004 — Legacy formation geometry

- **Observed:** Older width/height multipliers and geometry helpers may reflect an obsolete concept of resizing counters.
- **Acceptance:** Audit actual callers and ensure fixed counter dimensions remain invariant when switching line/column.

### FEATURE-001 — Multi-contact melee

- **Scope:** More than one attacker in contact with a unit, geometric side assignment, flank/rear effects, shared defensive capability, multi-contact disengage, and no counter stacking.
- **Acceptance:** Automated tests for two attackers, charge contact, routing, death and withdrawal; manual flank engagement scenario.
- **Constraint:** Replace the current 1-on-1 representation incrementally, not with an untested rewrite.

### FEATURE-002 — Rally/reforming

- **Scope:** Routed → rallying → reforming → controllable, with risk, nearby enemies, strength and elapsed time; off-map routing remains terminal.
- **Acceptance:** Test successful recovery, interrupted rally, repeat routing and permanent off-map loss.
- **Note:** Exact thresholds suggested in discussion are illustrative, not approved constants.

### FEATURE-003 — Cohesion, suppression and disorder

- **Scope:** Separate unit cohesion/disorder from morale and fatigue; adjust after maneuver, incoming fire, close combat and major disruption.
- **Acceptance:** Rules, UI indication and deterministic tests for state changes and battlefield consequences.

### FEATURE-004 — Explicit fire policy and UI

- **Scope:** `FIRE_AT_WILL`, `RETURN_FIRE`, `HOLD_FIRE`; distinguish these from melee initiative `Attack at Will`. Provide obvious counter/HUD visuals and group control.
- **Acceptance:** Tests for automatic fire, return fire only within realistic range/arc, no autonomous march toward threats, hold-fire suppression and unconditional melee self-defense.
- **Existing behavior:** Current `hold_fire=True` blocks automatic ranged fire, but an explicit attack can override it. Do not change silently before resolving `DESIGN-001`.

### FEATURE-005 — Save/load system

- **Scope:** Game state persistence and version-compatible loading as the demo approaches.
- **Acceptance:** Save/reload an active battle without losing unit state, orders or scenario progress; handle invalid files gracefully.

### DESIGN-001 — Hold Fire versus explicit attack

- **Question:** Should direct attack be rejected until Hold Fire is explicitly cancelled, or should issuing direct attack automatically cancel it?
- **Current preference:** Explicit cancellation, subject to playtests. Never mix behaviors unintentionally.
- **Resolution required:** Record decision, implement consistently, add tests and update UI/help.

### DESIGN-002 — Demo historical scenario

- **Question:** Which small, feasible historical or historically inspired battle best demonstrates terrain, formations, command and readable objectives?
- **Resolution required:** Choose after basic terrain/scenario framework tests, before v0.13 demo polishing.

## Resolved

### BUG-002 — Crossing reversals and interrupted orders
- **Observed:** Crossing reversal and changes of orders during/after bridge or ford passage still have edge cases involving stopping and getting stuck on banks.
- **Acceptance:** Safely stop, reverse without an illegal in-place turn, resume, and receive new/deferred orders inside and near a crossing. Automated and manual cases.
- **Target:** v0.5.

- **Status:** Done (v0.5, 2026-10-11).
- **Closure evidence:** Closed for tested stop, redirection, backward retreat and resume on bridge and ford. Automated crossing/retreat regressions and manual acceptance checks passed on 2026-10-11.

### BUG-003 — Group movement can block on riverbanks

- **Observed (manual, 2026-10-11):** Infantry and cavalry individually cross the bridge, but group-selected orders can spread formations laterally and result in `ROTATION_BLOCKED` near (2398,1089) and (2402,1029). Movement orders can overlap units during attempted passage.
- **Code evidence:** The single-unit branch of `move_selected_units()` plans routes using `plan_movement_leg()`, while its multi-unit branch directly calls `unit.set_target(unit_target_x, unit_target_y)` for perpendicular group slots. Crossing clearance is not planned for group units.
- **Acceptance:** Group move over bridge and ford must use formation-size-aware legal approach/crossing/exit routes, avoid trying to spread inside the river corridor, and not leave units permanently stuck. Explicitly handle crossing capacity and simultaneous/opposite-direction orders. Add a regression for group orders before changing the implementation.
- **Target:** v0.5; P1.

- **Status:** Done (v0.5, 2026-10-11).
- **Closure evidence:** Group movement now uses terrain-aware route planning. Automated group-crossing regressions and manual infantry+cavalry group marches across bridge and ford passed on 2026-10-11.

### BUG-004 — Opposite-direction friendly units overlap on bridge

- **Observed (2026-10-11, manual):** 1st Infantry moving east and 6th Cavalry moving west used the same bridge simultaneously; both crossed through one another. Logs show `FRIENDLY OVERLAP` at `speed_mult=0.40`, followed by `FRIENDLY OVERLAP END` and crossing waypoints reached.
- **Cause to investigate:** Friendly overlap currently slows movement instead of preventing conflicting occupancy in narrow crossing corridors.
- **Acceptance:** Opposite-direction friendly formations do not interpenetrate in bridges/fords; one waits before entry or otherwise yields safely, both can eventually complete orders without a permanent deadlock. Preserve normal friendly traffic behavior outside bottlenecks, and cover same-direction and opposite-direction cases with automated regressions.
- **Target:** v0.5, P1.

- **Status:** Done (v0.5, 2026-10-11).
- **Closure evidence:** Exclusive crossing ownership and entry clearance prevent counter interpenetration in tested opposing/group cases. Manual STOP/retreat/wait/resume and simultaneous opposing crossings passed on bridge and ford on 2026-10-11. This is not a claim of FIFO or large-scale traffic fairness.


- **2026-10-14:** Planned TECH-007 repository cleanup after v0.7 acceptance and before v0.8, including tcod/LoS experiment retirement, dependencies and regression safety.

## Register history

- **2026-10-11:** v0.5 acceptance review: BUG-002/003/004 marked Done with scoped manual and automated evidence; TECH-005 kept open for incremental cleanup; BUG-001/TECH-001 retargeted to v0.9; TECH-006 added for periodic FPS logging.

- **2026-10-11:** Added BUG-004 for observed opposite-direction overlapping friendly units on a bridge.

- **2026-10-11:** Captured observed multi-unit crossing failure as BUG-003 (group branch bypasses terrain-aware route planner).

- **2026-10-11:** Deferred map art to v0.6 and shifted later targets; introduced BUG-002, TECH-005 and FEATURE-006 to track remaining work.

- **2026-10-10:** Created from deferred issues and design decisions already discussed during v0.4 release preparation and the consolidated roadmap. Priorities and targets are initial proposals, not fixed commitments.
