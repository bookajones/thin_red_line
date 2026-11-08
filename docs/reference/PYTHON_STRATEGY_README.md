<!-- Read-only source snapshot captured 2026-11-08 from bookajones/python-strategy main. Python milestone statuses do not apply to this Godot port. -->

# A horse with no name - Strategy with no name yet

A real-time tactical strategy game prototype focused on 19th-century warfare. The game simulates tactical decisions at **formation level**, rather than individual soldiers.

The project is in early development and targets **desktop** first. The longer-term goal is a polished Steam demo followed by a full Steam release. Browser compatibility is optional and not the primary platform.

## Requirements

- Python 3.13+
- pygame
- pytest

Dependencies are listed in `requirements.txt`.

## Setup (Windows / PowerShell)

Create and activate the virtual environment:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

Install dependencies:

```powershell
python -m pip install -r requirements.txt
```

Run the game:

```powershell
python main.py
```

Run all automated tests:

```powershell
python -m pytest
```

If VS Code opens a different Python interpreter, select the project's `.venv\Scripts\python.exe` interpreter.

## Controls

| Input | Action |
| --- | --- |
| Left click | Select a unit |
| Shift + left click | Add/remove a unit from selection |
| Left mouse drag | Select multiple units |
| Right click on ground | Move selected units |
| Right click on an enemy | Normal attack (infantry fires; cavalry closes to melee) |
| Double right click on an enemy | Infantry bayonet assault / cavalry charge |
| Right mouse drag | Deployment line or facing order; drag from a selected counter to rotate in place |
| Shift + right click | Queue movement waypoint |
| Shift + right drag | Queue deployment/facing waypoint |
| WASD / arrow keys | Pan the camera (also works while paused) |
| Mouse wheel | Zoom around mouse cursor |
| C | Center camera on selected unit or average center of selected group |
| F | Change formation of selected player units |
| X | Stop selected player units |
| Space | Pause / resume |
| + / = | Increase simulation speed |
| - | Decrease simulation speed |
| F1 | Toggle controls/help overlay |
| F8 | Toggle logical terrain debug overlay |
| Esc | Close help overlay or clear selection |

Supported game speeds: **0.5x, 1x, 2x, 4x**. Speed currently scales the frame delta; a fixed-step simulation has not yet been adopted.

## Gameplay systems (v0.4 foundation)

- Fixed-size rectangular counters: infantry 120×60, cavalry 100×50, artillery 90×70.
- Line/column formations, facing, group deployment and queued waypoints.
- Friendly-unit overlap slowdown and destination collision handling.
- Ranged combat, reloads, morale, fatigue, routing, and melee.
- Single-RMB ranged infantry attack versus double-RMB bayonet assault.
- Single-RMB cavalry attack versus double-RMB charge with a **one-time impact**.
- Melee currently supports **one opponent per unit**. Attempts to join an occupied melee are blocked.
- Controlled disengagement, potentially including a free enemy strike, a preparation delay, and temporary contact protection until separation.
- Emergency turning while engaged in melee.
- Separate `attack_at_will`, `fire_at_will`, and `hold_fire` state; their full player-facing order policy and visual UI are not yet complete.
- Aggressive-order restrictions when morale is critical or fatigue is exhausted.
- Automatic fire does not interrupt ordinary movement or queued waypoint orders.

The current playable scenario is a development test battle, not a polished historical scenario.

## Battlefield & Terrain (v0.5.0 released)

- A battlefield larger than the viewport, using separate world and screen coordinates.
- Camera panning, cursor-anchored zoom and one-shot `C` centering; the camera remains manually controllable afterwards.
- A fictional terrain map including rivers, bridges, fords, roads, forests, hills, villages and marshes.
- Terrain-related movement speed, fatigue and maneuver restrictions; rivers block movement outside traversable crossings.
- Terrain-aware route planning for single- and group-unit orders, with controlled bridge/ford traffic, waiting and reservation cleanup.
- Order changes, stopping, retreating and resuming around bridge/ford bottlenecks, with automated regressions and targeted manual tests.
- An on-screen FPS indicator using the existing Pygame clock.

**Display resolution:** Change `WIDTH` and `HEIGHT` in `settings.py` before launching the game. The default is 1289 x 720, and 1600 x 900 has been manually tested. Resizing the running window and a display-settings UI are not yet supported.

**Performance observation:** Approximately 60 FPS idle, 50 FPS with several moving units and 40–50 FPS during combat plus camera movement/zoom, with no reported stutter. These are informal measurements from the development scene under the FPS cap, not a large-battle benchmark.

**Limitations:** Explicit elevation/high-ground and line of sight are future work; detailed terrain cover/combat modifiers are not part of v0.5. Historical-style map art follows in v0.6. Crossing traffic does not promise FIFO fairness for large armies. See `BACKLOG.md` for tracked issues and `MILESTONES.md` for planned versions.

