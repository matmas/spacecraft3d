extends EnumOption

var current_value := 75.0


func section() -> String:
	return "display"


func key() -> String:
	return "camera_fov"


func set_value(value: Variant) -> void:
	current_value = value
	var camera := get_viewport().get_camera_3d()
	if camera:
		camera.fov = value
	value_changed.emit(value)


func get_value() -> Variant:
	return current_value


func get_value_from_string(value: String) -> Variant:
	return float(value)


func get_possible_string_values() -> Array[String]:
	return ["50", "75"]
