extends BoolOption

var current_value := true


func section() -> String:
	return "graphics"


func key() -> String:
	return "lens_flare"


func get_display_name() -> String:
	return tr("Lens flare")


func get_display_category() -> String:
	return tr("Graphics")


func set_value(value: Variant) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value
