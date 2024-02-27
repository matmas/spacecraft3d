extends Node
class_name Option

signal value_changed

var section: GameOptionSection
var category: GameOptionCategory
var initial_value: Variant


func key() -> String:
	printerr("Not implemented."); return ""


func get_display_name() -> String:
	printerr("Not implemented."); return ""


func get_description() -> String:
	return ""


func get_value() -> Variant:
	printerr("Not implemented."); return null


func set_value(_value: Variant) -> void:
	printerr("Not implemented.")


func is_visible() -> bool:
	return true
