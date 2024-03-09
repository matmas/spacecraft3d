@tool
extends KeyIconTextureRect
class_name InputEventTextureRect

@export var input_event: InputEvent:
	set(value):
		if input_event:
			input_event.changed.disconnect(_update_text)
		input_event = value
		if input_event:
			input_event.changed.connect(_update_text)
		_update_text()

## Convert physical keycodes (US QWERTY) to ones in the active keyboard layout, e.g. AZERTY if supported by DisplayServer
@export var convert_physical_keycodes := false:
	set(value):
		convert_physical_keycodes = value
		_update_text()

enum VisibilityMode {
	SHRINK,  ## Reduces size to zero when visibility condition is not met
	INVISIBLE,  ## Turns invisible but retains size when visibility condition is not met
}
@export var visibility_mode := VisibilityMode.SHRINK:
	set(value):
		visibility_mode = value
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

				match keycode:
					KEY_NONE:
						_set_text("")
					KEY_SPECIAL:
						_set_text(" ")
					KEY_ESCAPE:
						_set_text("Esc")
					KEY_BACKSPACE:
						_set_texture("keyboard", "backspace")
					KEY_ENTER:
						_set_texture("keyboard", "enter")
					KEY_KP_ENTER:
						_set_texture("keyboard", "kp_enter")
					KEY_INSERT:
						_set_text("Ins")
					KEY_DELETE:
						_set_text("Del")
					KEY_PRINT:
						_set_text("PrtScr")
					KEY_LEFT:
						_set_texture("keyboard", "arrow_left")
					KEY_UP:
						_set_texture("keyboard", "arrow_up")
					KEY_RIGHT:
						_set_texture("keyboard", "arrow_right")
					KEY_DOWN:
						_set_texture("keyboard", "arrow_down")
					KEY_PAGEUP:
						_set_text("Page\nUp", HorizontalAlignment.LEFT)
					KEY_PAGEDOWN:
						_set_text("Page\nDown", HorizontalAlignment.LEFT)
					KEY_META:
						match OS.get_name():
							"macOS":
								_set_texture("keyboard", "cmd")
							"Windows":
								_set_texture("keyboard", "windows")
							_:
								_set_text("Meta")
					KEY_CAPSLOCK:
						_set_text("Caps\nLock", HorizontalAlignment.LEFT)
					KEY_NUMLOCK:
						_set_text("Num\nLock", HorizontalAlignment.LEFT)
					KEY_SCROLLLOCK:
						_set_text("Scroll\nLock", HorizontalAlignment.LEFT)
					KEY_KP_MULTIPLY:
						_set_text("*")
					KEY_KP_DIVIDE:
						_set_text("/")
					KEY_KP_SUBTRACT:
						_set_texture("keyboard", "kp_minus")
					KEY_KP_PERIOD:
						_set_text(".")
					KEY_KP_ADD:
						_set_texture("keyboard", "kp_plus")
					KEY_KP_0:
						_set_text("0\nIns")
					KEY_KP_1:
						_set_text("1\nEnd")
					KEY_KP_2:
						_set_text("2\n↓")
					KEY_KP_3:
						_set_text("3\nPgDn")
					KEY_KP_4:
						_set_text("4\n←")
					KEY_KP_5:
						_set_text("5\n.")
					KEY_KP_6:
						_set_text("6\n→")
					KEY_KP_7:
						_set_text("7\nHome")
					KEY_KP_8:
						_set_text("8\n↑")
					KEY_KP_9:
						_set_text("9\nPgUp")
					KEY_VOLUMEDOWN:
						_set_text("Vol-")
					KEY_VOLUMEMUTE:
						_set_text("Mute")
					KEY_VOLUMEUP:
						_set_text("Vol+")
					KEY_MEDIAPLAY:
						_set_text("Play")
					KEY_MEDIASTOP:
						_set_text("Stop")
					KEY_MEDIAPREVIOUS:
						_set_text("Prev")
					KEY_MEDIANEXT:
						_set_text("Next")
					KEY_MEDIARECORD:
						_set_text("Rec")
					KEY_FAVORITES:
						_set_text("Fav")
					KEY_OPENURL:
						_set_text("URL")
					KEY_LAUNCHMAIL:
						_set_text("Mail")
					KEY_LAUNCHMEDIA:
						_set_text("Media")
					KEY_KEYBOARD:
						_set_text("Keyboard")
					KEY_JIS_EISU:
						_set_text("英数")
					KEY_JIS_KANA:
						_set_text("かな")
					KEY_EXCLAM:
						_set_text("!")
					KEY_QUOTEDBL:
						_set_text("\"")
					KEY_NUMBERSIGN:
						_set_text("#")
					KEY_DOLLAR:
						_set_text("$")
					KEY_PERCENT:
						_set_text("%")
					KEY_AMPERSAND:
						_set_text("&")
					KEY_APOSTROPHE:
						_set_text("'")
					KEY_PARENLEFT:
						_set_text("(")
					KEY_PARENRIGHT:
						_set_text(")")
					KEY_ASTERISK:
						_set_text("*")
					KEY_PLUS:
						_set_text("+")
					KEY_COMMA:
						_set_text(",")
					KEY_MINUS:
						_set_text("-")
					KEY_PERIOD:
						_set_text(".")
					KEY_SLASH:
						_set_text("/")
					KEY_COLON:
						_set_text(":")
					KEY_SEMICOLON:
						_set_text(";")
					KEY_LESS:
						_set_text("<")
					KEY_EQUAL:
						_set_text("=")
					KEY_GREATER:
						_set_text(">")
					KEY_QUESTION:
						_set_text("?")
					KEY_AT:
						_set_text("@")
					KEY_BRACKETLEFT:
						_set_text("[")
					KEY_BACKSLASH:
						_set_text("\\")
					KEY_BRACKETRIGHT:
						_set_text("]")
					KEY_ASCIICIRCUM:
						_set_text("^")
					KEY_UNDERSCORE:
						_set_text("_")
					KEY_QUOTELEFT:
						_set_text("`")
					KEY_BRACELEFT:
						_set_text("{")
					KEY_BAR:
						_set_text("|")
					KEY_BRACERIGHT:
						_set_text("}")
					KEY_ASCIITILDE:
						_set_text("~")
					KEY_YEN:
						_set_text("¥")
					KEY_SECTION:
						_set_text("§")
					_:
						_set_text(OS.get_keycode_string(keycode))
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
						_set_text("")
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
						_set_texture(_get_joypad_name(), "select")
					JOY_BUTTON_GUIDE:
						match _get_joypad_name():
							"steam", "steam_deck", "switch", "joy_con":
								_set_texture(_get_joypad_name(), "home")
							"ps3", "ps4", "ps5":
								_set_text("PS")
							_:
								_set_text("Home")
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
						match _get_joypad_name():
							"steam_deck", "steam":
								_set_texture(_get_joypad_name(), "paddle1")
							_:
								_set_text("Paddle 1")
					JOY_BUTTON_PADDLE2:
						match _get_joypad_name():
							"steam_deck", "steam":
								_set_texture(_get_joypad_name(), "paddle2")
							_:
								_set_text("Paddle 2")
					JOY_BUTTON_PADDLE3:
						match _get_joypad_name():
							"steam_deck":
								_set_texture(_get_joypad_name(), "paddle3")
							_:
								_set_text("Paddle 3")
					JOY_BUTTON_PADDLE4:
						match _get_joypad_name():
							"steam_deck":
								_set_texture(_get_joypad_name(), "paddle4")
							_:
								_set_text("Paddle 4")
					JOY_BUTTON_TOUCHPAD:
						_set_texture(_get_joypad_name(), "touchpad")
					_:
						printerr("Unknown joypad button ", event.button_index)
						_set_text("")
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
						_set_text("")
	else:
		_set_text("")

	shrink = bool(not text and not texture and visibility_mode == VisibilityMode.SHRINK)
	queue_redraw()


