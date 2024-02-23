extends BoolOption


func section() -> String:
	return "display"


func key() -> String:
	return "fullscreen"


func set_value(value: Variant) -> void:
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	value_changed.emit(value)


func get_value() -> Variant:
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_WINDOWED:
			return false
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, DisplayServer.WINDOW_MODE_FULLSCREEN:
			return true
		_:
			return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"toggle_fullscreen"):
		set_value(not get_value())
