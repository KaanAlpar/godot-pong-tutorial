@tool
extends Node2D

func _draw() -> void:
	var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var line_start = Vector2(window_width/2.0, 0)
	var line_end = Vector2(window_width/2.0, window_height)
	draw_dashed_line(line_start, line_end, Color.WHITE, 8.0, 12.0, false)
