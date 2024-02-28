@icon("../icons/GuiToggleOn.svg")
extends Option
class_name BoolOption


func get_value() -> bool:
	printerr("Not implemented."); return false


func set_value(_value: bool) -> void:
	printerr("Not implemented.")


func _to_string() -> String:
	return "%s(%s)" % [name, get_value()]
