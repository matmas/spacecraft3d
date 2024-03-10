@tool
extends ShortcutButton
class_name BackButton

const ACTION_NAME = &"ui_cancel"


func _ready() -> void:
	if not Engine.is_editor_hint():
		_ensure_shortcut_event(ACTION_NAME)

		pressed.connect(_on_pressed)
	super._ready()


func _ensure_shortcut_event(action: StringName) -> void:
	if not shortcut:
		shortcut = Shortcut.new()

	for event in shortcut.events:
		if event is InputEventAction:
			if (event as InputEventAction).action == action:
				return

	var event := InputEventAction.new()
	event.action = action
	shortcut.events.append(event)


func _on_pressed() -> void:
	SceneManagement.close_current_scene()
