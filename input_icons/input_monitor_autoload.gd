@tool
extends Node

signal input_type_changed(input_type)

const MOUSE_MIN_MOVEMENT = 100
const JOYPAD_DEADZONE = 0.5

enum InputType {
	KEYBOARD_AND_MOUSE,
	JOYPAD
}

var current_input_type: InputType


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Allow in paused game menus such as control remapping

	var found_known_joypad := false
	for device in Input.get_connected_joypads():
		# Some joypads are not known, e.g. Wooting one keyboard
		if Input.is_joy_known(device):
			found_known_joypad = true
			_set_current_input_type(InputType.JOYPAD)
	if not found_known_joypad:
		_set_current_input_type(InputType.KEYBOARD_AND_MOUSE)

	Input.joy_connection_changed.connect(_on_joy_connection_changed)


func _on_joy_connection_changed(_device: int, connected: bool) -> void:
	if connected:
		_set_current_input_type(InputType.JOYPAD)
	else:
		_set_current_input_type(InputType.KEYBOARD_AND_MOUSE)


func _input(event: InputEvent) -> void:
	var new_input_type := current_input_type
	match event.get_class():
		"InputEventKey", "InputEventMouseButton":
			new_input_type = InputType.KEYBOARD_AND_MOUSE
		"InputEventMouseMotion":
			if (event as InputEventMouseMotion).velocity.length() > MOUSE_MIN_MOVEMENT:
				new_input_type = InputType.KEYBOARD_AND_MOUSE
		"InputEventJoypadButton":
			new_input_type = InputType.JOYPAD
		"InputEventJoypadMotion":
			if absf((event as InputEventJoypadMotion).axis_value) > JOYPAD_DEADZONE:
				new_input_type = InputType.JOYPAD
	if new_input_type != current_input_type:
		_set_current_input_type(new_input_type)


func _set_current_input_type(_current_input_type: InputType) -> void:
	current_input_type = _current_input_type
	input_type_changed.emit(_current_input_type)
