@tool
extends KeyIconRect
class_name InputEventRect

@export var input_event: InputEvent:
	set(value):
		input_event = value
		_update_text()
		queue_redraw()


func _validate_property(property: Dictionary) -> void:
	if property.name == "text":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


func _update_text() -> void:
	if input_event:
		match input_event.get_class():
			"InputEventKey":
				var event := input_event as InputEventKey
				var keycode := event.keycode
				if event.physical_keycode:
					keycode = DisplayServer.keyboard_get_keycode_from_physical(
						event.physical_keycode
					)
				text = OS.get_keycode_string(keycode)
	else:
		text = " "
