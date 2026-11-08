# Porting parity and deliberate omissions

The target game is exactly the original Python Strategy game; this table is the current **Godot delivery truth**, not a permission to change requirements.

Legend: **Data** = values or definitions copied but mechanic not implemented; **Slice** = simplified playable prototype; **Pending** = not delivered in Godot. "Original" means the status as represented by source main/docs at time of migration.

| System | Python source baseline | Godot foundation PR | Required for parity |
| --- | --- | --- | --- |
| 19th-century, formation-counter game | Approved core design | **Design preserved** | Never reinterpret as per-soldier RTS |
| Source unit dimensions/speed/strength | Implemented | **Data** + counter movement | Mechanical rotated footprint, collision and tactical grouping |
| Test map geometry 3000×2000 | Implemented | **Data** + painted rectangles | Terrain mechanics and route behavior |
| Original scenario seed and nine units | Implemented | **Data** + spawn | Full AI/combat and deterministic outcomes |
| World/screen camera, pan/zoom/center | Implemented | **Slice** | Selection/preview edge cases, settings/resizing |
| LMB/Shift/marquee | Implemented | **Slice** | Enemy debug targeting, exact visual hitboxes/rotation |
| Straight move, Shift queue, stop | Implemented with route planner | **Slice** (straight line only) | Destination collision handling, formation deployment and full waypoint semantics |
| RMB drag facing/line orders | Implemented | **Pending** | Previews and same orientation semantics |
| Double-RMB assault/charge | Implemented | **Pending** | Infantry bayonet, cavalry charge and lifecycle |
| LINE/COLUMN multipliers | Implemented | **Slice** | Exact geometry, fatigue/timing and fire arcs |
| Ranged infantry/artillery fire, reload and hit rolls | Implemented | **Data** weapons only | Original formulae, damage/smoke, shot/reload timing |
| Melee, withdrawal, charge/disengagement | Implemented with limits | **Pending** | Test-first 1:1 lifecycle then advanced contacts |
| Morale, fatigue and routing | Implemented | **Slice** fatigue tracking only | Threshold states, casualty morale and routing, recovery rules |
| Fire policy and automatic enemy AI | Implemented partially | **Pending** | No automatic omniscience; attack/fire/hold rules |
| Terrain effects and river restrictions | Implemented on test map | **Slice** point blocking only | Rotated footprint, speed/fatigue, crossing reservations |
| Bridges/fords and opposing traffic | Implemented with regression tests | **Pending** | True routes, queue/ownership, stop/retreat |
| Historical art maps/counters/annotations | Source v0.6 delivered | **Pending** | Asset license audit, port illustrations/annotations/masks |
| Forest/village line of sight | Implemented geometry + raster DDA | **Slice** 8-unit rectangle sampling | Pixel-mask DDA, occlusion accuracy, all edge cases |
| Forest/village full-footprint concealment | Implemented in Python | **Slice** center-based 60/40 detection | Rotated full-footprint exposure and partial visibility |
| Per-side visible/discovered fog cells | Implemented | **Slice** 32-unit grid | Source semantics for all maps; true vs scout compositing |
| Fog render tile caching | Implemented in Pygame | **Slice** one ImageTexture | GPU/perf profile and screenshot QA; no exact visual parity claim |
| Exact enemy detection vs delayed fog display | Implemented in Python | **Slice** enemy hidden by detection | Fire/AI/click consistency and camouflage tests |
| Fixed-step, speed/pause and observer scheduling | Implemented Python fixed-step | **Slice** Godot physics + real-time 0.1s fog | Cross-speed parity, lag/pause/slow motion tests |
| Strategic LOD, SQUARE, command chain, logistics | Original roadmap | **Pending** | Original unchanged future milestones |

## Not promised by foundation

The initial Godot test scene is **not yet a playable historical battle**: no firing, melee, enemy AI, route planner, bridging traffic, victory, save, menus, original assets or historical map parser. Enemy units are static. No automated performance benchmark has been executed on this branch in the review environment. These are tracked development tasks, not a change to product requirements.

The foundation uses only the factual data needed for its first scene. Other original parameters, formulas, detailed acceptance criteria and decisions are retained by the historical [milestone](reference/PYTHON_STRATEGY_MILESTONES.md) and [backlog](reference/PYTHON_STRATEGY_BACKLOG.md) snapshots plus [GAME_DESIGN.md](GAME_DESIGN.md). Preserve and implement the originals, do not discard them because a prototype simplifies something.

## Compatibility acceptance gate

Do not mark a row **Ported** until:
- Deterministic Godot tests cover the corresponding source regression behavior.
- A manual reproduction is checked on the matching Python and Godot scene.
- Changes to angle, formation footprint, line-of-sight or combat timing are explained and explicitly approved.
- Any player-visible behavior differences are documented.
