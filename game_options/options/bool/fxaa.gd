extends BoolOption

@onready var current_value := _get_initial_value()


func section() -> String:
	return "display"


func key() -> String:
	return "fxaa"


func get_display_name() -> String:
	return tr("FXAA")


func get_display_category() -> String:
	return tr("Graphics")


func set_value(value: Variant) -> void:
	if value:
		RenderingServer.viewport_set_screen_space_aa(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA)
	else:
		RenderingServer.viewport_set_screen_space_aa(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
	current_value = value
	value_changed.emit(value)


func get_value() -> Variant:
	return current_value


func _get_initial_value() -> bool:
	match ProjectSettings.get_setting("rendering/anti_aliasing/quality/screen_space_aa"):
		RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA:
			return true
		RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED:
			return false
		_:
			return false