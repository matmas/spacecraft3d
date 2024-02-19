@tool
extends InputEventTextureRect
class_name InputActionTextureRect

@export var action_name: StringName = &"":
	set(value):
		action_name = value
		_update_input_event()

enum InputTypeMode {
	ADAPTIVE,  ## Icon that corresponds to the current input type used is shown.
	FORCE_KEYBOARD_AND_MOUSE,  ## Keyboard or mouse icon is shown.
	FORCE_JOYPAD,  ## Joypad icon is shown.
}
@export var input_type_mode := InputTypeMode.ADAPTIVE:
	set(value):
		input_type_mode = value
		_update_input_event()

@export var ignore_joypad_direction := false:
	set(value):
		ignore_joypad_direction = value
		_update_input_event()

enum VisibilityMode {
	ANY_USAGE,  ## Icon is shown regardless of the current input usage.
	USING_KEYBOARD_AND_MOUSE,  ## Icon is shown when using keyboard or mouse only.
	USING_JOYPAD,  ## Icon is shown when using joypad only.
}
@export var visibility_mode := VisibilityMode.ANY_USAGE:
	set(value):
		visibility_mode = value
		_update_input_event()


func _init() -> void:
	super._init()
	InputMonitor.input_type_changed.connect(_on_input_type_changed)
	InputMonitor.input_map_changed.connect(_on_input_map_changed)


func _on_input_type_changed(_input_type: InputMonitor.InputType) -> void:
	_update_input_event()


func _on_input_map_changed() -> void:
	_update_input_event()


func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
	if property.name == "input_event":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


func _update_input_event() -> void:
	var event = _get_input_event_for_display()

	if ignore_joypad_direction and event is InputEventJoypadMotion:
		var e := event as InputEventJoypadMotion
		event = InputEventJoypadMotion.new()  # Modifying existing instance would interfere with gameplay
		event.axis = e.axis  # Ignore event.axis_value

	input_event = event
	queue_redraw()


func _get_input_event_for_display() -> InputEvent:
	if visibility_mode == VisibilityMode.USING_KEYBOARD_AND_MOUSE \
			and InputMonitor.current_input_type != InputMonitor.InputType.KEYBOARD_AND_MOUSE \
			or visibility_mode == VisibilityMode.USING_JOYPAD \
			and InputMonitor.current_input_type != InputMonitor.InputType.JOYPAD:
		return null

	for event in _inputmap_get_events(action_name):
		match event.get_class():
			"InputEventKey", "InputEventMouseButton":
				if input_type_mode:
					if input_type_mode == InputTypeMode.FORCE_KEYBOARD_AND_MOUSE:
						return event
				else:
					if InputMonitor.current_input_type == InputMonitor.InputType.KEYBOARD_AND_MOUSE:
						return event
			"InputEventJoypadButton", "InputEventJoypadMotion":
				if input_type_mode:
					if input_type_mode == InputTypeMode.FORCE_JOYPAD:
						return event
				else:
					if InputMonitor.current_input_type == InputMonitor.InputType.JOYPAD:
						return event
	return null


func _inputmap_get_events(action: StringName) -> Array[InputEvent]:
	# Inside the editor InputMap.action_get_events() doesn't return custom events in ProjectSettings
	if Engine.is_editor_hint():
		var action_setting = ProjectSettings.get_setting("input/%s" % action)
		if action_setting:
			var typed_array: Array[InputEvent] = []
			typed_array.assign(action_setting["events"])
			return typed_array
		else:
			return []
	else:
		return InputMap.action_get_events(action)
