extends VBoxContainer


func _ready() -> void:
	_set_paused(false)


func _input(event: InputEvent) -> void:
	if SceneManagement.current_scene() is Game and event.is_action_pressed(&"pause_menu"):
		_set_paused(not get_tree().paused)
		get_viewport().set_input_as_handled()


func _on_resume_pressed() -> void:
	_set_paused(false)


func _set_paused(paused: bool) -> void:
	get_tree().paused = paused
	visible = paused
	_update_mouse_mode()
	EmulateMouseFromTouch.enabled = paused
	if paused:
		Utils.grab_focus_first_visible_button(self)


func _update_mouse_mode() -> void:
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_quit_to_main_menu_pressed() -> void:
	get_tree().paused = false
	owner.get_parent().remove_child(owner)
	owner.queue_free()


func _on_go_back_requested() -> void:
	if not get_tree().paused:
		_set_paused(true)
	else:
		_on_quit_to_main_menu_pressed()
