extends Scene


func _on_quit_to_main_menu_pressed() -> void:
	queue_free()
	SceneManagement.previous_scene().queue_free.call_deferred()
