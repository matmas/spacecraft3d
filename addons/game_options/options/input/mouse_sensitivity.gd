extends RangeOption

@onready var current_value := 2.0


func key() -> String:
	return "mouse_sensitivity"


func get_display_name() -> String:
	return tr("Mouse")


func set_value(value: float) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> float:
	return current_value


func get_min_value() -> float:
	return 0.0


func get_step() -> float:
	return 0.08


func get_max_value() -> float:
	return 8.0


func get_display_value() -> String:
	return "%s %%" % str(get_value() / 8.0 * 100.0)
