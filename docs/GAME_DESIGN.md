# Thin Red Line — game design contract

**Same game as \`bookajones/python-strategy\`.** This document restates its approved design for a Godot codebase; nothing here authorizes changing game genre, unit scale, period or simulation rules. The Python implementation is a reference for existing mechanics. The old project's [milestone](reference/PYTHON_STRATEGY_MILESTONES.md) and [backlog](reference/PYTHON_STRATEGY_BACKLOG.md) snapshots preserve granular decisions.

## Identity, audience and product

- Desktop-first nineteenth-century real-time tactical strategy, focused on **battlefield formations**, not individually simulated soldiers. Target an accessible Steam demo and eventually a full commercial release. Browser is optional, not a target platform.
- Viewpoint is a historical staff/battlefield map with terrain annotations and readable counter symbols, navy/gold for friendly units and burgundy for enemies. A historical illustrated map asset and historical counter artwork remain the intended presentation; programmer rectangles are temporary.
- Historical or history-inspired scenarios: an early fictional test map and smaller historical battles lead to larger engagements (e.g. Maiwand is an *aspiration*, not a committed first demo scenario).
- Player skill lies in timing, positioning, formation, line of sight, fatigue, morale, terrain, flanking, command delays, intelligence and supplies, rather than action-game reflexes.

## Scale and geometry

- A tactical unit is one infantry, cavalry, artillery or HQ **formation counter** with a mechanical rectangular footprint, independent of the PNG asset dimensions and current zoom/LOD.
- Source baseline at 1.0 footprint scale: infantry 120×60, speed 100, turn 90°/s, 2×5 blocks of 10 = 100 men; cavalry 100×50, 80, 120°/s, 2×3 blocks of 10 = 60; artillery 90×70, 60, 45°/s, 2×4 blocks of 5 = 40 elements; HQ 72×36, 60, 90°/s, 1 element and **visual-only until command mechanics ship**. Do not silently reinterpret artillery 'strength' as an individual-person count.
- Coordinate system: world-space top-left deployment position in legacy scenario data; formation center and facing derived from it. Facing 0° points right. The mechanical footprint rotates; visual dimensions are not collision/LOS dimensions.
- LINE and COLUMN are the existing formations. Source speed/rotation multipliers: line 1.0/1.0, column 1.2/1.3. Change duration 2.0 s. Ranged fire arcs are ±30° line and ±15° column. SQUARE is planned for advanced combat; not an original starting formation.

## Controls and orders (parity targets)

- LMB select; Shift+LMB add/remove; LMB drag marquee; RMB move/attack depending on target; **double RMB** on enemy = infantry bayonet assault or cavalry charge; RMB drag = deployment line/facing order; Shift queues waypoints/orders; X stops; F changes formation.
- WASD/arrows pan while paused, wheel zoom around cursor, C center selection, Space pause, +/- select 0.5×/1×/2×/4×. F1 help, F8 terrain/debug, other diagnostic controls guarded by debug mode.
- Automatic ranged attacks must not cancel ordinary movement/queued orders. Separate 'attack at will' (melee initiative), 'fire at will' and 'hold fire'. Later: Return Fire policy, command groups, delegated commander orders and delivery delays.
- Units have orientation, frontage, flanks, rear, strength blocks, morale, fatigue, reload/weapon state and orders. Casualties affect morale, and flank/rear attack amplifies morale loss. Melee disengagement, routing and crossing traffic have their own lifecycle constraints.
- Original ranged weapon data: smoothbore musket range 150, reload 5 s, base hit chance .03; Minié rifle range 220, reload 5 s, base hit chance .05; field gun range 450, reload 8 s, base hit chance .20, casualties per hit 3. Preserve the original gameplay formulae rather than inventing a new balance while porting.

## Terrain, maps and route execution

- Battlefield is larger than viewport (original fictional test map is 3000×2000); maps are independent of scenarios. Original terrain types: plain, forest, hill, marsh, village, road, river, bridge and ford.
- Rivers block movement except where a bridge/ford physically permits passage. Roads/terrain influence speed, fatigue and maneuver; group movement requires route planning and controlled crossing/reservation traffic, including opposing directions, STOP, retreat and interrupted orders.
- The historical art map in Python is 1536×1024 with authored PNG illustration, terrain JSON and raster masks. Its old **gameplay/annotation integration was intentionally incomplete**; do not claim that it had parity with the fictional test-map's route/collision system.
- True map annotations are the sole authoritative terrain for movement and combat; optional recon sketch JSON can be incomplete or wrong without changing physics. Future knowledge-aware orders must avoid leaking unknown obstacles through immediate rejection or omniscient route previews.

## LOS, concealment, Fog of War and intelligence

- Source visibility baseline: 300 world units, full 360° observation; forest/village can occlude LOS. Sight into obstructing terrain up to approximately 20 world units when the observer/target touches that feature. Target *concealment detection* range: forest 60, village 40, subject to line of sight and **full rotated mechanical-footprint** checks, not merely target-center tests.
- Each side owns independent **currently_visible** transient cells and **discovered_terrain** persistent cells. Detection/targeting is separate from map tile visibility.
- Hidden enemy cannot be rendered, clicked, directly targeted or chosen by AI using omniscient coordinates. A discovered but now unobserved region is remembered terrain, not current enemy intel. Do not reveal ghost counters without explicit future design approval.
- The source implemented historical raster forest LOS with DDA and separate cached observer updates, plus a cooldown/queue for performance. Preserve the *behavior*, not the CPU-heavy implementation. Larger maps and multiple moving observers must be benchmarked.
- An unresolved original edge case (BUG-006) concerns visibility of an observer **inside** deep forest. Do not silently change forest exposure rules; regression tests must cover inside, boundary and outside observations.

## Combat, morale, commands and intelligence roadmap

- Existing Python mechanics include infantry ranged fire, cavalry charge, simple melee, fatigue/morale thresholds and routing, limited one-opponent melee, controlled disengagement and isolated fire permissions.
- More advanced combat: SQUARE, multiple simultaneous melee contacts, flanking/rear losses, cohesion/disorder, rally/reform under conditions, cavalry vs square and impact consequences.
- Command & control: unique Army HQ per side, brigade commanders attached to existing counters (not separate mandatory on-map officer units), order delivery via command hierarchy, distances, terrain and interruptions, local autonomy, command loss and succession.
- Later: ammunition, logistics, resupply, defensive/flanking AI, scenario objectives (hold/seize/delay/evacuate), historical content, campaign-ready UI, sound, saves, and Steam demo.
- Avoid feature creep or a switch to soldier-sprite tactical simulation. Those decisions belong to a different game, not Thin Red Line.

## Quality and player experience

- Deterministic scenario seed (test battle 12345), testable gameplay rules, controlled pause/game speed, transparent orders and meaningful failure states.
- Preserve test coverage, logging/performance counters, staged acceptance and manual replay scenarios on test and historical maps.
- Performance objective is stable 60 FPS in representative tactical scenes, measured through frame times and LOS/renderer costs. No unsupported benchmark promises.

**Implementation scope:** The Godot foundation PR implements only a subset. The [parity matrix](PORTING_PARITY.md) is authoritative for *delivery status* and the [roadmap](ROADMAP.md) for porting order. The design contract above remains the target even when a foundation build has temporary placeholders.
