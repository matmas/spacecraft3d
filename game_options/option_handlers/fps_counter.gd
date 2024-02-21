extends OptionHandler

var ENABLED = tr("Enabled")
var DISABLED = tr("Disabled")


func section() -> String:
	return "display"


func key() -> String:
	return "fps_counter"


func set_value(value: Variant) -> void:
	FpsCounter.is_enabled = value


func get_value() -> Variant:
	return FpsCounter.is_enabled


func get_value_from_string(value: String) -> Variant:
	match value:
		ENABLED:
			return true
		DISABLED:
			return false
		_:
			return null


func get_possible_string_values() -> Array[String]:
	return [ENABLED, DISABLED]
