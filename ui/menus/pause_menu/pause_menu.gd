extends Scene


func _on_quit_to_main_menu_pressed() -> void:
	SceneStack.close_current_scene(2)
