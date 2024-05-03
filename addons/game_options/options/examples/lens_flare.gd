extends BoolOption

var current_value := true


func key() -> String:
	return "lens_flare"


func get_display_name() -> String:
	return tr("Lens flare")


func set_value(value: bool) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> bool:
	return current_value
