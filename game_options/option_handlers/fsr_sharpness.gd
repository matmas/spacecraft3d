extends OptionHandler

@onready var current_value = snappedf(ProjectSettings.get_setting("rendering/scaling_3d/fsr_sharpness"), 0.1)


func section() -> String:
	return "display"


func key() -> String:
	return "fsr_sharpness"


func set_value(value: Variant) -> void:
	RenderingServer.viewport_set_fsr_sharpness(get_viewport().get_viewport_rid(), value)
	current_value = value


func get_value() -> Variant:
	return current_value


func get_value_from_string(value: String) -> Variant:
	return float(value)


func get_possible_string_values() -> Array[String]:
	return ["0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "2.0"]
