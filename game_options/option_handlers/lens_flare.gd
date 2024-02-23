extends BoolOptionHandler

var current_value := true


func section() -> String:
	return "display"


func key() -> String:
	return "lens_flare"


func set_value(value: Variant) -> void:
	current_value = value


func get_value() -> Variant:
	return current_value
