extends BoolOption

var current_value := true


func section() -> String:
	return "display"


func key() -> String:
	return "motion_particles"


func get_display_name() -> String:
	return tr("Motion particles")


func get_display_category() -> String:
	return tr("Graphics")


func set_value(value: Variant) -> void:
	current_value = value
	value_changed.emit(value)


func get_value() -> Variant:
	return current_value
