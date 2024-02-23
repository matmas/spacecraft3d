extends BoolOption

var current_value := true  # Assume glow is enabled by default


func section() -> String:
	return "display"


func key() -> String:
	return "glow"


func set_value(value: Variant) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera:
		camera.get_world_3d().environment.glow_enabled = value
	else:
		current_value = value


func get_value() -> Variant:
	var camera := get_viewport().get_camera_3d()
	if camera:
		return camera.get_world_3d().environment.glow_enabled
	else:
		return current_value
