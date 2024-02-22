extends BoolOptionHandler


func section() -> String:
	return "display"


func key() -> String:
	return "fps_counter"


func set_value(value: Variant) -> void:
	FpsCounter.is_enabled = value


func get_value() -> Variant:
	return FpsCounter.is_enabled
