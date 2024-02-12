extends Node
# Adapted code from https://github.com/rsubtil/controller_icons by Ricardo Subtil, (c) 2023, MIT license

signal input_type_changed(input_type)

const MOUSE_MIN_MOVEMENT = 200
const JOYPAD_DEADZONE = 0.5

enum InputType {
	KEYBOARD_MOUSE,
	CONTROLLER
}

var last_input_type: InputType

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Allow in paused game menus such as control remapping

	# Set input type to what's likely being used currently
	if Input.get_connected_joypads():
		_set_last_input_type(InputType.CONTROLLER)
	else:
		_set_last_input_type(InputType.KEYBOARD_MOUSE)

	Input.joy_connection_changed.connect(_on_joy_connection_changed)


func _on_joy_connection_changed(_device: int, connected: bool) -> void:
	if connected:
		_set_last_input_type(InputType.CONTROLLER)
	else:
		_set_last_input_type(InputType.KEYBOARD_MOUSE)


func _input(event: InputEvent):
	var input_type = last_input_type
	match event.get_class():
		"InputEventKey", "InputEventMouseButton":
			input_type = InputType.KEYBOARD_MOUSE
		"InputEventMouseMotion":
			if event.velocity.length() > MOUSE_MIN_MOVEMENT:
				input_type = InputType.KEYBOARD_MOUSE
		"InputEventJoypadButton":
			input_type = InputType.CONTROLLER
		"InputEventJoypadMotion":
			if abs(event.axis_value) > JOYPAD_DEADZONE:
				input_type = InputType.CONTROLLER
	if input_type != last_input_type:
		_set_last_input_type(input_type)


func _set_last_input_type(_last_input_type):
	last_input_type = _last_input_type
	input_type_changed.emit(_last_input_type)
