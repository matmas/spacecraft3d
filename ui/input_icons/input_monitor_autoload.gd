@tool
extends Node

signal input_type_changed(input_type)

## Emit this signal to refresh InputActionTextureRect and InputActionButton instances
signal input_map_changed

const MOUSE_MIN_MOVEMENT = 100
const JOYPAD_DEADZONE = 0.5

enum InputType {
	KEYBOARD_AND_MOUSE,
	JOYPAD
}

var current_input_type: InputType


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Allow in paused game menus such as control remapping
	_update_joy_mappings()

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
	if event.device == -1:
		# Ignore emulate_mouse_from_touch
		return

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


func _update_joy_mappings() -> void:
	Input.add_joy_mapping(
		"03000000eb03000001ff000093000000,Wooting One (Legacy),a:b0,b:b1,x:b2,y:b3," +
		"leftshoulder:b4,rightshoulder:b5,back:b6,start:b7,guide:b8,leftstick:b9,rightstick:b10," +
		"dpup:h0.1,dpright:h0.2,dpdown:h0.4,dpleft:h0.8," +
		"leftx:a0,lefty:a1,lefttrigger:a2,rightx:a3,righty:a4,righttrigger:a5", true
	)
