extends Entity


class_name Unit


const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

export var agility := 2
export var attack_range := 1
export var attack_power := 1

var can_move := true
var _moves := {} # Dictionary<Vector2, int>
var can_act := true
var _targets := []


# Sets the coordinate of this entity, ignoring agility constraint
func set_coord(coord: Vector2):
	.set_coord(coord)
	find_actions()


# Sets the coordinate of this entity if allowed by agility constraint
func move(coord: Vector2):
	coord = coord.round()
	if !get_moves().has(coord):
		return
	
	can_move = false
	set_coord(coord)
	find_actions()


# 
func attack(entity: Entity):
	if !can_attack(entity):
		return
	
	can_act = false
	can_move = false
	find_actions()
	
	entity.adjust_health(-attack_power)


func find_actions():
	_find_moves()
	_find_targets()


# Finds all allowed moves from this unit's current location
func _find_moves():
	_moves.clear()
	if !can_move:
		return
	
	for direction in DIRECTIONS:
		next_moves(_coord + direction, agility - 1)


func _find_targets():
	_targets.clear()
	for e in get_tree().get_nodes_in_group("entities"):
		if dist(e.get_coord()) <= attack_range:
			_targets.append(e)


# Uses a modified flood fill algorithm to determine which grid locations can be moved to.
func next_moves(from: Vector2, moves_left: int):
	if moves_left < 0:
		return
	if _moves.has(from) && moves_left < _moves[from]:
		return
	if !_level.cell_available(from):
		return
	
	_moves[from] = moves_left
	for direction in DIRECTIONS:
		next_moves(from + direction, moves_left - 1)


# Returns a list of coordinates this entity can move to
func get_moves() -> Array:  # Array<Vector2>
	return _moves.keys()


# Returns a list of entities this unit can target
func get_targets() -> Array:  # Array<Vector2>
	return _targets


# Returns true if the specified entity can be attacked
func can_attack(entity: Entity) -> bool:
	if entity == null || !can_act || entity.alignment == alignment:
		return false
	
	return _targets.has(entity)
