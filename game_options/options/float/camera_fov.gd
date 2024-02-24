extends FloatOption

var current_value := 75.0


func section() -> String:
	return "display"


func key() -> String:
	return "camera_fov"


func display_name() -> String:
	return tr("Vertical FOV")


func display_category() -> String:
	return tr("Graphics")


func set_value(value: Variant) -> void:
	current_value = value
	var camera := get_viewport().get_camera_3d()
	if camera:
		camera.fov = value
	value_changed.emit(value)


func get_value() -> Variant:
	return current_value


func get_min_value() -> float:
	return 50


func get_step() -> float:
	return 1


func get_max_value() -> float:
	return 75
