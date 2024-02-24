extends EnumOption


func section() -> String:
	return "display"


func key() -> String:
	return "ui_scale"


func get_display_name() -> String:
	return tr("UI scale")


func get_display_category() -> String:
	return tr("User interface")


func set_value(value: Variant) -> void:
	get_window().content_scale_factor = value
	value_changed.emit(value)


func get_value() -> Variant:
	return get_window().content_scale_factor


func get_value_from_string(value: String) -> Variant:
	return int(value.rstrip("%")) / 100.0


func get_possible_string_values() -> Array[String]:
	return ["100%", "150%", "200%"]


func _ready() -> void:
	if DisplayServer.screen_get_dpi(DisplayServer.SCREEN_OF_MAIN_WINDOW) > 120:
		get_window().content_scale_factor = 2.0
