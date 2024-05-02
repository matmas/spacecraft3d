@tool
extends EditorPlugin

const AUTOLOAD_SINGLETON_NAME = "ScreenshotCapture"
const INPUT_ACTION_NAME = &"capture_screenshot"


func _enter_tree() -> void:
	await get_tree().process_frame  # Wait for @tool autoloads to load

	if not get_node_or_null("/root/%s" % AUTOLOAD_SINGLETON_NAME):  # Avoid project modification indicator in the Godot window title (*) everytime project loads
		add_autoload_singleton(AUTOLOAD_SINGLETON_NAME, "autoload.gd")

	if not ProjectSettings.has_setting("input/%s" % INPUT_ACTION_NAME):
		var event := InputEventKey.new()
		event.physical_keycode = KEY_F12
		ProjectSettings.set_setting("input/%s" % INPUT_ACTION_NAME, {"deadzone": 0.5, "events": [event]})
		push_warning("Project Settings Input Map changed. Restart is required to see the change there.")


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_SINGLETON_NAME)

	if ProjectSettings.has_setting("input/%s" % INPUT_ACTION_NAME):
		ProjectSettings.set_setting("input/%s" % INPUT_ACTION_NAME, null)
		push_warning("Project Settings Input Map changed. Restart is required to see the change there.")
