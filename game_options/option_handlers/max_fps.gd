extends OptionHandler

var UNLIMITED = tr("Unlimited")


func section() -> String:
	return "display"


func key() -> String:
	return "max_fps"


func set_value(value: Variant) -> void:
	Engine.max_fps = value


func get_value() -> Variant:
	return Engine.max_fps


func get_value_from_string(value: String) -> Variant:
	if value == UNLIMITED:
		return 0
	return int(value)


func get_possible_string_values() -> Array[String]:
	return [UNLIMITED, "15", "30", "60", "75", "120", "144", "165", "240", "360", "500"]
