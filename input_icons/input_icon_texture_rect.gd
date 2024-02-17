@tool
extends KeyIconTextureRect
class_name InputEventTextureRect

@export var input_event: InputEvent:
	set(value):
		input_event = value
		_update_text()

## Convert physical keycodes (US QWERTY) to ones in the active keyboard layout, e.g. AZERTY if supported by DisplayServer
@export var convert_physical_keycodes := false:
	set(value):
		convert_physical_keycodes = value
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
	if property.name in ["text", "texture", "expand_mode", "stretch_mode", "horizontal_alignment"]:
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


func _update_text() -> void:
	if input_event:
		match input_event.get_class():
			"InputEventKey":
				var event := input_event as InputEventKey
				var keycode: Key

				if event.physical_keycode:
					if convert_physical_keycodes and DisplayServer.get_name() in ["X11", "macOS", "Windows"]:
						keycode = DisplayServer.keyboard_get_keycode_from_physical(
							event.physical_keycode
						)
					else:
						keycode = event.physical_keycode
				elif event.keycode:
					keycode = event.keycode
				elif event.key_label:
					keycode = event.key_label

				horizontal_alignment = HorizontalAlignment.CENTER
				match keycode:
					KEY_NONE:
						texture = null; text = ""
					KEY_SPECIAL:
						texture = null; text = " "
					KEY_ESCAPE:
						texture = null; text = "Esc"
					KEY_BACKSPACE:
						_set_texture("keyboard", "backspace")
					KEY_ENTER:
						_set_texture("keyboard", "enter")
					KEY_KP_ENTER:
						_set_texture("keyboard", "kp_enter")
					KEY_INSERT:
						texture = null; text = "Ins"
					KEY_DELETE:
						texture = null; text = "Del"
					KEY_PRINT:
						texture = null; text = "PrtScr"
					KEY_LEFT:
						_set_texture("keyboard", "arrow_left")
					KEY_UP:
						_set_texture("keyboard", "arrow_up")
					KEY_RIGHT:
						_set_texture("keyboard", "arrow_right")
					KEY_DOWN:
						_set_texture("keyboard", "arrow_down")
					KEY_PAGEUP:
						texture = null; text = "Page\nUp"; horizontal_alignment = HorizontalAlignment.LEFT
					KEY_PAGEDOWN:
						texture = null; text = "Page\nDown"; horizontal_alignment = HorizontalAlignment.LEFT
					KEY_META:
						match OS.get_name():
							"macOS":
								_set_texture("keyboard", "cmd")
							"Windows":
								_set_texture("keyboard", "windows")
							_:
								texture = null; text = "Meta"
					KEY_CAPSLOCK:
						texture = null; text = "Caps\nLock"; horizontal_alignment = HorizontalAlignment.LEFT
					KEY_NUMLOCK:
						texture = null; text = "Num\nLock"; horizontal_alignment = HorizontalAlignment.LEFT
					KEY_SCROLLLOCK:
						texture = null; text = "Scroll\nLock"; horizontal_alignment = HorizontalAlignment.LEFT
					KEY_KP_MULTIPLY:
						texture = null; text = "*"
					KEY_KP_DIVIDE:
						texture = null; text = "/"
					KEY_KP_SUBTRACT:
						_set_texture("keyboard", "kp_minus")
					KEY_KP_PERIOD:
						texture = null; text = "."
					KEY_KP_ADD:
						_set_texture("keyboard", "kp_plus")
					KEY_KP_0:
						texture = null; text = "0"
					KEY_KP_1:
						texture = null; text = "1"
					KEY_KP_2:
						texture = null; text = "2"
					KEY_KP_3:
						texture = null; text = "3"
					KEY_KP_4:
						texture = null; text = "4"
					KEY_KP_5:
						texture = null; text = "5"
					KEY_KP_6:
						texture = null; text = "6"
					KEY_KP_7:
						texture = null; text = "7"
					KEY_KP_8:
						texture = null; text = "8"
					KEY_KP_9:
						texture = null; text = "9"
					KEY_VOLUMEDOWN:
						texture = null; text = "Vol-"
					KEY_VOLUMEMUTE:
						texture = null; text = "Mute"
					KEY_VOLUMEUP:
						texture = null; text = "Vol+"
					KEY_MEDIAPLAY:
						texture = null; text = "Play"
					KEY_MEDIASTOP:
						texture = null; text = "Stop"
					KEY_MEDIAPREVIOUS:
						texture = null; text = "Prev"
					KEY_MEDIANEXT:
						texture = null; text = "Next"
					KEY_MEDIARECORD:
						texture = null; text = "Rec"
					KEY_FAVORITES:
						texture = null; text = "Fav"
					KEY_OPENURL:
						texture = null; text = "URL"
					KEY_LAUNCHMAIL:
						texture = null; text = "Mail"
					KEY_LAUNCHMEDIA:
						texture = null; text = "Media"
					KEY_KEYBOARD:
						texture = null; text = "Keyboard"
					KEY_JIS_EISU:
						texture = null; text = "英数"
					KEY_JIS_KANA:
						texture = null; text = "かな"
					KEY_EXCLAM:
						texture = null; text = "!"
					KEY_QUOTEDBL:
						texture = null; text = "\""
					KEY_NUMBERSIGN:
						texture = null; text = "#"
					KEY_DOLLAR:
						texture = null; text = "$"
					KEY_PERCENT:
						texture = null; text = "%"
					KEY_AMPERSAND:
						texture = null; text = "&"
					KEY_APOSTROPHE:
						texture = null; text = "'"
					KEY_PARENLEFT:
						texture = null; text = "("
					KEY_PARENRIGHT:
						texture = null; text = ")"
					KEY_ASTERISK:
						texture = null; text = "*"
					KEY_PLUS:
						texture = null; text = "+"
					KEY_COMMA:
						texture = null; text = ","
					KEY_MINUS:
						texture = null; text = "-"
					KEY_PERIOD:
						texture = null; text = "."
					KEY_SLASH:
						texture = null; text = "/"
					KEY_COLON:
						texture = null; text = ":"
					KEY_SEMICOLON:
						texture = null; text = ";"
					KEY_LESS:
						texture = null; text = "<"
					KEY_EQUAL:
						texture = null; text = "="
					KEY_GREATER:
						texture = null; text = ">"
					KEY_QUESTION:
						texture = null; text = "?"
					KEY_AT:
						texture = null; text = "@"
					KEY_BRACKETLEFT:
						texture = null; text = "["
					KEY_BACKSLASH:
						texture = null; text = "\\"
					KEY_BRACKETRIGHT:
						texture = null; text = "]"
					KEY_ASCIICIRCUM:
						texture = null; text = "^"
					KEY_UNDERSCORE:
						texture = null; text = "_"
					KEY_QUOTELEFT:
						texture = null; text = "`"
					KEY_BRACELEFT:
						texture = null; text = "{"
					KEY_BAR:
						texture = null; text = "|"
					KEY_BRACERIGHT:
						texture = null; text = "}"
					KEY_ASCIITILDE:
						texture = null; text = "~"
					KEY_YEN:
						texture = null; text = "¥"
					KEY_SECTION:
						texture = null; text = "§"
					_:
						texture = null; text = OS.get_keycode_string(keycode)
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
						printerr("Unknown mouse button ", event.button_index)
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
						texture = null; text = "Home"
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
						printerr("Unknown joypad button ", event.button_index)
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
						printerr("Unknown joypad axis ", event.axis)
						texture = null; text = ""
	else:
		texture = null; text = ""
	queue_redraw()


func _set_texture(folder: String, filename: String, extension: String = "png") -> void:
	var base_path := "res://input_icons/icons"
	var path := "%s/%s/%s.%s" % [base_path, folder, filename, extension]
	texture = ResourceLoader.load(path)
	if not texture:
		if ResourceLoader.exists(path):
			printerr("Failed loading ", path)
		else:
			printerr("Missing icon ", path)
		text = ""


func _get_joypad_name() -> String:
	# Wooting One keyboard on Linux:
	# { "vendor_id": 1003, "product_id": 65281, "raw_name": "Wooting One (Legacy)" }
	# Xbox Series Controller on Linux via USB:
	# { "vendor_id": 1118, "product_id": 2834, "raw_name": "Microsoft Xbox Series S|X Controller" }
	# Xbox Series Controller on Linux via Bluetooth:
	# { "vendor_id": 1118, "product_id": 654, "raw_name": "Xbox Wireless Controller" }

	for device in Input.get_connected_joypads():
		if Input.is_joy_known(device):
			var joy_name := Input.get_joy_name(device)
			if joy_name.contains("Xbox"):
				return "xbox_series"
	return "xbox_series"
