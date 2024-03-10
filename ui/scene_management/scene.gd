extends Node
class_name Scene


func _ready() -> void:
	refresh()


func refresh() -> void:
	if should_focus_first_visible_button():
		Utils.grab_focus_first_visible_button(self)
	EmulateMouseFromTouch.enabled = should_emulate_mouse_from_touch()
	get_tree().paused = should_pause_game()
	if should_hide_mouse_cursor():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func should_focus_first_visible_button() -> bool:
	return true


func should_emulate_mouse_from_touch() -> bool:
	return true


func should_pause_game() -> bool:
	return true


func should_hide_mouse_cursor() -> bool:
	return false


func on_go_back_requested() -> void:
	SceneManagement.close_current_scene()
