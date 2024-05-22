extends BoolOption
class_name GenericBoolOption

@export var key_name := ""
@export var display_name := ""

var current_value := true


func key() -> String:
	return key_name


func get_display_name() -> String:
	return display_name


func set_value(value: bool) -> void:
	current_value = value
	value_changed.emit()


func get_value() -> bool:
	return current_value
