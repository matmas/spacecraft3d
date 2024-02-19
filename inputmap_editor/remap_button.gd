@tool
extends InputActionButton
class_name RemapButton

@export var is_controller_button: bool = false:
	set(value):
		is_controller_button = value

var action: StringName:
	set(value):
		action = value
		action_name = value

var _is_capturing := false
var _saved_mouse_position := Vector2()


func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
	if property.name == "disabled":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


func _ready() -> void:
	_on_input_type_changed(InputMonitor.current_input_type)
	InputMonitor.input_type_changed.connect(_on_input_type_changed)


func _on_input_type_changed(input_type) -> void:
	disabled = (input_type == InputMonitor.InputType.KEYBOARD_AND_MOUSE) == is_controller_button


func refresh() -> void:
	input_action_rect._update_input_event()


func _get_current_event() -> InputEvent:
	for event in InputMap.action_get_events(action):
		if is_controller_button:
			if _is_joypad_event(event):
				return event
		else:
			if _is_key_or_mouse_event(event):
				return event
	return null


func _on_toggled(toggled_on: bool) -> void:
	_is_capturing = toggled_on
	if toggled_on:
		action_name = &""  # Hide icon
		text = "..."
		release_focus()
		_saved_mouse_position = get_viewport().get_mouse_position()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_viewport().warp_mouse(_saved_mouse_position)
		text = ""
		action_name = action  # Show icon


func _input(event: InputEvent) -> void:
	if _is_capturing:
		if event.is_pressed():
			if is_controller_button == _is_joypad_event(event):
				# Allow remap cancelling with keyboard but not with joypad
				if not event.is_action(&"ui_cancel") or _is_joypad_event(event):
					_remap_action_to(event)
			get_viewport().set_input_as_handled()
			button_pressed = false
			grab_focus()
		if disabled:
			button_pressed = false
			grab_focus()


func _remap_action_to(event: InputEvent) -> void:
	var current_event := _get_current_event()
	if current_event:
		InputMap.action_erase_event(action, current_event)
	InputMap.action_add_event(action, event)
	InputMonitor.input_map_changed.emit()
	InputmapPersistence.add_action(action)
	InputmapPersistence.save()


func _is_joypad_event(event: InputEvent) -> bool:
	return event is InputEventJoypadButton or event is InputEventJoypadMotion


func _is_key_or_mouse_event(event: InputEvent) -> bool:
	return event is InputEventKey or event is InputEventMouse


func _on_gui_input(event: InputEvent) -> void:
	if not disabled:
		if event is InputEventMouseButton:
			if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
				if event.is_pressed():
					grab_focus()
				if event.is_released():
					if Rect2(Vector2(), size).has_point(event.position):
						_clear_mapping()
						refresh()
		if event.is_action_pressed(&"ui_text_delete"):
			_clear_mapping()
			refresh()


func _clear_mapping() -> void:
	var current_event := _get_current_event()
	if current_event:
		InputMap.action_erase_event(action, current_event)
		InputMonitor.input_map_changed.emit()
		InputmapPersistence.add_action(action)
		InputmapPersistence.save()
