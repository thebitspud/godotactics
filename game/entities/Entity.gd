extends Node2D


class_name Entity


enum Alignment { FRIENDLY, NEUTRAL, ENEMY }

export var max_health := 5
export var _coord: Vector2
export(Alignment) var alignment := Alignment.NEUTRAL

onready var _health := max_health
onready var _level := get_parent()
onready var _map = $"../../Map"


# Called when the node enters the scene tree for the first time.
func _ready():
	_coord = _coord.round();
	position = _map.map_to_world(_coord)


# Retrieves the coordinate of this entity
func get_coord() -> Vector2:
	return _coord;


# Retrieves the manhattan distance from the entity to this location
func dist(coord: Vector2) -> int:
	var diff := coord - _coord
	return int(abs(diff.x) + abs(diff.y))


# Sets the coordinate of this entity, if possible
func set_coord(coord: Vector2):
	coord = coord.round()
	if _level.cell_available(coord):
		self._coord = coord;
		position = _map.map_to_world(coord)


# Increments or decrements entity health by the given value
func adjust_health(value: int):
	_health = clamp(_health + value, 0, max_health)
	if _health == 0:
		queue_free()


func get_health() -> int:
	return _health


func get_health_str() -> String:
	return str(_health) + "/" + str(max_health)
