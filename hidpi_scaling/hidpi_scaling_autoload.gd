extends Node


func _ready() -> void:
	if DisplayServer.screen_get_dpi(0) > 120:
		get_window().content_scale_factor = 2.0
