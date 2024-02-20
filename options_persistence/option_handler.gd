extends Node
class_name OptionHandler

var initial_value: Variant


func get_value() -> Variant:
	printerr("Not implemented."); return null


func set_value(_value: Variant) -> void:
	printerr("Not implemented.")


func get_value_from_string(_value: String) -> Variant:
	printerr("Not implemented."); return null


func set_value_string(value: String) -> void:
	set_value(get_value_from_string(value))


func value_string_matches(value: String) -> bool:
	return get_value_from_string(value) == get_value()
