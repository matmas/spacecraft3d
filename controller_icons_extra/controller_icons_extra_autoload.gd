extends Node


func parse_event(event: InputEvent) -> Texture:
	var path = _convert_event_to_path(event)
	if path.is_empty():
		return null

	var base_paths := [
		ControllerIcons._settings.custom_asset_dir + "/",
		"res://addons/controller_icons/assets/"
	]
	for base_path in base_paths:
		if base_path.is_empty():
			continue
		base_path += path + ".png"
		if not ControllerIcons._cached_icons.has(base_path):
			if ControllerIcons._load_icon(base_path):
				continue
		return ControllerIcons._cached_icons[base_path]
	return null


func _convert_event_to_path(event: InputEvent):
	if event is InputEventKey:
		# If this is a physical key, convert to localized scancode
		if event.keycode == 0:
			return ControllerIcons._convert_key_to_path(DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode))
		return ControllerIcons._convert_key_to_path(event.keycode)
	elif event is InputEventMouseButton:
		return ControllerIcons._convert_mouse_button_to_path(event.button_index)
	elif event is InputEventJoypadButton:
		return ControllerIcons._convert_joypad_button_to_path(event.button_index)
	elif event is InputEventJoypadMotion:
		return _convert_joypad_motion_to_path(event)


func _convert_joypad_motion_to_path(event: InputEventJoypadMotion):
	var path : String
	match event.axis:
		JOY_AXIS_LEFT_X when event.axis_value >= 0:
			path = "joypad/l_stick_right"
		JOY_AXIS_LEFT_X when event.axis_value < 0:
			path = "joypad/l_stick_left"
		JOY_AXIS_LEFT_Y when event.axis_value >= 0:
			path = "joypad/l_stick_down"
		JOY_AXIS_LEFT_Y when event.axis_value < 0:
			path = "joypad/l_stick_up"
		JOY_AXIS_RIGHT_X when event.axis_value >= 0:
			path = "joypad/r_stick_right"
		JOY_AXIS_RIGHT_X when event.axis_value < 0:
			path = "joypad/r_stick_left"
		JOY_AXIS_RIGHT_Y when event.axis_value >= 0:
			path = "joypad/r_stick_down"
		JOY_AXIS_RIGHT_Y when event.axis_value < 0:
			path = "joypad/r_stick_up"
		JOY_AXIS_TRIGGER_LEFT:
			path = "joypad/lt"
		JOY_AXIS_TRIGGER_RIGHT:
			path = "joypad/rt"
		_:
			return ""
	return ControllerIcons.Mapper._convert_joypad_path(path, ControllerIcons._settings.joypad_fallback)
