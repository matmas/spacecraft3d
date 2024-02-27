extends Option
class_name EnumOption


func get_value() -> Variant:
	printerr("Not implemented."); return null


func set_value(_value: Variant) -> void:
	printerr("Not implemented.")


func get_value_from_display_value(_value: String) -> Variant:
	printerr("Not implemented."); return null


func get_possible_display_values() -> Array[String]:
	printerr("Not implemented."); return []


func get_display_value() -> String:
	# Implementing this will postpone calling get_possible_display_values() when using OptionButton
	# until user clicks on the button to see the options
	return ""


func set_display_value(value: String) -> void:
	set_value(get_value_from_display_value(value))


func display_value_matches(value: String) -> bool:
	return get_value_from_display_value(value) == get_value()
