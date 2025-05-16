extends Node2D

@onready var ball = $TheBall/Ball
@onready var paddle_one = $Paddles/PaddleOne
@onready var paddle_two = $Paddles/PaddleTwo

@onready var detector_left = $Environment/DetectorLeft
@onready var detector_right = $Environment/DetectorRight
@onready var start_delay = $StartDelay

@onready var hud = $CanvasLayer/HUD
@onready var l2d = $TheBall/BallMovementLine2D
@onready var ball_out_sound = $TheBall/BallOutSound

var game_area_size = Vector2(1280, 720)

var score = Vector2i.ZERO
@export var final_score = 11

func _ready():
	detector_left.ball_out.connect(_on_detector_ball_out)
	detector_right.ball_out.connect(_on_detector_ball_out)
	ball.bounced.connect(_on_ball_bounced)
	
	randomize()
	reset_game()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ball_control"):
		ball.debug_mode = !ball.debug_mode
		paddle_one.active = !ball.debug_mode
		if !ball.debug_mode:
			ball.move_dir = Vector2(-1, 0)
	if Input.is_action_just_pressed("show_lines"):
		l2d.visible = !l2d.visible

func _draw() -> void:
	var line_start = Vector2(game_area_size.x/2.0, 0)
	var line_end = Vector2(game_area_size.x/2.0, game_area_size.y)
	draw_dashed_line(line_start, line_end, Color.WHITE, 8.0, 12.0, false)

func reset_game():
	score = Vector2i.ZERO
	hud.reset_score()
	reset_round()

func reset_round():
	var reset_pos = game_area_size / 2.0
	ball.reset(reset_pos)
	start_delay.start()
	await start_delay.timeout
	ball.active = true
	simulate_ball_movement()

func _on_detector_ball_out(is_left):
	if is_left:
		score.y += 1 # right scored
	else:
		score.x += 1 # left scored
	
	hud.set_new_score(score)
	ball_out_sound.play()
	l2d.clear_points()
	
	if score.x >= final_score || score.y >= final_score:
		reset_game()
	else:
		reset_round()

func update_l2d(points):
	l2d.clear_points()
	l2d.global_position = ball.global_position
	for point in points:
		var localized_point = l2d.to_local(point)
		l2d.add_point(localized_point)

func _on_ball_bounced():
	simulate_ball_movement()

func simulate_ball_movement(seconds: float = 3.0):
	var ball_pos = ball.global_position
	var move_dir_copy = ball.move_dir
	var bs = ball.get_size()
	
	var top_limit = bs.y / 2.0
	var bottom_limit = game_area_size.y - (bs.y / 2.0)
	var left_limit = paddle_one.global_position.x + (bs.x / 2.0)
	var right_limit = paddle_two.global_position.x - (bs.x / 2.0)
	
	var points = [ball_pos]
	var dt = get_physics_process_delta_time()
	
	for i in range(0, 60 * seconds):
		ball_pos += move_dir_copy * ball.speed * dt
		
		if ball_pos.x <= left_limit || ball_pos.x >= right_limit:
			if (ball_pos.x <= left_limit) && (move_dir_copy.x > 0):
				pass
			elif (ball_pos.x >= right_limit) && (move_dir_copy.x < 0):
				pass
			else:
				break
		
		if ball_pos.y <= top_limit || ball_pos.y >= bottom_limit:
			move_dir_copy.y *= -1
			points.append(ball_pos)
	
	points.append(ball_pos)
	
	if paddle_one.is_ai:
		paddle_one.ai_target_ypos = ball_pos.y
	if paddle_two.is_ai:
		paddle_two.ai_target_ypos = ball_pos.y
	
	update_l2d(points)
