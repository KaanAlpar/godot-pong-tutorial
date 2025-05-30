extends CharacterBody2D
class_name Ball

signal bounced

@onready var cshape = $CollisionShape2D
@onready var beep1 = $Beep1
@onready var beep2 = $Beep2

@export var speed_increase_per_bounce = 20

var active = false
var debug_mode = false

const START_SPEED = 500
var speed = START_SPEED
var move_dir = Vector2(-1, 0)

func _physics_process(delta: float) -> void:
	if !active: return
	
	if debug_mode:
		var vertical_dir = Input.get_axis("ball_up", "ball_down")
		var horizontal_dir = Input.get_axis("ball_left", "ball_right")
		move_dir = Vector2(horizontal_dir, vertical_dir)
		
		if move_dir.x != 0.0 || move_dir.y != 0.0:
			velocity = move_dir * speed
		else:
			velocity = Vector2.ZERO
		
	else:
		velocity = move_dir * speed
	
	var collided = move_and_slide()
	
	if collided:
		move_dir = move_dir.bounce(get_last_slide_collision().get_normal())
		play_beep()

func bounce_from_paddle(paddle_y_pos, paddle_height):
	var new_move_dir_y = (global_position.y - paddle_y_pos) / (paddle_height/2.0)
	move_dir.y = new_move_dir_y
	move_dir.x *= -1
	
	speed += speed_increase_per_bounce
	
	play_beep()
	
	bounced.emit()

func reset(reset_pos):
	global_position = reset_pos
	speed = START_SPEED
	
	move_dir.x = [-1, 1].pick_random()
	move_dir.y = randf() * [-1, 1].pick_random()
	
	active = false

func get_size():
	return cshape.shape.get_rect().size

func play_beep():
	var beep = [beep1, beep2].pick_random()
	beep.pitch_scale = [0.8, 1.0, 1.2].pick_random()
	beep.play()
