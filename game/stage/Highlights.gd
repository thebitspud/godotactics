extends Node2D


const PL_HIGHLIGHT = preload("res://game/stage/Highlight.tscn")
enum SpriteIndex { HOVER, MOVE, SELF, ACTION, ATTACK }


onready var _map := $"../Map"
onready var _tile_hover := $TileHover
onready var _tile_select := $TileSelect
onready var _actions := $Actions


# Called when the node enters the scene tree for the first time.
func _ready():
	update_select(null)


func set_hover(coord: Vector2):
	_tile_hover.visible = _map.is_valid_cell(coord)
	_tile_hover.position = _map.map_to_world(coord)


# Updates TileSelect highlight to selected entity
func update_select(selected_unit: Unit):
	if (selected_unit == null):
		_tile_select.visible = false
	else:
		_tile_select.position = _map.map_to_world(selected_unit.get_coord())
		_tile_select.visible = true
		selected_unit.find_actions()
	
	_draw_actions(selected_unit)


func _draw_actions(unit: Unit):
	_clear_actions()
	if (unit == null):
		return
	
	for move in unit.get_moves():
		_add_action(move, SpriteIndex.MOVE)
	
	for target in unit.get_targets():
		if target.alignment != unit.alignment:
			_add_action(target.get_coord(), SpriteIndex.ATTACK)


func _clear_actions():
	for child in _actions.get_children():
		child.queue_free()


func _add_action(coord: Vector2, index: int):
	var action_highlight := PL_HIGHLIGHT.instance()
	_actions.add_child(action_highlight)
	action_highlight.position = _map.map_to_world(coord)
	action_highlight.region_rect.position.x = 16 * index
