extends Node2D
class_name TacticalTerrain
## Runtime view of authoritative terrain data. Scout maps must never alter this state.

var world_size: Vector2 = Vector2(3000.0, 2000.0)
var features: Array[Dictionary] = []

const COLORS: Dictionary = {
	"forest": Color("#536d53"),
	"hill": Color("#a8a17b"),
	"marsh": Color("#788a7a"),
	"village": Color("#ad8e75"),
	"road": Color("#c0b49a"),
	"river": Color("#597c9d"),
	"bridge": Color("#d0b98b"),
	"ford": Color("#9bb1b3")
}


func configure(definition: Dictionary) -> void:
	world_size = Vector2(float(definition.get("width", 3000)), float(definition.get("height", 2000)))
	features.clear()
	for raw_feature in definition.get("terrain", []):
		var feature: Dictionary = raw_feature
		var area := Rect2(
			float(feature.get("x", 0.0)),
			float(feature.get("y", 0.0)),
			float(feature.get("width", 0.0)),
			float(feature.get("height", 0.0))
		)
		assert(area.size.x > 0.0 and area.size.y > 0.0)
		features.append({"type": str(feature.get("type", "plain")), "rect": area})
	queue_redraw()


func terrain_at(world_point: Vector2) -> String:
	# Bridge/ford take precedence over underlying river and road.
	var kind: String = "plain"
	for feature in features:
		var area: Rect2 = feature["rect"]
		if not area.has_point(world_point):
			continue
		var candidate: String = feature["type"]
		if candidate == "bridge" or candidate == "ford":
			return candidate
		if candidate == "river":
			kind = "river"
		elif kind != "river":
			kind = candidate
	return kind


func blocker_at(world_point: Vector2) -> String:
	for feature in features:
		var kind: String = feature["type"]
		if kind != "forest" and kind != "village":
			continue
		var area: Rect2 = feature["rect"]
		if area.has_point(world_point):
			return kind
	return ""


func can_occupy(world_point: Vector2) -> bool:
	return Rect2(Vector2.ZERO, world_size).has_point(world_point) and terrain_at(world_point) != "river"


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, world_size), Color("#c8bea6"))
	for feature in features:
		var area: Rect2 = feature["rect"]
		var kind: String = feature["type"]
		draw_rect(area, COLORS.get(kind, Color("#c8bea6")))
		draw_rect(area, Color("#3b4644"), false, 2.0)
	# A subtle cartographic grid is intentionally presentation-only.
	for x in range(0, int(world_size.x) + 1, 200):
		draw_line(Vector2(x, 0), Vector2(x, world_size.y), Color(0.2, 0.2, 0.2, 0.12))
	for y in range(0, int(world_size.y) + 1, 200):
		draw_line(Vector2(0, y), Vector2(world_size.x, y), Color(0.2, 0.2, 0.2, 0.12))
	draw_rect(Rect2(Vector2.ZERO, world_size), Color("#3b4644"), false, 5.0)
