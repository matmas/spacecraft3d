extends Node
# Alternative to input_devices/pointing/emulate_mouse_from_touch (default: true)

func set_enabled(value) -> void:
	set_process_input(value)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Useful even when game is paused
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)


func _input(event: InputEvent) -> void:
	var embedded_window_position := Vector2() if get_window() == get_tree().root else Vector2(get_window().position)
	match event.get_class():
		"InputEventScreenTouch":
			var touch_event := event as InputEventScreenTouch
			var e := InputEventMouseButton.new()
			e.button_index = MOUSE_BUTTON_LEFT
			e.button_mask = MOUSE_BUTTON_MASK_LEFT if event.is_pressed() else 0
			e.pressed = event.is_pressed()
			e.double_click = touch_event.double_tap
			e.position = embedded_window_position + touch_event.position
			e.device = -1
			get_tree().root.push_input(e, true)
		"InputEventScreenDrag":
			var drag_event := event as InputEventScreenDrag
			var e := InputEventMouseMotion.new()
			e.position = embedded_window_position + drag_event.position
			e.relative = drag_event.relative
			e.velocity = drag_event.velocity
			e.device = -1
			get_tree().root.push_input(e, true)


func _on_gui_focus_changed(node: Control) -> void:
	if node is OptionButton:
		for child in node.get_children(true):
			if child is PopupMenu:
				var popup_menu := child as PopupMenu
				# While a PopupMenu is open we don't receive _input events here
				popup_menu.set_script(get_script())
				popup_menu.set_process_input(is_processing_input())
				return
