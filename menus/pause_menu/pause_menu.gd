extends Control


func _ready():
	_set_paused(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause_menu"):
		# Prevent unpausing when nested menus are still open
		if not get_tree().paused or get_tree().paused and visible:
			_set_paused(not get_tree().paused)


func _on_resume_pressed() -> void:
	_set_paused(false)


func _set_paused(paused: bool) -> void:
	get_tree().paused = paused
	visible = paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED
	if visible:
		Utils.grab_focus_first_visible_button(self)


func _on_quit_to_main_menu_pressed() -> void:
	get_tree().paused = false
	owner.get_parent().remove_child(owner)
	owner.queue_free()
