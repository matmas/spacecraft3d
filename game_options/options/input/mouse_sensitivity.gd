extends RangeOption

@onready var current_value = 0.002


func section() -> String:
	return "input"


func key() -> String:
	return "mouse_sensitivity"


func get_display_name() -> String:
	return tr("Mouse sensitivity")


func get_display_category() -> String:
	return tr("Player input")


func set_value(value: Variant) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value


func get_min_display_value() -> float:
	return 0.0


func get_display_step() -> float:
	return 1.0


func get_max_display_value() -> float:
	return 100.0


func get_display_value() -> float:
	return get_value() * 100.0 / 0.008


func set_display_value(value: float) -> void:
	set_value(value / 100 * 0.008)


func spinbox_suffix() -> String:
	return "%"
