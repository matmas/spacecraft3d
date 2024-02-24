extends Option
class_name RangeOption


func get_min_display_value() -> float:
	printerr("Not implemented"); return 0


func get_display_step() -> float:
	printerr("Not implemented"); return 0


func get_max_display_value() -> float:
	printerr("Not implemented"); return 0


func spinbox_suffix() -> String:
	return ""


# Optional conversion to the displayed float
func get_display_value() -> float:
	return get_value()


# Optional conversion from the displayed float
func set_display_value(value: float) -> void:
	set_value(value)
