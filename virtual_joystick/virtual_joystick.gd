@tool  # For drawing shape radius inside the editor
extends Control
class_name VirtualJoystick

@onready var base := $Base as Control
@onready var tip := $Base/Tip as Control

enum JoystickMode {
	FIXED,
	DYNAMIC,
	FOLLOWING,
}
@export var joystick_mode := JoystickMode.FOLLOWING

enum VisibilityCondition {
	ALWAYS,
	TOUCHSCREEN_ONLY,
}
@export var visibility_condition := VisibilityCondition.TOUCHSCREEN_ONLY

@export var shape: CircleShape2D:
	set(value):
		if shape:
			shape.changed.disconnect(queue_redraw)
		shape = value
		if shape:
			shape.changed.connect(queue_redraw)
		queue_redraw()

@export var action_up := &""
@export var action_down := &""
@export var action_left := &""
@export var action_right := &""
@export var action_double_tap := &""

## Triggers Input.is_action_pressed(), Input.is_action_just_pressed(), Input.get_axis(), Input.get_vector(), etc.
@export var trigger_action_presses := true

## Triggers Node._input()
@export var trigger_input_events := false

var current_value := Vector2()
var current_index := -1
@onready var _original_base_position := base.global_position


func _ready():
	match visibility_condition:
		VisibilityCondition.TOUCHSCREEN_ONLY when not DisplayServer.is_touchscreen_available() and not Engine.is_editor_hint():
			hide()


func _draw() -> void:
	if shape and Engine.is_editor_hint() or get_tree().is_debugging_collisions_hint():
		draw_circle(size * 0.5, shape.radius, ProjectSettings.get_setting("debug/shapes/collision/shape_color"))


func _input(event: InputEvent) -> void:
	if not event is InputEventScreenTouch and not event is InputEventScreenDrag:
		return  # We are interested only in touch events

	if not shape:
		return  # No shape no game

	if current_index != -1:  # Tracking a finger
		match event.get_class():
			"InputEventScreenTouch":
				if (event as InputEventScreenTouch).index != current_index:
					return  # Not interested in other finger touches
			"InputEventScreenDrag":
				if (event as InputEventScreenDrag).index != current_index:
					return  # Not interested in other finger movements

	var event_position: Vector2
	match event.get_class():
		"InputEventScreenTouch":
			event_position = (event as InputEventScreenTouch).position
		"InputEventScreenDrag":
			event_position = (event as InputEventScreenDrag).position

	match event.get_class():
		"InputEventScreenTouch":
			if event.is_pressed():
				var touch_event := event as InputEventScreenTouch
				var vector := (event_position - get_global_rect().get_center()) / shape.radius
				if (joystick_mode == JoystickMode.FIXED and vector.length_squared() < 1.0  # Finger press inside shape
						or joystick_mode in [JoystickMode.DYNAMIC, JoystickMode.FOLLOWING] and get_global_rect().has_point(event_position)):  # Finger press inside the whole control
					if joystick_mode in [JoystickMode.DYNAMIC, JoystickMode.FOLLOWING]:
						base.global_position = event_position - base.size * 0.5
						vector = (event_position - base.get_global_rect().get_center()) / shape.radius

					current_value = vector
					_trigger_input_from_vector(current_value)
					current_index = touch_event.index
					if touch_event.double_tap:
						_trigger_input(action_double_tap, true)
					get_viewport().set_input_as_handled()
				else:
					return  # Ignore finger presses outside shape
			else:  # Finger release
				if current_index == (event as InputEventScreenTouch).index:
					for action in [action_up, action_down, action_left, action_right, action_double_tap] as Array[StringName]:
						_trigger_input(action, false)
					current_value = Vector2()
					current_index = -1
					base.global_position = _original_base_position
					get_viewport().set_input_as_handled()
		"InputEventScreenDrag":
			if current_index != -1:
				var vector := (event_position - base.get_global_rect().get_center()) / shape.radius

				if joystick_mode == JoystickMode.FOLLOWING and vector.length_squared() > 1.0:
					base.global_position = event_position + event_position.direction_to(base.get_global_rect().get_center()) * shape.radius - base.size * 0.5

				current_value = vector if vector.length_squared() < 1.0 else vector.normalized()
				_trigger_input_from_vector(current_value)
				get_viewport().set_input_as_handled()

	tip.position = size * 0.5 - tip.size * 0.5 + current_value * shape.radius


func _trigger_input_from_vector(vector: Vector2) -> void:
	if absf(vector.x) > 0:
		_trigger_input(action_right if vector.x > 0 else action_left, true, absf(vector.x))
	if absf(vector.y) > 0:
		_trigger_input(action_down if vector.y > 0 else action_up, true, absf(vector.y))


func _trigger_input(action: StringName, pressed: bool, strength: float = 1) -> void:
	if trigger_action_presses:
		if pressed:
			strength = clampf(strength * 1.04, 0, 1)  # Allow wider angle with strength 1
			Input.action_press(action, strength)
		else:
			Input.action_release(action)

	if trigger_input_events:
		var event := InputEventAction.new()
		event.action = action
		event.pressed = pressed
		event.strength = strength
		Input.parse_input_event(event)
