extends OptionHandler


func section() -> String:
	return "display"


func key() -> String:
	return "3d_scale"


func set_value(value: Variant) -> void:
	get_viewport().scaling_3d_scale = value


func get_value() -> Variant:
	return get_viewport().scaling_3d_scale


func get_value_from_string(value: String) -> Variant:
	return int(value.rstrip("%")) / 100.0


func get_possible_string_values() -> Array[String]:
	return ["25%", "50%", "100%", "200%"]
