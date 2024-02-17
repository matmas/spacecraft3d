@tool
extends KeyIconTextureRect
class_name InputEventTextureRect

@export var input_event: InputEvent:
	set(value):
		input_event = value
		_update_text()


func _init() -> void:
	super._init()
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED


func _draw() -> void:
	if not texture:
		# Use KeyIconTextureRect._draw() as a fallback when we don't have texture
		super._draw()


func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
	if property.name in ["text", "texture", "expand_mode", "stretch_mode"]:
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
				texture = null
			"InputEventMouseButton":
				var event := input_event as InputEventMouseButton
				match event.button_index:
					MOUSE_BUTTON_LEFT:  # Primary mouse button, usually assigned to the left button.
						_set_texture("mouse", "left")
					MOUSE_BUTTON_RIGHT:  # Secondary mouse button, usually assigned to the right button.
						_set_texture("mouse", "right")
					MOUSE_BUTTON_MIDDLE:
						_set_texture("mouse", "middle")
					MOUSE_BUTTON_WHEEL_UP:
						_set_texture("mouse", "wheel_up")
					MOUSE_BUTTON_WHEEL_DOWN:
						_set_texture("mouse", "wheel_down")
					MOUSE_BUTTON_WHEEL_LEFT:
						_set_texture("mouse", "wheel_left")
					MOUSE_BUTTON_WHEEL_RIGHT:
						_set_texture("mouse", "wheel_right")
					MOUSE_BUTTON_XBUTTON1:  # Extra mouse button 1. This is sometimes present, usually to the sides of the mouse.
						_set_texture("mouse", "thumb_button_1")
					MOUSE_BUTTON_XBUTTON2:  # Extra mouse button 2. This is sometimes present, usually to the sides of the mouse.
						_set_texture("mouse", "thumb_button_2")
					_:
						texture = null; text = ""
			"InputEventJoypadButton":
				var event := input_event as InputEventJoypadButton
				match event.button_index:
					JOY_BUTTON_A:
						_set_texture(_get_joypad_name(), "a")
					JOY_BUTTON_B:
						_set_texture(_get_joypad_name(), "b")
					JOY_BUTTON_X:
						_set_texture(_get_joypad_name(), "x")
					JOY_BUTTON_Y:
						_set_texture(_get_joypad_name(), "y")
					JOY_BUTTON_BACK:
						_set_texture(_get_joypad_name(), "back")
					JOY_BUTTON_GUIDE:
						texture = null; text = "Guide"
					JOY_BUTTON_START:
						_set_texture(_get_joypad_name(), "start")
					JOY_BUTTON_LEFT_STICK:
						_set_texture(_get_joypad_name(), "left_stick_click")
					JOY_BUTTON_RIGHT_STICK:
						_set_texture(_get_joypad_name(), "right_stick_click")
					JOY_BUTTON_LEFT_SHOULDER:
						_set_texture(_get_joypad_name(), "left_shoulder")
					JOY_BUTTON_RIGHT_SHOULDER:
						_set_texture(_get_joypad_name(), "right_shoulder")
					JOY_BUTTON_DPAD_UP:
						_set_texture(_get_joypad_name(), "dpad_up")
					JOY_BUTTON_DPAD_DOWN:
						_set_texture(_get_joypad_name(), "dpad_down")
					JOY_BUTTON_DPAD_LEFT:
						_set_texture(_get_joypad_name(), "dpad_left")
					JOY_BUTTON_DPAD_RIGHT:
						_set_texture(_get_joypad_name(), "dpad_right")
					JOY_BUTTON_MISC1:
						_set_texture(_get_joypad_name(), "misc")
					JOY_BUTTON_PADDLE1:
						texture = null; text = "Paddle 1"
					JOY_BUTTON_PADDLE2:
						texture = null; text = "Paddle 2"
					JOY_BUTTON_PADDLE3:
						texture = null; text = "Paddle 3"
					JOY_BUTTON_PADDLE4:
						texture = null; text = "Paddle 4"
					JOY_BUTTON_TOUCHPAD:
						_set_texture(_get_joypad_name(), "touchpad")
					_:
						texture = null; text = ""
			"InputEventJoypadMotion":
				var event := input_event as InputEventJoypadMotion
				match event.axis:
					JOY_AXIS_LEFT_X when event.axis_value > 0:
						_set_texture(_get_joypad_name(), "left_stick_right")
					JOY_AXIS_LEFT_X when event.axis_value < 0:
						_set_texture(_get_joypad_name(), "left_stick_left")
					JOY_AXIS_LEFT_Y when event.axis_value > 0:
						_set_texture(_get_joypad_name(), "left_stick_down")
					JOY_AXIS_LEFT_Y when event.axis_value < 0:
						_set_texture(_get_joypad_name(), "left_stick_up")
					JOY_AXIS_RIGHT_X when event.axis_value > 0:
						_set_texture(_get_joypad_name(), "right_stick_right")
					JOY_AXIS_RIGHT_X when event.axis_value < 0:
						_set_texture(_get_joypad_name(), "right_stick_left")
					JOY_AXIS_RIGHT_Y when event.axis_value > 0:
						_set_texture(_get_joypad_name(), "right_stick_down")
					JOY_AXIS_RIGHT_Y when event.axis_value < 0:
						_set_texture(_get_joypad_name(), "right_stick_up")
					JOY_AXIS_TRIGGER_LEFT:
						_set_texture(_get_joypad_name(), "left_trigger")
					JOY_AXIS_TRIGGER_RIGHT:
						_set_texture(_get_joypad_name(), "right_trigger")
					JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y when event.axis_value == 0:
						_set_texture(_get_joypad_name(), "left_stick")
					JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y when event.axis_value == 0:
						_set_texture(_get_joypad_name(), "right_stick")
					_:
						texture = null; text = ""
	else:
		text = ""
	queue_redraw()


func _set_texture(folder: String, filename: String, extension: String = "png") -> void:
	var base_path := "res://input_icons/icons"
	var path := "%s/%s/%s.%s" % [base_path, folder, filename, extension]
	if FileAccess.file_exists(path):
		texture = ResourceLoader.load(path)
	else:
		texture = null; text = ""


func _get_joypad_name() -> String:
	#print(Input.get_joy_info(1))
	#print(Input.get_joy_name(1))
	return "xbox_series"
