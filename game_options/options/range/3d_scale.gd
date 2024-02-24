extends RangeOption


func section() -> String:
	return "graphics"


func key() -> String:
	return "3d_scale"


func get_display_name() -> String:
	return tr("3D resolution")


func get_display_category() -> String:
	return tr("General")


func set_value(value: Variant) -> void:
	get_viewport().scaling_3d_scale = value
	value_changed.emit()


func get_value() -> Variant:
	return get_viewport().scaling_3d_scale


func get_min_display_value() -> float:
	return 12.5


func get_display_step() -> float:
	return 12.5


func get_max_display_value() -> float:
	return 100.0


func get_display_value() -> float:
	return get_value() * 100.0


func set_display_value(value: float) -> void:
	set_value(value / 100.0)


func spinbox_suffix() -> String:
	return "%"


func get_description() -> String:
	var size := get_window().size * float(get_value())
	return "%d x %d" % [size.x, size.y]


func _ready() -> void:
	# Update description when window size changes
	get_window().size_changed.connect(func(): value_changed.emit())
