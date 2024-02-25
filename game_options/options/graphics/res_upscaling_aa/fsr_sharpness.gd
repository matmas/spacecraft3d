extends RangeOption

@onready var current_value = snappedf(ProjectSettings.get_setting("rendering/scaling_3d/fsr_sharpness"), 0.1)


func section() -> String:
	return "graphics"


func key() -> String:
	return "fsr_sharpness"


func get_display_name() -> String:
	return tr("FSR sharpness")


func get_display_category() -> String:
	return tr("Resolution, upscaling & anti-aliasing")


func set_value(value: Variant) -> void:
	RenderingServer.viewport_set_fsr_sharpness(get_viewport().get_viewport_rid(), value)
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value


func get_min_display_value() -> float:
	return 0.0


func get_display_step() -> float:
	return 5.0


func get_max_display_value() -> float:
	return 100.0


func get_display_value() -> float:
	return (1 - get_value() * 0.5) * 100.0


func set_display_value(value: float) -> void:
	set_value((1 - value / 100) * 2)


func get_display_suffix() -> String:
	return "%"
