extends Node2D

var game_area_size = Vector2(1280, 720)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _draw() -> void:
	var line_start = Vector2(game_area_size.x/2.0, 0)
	var line_end = Vector2(game_area_size.x/2.0, game_area_size.y)
	draw_dashed_line(line_start, line_end, Color.WHITE, 8.0, 12.0, false)
