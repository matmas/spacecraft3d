extends BoolOption

@onready var current_value := _get_initial_value()


func key() -> String:
	return "fxaa"


func get_display_name() -> String:
	return tr("FXAA")


func set_value(value: bool) -> void:
	if value:
		RenderingServer.viewport_set_screen_space_aa(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA)
	else:
		RenderingServer.viewport_set_screen_space_aa(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
	current_value = value
	value_changed.emit()


func get_value() -> bool:
	return current_value


func _get_initial_value() -> bool:
	match ProjectSettings.get_setting("rendering/anti_aliasing/quality/screen_space_aa"):
		RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA:
			return true
		RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED:
			return false
		_:
			return false


func is_visible() -> bool:
	return ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method") not in ["gl_compatibility"]
