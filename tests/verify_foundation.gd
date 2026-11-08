extends SceneTree
## Headless smoke/regression checks for portable data and first-slice systems.
## godot --headless --path . --script tests/verify_foundation.gd

const TerrainScript = preload("res://scripts/terrain_map.gd")
const CounterScript = preload("res://scripts/unit_counter.gd")
const FogScript = preload("res://scripts/fog_model.gd")

var failures: int = 0


func expect(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error("FAIL: " + message)


func load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	expect(file != null, "Cannot open " + path)
	if file == null:
		return {}
	var result: Variant = JSON.parse_string(file.get_as_text())
	expect(result is Dictionary, "JSON object required: " + path)
	if result is Dictionary:
		return result
	return {}


func _initialize() -> void:
	var map := load_json("res://data/maps/test_map.json")
	var unit_rules := load_json("res://data/rules/units.json")
	var weapons := load_json("res://data/rules/weapons.json")
	var scenario := load_json("res://data/scenarios/test_battle.json")
	expect(int(map.get("width", -1)) == 3000 and int(map.get("height", -1)) == 2000, "original test-map size")
	expect(map.get("terrain", []).size() == 10, "all ten original terrain features")
	expect(int(scenario.get("seed", -1)) == 12345, "deterministic source scenario seed")
	expect(scenario.get("units", []).size() == 9, "original nine test combatants")
	expect(int(unit_rules["infantry"]["block_rows"]) * int(unit_rules["infantry"]["block_columns"]) * int(unit_rules["infantry"]["block_strength"]) == 100, "100-soldier infantry formation")
	expect(float(weapons["minie_rifle"]["effective_range"]) == 220.0, "original Minie rifle range")

	var terrain = TerrainScript.new()
	terrain.configure(map)
	expect(not terrain.can_occupy(Vector2(2480.0, 900.0)), "river blocks movement")
	expect(terrain.can_occupy(Vector2(2480.0, 1050.0)), "bridge permits movement")
	expect(terrain.can_occupy(Vector2(2480.0, 1600.0)), "ford permits movement")
	expect(terrain.blocker_at(Vector2(300.0, 800.0)) == "forest", "original western forest")

	var friendly = CounterScript.new()
	friendly.configure(scenario["units"][0], unit_rules)
	expect(friendly.position == Vector2(1360.0, 1330.0), "Python top-left scenario coordinates converted to center")
	expect(friendly.strength == 100, "Python infantry max strength")
	expect(friendly.formation == "line", "original starting formation")
	friendly.issue_move(Vector2(1450.0, 1330.0))
	expect(friendly.orders.size() == 1, "first move order queued")
	friendly.toggle_formation()
	expect(friendly.formation == "column" and friendly.formation_time == 2.0, "line-column changes take time")
	friendly.stop()
	expect(friendly.orders.is_empty(), "stop cancels queued movement")

	var enemy = CounterScript.new()
	enemy.configure(scenario["units"][5], unit_rules)
	var fog = FogScript.new()
	fog.configure(terrain.world_size)
	fog.recalculate([friendly, enemy], terrain)
	var seen_point: Vector2 = friendly.position
	expect(fog.is_world_visible("player", seen_point), "observer sees own cell")
	expect(fog.is_cell_discovered("player", floori(seen_point.x / 32.0), floori(seen_point.y / 32.0)), "visible cell becomes discovered")
	friendly.position = Vector2(2050.0, 1750.0)
	fog.recalculate([friendly, enemy], terrain)
	expect(not fog.is_world_visible("player", seen_point), "old position is no longer visible")
	expect(fog.is_cell_discovered("player", floori(seen_point.x / 32.0), floori(seen_point.y / 32.0)), "discovery persists")
	friendly.position = Vector2(800.0, 550.0)
	enemy.position = Vector2(840.0, 550.0)
	expect(fog.can_detect(friendly, enemy, terrain), "close uncovered enemy can be detected")
	enemy.position = Vector2(1110.0, 550.0)
	expect(not fog.can_detect(friendly, enemy, terrain), "distant enemy is outside observation range")
	expect(not fog.has_line_of_sight(Vector2(160.0, 800.0), Vector2(900.0, 800.0), terrain), "forest blocks line of sight")
	expect(fog.has_line_of_sight(Vector2(1000.0, 1200.0), Vector2(1100.0, 1200.0), terrain), "open ground permits line of sight")

	if failures == 0:
		print("PASS: Thin Red Line foundation checks")
	else:
		printerr("FAIL: %d foundation checks" % failures)
	quit(1 if failures > 0 else 0)
