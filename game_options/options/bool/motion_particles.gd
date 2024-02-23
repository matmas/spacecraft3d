extends BoolOption

var current_value := true


func section() -> String:
	return "display"


func key() -> String:
	return "motion_particles"


func set_value(value: Variant) -> void:
	current_value = value
	value_changed.emit(value)


func get_value() -> Variant:
	return current_value
