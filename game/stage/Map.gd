extends TileMap


onready var camera := $"../../GameCamera"


func get_mouse_cell() -> Vector2:
	var camera_position = camera.get_camera_position()
	var mouse_position = get_viewport().get_mouse_position()
	var mouse_offset = (mouse_position - get_viewport().size / 2) * camera.zoom
	return world_to_map(camera_position + mouse_offset)


func is_valid_cell(cell: Vector2) -> bool:
	return get_cellv(cell) >= 0


func in_map_bounds(cell: Vector2) -> bool:
	return get_used_rect().has_point(cell)
