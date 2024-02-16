@tool
extends Node
# Adapted code from https://github.com/rsubtil/controller_icons by Ricardo Subtil, (c) 2023, MIT license

signal input_type_changed(input_type)

const MOUSE_MIN_MOVEMENT = 200
const JOYPAD_DEADZONE = 0.5

enum InputType {
	KEYBOARD_AND_MOUSE,
	JOYPAD
}

var current_input_type: InputType

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Allow in paused game menus such as control remapping

	if Input.get_connected_joypads():
		_set_current_input_type(InputType.JOYPAD)
	else:
		_set_current_input_type(InputType.KEYBOARD_AND_MOUSE)

	Input.joy_connection_changed.connect(_on_joy_connection_changed)


func _on_joy_connection_changed(_device: int, connected: bool) -> void:
	if connected:
		_set_current_input_type(InputType.JOYPAD)
	else:
		_set_current_input_type(InputType.KEYBOARD_AND_MOUSE)


func _input(event: InputEvent):
	var input_type = current_input_type
	match event.get_class():
		"InputEventKey", "InputEventMouseButton":
			input_type = InputType.KEYBOARD_AND_MOUSE
		"InputEventMouseMotion":
			if event.velocity.length() > MOUSE_MIN_MOVEMENT:
				input_type = InputType.KEYBOARD_AND_MOUSE
		"InputEventJoypadButton":
			input_type = InputType.JOYPAD
		"InputEventJoypadMotion":
			if abs(event.axis_value) > JOYPAD_DEADZONE:
				input_type = InputType.JOYPAD
	if input_type != current_input_type:
		_set_current_input_type(input_type)


func _set_current_input_type(_current_input_type):
	current_input_type = _current_input_type
	input_type_changed.emit(_current_input_type)
