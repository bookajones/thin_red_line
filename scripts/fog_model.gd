extends RefCounted
## Side-specific battlefield knowledge and LOS. No UI or AI side effects.
## First-slice LOS uses 8-unit sampling of authored rectangles. Exact raster
## forest DDA and exposed-footprint detection are parity work, not claimed here.

const CELL_SIZE := 32
const OBSERVATION_RANGE := 300.0
const FOREST_EDGE_DEPTH := 20.0
const VILLAGE_EDGE_DEPTH := 20.0

var columns: int = 0
var rows: int = 0
var visibility: Dictionary = {}
var discovered: Dictionary = {}
var fog_image: Image
var fog_texture: ImageTexture


func configure(world_size: Vector2) -> void:
	columns = ceili(world_size.x / CELL_SIZE)
	rows = ceili(world_size.y / CELL_SIZE)
	for side in ["player", "enemy"]:
		var empty := PackedByteArray()
		empty.resize(columns * rows)
		empty.fill(0)
		visibility[side] = empty.duplicate()
		discovered[side] = empty.duplicate()
	fog_image = Image.create_empty(columns, rows, false, Image.FORMAT_RGBA8)
	fog_texture = ImageTexture.create_from_image(fog_image)


func is_cell_visible(side: String, x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= columns or y >= rows or not visibility.has(side):
		return false
	var cells: PackedByteArray = visibility[side]
	return cells[y * columns + x] == 1


func is_cell_discovered(side: String, x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= columns or y >= rows or not discovered.has(side):
		return false
	var cells: PackedByteArray = discovered[side]
	return cells[y * columns + x] == 1


func is_world_visible(side: String, world_point: Vector2) -> bool:
	return is_cell_visible(side, floori(world_point.x / CELL_SIZE), floori(world_point.y / CELL_SIZE))


func has_line_of_sight(start: Vector2, finish: Vector2, terrain: Node2D) -> bool:
	var length := start.distance_to(finish)
	if length < 0.001:
		return true
	var steps := maxi(1, ceili(length / 8.0))
	var step_length := length / float(steps)
	var forest_depth := 0.0
	var village_depth := 0.0
	for i in range(steps):
		var midpoint := start.lerp(finish, (float(i) + 0.5) / float(steps))
		var obstacle: String = terrain.blocker_at(midpoint)
		if obstacle == "forest":
			forest_depth += step_length
		elif obstacle == "village":
			village_depth += step_length
		var forest_touch: bool = terrain.blocker_at(start) == "forest" or terrain.blocker_at(finish) == "forest"
		var village_touch: bool = terrain.blocker_at(start) == "village" or terrain.blocker_at(finish) == "village"
		if forest_depth > (FOREST_EDGE_DEPTH if forest_touch else 0.0):
			return false
		if village_depth > (VILLAGE_EDGE_DEPTH if village_touch else 0.0):
			return false
	return true


func can_detect(observer: Node2D, target: Node2D, terrain: Node2D) -> bool:
	if observer.side == target.side or observer.destroyed or target.destroyed:
		return false
	var distance := observer.position.distance_to(target.position)
	var concealment: String = terrain.blocker_at(target.position)
	var allowed := OBSERVATION_RANGE
	if concealment == "forest":
		allowed = 60.0
	elif concealment == "village":
		allowed = 40.0
	return distance <= allowed and has_line_of_sight(observer.position, target.position, terrain)


func recalculate(observers: Array[Node2D], terrain: Node2D) -> bool:
	var anything_changed := false
	for side in ["player", "enemy"]:
		var new_visible := PackedByteArray()
		new_visible.resize(columns * rows)
		new_visible.fill(0)
		for observer in observers:
			if observer.destroyed or observer.side != side:
				continue
			var pos: Vector2 = observer.position
			var min_x := maxi(0, floori((pos.x - OBSERVATION_RANGE) / CELL_SIZE))
			var max_x := mini(columns - 1, floori((pos.x + OBSERVATION_RANGE) / CELL_SIZE))
			var min_y := maxi(0, floori((pos.y - OBSERVATION_RANGE) / CELL_SIZE))
			var max_y := mini(rows - 1, floori((pos.y + OBSERVATION_RANGE) / CELL_SIZE))
			for row in range(min_y, max_y + 1):
				for column in range(min_x, max_x + 1):
					var cell_center := Vector2((float(column) + 0.5) * CELL_SIZE, (float(row) + 0.5) * CELL_SIZE)
					if pos.distance_squared_to(cell_center) > OBSERVATION_RANGE * OBSERVATION_RANGE:
						continue
					if has_line_of_sight(pos, cell_center, terrain):
						new_visible[row * columns + column] = 1

		var old: PackedByteArray = visibility[side]
		var known: PackedByteArray = discovered[side]
		if old != new_visible:
			anything_changed = true
		for index in range(new_visible.size()):
			if new_visible[index] == 1:
				known[index] = 1
		visibility[side] = new_visible
		discovered[side] = known
	return anything_changed


func refresh_texture(side: String = "player") -> void:
	var current: PackedByteArray = visibility[side]
	var known: PackedByteArray = discovered[side]
	for row in range(rows):
		for col in range(columns):
			var index := row * columns + col
			var alpha := 1.0
			if current[index] == 1:
				alpha = 0.0
			elif known[index] == 1:
				alpha = 0.55
			fog_image.set_pixel(col, row, Color(0.035, 0.05, 0.075, alpha))
	fog_texture.update(fog_image)


func apply_to_sprite(sprite: Sprite2D) -> void:
	sprite.texture = fog_texture
	sprite.centered = false
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2(CELL_SIZE, CELL_SIZE)
