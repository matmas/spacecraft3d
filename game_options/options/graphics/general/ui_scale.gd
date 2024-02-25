extends RangeOption


func section() -> String:
	return "graphics"


func key() -> String:
	return "ui_scale"


func get_display_name() -> String:
	return tr("UI scale")


func get_display_category() -> String:
	return tr("General")


func set_value(value: Variant) -> void:
	get_window().content_scale_factor = value
	value_changed.emit()


func get_value() -> Variant:
	return get_window().content_scale_factor


func get_min_value() -> float:
	return 1.0


func get_step() -> float:
	return 0.125


func get_max_value() -> float:
	return 2.0


func get_display_value() -> String:
	return "%s %%" % str(get_value() * 100.0)


func _ready() -> void:
	if DisplayServer.screen_get_dpi(DisplayServer.SCREEN_OF_MAIN_WINDOW) > 120:
		get_window().content_scale_factor = 2.0
