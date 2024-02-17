@tool
extends Node


func inputmap_get_events(action: StringName) -> Array[InputEvent]:
	# Inside the editor InputMap.action_get_events() doesn't return custom events in ProjectSettings
	# and ProjectSettings doesn't have a method of iterating over its keys
	# So we need to read the project.godot file directly to get the list of custom actions defined in ProjectSettings
	if Engine.is_editor_hint():
		var config := ConfigFile.new()
		var project_path := "res://project.godot"
		var error := config.load(project_path)
		if error:
			printerr("Error while reading %s:" % ProjectSettings.globalize_path(project_path), Utils.error_message(error))
			return []
		if config.has_section("input"):
			var keys := config.get_section_keys("input")
			for key in keys:
				if key == action:
					var typed_array: Array[InputEvent] = []
					typed_array.assign(ProjectSettings.get_setting("input/%s" % key)["events"])
					return typed_array
	# We still need to fall back to InputMap.action_get_events()
	# since project.godot doesn't contain actions that were not changed
	return InputMap.action_get_events(action)


func _ready() -> void:
	for device in Input.get_connected_joypads():
		print(Input.get_joy_info(device), "" if Input.is_joy_known(device) else " (unknown)")
