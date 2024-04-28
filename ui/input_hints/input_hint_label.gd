extends Label


@export var input_action := &""


func _init() -> void:
	InputMonitor.input_type_changed.connect(func(_input_type): _update_visibility())
	InputMonitor.input_map_changed.connect(_update_visibility)


func _ready() -> void:
	_update_visibility()


func _update_visibility() -> void:
	visible = InputMap.action_get_events(input_action).filter(_event_matches_current_input_type).size() > 0


func _event_matches_current_input_type(event: InputEvent) -> bool:
	match InputMonitor.current_input_type:
		InputMonitor.InputType.KEYBOARD_AND_MOUSE:
			return event is InputEventKey or event is InputEventMouse
		InputMonitor.InputType.JOYPAD:
			return event is InputEventJoypadButton or event is InputEventJoypadMotion
		_:
			return false
