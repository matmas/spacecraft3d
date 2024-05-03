extends BoolOption

var current_value := true


func key() -> String:
	return "input_hints"


func get_display_name() -> String:
	return tr("Input hints")


func set_value(value: bool) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> bool:
	return current_value
