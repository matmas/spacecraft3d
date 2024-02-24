extends EnumOption

var UNLIMITED = tr("Unlimited")


func section() -> String:
	return "graphics"


func key() -> String:
	return "max_fps"


func get_display_name() -> String:
	return tr("Max FPS")


func get_display_category() -> String:
	return tr("General")


func set_value(value: Variant) -> void:
	Engine.max_fps = value
	value_changed.emit()


func get_value() -> Variant:
	return Engine.max_fps


func get_value_from_display_value(value: String) -> Variant:
	if value == UNLIMITED:
		return 0
	return int(value)


func get_possible_display_values() -> Array[String]:
	return [UNLIMITED, "15", "30", "40", "60", "75", "90", "120", "144", "165", "175", "200", "240", "250", "300", "360", "500"]
