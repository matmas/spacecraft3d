extends FloatOption

@onready var current_value = snappedf(ProjectSettings.get_setting("rendering/scaling_3d/fsr_sharpness"), 0.1)


func section() -> String:
	return "display"


func key() -> String:
	return "fsr_sharpness"


func set_value(value: Variant) -> void:
	RenderingServer.viewport_set_fsr_sharpness(get_viewport().get_viewport_rid(), value)
	current_value = value
	value_changed.emit(value)


func get_value() -> Variant:
	return current_value


func get_min_value() -> float:
	return 0.0


func get_step() -> float:
	return 0.1


func get_max_value() -> float:
	return 2.0
