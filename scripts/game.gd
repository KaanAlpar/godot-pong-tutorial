extends Node2D

@onready var ball = $Ball
@onready var paddle_one = $PaddleOne
@onready var paddle_two = $PaddleTwo

var game_area_size = Vector2(1280, 720)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ball_control"):
		ball.debug_mode = !ball.debug_mode
		paddle_one.active = !ball.debug_mode
		if !ball.debug_mode:
			ball.move_dir = Vector2(1, 0.2)

func _draw() -> void:
	var line_start = Vector2(game_area_size.x/2.0, 0)
	var line_end = Vector2(game_area_size.x/2.0, game_area_size.y)
	draw_dashed_line(line_start, line_end, Color.WHITE, 8.0, 12.0, false)
