extends BoolOption


func key() -> String:
	return "fullscreen"


func get_display_name() -> String:
	return tr("Fullscreen")


func set_value(value: Variant) -> void:
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	value_changed.emit()


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


func is_visible() -> bool:
	return OS.get_name() not in ["Android"]
