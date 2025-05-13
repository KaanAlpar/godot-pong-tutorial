extends Area2D

@export var is_player_one = false

var up_input = "paddle_up"
var down_input = "paddle_down"

const MAX_VELOCITY = 10.0
var velocity = 0.0
var acceleration = 50.0
var slow_down_delta = 2.0

func _ready():
	if is_player_one == false:
		up_input += "_two"
		down_input += "_two"
		print(up_input)
		print(down_input)

func _physics_process(delta: float) -> void:
	var move_dir = 0.0
	
	move_dir = Input.get_axis(up_input, down_input)
	
	velocity += move_dir * acceleration * delta
	if move_dir == 0.0:
		velocity = move_toward(velocity, 0.0, slow_down_delta)
	
	velocity = clampf(velocity, -MAX_VELOCITY, MAX_VELOCITY)
	
	global_position.y += velocity
	global_position.y = clampf(global_position.y, 0, get_window().size.y)
	
