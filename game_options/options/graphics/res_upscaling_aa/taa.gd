extends BoolOption

@onready var current_value := ProjectSettings.get_setting("rendering/anti_aliasing/quality/use_taa") as bool


func key() -> String:
	return "taa"


func get_display_name() -> String:
	return tr("TAA")


func set_value(value: bool) -> void:
	RenderingServer.viewport_set_use_taa(get_viewport().get_viewport_rid(), value)
	current_value = value
	value_changed.emit()


func get_value() -> bool:
	return current_value


func is_visible() -> bool:
	return ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method") not in ["mobile", "gl_compatibility"]
