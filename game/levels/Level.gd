extends Node2D


const PL_UNIT := preload("res://game/entities/units/Unit.tscn")

onready var _map := $"../Map"


# Returns true if this cell contains an entity
func has_entity(cell: Vector2) -> bool:
	return get_entity(cell) != null


# Returns the entity at this cell, or null if there is none
func get_entity(cell: Vector2) -> Node2D:
	if _map.in_map_bounds(cell):
		for e in get_tree().get_nodes_in_group("entities"):
			if e.get_coord().is_equal_approx(cell):
				return e
	
	return null


# Spawns an entity at the specified cell if possible
func spawn_entity(cell: Vector2):
	if cell_available(cell):
		var entity := PL_UNIT.instance()
		add_child(entity)
		entity.set_coord(cell)


func cell_available(cell: Vector2) -> bool:
	return _map.in_map_bounds(cell) && !has_entity(cell)
