@tool
extends InputEventTextureRect
class_name InputActionTextureRect

@export var action_name: StringName = "":
	set(value):
		action_name = value
		_update_input_event()

enum ShowMode { ANY, KEYBOARD_AND_MOUSE, JOYPAD }
@export var show_mode := ShowMode.ANY:
	set(value):
		show_mode = value
		_update_input_event()

enum ForceMode { DISABLED, KEYBOARD_AND_MOUSE, JOYPAD }
@export var force_mode := ForceMode.DISABLED:
	set(value):
		force_mode = value
		_update_input_event()

@export var ignore_joypad_direction := false:
	set(value):
		ignore_joypad_direction = value
		_update_input_event()

func _init() -> void:
	super._init()
	InputMonitor.input_type_changed.connect(_on_input_type_changed)


func _on_input_type_changed(_input_type: InputMonitor.InputType) -> void:
	_update_input_event()


func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
	if property.name == "input_event":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


func _update_input_event() -> void:
	input_event = _get_input_event_for_display()

	if ignore_joypad_direction and input_event is InputEventJoypadMotion:
		var event := input_event as InputEventJoypadMotion
		input_event = InputEventJoypadMotion.new()  # Modifying existing instance would interfere with gameplay
		input_event.axis = event.axis  # Ignore event.axis_value
	queue_redraw()


func _get_input_event_for_display() -> InputEvent:
	if show_mode == ShowMode.KEYBOARD_AND_MOUSE \
			and InputMonitor.current_input_type != InputMonitor.InputType.KEYBOARD_AND_MOUSE \
			or show_mode == ShowMode.JOYPAD \
			and InputMonitor.current_input_type != InputMonitor.InputType.JOYPAD:
		return null

	for event in _inputmap_get_events(action_name):
		match event.get_class():
			"InputEventKey", "InputEventMouseButton":
				if force_mode:
					if force_mode == ForceMode.KEYBOARD_AND_MOUSE:
						return event
				else:
					if InputMonitor.current_input_type == InputMonitor.InputType.KEYBOARD_AND_MOUSE:
						return event
			"InputEventJoypadButton", "InputEventJoypadMotion":
				if force_mode:
					if force_mode == ForceMode.JOYPAD:
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