## Developer Test Mode

Set `DEBUG_TEST_MODE = True` in `settings.py` to enable developer controls. Debug keys `1–4` and presets `F5–F7` apply to **all selected, non-destroyed units**, including enemy units when selected in debug mode. `F8` is assigned to the terrain debug overlay in the main input handler; avoid relying on it as an unambiguous morale preset until input handling is cleaned up.

| Key | Developer action |
| --- | --- |
| 1 | Decrease morale by 10 |
| 2 | Increase morale by 10 |
| 3 | Decrease fatigue by 10 |
| 4 | Increase fatigue by 10 |
| F5 | Morale 100 / fatigue 0 |
| F6 | Morale 55 / fatigue 20 |
| F7 | Morale 30 / fatigue 40 |
| F8 | Terrain overlay toggle (also has a legacy debug-preset binding; see note above) |
| F9 | Restore all routed/destroyed units to their original positions |

F9 works regardless of selection. Enemy AI is suspended for a selected enemy unit in Developer Test Mode and resumes after deselection. Setting morale above zero does **not** automatically rally a routed unit; rally/reforming is a planned future feature.

Additional flags in `settings.py`:

- `DEBUG_MOVEMENT_LOGS`
- `DEBUG_COMBAT_LOGS`
- `DEBUG_HIGH_COMBAT_ACCURACY`

**Known developer-mode UI limitation:** rotating an enemy counter in place lacks a clear rectangle/front-facing preview. This is tracked for later improvement.

## Logging

Runtime logs are written to `python_strategy.log`, including key battle events and unhandled exceptions. Log rotation limits file growth. Typical event labels include `[ATTACK ORDER]`, `[CHARGE]`, `[MELEE]`, `[DISENGAGE]`, `[MORALE]` and `[DEBUG RESTORE]`.

## Development milestones

### v0.5.0 — Battlefield & Terrain (released 2026-10-11)

Camera/navigation, terrain-aware movement, bridge/ford routing and traffic coordination are implemented and verified. Automated regression and final manual smoke tests passed. Released as tag `v0.5.0` (commit `83c5ff3`). See `CHANGELOG.md`.

### v0.4.0 — Orders & Combat Control (release candidate)

The combat/order expansion, gameplay-speed controls, debug restoration, and additional regression coverage are implemented. Final release verification and version tagging remain outstanding. See `CHANGELOG.md`.

### v0.3.0 — Code & Test Foundation

Established pytest regression coverage, deterministic gameplay RNG and scenario seeds, pure gameplay calculations, morale/fatigue enums, structured logging, crash diagnostics, and developer-testing infrastructure.

## Architecture

| File or directory | Responsibility |
| --- | --- |
| `main.py` | Game loop, input, rendering coordination and order dispatch |
| `camera.py` | World/screen coordinate transforms, panning, zoom and centering |
| `terrain.py` | Battlefield and terrain representation |
| `terrain_rules.py` | Movement/fatigue effects of terrain |
| `movement_planner.py` | Terrain-aware route planning |
| `unit.py` | Unit state, movement, contact, melee, morale and routing |
| `ai.py` | Automatic combat and enemy AI decisions |
| `ui.py` | Unit information and command visualizations |
| `debug_tools.py` | Developer controls and restore operations |
| `settings.py` | Gameplay constants and debug configuration |
| `gameplay_types.py` | Morale and fatigue enums |
| `gameplay_rules.py` | Reusable gameplay calculations |
| `gameplay_rng.py` | Deterministic gameplay random-number generator |
| `game_logging.py` | Logging and crash diagnostics |
| `data/scenarios/` | Scenario unit definitions and seeds |
| `tests/` | Automated regression tests |
| `project_context/` | Development decisions and roadmap context |

## Current development focus

**v0.5.0 — Battlefield & Terrain (released):** core gameplay and acceptance checks are complete; tagged as `v0.5.0` on 2026-10-11. Terrain graphics remain provisional. Some movement/order state ownership cleanup is deferred (`TECH-005`).

**v0.6.0 — Historical Map Art (planned):** resume SVG, pixel/staff-map, terrain mask and illustration experiments; ensure the selected pipeline follows exact game-world coordinates and polish counters. Later roadmap milestones shift by one version; refer to `MILESTONES.md`.

## Planned work

After v0.5 terrain completion and v0.6 art: multi-unit melee (flanks/rear, damage allocation and disengagement) and a future rally/reforming system. A more coherent fire-policy system (Fire at Will / Return Fire / Hold Fire) with clear order indicators is also planned, but not yet implemented.

Longer term: line of sight, command/control, ammunition and logistics, tactical AI, historical or history-inspired scenarios, a 19th-century staff-map visual style, audio, tutorial, desktop packaging, and a Steam demo. Balance and specific timings remain provisional.
