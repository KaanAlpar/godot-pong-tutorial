extends Node2D

@onready var ball = $Ball
@onready var paddle_one = $PaddleOne
@onready var paddle_two = $PaddleTwo

@onready var detector_left = $DetectorLeft
@onready var detector_right = $DetectorRight
@onready var start_delay = $StartDelay

@onready var hud = $CanvasLayer/HUD

var game_area_size = Vector2(1280, 720)

var score = Vector2i.ZERO
@export var final_score = 11

func _ready():
	detector_left.ball_out.connect(_on_detector_ball_out)
	detector_right.ball_out.connect(_on_detector_ball_out)
	
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

func _on_detector_ball_out(is_left):
	if is_left:
		score.y += 1 # right scored
	else:
		score.x += 1 # left scored
	
	hud.set_new_score(score)
	
	if score.x >= final_score || score.y >= final_score:
		reset_game()
	else:
		reset_round()
	
	
	
