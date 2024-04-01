@tool
extends ShortcutButton
class_name BackButton


func get_shortcut_action_name() -> StringName:
	return &"ui_cancel"


func _ready() -> void:
	if not Engine.is_editor_hint():
		pressed.connect(_on_pressed)
	super._ready()


func _on_pressed() -> void:
	SceneManagement.close_current_scene()
