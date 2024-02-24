extends Node
class_name Option

signal value_changed(value)

var initial_value: Variant


func section() -> String:
	printerr("Not implemented."); return ""


func key() -> String:
	printerr("Not implemented."); return ""


func get_display_name() -> String:
	printerr("Not implemented."); return ""


func get_description() -> String:
	return ""


func get_display_category() -> String:
	printerr("Not implemented."); return ""


func get_value() -> Variant:
	printerr("Not implemented."); return null


func set_value(_value: Variant) -> void:
	printerr("Not implemented.")
