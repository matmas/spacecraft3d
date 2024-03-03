extends InputActionButton
class_name InputRemapButton

var option: InputActionOption
var is_controller_button: bool

var _is_capturing := false
var _saved_mouse_position := Vector2()


func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
	if property.name in ["disabled", "toggle_mode"]:
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


func _ready() -> void:
	toggle_mode = true
	action_name = option.action_name
	toggled.connect(_on_toggled)
	gui_input.connect(_on_gui_input)
	option.value_changed.connect(_refresh)
	_on_input_type_changed(InputMonitor.current_input_type)
	InputMonitor.input_type_changed.connect(_on_input_type_changed)


func _on_input_type_changed(input_type) -> void:
	disabled = (input_type == InputMonitor.InputType.KEYBOARD_AND_MOUSE) == is_controller_button


func _refresh() -> void:
	input_action_rect._update_input_event()


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
		action_name = option.action_name  # Show icon


func _input(event: InputEvent) -> void:
	if _is_capturing:
		if event.is_pressed():
			if is_controller_button == _is_joypad_event(event):
				# Allow remap cancelling with keyboard but not with joypad
				if not event.is_action(&"ui_cancel") or _is_joypad_event(event):
					_normalize_event(event)
					_remap_action_to(event)
			get_viewport().set_input_as_handled()
			button_pressed = false
			grab_focus()
		if disabled:
			button_pressed = false
			grab_focus()


func _on_gui_input(event: InputEvent) -> void:
	if not disabled:
		if event is InputEventMouseButton:
			if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
				if event.is_pressed():
					grab_focus()
				if event.is_released():
					if Rect2(Vector2(), size).has_point(event.position):
						_clear_mapping()
						_refresh()
		if event.is_action_pressed(&"ui_text_delete"):
			_clear_mapping()
			_refresh()


func _is_joypad_event(event: InputEvent) -> bool:
	return event is InputEventJoypadButton or event is InputEventJoypadMotion


func _is_key_or_mouse_event(event: InputEvent) -> bool:
	return event is InputEventKey or event is InputEventMouse


func _matches_input_type(event: InputEvent) -> bool:
	if is_controller_button:
		if _is_joypad_event(event):
			return true
	else:
		if _is_key_or_mouse_event(event):
			return true
	return false


func _normalize_event(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		var e := event as InputEventJoypadMotion
		e.axis_value = signf(e.axis_value)
	event.device = -1  # All devices


func _remap_action_to(event: InputEvent) -> void:
	var events := option.get_value().filter(func(e): return not _matches_input_type(e))
	events.append(event)
	option.set_value(events)
	GameOptions.save()


func _clear_mapping() -> void:
	var events := option.get_value().filter(func(e): return not _matches_input_type(e))
	option.set_value(events)
	GameOptions.save()
