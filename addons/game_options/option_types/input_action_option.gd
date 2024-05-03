@icon("../icons/InputEventAction.svg")
extends Option
class_name InputActionOption

@export var action_name := &""
@export var display_name := ""


func key() -> String:
	return action_name


func get_display_name() -> String:
	return display_name


func get_value() -> Array[InputEvent]:
	return InputMap.action_get_events(action_name)


func set_value(value: Array[InputEvent]) -> void:
	InputMap.action_erase_events(action_name)
	for event in value:
		InputMap.action_add_event(action_name, event)
	value_changed.emit()
	var _InputMonitor := get_node_or_null("/root/InputMonitor")
	if _InputMonitor:
		_InputMonitor.input_map_changed.emit()


func _to_string() -> String:
	return "%s(%s)" % [name, get_value()]
