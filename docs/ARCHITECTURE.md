# Engine architecture — foundation and growth

## Working slice

- `data/maps/test_map.json` — exact original rectangular fictional terrain layout, in shared world coordinates.
- `data/scenarios/test_battle.json` — exact test deployment, original seed 12345, serialized as JSON. Top-left Python coordinate is converted to a Godot center on spawn.
- `data/rules/*.json` — verbatim source gameplay values for formation types and weapons (values are not automatically fully implemented).
- `scripts/terrain_map.gd` — authoritative physical terrain and temporary cartographic renderer; map and scenario remain separate.
- `scripts/unit_counter.gd` — one tactical formation counter; visual size independent of mechanical dimensions; movement, selection, fatigue and formation-change starter logic.
- `scripts/fog_model.gd` — per-side visible/discovered grids, temporary rectangular LOS, concealment range, image texture. ImageTexture.update avoids recreating GPU textures each refresh.
- `scripts/battle.gd` — local sandbox composition, controls, fixed engine physics tick, independent fog refresh, debug/HUD and enemy presentation policy.
- `tests/verify_foundation.gd` — data, terrain/crossing, selection/order and sightline model checks.

### Runtime flow

```text
scenario JSON -> formation data -> 60Hz physics steps -> orders/movement
        |           |                           |
        v           v                           v
authoritative terrain geometry ------------> LOS per-side (0.1s cadence)
        |                                     /        \
        v                                    v          v
map renderer                         target detection  visible/discovered
                                                     |
                                                     v
                                            ImageTexture -> GPU fog
```

Only **the authoritative terrain** may grant physical crossing permissions. Do not derive gameplay truth from a fog image. An unseen enemy is excluded from selection/targeting/AI, not merely painted dark. The image may be delayed a fraction of a second but tactical detection must remain safe.

## Mandatory separation when growing

1. **Simulation:** fixed 60 Hz (or deterministically stepped), order/formation, combat, routing, AI and morale; no renderer dependency. Disallow RNG without deterministic scenario seed.
2. **Movement/world geometry:** real rotated mechanical footprints, path planner, roads/forests/rivers, bridge/ford reservation and traffic; do not use visual counter size.
3. **Visibility/detection:** observer LOS, full-footprint concealment, per-side contact tracking. Distinguish visible terrain and detected units; never allow omniscient AI.
4. **Knowledge:** true terrain annotations, optional imperfect scout sketch and battle-specific discovered terrain must be different resources/state owners. Recon inaccuracies never modify movement physics.
5. **Rendering:** background, overlays, counters/LOD, GUI and camera; GPU fog texture updates only when needed. No gameplay rules hidden in shaders.
6. **Scenarios:** separate map resource and deployments/rules/seed, eventually victory conditions and editor tools.

## Explicit debt of the G0 sandbox

- `terrain_at` uses **point occupancy**, not rotated formation collision or traversability across the full move segment. Units can stop at rivers, but there is no path planner or bridge queue.
- Current LOS samples rectangular terrain every 8 world units, a **temporary** approximation to the historical polygon/mask LOS, DDA depth and fully concealed rotated footprints.
- Fog refresh scans observer grid cells at 10 Hz and creates two side snapshots; it is designed to make profiling easy, **not** to guarantee a benchmark score. Future work may use a C#/GDExtension shadowcasting or other algorithm only if it reproduces rules and outperforms the reference on stress tests.
- Marked map regions are programmer drawings, not licensed game art; don't ship or describe them as finished visual assets.
- `UnitCounter` initial movement is straight-line, no target/fire/AI logic. “Tactical sandbox” is the correct description.
