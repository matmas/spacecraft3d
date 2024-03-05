extends Node
# Alternative to input_devices/pointing/emulate_mouse_from_touch (default: true)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Useful even when game is paused
	# _window_input receives input events even when there is another embedded
	# window focused. Function _input() stops receiving them when window loses focus
	get_tree().root.window_input.connect(_window_input)


func _window_input(event: InputEvent) -> void:
	match event.get_class():
		"InputEventScreenTouch":
			var touch_event := event as InputEventScreenTouch
			var e := InputEventMouseButton.new()
			e.button_index = MOUSE_BUTTON_LEFT
			e.button_mask = MOUSE_BUTTON_MASK_LEFT if event.is_pressed() else 0
			e.pressed = event.is_pressed()
			e.double_click = touch_event.double_tap
			e.position = touch_event.position / get_tree().root.content_scale_factor
			e.device = -1
			get_tree().root.push_input(e, true)
		"InputEventScreenDrag":
			var drag_event := event as InputEventScreenDrag
			var e := InputEventMouseMotion.new()
			e.position = drag_event.position / get_tree().root.content_scale_factor
			e.relative = drag_event.relative / get_tree().root.content_scale_factor
			e.velocity = drag_event.velocity / get_tree().root.content_scale_factor
			e.device = -1
			get_tree().root.push_input(e, true)
