# Thin Red Line — project rules for AI contributors

- Owner decides gameplay and merges PRs. AI is implementation/architecture/QA partner; **never merge or enable auto-merge**.
- **No redesign:** port the same nineteenth-century formation-counter game from bookajones/python-strategy. Preserve historical scenario data, order semantics, force structure, formations, fatigue/morale, line of sight, concealment, terrain, crossings and the approved roadmap.
- Godot 4.7.2; prefer typed GDScript. Keep runtime logic independent from terrain art and HUD. No external services or plugins without owner approval.
- Original Python game is the behavioral reference. Port in small testable increments; update docs/PORTING_PARITY.md and the test plan whenever behavior changes.
- Do not infer “ported” from a copied data file. A mechanic is ported only with implementation, deterministic tests and relevant manual QA.
- Tactical unit is a formation/regiment counter, not individual soldiers. Visual art never determines mechanical footprint.
- World coordinates are distinct from camera/screen coordinates; original Python scenario x/y are top-left mechanical coordinates, with 0° facing right.
- True map terrain is immutable simulation authority. Recon sketch data is provisional knowledge, never truth. Per-side discovered terrain persists, per-side visibility does not. Enemy selection, AI and combat must not leak hidden contacts.
- Separate gameplay simulation, exact tactical target detection, map FoW display and renderer. Profile LOS and track p95/peak frame times; target stable 60 FPS rather than average alone.
- Keep deterministic scenario RNG, fixed-step simulation and timed observation independent of renderer FPS. Verify 0.5×, 1×, 2×, 4× and pause.
- Maintain milestone statuses accurately; port first, then resume original future roadmap. Documentation/code comments in English; user-facing conversation may be Polish.
- No asset licensing assumptions: do not copy or publish binary graphics from private source without an explicit license/provenance check.
- For each PR: short summary, exact files/behavior, tests run vs not run, manual checklist, known limitations. Work on branch and open PR for review.
