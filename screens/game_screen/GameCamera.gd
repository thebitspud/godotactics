extends Camera2D


export var scroll_speed: float = 250

var _stage_scale := 2;


# Called when the node enters the scene tree for the first time.
func _ready():
	adjust_stage_scale(0)


# Called at a constant rate. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	var scroll_dist := (scroll_speed * delta) / sqrt(_stage_scale)
	
	if Input.is_action_pressed("ui_left"):
		position.x -= scroll_dist
	
	if Input.is_action_pressed("ui_right"):
		position.x += scroll_dist
	
	if Input.is_action_pressed("ui_up"):
		position.y -= scroll_dist
	
	if Input.is_action_pressed("ui_down"):
		position.y += scroll_dist
	
	if Input.is_action_just_pressed("ui_zoom_in"):
		adjust_stage_scale(1)
	
	if Input.is_action_just_pressed("ui_zoom_out"):
		adjust_stage_scale(-1)


func adjust_stage_scale(value: int):
	_stage_scale = clamp(_stage_scale + value, 1, 4)
	var zoom_factor := 1.0/_stage_scale;
	zoom = Vector2(zoom_factor, zoom_factor)