func _set_text(value: String, _horizontal_alignment := HorizontalAlignment.CENTER) -> void:
	texture = null
	text = value
	horizontal_alignment = _horizontal_alignment


func _set_texture(folder: String, filename: String, extension: String = "png") -> void:
	var base_path := "res://ui/input_icons/icons"
	var path := "%s/%s/%s.%s" % [base_path, folder, filename, extension]
	texture = ResourceLoader.load(path)
	text = ""
	if not texture:
		if ResourceLoader.exists(path):
			printerr("Failed loading ", path)
		else:
			printerr("Missing icon ", path)


func _get_joypad_name() -> String:
	for device in Input.get_connected_joypads():
		if Input.is_joy_known(device):
			var joy_name := Input.get_joy_name(device)
			if "PS3 Controller" in joy_name:
				return "ps3"
			elif "PS4 Controller" in joy_name:
				return "ps4"
			elif "PS5 Controller" in joy_name:
				return "ps5"
			elif "Xbox 360 Controller" in joy_name:
				return "xbox_360"
			elif "Xbox One" in joy_name or "X-Box One" in joy_name or "Xbox Wireless Controller" in joy_name:
				return "xbox_one"
			elif "Xbox Series" in joy_name:
				return "xbox_series"
			elif "Switch Controller" in joy_name or "Switch Pro Controller" in joy_name:
				return "switch"
			elif "Joy-Con" in joy_name:
				return "joy_con"
			elif "Steam Controller" in joy_name:
				return "steam"
			elif "Steam Deck" in joy_name or "Steam Virtual Gamepad" in joy_name:
				return "steam_deck"
	return "xbox_series"
