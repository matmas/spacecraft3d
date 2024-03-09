extends BoolOption

var current_value := false  # Assume disabled by default


func key() -> String:
	return "ssil"


func get_display_name() -> String:
	return tr("SSIL")


func set_value(value: bool) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera:
		camera.get_world_3d().environment.ssil_enabled = value
	else:
		current_value = value
	value_changed.emit()


func get_value() -> bool:
	var camera := get_viewport().get_camera_3d()
	if camera:
		return camera.get_world_3d().environment.ssil_enabled
	else:
		return current_value


func is_visible() -> bool:
	return ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method") not in ["mobile", "gl_compatibility"]
