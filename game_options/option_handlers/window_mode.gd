extends OptionHandler

var WINDOWED = tr("Windowed")
var FULLSCREEN = tr("Fullscreen")
var EXCLUSIVE_FULLSCREEN = tr("Exclusive fullscreen")


func section() -> String:
	return "display"


func key() -> String:
	return "window_mode"


func set_value(value: Variant) -> void:
	DisplayServer.window_set_mode(value)


func get_value() -> Variant:
	return DisplayServer.window_get_mode()


func get_value_from_string(value: String) -> Variant:
	match value:
		WINDOWED:
			return DisplayServer.WINDOW_MODE_WINDOWED
		FULLSCREEN:
			return DisplayServer.WINDOW_MODE_FULLSCREEN
		EXCLUSIVE_FULLSCREEN:
			return DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		_:
			return null


func get_possible_string_values() -> Array[String]:
	return [WINDOWED, FULLSCREEN, EXCLUSIVE_FULLSCREEN]
