extends Node2D
## Tactical sandbox for the Python Strategy design, not a new game design.
## No combat, route planner, or command-chain behavior is claimed in this PR.

const TerrainScript = preload("res://scripts/terrain_map.gd")
const CounterScript = preload("res://scripts/unit_counter.gd")
const FogScript = preload("res://scripts/fog_model.gd")
const SelectionOverlayScript = preload("res://scripts/selection_overlay.gd")
const SCENARIO_PATH := "res://data/scenarios/test_battle.json"
const UNIT_RULES_PATH := "res://data/rules/units.json"
const FOG_REFRESH_SECONDS := 0.1
const GAME_SPEEDS := [0.5, 1.0, 2.0, 4.0]

@onready var camera: Camera2D = $Camera2D

var terrain
var fog
var fog_sprite: Sprite2D
var counters: Array = []
var hud: Label
var paused: bool = false
var fog_debug: bool = false
var game_speed_index: int = 1
var visibility_elapsed: float = 0.0
var los_last_ms: float = 0.0
var selection_origin: Vector2 = Vector2.ZERO
var selection_active: bool = false
var show_selection_box: bool = false
var selection_overlay
var selection_end: Vector2 = Vector2.ZERO


func _ready() -> void:
	var scenario := read_json(SCENARIO_PATH)
	var unit_rules := read_json(UNIT_RULES_PATH)
	if scenario.is_empty() or unit_rules.is_empty():
		push_error("Scenario/rules missing; cannot start the tactical sandbox.")
		return

	var map_path: String = str(scenario["map"])
	var map_definition := read_json(map_path)
	if map_definition.is_empty():
		push_error("Map missing: " + map_path)
		return

	terrain = TerrainScript.new()
	add_child(terrain)
	terrain.configure(map_definition)
	var terrain_size: Vector2 = terrain.world_size

	for entry in scenario["units"]:
		var counter = CounterScript.new()
		add_child(counter)
		counter.configure(entry, unit_rules)
		counters.append(counter)

	fog = FogScript.new()
	fog.configure(terrain_size)
	fog_sprite = Sprite2D.new()
	add_child(fog_sprite)
	fog.apply_to_sprite(fog_sprite)

	selection_overlay = SelectionOverlayScript.new()
	add_child(selection_overlay)

	var canvas := CanvasLayer.new()
	add_child(canvas)
	hud = Label.new()
	hud.position = Vector2(14.0, 12.0)
	hud.add_theme_color_override("font_color", Color.WHITE)
	hud.add_theme_color_override("font_shadow_color", Color.BLACK)
	hud.add_theme_constant_override("shadow_offset_x", 1)
	hud.add_theme_constant_override("shadow_offset_y", 1)
	hud.add_theme_font_size_override("font_size", 16)
	canvas.add_child(hud)

	camera.position = terrain_size * 0.5
	camera.zoom = Vector2(0.78, 0.78)
	refresh_visibility()
	refresh_hud()


func read_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Cannot open " + path)
		return {}
	var data: Variant = JSON.parse_string(file.get_as_text())
	if data is Dictionary:
		return data
	push_error("Invalid JSON object: " + path)
	return {}


func _physics_process(delta: float) -> void:
	if terrain == null or fog == null or paused:
		return

	var game_delta: float = delta * float(GAME_SPEEDS[game_speed_index])
	for counter in counters:
		counter.simulate_step(game_delta, terrain)

	# Expensive LOS is scheduled in real time, not on every physics step.
	visibility_elapsed += delta
	if visibility_elapsed >= FOG_REFRESH_SECONDS:
		visibility_elapsed = fmod(visibility_elapsed, FOG_REFRESH_SECONDS)
		refresh_visibility()


func refresh_visibility() -> void:
	var start_us := Time.get_ticks_usec()
	fog.recalculate(counters, terrain)
	fog.refresh_texture("player")
	los_last_ms = float(Time.get_ticks_usec() - start_us) / 1000.0

	# Detection, not the painted fog, controls enemy visibility and clicking.
	for counter in counters:
		if counter.side == "player":
			counter.visible = true
			continue
		var spotted := false
		for observer in counters:
			if observer.side == "player" and fog.can_detect(observer, counter, terrain):
				spotted = true
				break
		counter.visible = fog_debug or spotted


func _process(delta: float) -> void:
	if terrain == null:
		return
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1.0
	if direction.length_squared() > 0.0:
		camera.position += direction.normalized() * 600.0 * delta / camera.zoom.x
	clamp_camera()
	refresh_hud()


func clamp_camera() -> void:
	var half_view := get_viewport_rect().size * 0.5 / camera.zoom.x
	var map_size: Vector2 = terrain.world_size
	camera.position.x = clampf(camera.position.x, half_view.x, maxf(half_view.x, map_size.x - half_view.x))
	camera.position.y = clampf(camera.position.y, half_view.y, maxf(half_view.y, map_size.y - half_view.y))


