@tool
extends TextureRect

@export var tip: Texture2D:
	set(value):
		tip = value
		queue_redraw()
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

## Triggers Input.is_action_pressed(), Input.is_action_just_pressed(), Input.get_axis(), Input.get_vector(), etc.
@export var trigger_action_presses := true

## Triggers Node._input()
@export var trigger_input_events := false

var current_value := Vector2()
var current_index := -1

func _draw() -> void:
	if tip:
		draw_texture(tip, size * 0.5 - tip.get_size() * 0.5 + current_value * shape.radius)
	if shape and Engine.is_editor_hint() or get_tree().is_debugging_collisions_hint():
		draw_circle(size * 0.5, shape.radius, ProjectSettings.get_setting("debug/shapes/collision/shape_color"))


func _input(event: InputEvent) -> void:
	if not event is InputEventScreenTouch and not event is InputEventScreenDrag:
		return  # We are interested only in touch events

	if not shape:
		return  # No shape no game

	if current_index != -1:  # We are tracking some finger index
		match event.get_class():
			"InputEventScreenTouch":
				if (event as InputEventScreenTouch).index != current_index:
					return  # We are not interested in other finger touches
			"InputEventScreenDrag":
				if (event as InputEventScreenDrag).index != current_index:
					return  # We are not interested in other finger movements

	var event_position: Vector2
	match event.get_class():
		"InputEventScreenTouch":
			event_position = (event as InputEventScreenTouch).position
		"InputEventScreenDrag":
			event_position = (event as InputEventScreenDrag).position
	var vector := (event_position - (global_position + size * 0.5)) / shape.radius

	match event.get_class():
		"InputEventScreenTouch":
			if event.is_pressed():
				if vector.length_squared() < 1.0:  # Finger press inside shape
					current_value = vector
					_trigger_input_from_vector(current_value)
					current_index = (event as InputEventScreenTouch).index
					get_viewport().set_input_as_handled()
				else:
					return  # Ignore finger presses outside shape
			else:  # Finger release
				for action in [action_up, action_down, action_left, action_right]:
					_trigger_input(action, false)
				current_value = Vector2()
				current_index = -1
				get_viewport().set_input_as_handled()
		"InputEventScreenDrag":
			if current_index != -1:
				current_value = vector if vector.length_squared() < 1.0 else vector.normalized()
				_trigger_input_from_vector(current_value)
				get_viewport().set_input_as_handled()
	queue_redraw()


func _trigger_input_from_vector(vector: Vector2) -> void:
	if absf(vector.x) > 0:
		_trigger_input(action_right if vector.x > 0 else action_left, true, absf(vector.x))
	if absf(vector.y) > 0:
		_trigger_input(action_down if vector.y > 0 else action_up, true, absf(vector.y))


func _trigger_input(action: StringName, pressed: bool, strength: float = 1) -> void:
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
