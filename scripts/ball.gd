extends CharacterBody2D

var debug_mode = false

const START_SPEED = 500
var speed = START_SPEED
var move_dir = Vector2(-1, -1)

func _physics_process(delta: float) -> void:
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
		#move_dir.y *= -1
		move_dir = move_dir.bounce(get_last_slide_collision().get_normal())
