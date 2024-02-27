extends RangeOption

var current_value := 75.0


func key() -> String:
	return "camera_fov"


func get_display_name() -> String:
	return tr("Vertical FOV")  # Assumes Camera3D.keep_aspect == Camera3D.KEEP_HEIGHT (default)


func get_description() -> String:
	var horizontal_fov := rad_to_deg(2 * atan(tan(deg_to_rad(current_value * 0.5)) * get_window().size.aspect()))
	return "Horizontal: %d°" % horizontal_fov


func set_value(value: Variant) -> void:
	current_value = value
	var camera := get_viewport().get_camera_3d()
	if camera:
		camera.fov = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value


func get_min_value() -> float:
	return 35


func get_step() -> float:
	return 1


func get_max_value() -> float:
	return 75


func get_display_value() -> String:
	return "%s °" % str(get_value())


func _ready() -> void:
	# Update description when window size changes
	get_window().size_changed.connect(func(): value_changed.emit())
