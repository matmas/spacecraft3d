@tool
extends InputEventTextureRect
class_name InputEventTouchButton

enum VisibilityCondition {
	ALWAYS,
	TOUCHSCREEN_ONLY,
}
@export var visibility_condition := VisibilityCondition.TOUCHSCREEN_ONLY

## Triggers Input.is_action_pressed(), Input.is_action_just_pressed(), Input.get_axis(), Input.get_vector(), etc.
@export var trigger_action_presses := true

## Triggers Node._input()
@export var trigger_input_events := true

var _current_index := -1


func _ready():
	match visibility_condition:
		VisibilityCondition.TOUCHSCREEN_ONLY when not DisplayServer.is_touchscreen_available() and not Engine.is_editor_hint():
			hide()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		if _current_index == -1 and touch_event.pressed and get_global_rect().has_point(touch_event.position):  # Press untracked finger on button
			_trigger_input(get_action(), true)
			_current_index = touch_event.index
		if _current_index == touch_event.index and touch_event.is_released():  # Lift tracked finger anywhere
			_trigger_input(get_action(), false)
			_current_index = -1
	if event is InputEventScreenDrag:
		var drag_event := event as InputEventScreenDrag
		if _current_index == -1 and get_global_rect().has_point(drag_event.position):  # Drag untracked finger onto button
			_trigger_input(get_action(), true)
			_current_index = drag_event.index
		if drag_event.index == _current_index and not get_global_rect().has_point(drag_event.position):  # Drag tracked finger away from button
			_trigger_input(get_action(), false)
			_current_index = -1


func _trigger_input(action: StringName, pressed: bool, strength: float = 1) -> void:
	if not action:
		return

	if trigger_action_presses:
		if pressed:
			Input.action_press(action, strength)
		else:
			Input.action_release(action)

	if trigger_input_events:
		var event := InputEventAction.new()
		event.action = action
		event.pressed = pressed
		event.strength = strength
		Input.parse_input_event(event)


func get_action() -> StringName:
	for action in InputMap.get_actions():
		if InputMap.action_has_event(action, input_event):
			return action
	return &""
