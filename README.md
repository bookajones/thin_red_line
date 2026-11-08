# Thin Red Line

**Thin Red Line is the Godot reimplementation of [Python Strategy](https://github.com/bookajones/python-strategy): the same game, not a redesigned successor.** A formation-level, real-time tactical strategy game about nineteenth-century warfare, intended for Windows/Steam. Army formations are units; individual soldier simulation is not the design.

> **Status:** Godot foundation / playable *tactical sandbox*, not a feature-complete port. The original Python project is the behavioral reference. See [game design](docs/GAME_DESIGN.md), [parity matrix](docs/PORTING_PARITY.md), and [roadmap](docs/ROADMAP.md). All historical Python releases must be revalidated in Godot.

## Run

1. Install Godot 4.7.2 (or a compatible Godot 4.x version).
2. Open the repository root via Godot Project Manager and run the main scene with **F6** or the project with **F5**.
3. The bundled fictional test battlefield (3000×2000) and nine formation counters appear. No external assets/plugins are required.

### Controls (implemented in this initial Godot sandbox)

| Input | Effect |
| --- | --- |
| WASD / arrows | Pan camera, including while paused |
| Mouse wheel | Cursor-anchored zoom |
| LMB / drag | Select one or marquee-select multiple friendly formations |
| Shift+LMB | Add/remove formation selection |
| RMB | Straight-line move order (no route planner yet) |
| Shift+RMB | Queue additional straight-line waypoint |
| F | Toggle LINE/COLUMN for selected formation (2-second transition) |
| X | Stop selected formation |
| C | Center on selected formation(s) |
| Space | Pause/resume simulation |
| +/- | Change speed 0.5× / 1× / 2× / 4× |
| F8 | Debug-only reveal of enemy units and removal of fog overlay |

The fog model tracks per-side discovered terrain and current visibility with 32-world-unit cells, 300-unit observation radius and provisional rectangular terrain occlusion. Enemy counters are hidden unless tactically detected. The fog is a single low-resolution GPU texture, updated at 10 Hz rather than recreating thousands of translucent Pygame rectangles each frame. Neither combat nor automated enemy movement is implemented in this initial PR. **The historical PNG map/counter art is not yet transferred; the sandbox deliberately uses temporary cartographic rectangles.**

## Test

In PowerShell on Windows, using the local Godot console binary:

~~~powershell
& "D:\Workspace\godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script tests/verify_foundation.gd
~~~

Or, when Godot is on PATH: \`godot --headless --path . --script tests/verify_foundation.gd\`.

See [manual QA & performance plan](docs/PERFORMANCE_AND_QA.md). Headless validation has to be executed on a machine with Godot installed; publishing this PR does not assert that a local Godot run has occurred.

## Canonical design and migration

- [GAME_DESIGN.md](docs/GAME_DESIGN.md) — unchanged product vision, controls, tactical rules and constraints.
- [ROADMAP.md](docs/ROADMAP.md) — porting gates plus the entire original development sequence.
- [PORTING_PARITY.md](docs/PORTING_PARITY.md) — implemented vs partial vs unported, no hidden scope changes.
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) — boundaries between real terrain, knowledge, detection, presentation and timing.
- [Original Python milestones](docs/reference/PYTHON_STRATEGY_MILESTONES.md) and [original backlog](docs/reference/PYTHON_STRATEGY_BACKLOG.md) — read-only snapshots preserved for historical completeness and acceptance details.

## Process

Small PRs, explicit acceptance criteria, headless diagnostics and manual QA, **never auto-merge**. No speculative gameplay redesign, and no false “completed” statuses inherited from Python. This port must achieve functional parity before adding new features.
