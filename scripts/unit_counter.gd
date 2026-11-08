extends Node2D
## One formation counter is one tactical unit, not a collection of soldier actors.
## Visual counter geometry is deliberately separate from mechanical footprints.

const VISUAL_SIZE := Vector2(72.0, 36.0)
const TURN_TOLERANCE_DEGREES := 30.0
const FATIGUE_MOVEMENT_RATE := 0.20
const FATIGUE_RECOVERY_RATE := 0.50
const FATIGUE_TURN_RATE := 0.40
const FATIGUE_FORMATION_CHANGE_COST := 2.0

var unit_id: String = ""
var unit_name: String = ""
var unit_type: String = "infantry"
var side: String = "player"
var weapon: String = ""
var mechanical_size: Vector2 = Vector2(120.0, 60.0)
var speed: float = 100.0
var rotation_speed: float = 90.0
var strength: int = 100
var max_strength: int = 100
var morale: float = 100.0
var fatigue: float = 0.0
var formation: String = "line"
var formation_time: float = 0.0
var attack_at_will: bool = false
var fire_at_will: bool = true
var hold_fire: bool = false
var destroyed: bool = false
var selected: bool = false
var orders: Array[Vector2] = []


func configure(spec: Dictionary, unit_definitions: Dictionary) -> void:
	unit_id = str(spec.get("id", ""))
	unit_name = str(spec.get("name", unit_id))
	unit_type = str(spec.get("unit_type", "infantry"))
	side = str(spec.get("side", "player"))
	var definition: Dictionary = unit_definitions[unit_type]
	mechanical_size = Vector2(float(definition["width"]), float(definition["height"]))
	speed = float(definition["speed"])
	rotation_speed = float(definition["rotation_speed"])
	max_strength = int(definition["block_rows"]) * int(definition["block_columns"]) * int(definition["block_strength"])
	strength = max_strength
	var weapon_value: Variant = spec.get("weapon", null)
	weapon = "" if weapon_value == null else str(weapon_value)
	attack_at_will = bool(spec.get("attack_at_will", false))
	# Original scenario coordinates denote the top-left mechanical footprint.
	position = Vector2(float(spec["x"]), float(spec["y"])) + mechanical_size * 0.5
	rotation = deg_to_rad(float(spec.get("angle", 0.0)))
	queue_redraw()


func issue_move(world_destination: Vector2, queued: bool = false) -> void:
	if not queued:
		orders.clear()
	orders.append(world_destination)


func toggle_formation() -> void:
	if formation_time > 0.0 or destroyed:
		return
	formation = "column" if formation == "line" else "line"
	formation_time = 2.0
	fatigue = minf(100.0, fatigue + FATIGUE_FORMATION_CHANGE_COST)
	queue_redraw()


func stop() -> void:
	orders.clear()


func simulate_step(delta: float, terrain: Node2D) -> void:
	if destroyed:
		return
	if formation_time > 0.0:
		formation_time = maxf(0.0, formation_time - delta)
		return
	if orders.is_empty():
		fatigue = maxf(0.0, fatigue - FATIGUE_RECOVERY_RATE * delta)
		return

	var target: Vector2 = orders[0]
	var displacement := target - position
	if displacement.length() < 2.0:
		orders.pop_front()
		return

	var desired := displacement.angle()
	var difference := wrapf(desired - rotation, -PI, PI)
	var formation_turn := 1.3 if formation == "column" else 1.0
	var turn_per_sec := rotation_speed * formation_turn * (1.0 - fatigue / 100.0 * 0.50)
	var change := clampf(difference, -deg_to_rad(turn_per_sec) * delta, deg_to_rad(turn_per_sec) * delta)
	rotation = wrapf(rotation + change, -PI, PI)
	fatigue = minf(100.0, fatigue + absf(rad_to_deg(change)) * FATIGUE_TURN_RATE / 90.0)
	if absf(rad_to_deg(difference)) > TURN_TOLERANCE_DEGREES:
		return

	var formation_speed := 1.2 if formation == "column" else 1.0
	var movement_speed := speed * formation_speed * (1.0 - fatigue / 100.0 * 0.20)
	var travel := minf(movement_speed * delta, displacement.length())
	var next_position := position + displacement.normalized() * travel
	# This is a straight-line first slice, NOT the Python path planner.
	# Never pass through water; bridge/ford permissions come from true terrain.
	if not terrain.can_occupy(next_position):
		return
	position = next_position
	fatigue = minf(100.0, fatigue + FATIGUE_MOVEMENT_RATE * delta)
	if position.distance_to(target) < 2.0:
		orders.pop_front()


func hit_test(world_point: Vector2) -> bool:
	return Rect2(-VISUAL_SIZE * 0.5, VISUAL_SIZE).has_point(to_local(world_point))


func _draw() -> void:
	var base_color := Color("#244a67") if side == "player" else Color("#8a3045")
	draw_rect(Rect2(-VISUAL_SIZE * 0.5, VISUAL_SIZE), base_color)
	draw_rect(Rect2(-VISUAL_SIZE * 0.5, VISUAL_SIZE), Color("#e6d7ab"), false, 1.5)
	draw_line(Vector2(34, -16), Vector2(34, 16), Color("#f1cf6d"), 4.0)
	match unit_type:
		"infantry":
			draw_line(Vector2(-13, -12), Vector2(13, 12), Color.WHITE, 2.0)
			draw_line(Vector2(-13, 12), Vector2(13, -12), Color.WHITE, 2.0)
		"cavalry":
			draw_line(Vector2(-13, 12), Vector2(13, -12), Color.WHITE, 2.0)
		"artillery":
			draw_circle(Vector2.ZERO, 6.0, Color.WHITE)
		"hq":
			draw_line(Vector2(-11, 0), Vector2(11, 0), Color.WHITE, 2.0)
			draw_line(Vector2(0, -11), Vector2(0, 11), Color.WHITE, 2.0)
	if formation == "column":
		draw_circle(Vector2(-28, 0), 3.0, Color("#f1cf6d"))
	if selected:
		draw_rect(Rect2(-VISUAL_SIZE * 0.5 - Vector2(3, 3), VISUAL_SIZE + Vector2(6, 6)), Color.YELLOW, false, 2.5)
