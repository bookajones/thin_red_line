# Performance, Fog of War and QA

## Why Godot

The original Pygame LOS code tested many rays against raster forest masks. Original project notes (2026-10-16) reported ~4.6–5.2 FPS with the initial full raster LOS; disabling mask only for diagnosis recovered ~55–58 FPS. DDA early exits improved ~9.5–13 FPS, observer caching yielded ~52–57 FPS idle with moving-army dips ~26–30 FPS. The later 0.1 s cooldown and two-observer queue logged ~55–58 FPS in sampled sessions, with remaining spikes. These are **historical observations** in Python, not Godot performance results.

In Godot the foundation uses \`ImageTexture\` with \`update(image)\` so terrain masking is GPU composited as a single 94×63 grid image in a 3000×2000 world. This addresses repeated tile drawing but **does not inherently optimize tactical LOS**. CPU LOS remains a separate measurement. Never mistake average FPS for p95/p99 frame time.

## Measurements required before accepting G0/G3

- Headless validation: \`godot --headless --path . --script tests/verify_foundation.gd\`. Interpret non-zero exit/error output as a failure, not a pass.
- Interactive Windows: launch scene F5, monitor FPS + \`LOS ms\` HUD, verify stable units and no parse errors in the Godot debugger.
- Test: no move; one observer marching; 5+ moving observers; several groups continuously moving; combat once ported; 0.5×, 1×, 2×, 4×; pause; zoom while marching; both historical and test maps when present.
- At 1280×720 and 1600×900 measure FPS and, in later diagnostics, average/p95/p99/max frame-time, visibility_ms, renderer_ms, texture updates per second, cache hits, memory and map size.
- Stress map sizes: 3000×2000, 6000×4000, then 10000×8000; scale army size and obstacle density deliberately.
- Goal: stable 60 FPS under representative use without visible LOS lag or map flashing. GPU texture upload and grid resolution must be profiled, not assumed free.

## Manual smoke for this PR

- [ ] Import project in Godot 4.7.2; run F5 without script/parser errors.
- [ ] Verify original test map's forest/hill/marsh/village/roads/river/bridge/ford placements.
- [ ] Verify 5 player, 4 enemy units from scenario data, blue/burgundy counters with front markers.
- [ ] Select player, Shift-add, drag-select; enemy units are never normally selected when unseen.
- [ ] RMB move; Shift+RMB queue; X stops. F switches LINE/COLUMN, lasts 2 seconds.
- [ ] WASD/arrows pan, cursor-focused mouse zoom, C center, pause, 0.5×/1×/2×/4×.
- [ ] Move into and out of visibility; old terrain stays dim/discovered while enemy units disappear when not detected.
- [ ] Enter the river and verify movement blocks without a crossing; bridge/ford cells are valid terrain.
- [ ] F8 is **developer-only omniscient debug** and toggles overlay/enemy reveal; not intended as gameplay.
- [ ] Verify frame duration and LOS ms while multiple units move; record actual measurements.

## Later critical regression suite

- Forest observer inside/deep/edge; partial footprint exposure; overlapping forest polygons/raster and village LOS; absence of detection leaks.
- Hidden enemy cannot be selected, ordered against or fired on; AI reacts only to legitimate detection. Discovery persists; current visibility does not.
- Bridge entry, queue contention, opposing traffic, STOP/retreat and exit/reformation.
- Front/flank/rear casualty and morale multipliers, routed-off-map behavior, melee disengagement/charge.
- Camera/zoom and deployment/selection geometry; pause/slow/fast time consistency.
- Knowledge-aware order acceptance: false sketch road/bridge never gives passability; unknown real river is discovered locally, not revealed by omniscient path rejection.

**Validation caveat:** Foundation code and test script are committed for local execution, but no Godot executable is available in the authoring environment, so neither successful headless execution nor Windows FPS numbers are asserted in this PR.
