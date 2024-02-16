extends Button
class_name RemapButton

@export var is_controller_button: bool = false
var action: StringName:
	set(value):
		action = value
		refresh()

var _is_capturing := false
var _saved_mouse_position := Vector2()

func _ready() -> void:
	_on_input_type_changed(InputMonitor.current_input_type)
	InputMonitor.input_type_changed.connect(_on_input_type_changed)


func _on_input_type_changed(input_type) -> void:
	disabled = (input_type == InputMonitor.InputType.KEYBOARD_AND_MOUSE) == is_controller_button


func refresh() -> void:
	var event := _get_current_event()
	icon = ControllerIconsExtra.parse_event(event) if event else null
	text = event.as_text() if event and not icon else ""


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
		text = "..."
		icon = null
		release_focus()
		_saved_mouse_position = get_viewport().get_mouse_position()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_viewport().warp_mouse(_saved_mouse_position)
		refresh()


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
	InputmapPersistence.add_action(action)
	InputmapPersistence.save()
	ControllerIcons.refresh()


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


func _clear_mapping() -> void:
	var current_event := _get_current_event()
	if current_event:
		InputMap.action_erase_event(action, current_event)
	InputmapPersistence.add_action(action)
	InputmapPersistence.save()
	ControllerIcons.refresh()
