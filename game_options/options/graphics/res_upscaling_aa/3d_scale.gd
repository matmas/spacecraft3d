extends RangeOption


func key() -> String:
	return "3d_scale"


func get_display_name() -> String:
	return tr("3D resolution")


func set_value(value: float) -> void:
	get_viewport().scaling_3d_scale = value
	value_changed.emit()


func get_value() -> float:
	return get_viewport().scaling_3d_scale


func get_min_value() -> float:
	return 0.125


func get_step() -> float:
	return 0.125


func get_max_value() -> float:
	return 1.0


func get_display_value() -> String:
	return "%s %%" % str(get_value() * 100.0)


func get_description() -> String:
	var size := get_window().size * float(get_value())
	return "%d x %d" % [size.x, size.y]


func _ready() -> void:
	# Update description when window size changes
	get_window().size_changed.connect(func(): value_changed.emit())
