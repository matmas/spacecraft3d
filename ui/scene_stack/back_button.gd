@tool
extends ShortcutButton
class_name BackButton


func _on_pressed() -> void:
	SceneStack.close_current_scene()
