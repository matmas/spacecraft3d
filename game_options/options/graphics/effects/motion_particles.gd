extends BoolOption

var current_value := true


func key() -> String:
	return "motion_particles"


func get_display_name() -> String:
	return tr("Motion particles")


func set_value(value: Variant) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value
