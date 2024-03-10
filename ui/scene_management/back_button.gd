@tool
extends ShortcutButton


func _on_pressed() -> void:
	SceneManagement.close_current_scene()
