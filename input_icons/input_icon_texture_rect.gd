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


func _set_texture(relative_path_without_extension: String) -> void:
	texture = ResourceLoader.load("res://input_icons/icons/%s.png" % relative_path_without_extension)


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
						_set_texture("mouse/left")
					MOUSE_BUTTON_RIGHT:  # Secondary mouse button, usually assigned to the right button.
						_set_texture("mouse/right")
					MOUSE_BUTTON_MIDDLE:
						_set_texture("mouse/middle")
					MOUSE_BUTTON_WHEEL_UP:
						_set_texture("mouse/wheel_up")
					MOUSE_BUTTON_WHEEL_DOWN:
						_set_texture("mouse/wheel_down")
					MOUSE_BUTTON_WHEEL_LEFT:
						_set_texture("mouse/wheel_left")
					MOUSE_BUTTON_WHEEL_RIGHT:
						_set_texture("mouse/wheel_right")
					MOUSE_BUTTON_XBUTTON1:  # Extra mouse button 1. This is sometimes present, usually to the sides of the mouse.
						_set_texture("mouse/thumb_button_1")
					MOUSE_BUTTON_XBUTTON2:  # Extra mouse button 2. This is sometimes present, usually to the sides of the mouse.
						_set_texture("mouse/thumb_button_2")
			"InputEventJoypadButton":
				var event := input_event as InputEventJoypadButton
				print(event.as_text())
	else:
		text = ""
	queue_redraw()
