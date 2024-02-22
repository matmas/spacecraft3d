extends OptionHandler
class_name BoolOptionHandler

var ENABLED := tr("Enabled")
var DISABLED := tr("Disabled")


func get_value_from_string(value: String) -> Variant:
	match value:
		DISABLED:
			return false
		ENABLED:
			return true
		_:
			return null


func get_possible_string_values() -> Array[String]:
	return [DISABLED, ENABLED]
