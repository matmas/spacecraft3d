extends EnumOption

const UNFOCUSED_WINDOW_FPS = 4
var UNLIMITED = tr("Unlimited")

var current_value := Engine.max_fps


func key() -> String:
	return "max_fps"


func get_display_name() -> String:
	return tr("Max FPS")


func set_value(value: Variant) -> void:
	Engine.max_fps = value
	current_value = value
	value_changed.emit()


func get_value() -> Variant:
	return current_value


func get_value_from_display_value(value: String) -> Variant:
	if value == UNLIMITED:
		return 0
	return int(value)


func get_possible_display_values() -> Array[String]:
	return ["15", "30", "40", "60", "75", "90", "120", "144", "160", "165", "175", "180", "200", "240", "250", "300", "360", "500", UNLIMITED]


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			Engine.max_fps = UNFOCUSED_WINDOW_FPS
			OS.low_processor_usage_mode = true
		NOTIFICATION_APPLICATION_FOCUS_IN:
			Engine.max_fps = current_value
			OS.low_processor_usage_mode = false
