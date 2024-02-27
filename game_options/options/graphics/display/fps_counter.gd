extends BoolOption

var current_value := true


func key() -> String:
	return "fps_counter"


func get_display_name() -> String:
	return tr("Show FPS")


func set_value(value: Variant) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value
