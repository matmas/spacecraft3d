extends Scene
class_name BuildMenu


func should_pause_game() -> bool:
	return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"build_menu"):  # We can't use Button.shortcut as it clashes with ui_focus_next which takes priority
		get_viewport().set_input_as_handled()
		SceneManagement.close_current_scene()
