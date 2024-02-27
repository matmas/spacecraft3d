extends BoolOption

var current_value := true  # Assume enabled by default


func key() -> String:
	return "glow"


func get_display_name() -> String:
	return tr("Glow")


func set_value(value: bool) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera:
		camera.get_world_3d().environment.glow_enabled = value
	else:
		current_value = value
	value_changed.emit()


func get_value() -> bool:
	var camera := get_viewport().get_camera_3d()
	if camera:
		return camera.get_world_3d().environment.glow_enabled
	else:
		return current_value
