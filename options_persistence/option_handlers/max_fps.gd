extends OptionHandler


func section() -> String:
	return "display"


func key() -> String:
	return "max_fps"


func set_value(value: Variant) -> void:
	Engine.max_fps = value


func get_value() -> Variant:
	return Engine.max_fps


func get_value_from_string(value: String) -> Variant:
	if value == "Unlimited":
		return 0
	return int(value)
