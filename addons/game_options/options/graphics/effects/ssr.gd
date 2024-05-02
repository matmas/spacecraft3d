extends BoolOption

var current_value := false  # Assume disabled by default


func key() -> String:
	return "ssr"


func get_display_name() -> String:
	return tr("SSR")


func set_value(value: bool) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera and camera.get_world_3d().environment:
		camera.get_world_3d().environment.ssr_enabled = value
	else:
		current_value = value
	value_changed.emit()


func get_value() -> bool:
	var camera := get_viewport().get_camera_3d()
	if camera and camera.get_world_3d().environment:
		return camera.get_world_3d().environment.ssr_enabled
	else:
		return current_value


func is_visible() -> bool:
	return ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method") not in ["mobile", "gl_compatibility"]
