extends Node2D


onready var _map := $Map
onready var _level := $Level
onready var _tile_info := $"../UILayer/GameHUD/TileInfo"
onready var _highlights := $Highlights
var _selected_unit: Unit


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	_update_hover()


# Interacts with the game map according to mouse input
func _input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.is_pressed() && !event.is_echo():
			var mouse_cell = _map.get_mouse_cell()
			var entity = _level.get_entity(mouse_cell);
			
			if entity == _selected_unit:
				_selected_unit = null
			elif entity != null && entity.has_method("get_moves"):
				if _selected_unit != null && _selected_unit.get_targets().has(entity):
					_selected_unit.attack(entity)
					_selected_unit = null
				else:
					_selected_unit = _level.get_entity(mouse_cell)
			else:
				_selected_unit.move(mouse_cell)
				_selected_unit = null
			
			_highlights.update_select(_selected_unit)


# Updates tile info to match currently hovered tile
func _update_hover():
	var mouse_cell = _map.get_mouse_cell()
	_highlights.set_hover(mouse_cell)
	
	if _map.is_valid_cell(mouse_cell):
		var tileset_coord = _map.get_cell_autotile_coord(mouse_cell.x, mouse_cell.y);
		var tile_id = tileset_coord.y * 8 + tileset_coord.x
		_tile_info.text = str(mouse_cell) + ":" + str(tile_id)
		
		if _level.has_entity(mouse_cell):
			var entity = _level.get_entity(mouse_cell);
			_tile_info.text += "\n" + entity.get_health_str();
	
	else:
		_tile_info.text = ""