func _unhandled_input(event: InputEvent) -> void:
	if terrain == null:
		return
	if event is InputEventMouseButton:
		var mouse: InputEventMouseButton = event
		if mouse.button_index == MOUSE_BUTTON_WHEEL_UP and mouse.pressed:
			zoom_at_cursor(1.1)
			return
		if mouse.button_index == MOUSE_BUTTON_WHEEL_DOWN and mouse.pressed:
			zoom_at_cursor(1.0 / 1.1)
			return
		if mouse.button_index == MOUSE_BUTTON_LEFT:
			if mouse.pressed:
				selection_origin = get_global_mouse_position()
				selection_end = selection_origin
				selection_active = true
			elif selection_active:
				selection_active = false
				var release_point := get_global_mouse_position()
				if selection_origin.distance_to(release_point) > 12.0 / camera.zoom.x:
					select_rectangle(Rect2(selection_origin, release_point - selection_origin).abs(), mouse.shift_pressed)
				else:
					select_at(release_point, mouse.shift_pressed)
				show_selection_box = false
				update_selection_overlay()
			return
		if mouse.button_index == MOUSE_BUTTON_RIGHT and mouse.pressed:
			var destination := get_global_mouse_position()
			if not Rect2(Vector2.ZERO, terrain.world_size).has_point(destination):
				return
			for counter in counters:
				if counter.side == "player" and counter.selected and not counter.destroyed:
					counter.issue_move(destination, mouse.shift_pressed)
			return
	if event is InputEventMouseMotion and selection_active:
		selection_end = get_global_mouse_position()
		show_selection_box = true
		update_selection_overlay()
	if event is InputEventKey:
		var key: InputEventKey = event
		if not key.pressed or key.echo:
			return
		match key.keycode:
			KEY_SPACE:
				paused = not paused
			KEY_F:
				for counter in counters:
					if counter.side == "player" and counter.selected:
						counter.toggle_formation()
			KEY_X:
				for counter in counters:
					if counter.side == "player" and counter.selected:
						counter.stop()
			KEY_C:
				var group_center := Vector2.ZERO
				var count := 0
				for counter in counters:
					if counter.side == "player" and counter.selected:
						group_center += counter.position
						count += 1
				if count > 0:
					camera.position = group_center / float(count)
			KEY_F8:
				terrain.debug_terrain = not terrain.debug_terrain
				terrain.queue_redraw()
			KEY_F10:
				fog_debug = not fog_debug
				fog_sprite.visible = not fog_debug
				refresh_visibility()
			KEY_EQUAL, KEY_KP_ADD:
				game_speed_index = mini(GAME_SPEEDS.size() - 1, game_speed_index + 1)
			KEY_MINUS, KEY_KP_SUBTRACT:
				game_speed_index = maxi(0, game_speed_index - 1)


func zoom_at_cursor(factor: float) -> void:
	# Preserve the point under the cursor without relying on a camera update mid-event.
	var offset_from_center: Vector2 = get_viewport().get_mouse_position() - get_viewport_rect().size * 0.5
	var before: Vector2 = camera.position + offset_from_center / camera.zoom.x
	var next_zoom := clampf(camera.zoom.x * factor, 0.5, 2.0)
	camera.zoom = Vector2(next_zoom, next_zoom)
	camera.position = before - offset_from_center / next_zoom
	clamp_camera()


func select_at(world_point: Vector2, additive: bool) -> void:
	var chosen = null
	for counter in counters:
		if counter.side == "player" and counter.visible and counter.hit_test(world_point):
			chosen = counter
			break
	if not additive:
		for counter in counters:
			counter.selected = false
			counter.queue_redraw()
	if chosen != null:
		chosen.selected = (not chosen.selected) if additive else true
		chosen.queue_redraw()


func select_rectangle(rectangle: Rect2, additive: bool) -> void:
	for counter in counters:
		if counter.side != "player":
			continue
		if not additive:
			counter.selected = false
		if rectangle.has_point(counter.position):
			counter.selected = true
		counter.queue_redraw()


func update_selection_overlay() -> void:
	selection_overlay.start_world = selection_origin
	selection_overlay.end_world = selection_end
	selection_overlay.is_active = show_selection_box
	selection_overlay.queue_redraw()


func refresh_hud() -> void:
	if hud == null:
		return
	var names: Array[String] = []
	for counter in counters:
		if counter.side == "player" and counter.selected:
			names.append("%s [%s, %d/%d]" % [counter.unit_name, counter.formation, counter.strength, counter.max_strength])
	var selected_description := ", ".join(PackedStringArray(names)) if not names.is_empty() else "none"
	hud.text = "THIN RED LINE | tactical sandbox | FPS %d | LOS %.1f ms\n" % [Engine.get_frames_per_second(), los_last_ms]
	hud.text += "WASD/arrows pan  Wheel zoom  LMB select/drag  Shift+LMB add  RMB move  Shift+RMB queue\n"
	hud.text += "F line/column  X stop  C center  Space pause  +/- speed  F8 terrain debug  F10 fog reveal\n"
	hud.text += "Speed %.1fx | %s | Selected: %s" % [float(GAME_SPEEDS[game_speed_index]), "PAUSED" if paused else "RUNNING", selected_description]
