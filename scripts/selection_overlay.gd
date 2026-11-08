extends Node2D
## Selection rectangle is above the terrain, counters and fog.

var start_world: Vector2 = Vector2.ZERO
var end_world: Vector2 = Vector2.ZERO
var is_active: bool = false


func _draw() -> void:
	if not is_active:
		return
	var rect := Rect2(start_world, end_world - start_world).abs()
	draw_rect(rect, Color(0.7, 0.8, 1.0, 0.16))
	draw_rect(rect, Color(0.9, 0.95, 1.0), false, 2.0)
