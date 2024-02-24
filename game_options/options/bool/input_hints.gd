extends BoolOption

var current_value := true


func section() -> String:
	return "graphics"


func key() -> String:
	return "input_hints"


func get_display_name() -> String:
	return tr("Input hints")


func get_display_category() -> String:
	return tr("User interface")


func set_value(value: Variant) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value
