extends Option
class_name EnumOption


func get_value_from_string(_value: String) -> Variant:
	printerr("Not implemented."); return null


func get_possible_string_values() -> Array[String]:
	printerr("Not implemented."); return []


func get_string_value() -> String:
	# Implementing this will postpone calling get_possible_string_values() when using OptionButton
	# until user clicks on the button to see the options
	return ""


func set_value_string(value: String) -> void:
	set_value(get_value_from_string(value))


func value_string_matches(value: String) -> bool:
	return get_value_from_string(value) == get_value()
