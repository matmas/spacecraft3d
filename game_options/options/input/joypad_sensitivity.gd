extends RangeOption

@onready var current_value = 2.0


func section() -> String:
	return "input"


func key() -> String:
	return "joypad_sensitivity"


func get_display_name() -> String:
	return tr("Controller sensitivity")


func get_display_category() -> String:
	return tr("Player input")


func set_value(value: Variant) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value


func get_min_value() -> float:
	return 0.0


func get_step() -> float:
	return 0.05


func get_max_value() -> float:
	return 8.0


func get_display_value() -> String:
	return "%s %%" % str(get_value() / 8.0 * 100.0)
