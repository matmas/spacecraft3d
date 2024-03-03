@tool
extends InputEventTextureRect
class_name InputEventTouchButton

enum VisibilityCondition {
	ALWAYS,
	TOUCHSCREEN_ONLY,
}
@export var visibility_condition := VisibilityCondition.TOUCHSCREEN_ONLY

var _current_index := -1


func _ready():
	match visibility_condition:
		VisibilityCondition.TOUCHSCREEN_ONLY when not DisplayServer.is_touchscreen_available() and not Engine.is_editor_hint():
			hide()
	_update()
	InputMonitor.input_map_changed.connect(_update)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		if _current_index == -1 and touch_event.pressed and get_global_rect().has_point(touch_event.position):  # Press untracked finger on button
			_trigger_input(true)
			_current_index = touch_event.index
		if _current_index == touch_event.index and touch_event.is_released():  # Lift tracked finger anywhere
			_trigger_input(false)
			_current_index = -1
	if event is InputEventScreenDrag:
		var drag_event := event as InputEventScreenDrag
		if _current_index == -1 and get_global_rect().has_point(drag_event.position):  # Drag untracked finger onto button
			_trigger_input(true)
			_current_index = drag_event.index
		if drag_event.index == _current_index and not get_global_rect().has_point(drag_event.position):  # Drag tracked finger away from button
			_trigger_input(false)
			_current_index = -1


func _trigger_input(pressed: bool) -> void:
	var event := input_event.duplicate()
	match input_event.get_class():
		"InputEventJoypadButton":
			(event as InputEventJoypadButton).pressed = pressed
		"InputEventJoypadMotion":
			(event as InputEventJoypadMotion).axis_value = (input_event as InputEventJoypadMotion).axis_value if pressed else 0.0
	Input.parse_input_event(event)


func _update() -> void:
	var has_event := false
	for action in InputMap.get_actions():
		if InputMap.action_has_event(action, input_event):
			has_event = true
			break
	modulate = Color.WHITE if has_event else Color(Color.WHITE, 0.25)
