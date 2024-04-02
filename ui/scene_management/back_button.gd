@tool
extends ShortcutButton
class_name BackButton


func _on_pressed() -> void:
	SceneManagement.close_current_scene()
