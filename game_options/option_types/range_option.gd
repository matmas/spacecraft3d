@icon("../icons/HSlider.svg")
extends Option
class_name RangeOption


func get_value() -> float:
	printerr("Not implemented."); return 0.0


func set_value(_value: float) -> void:
	printerr("Not implemented.")


func get_min_value() -> float:
	printerr("Not implemented"); return 0


func get_step() -> float:
	printerr("Not implemented"); return 0


func get_max_value() -> float:
	printerr("Not implemented"); return 0


func get_display_value() -> String:
	return str(get_value())


func _to_string() -> String:
	return "%s(%s)" % [name, get_value()]
