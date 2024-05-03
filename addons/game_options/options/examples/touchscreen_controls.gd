extends BoolOption

var current_value := true


func key() -> String:
	return "touchscreen_controls"


func get_display_name() -> String:
	return tr("Touchscreen controls")


func set_value(value: bool) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> bool:
	return current_value


func is_visible() -> bool:
	return DisplayServer.is_touchscreen_available()
