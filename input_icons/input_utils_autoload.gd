@tool
extends Node


func inputmap_get_events(action: StringName) -> Array[InputEvent]:
	# Inside the editor InputMap.action_get_events() doesn't return custom events in ProjectSettings
	if Engine.is_editor_hint():
		var action_setting = ProjectSettings.get_setting("input/%s" % action)
		if action_setting:
			var typed_array: Array[InputEvent] = []
			typed_array.assign(action_setting["events"])
			return typed_array
		else:
			return []
	else:
		return InputMap.action_get_events(action)


func _ready() -> void:
	for device in Input.get_connected_joypads():
		print(Input.get_joy_info(device), "" if Input.is_joy_known(device) else " (unknown)")
