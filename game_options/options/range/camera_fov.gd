extends RangeOption

var current_value := 75.0


func section() -> String:
	return "display"


func key() -> String:
	return "camera_fov"


func get_display_name() -> String:
	return tr("Vertical FOV")  # Assumes Camera3D.keep_aspect == Camera3D.KEEP_HEIGHT (default)


func get_description() -> String:
	var horizontal_fov := rad_to_deg(2 * atan(tan(deg_to_rad(current_value * 0.5)) * get_window().size.aspect()))
	return "Horizontal FOV: %d°" % horizontal_fov


func get_display_category() -> String:
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
	return 36


func get_step() -> float:
	return 1


func get_max_value() -> float:
	return 75


func spinbox_suffix() -> String:
	return "°"