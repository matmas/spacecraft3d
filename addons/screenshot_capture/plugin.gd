@tool
extends EditorPlugin

const AUTOLOAD_SINGLETON_NAME = "ScreenshotCapture"
const INPUT_ACTION_NAME = &"capture_screenshot"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_SINGLETON_NAME, "autoload.gd")

	if not ProjectSettings.has_setting("input/%s" % INPUT_ACTION_NAME):
		var event := InputEventKey.new()
		event.physical_keycode = KEY_F12
		ProjectSettings.set_setting("input/%s" % INPUT_ACTION_NAME, {"deadzone": 0.5, "events": [event]})
		push_warning("Project Settings Input Map has been changed. Restart the editor to see the change there.")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_SINGLETON_NAME)

	if ProjectSettings.has_setting("input/%s" % INPUT_ACTION_NAME):
		ProjectSettings.set_setting("input/%s" % INPUT_ACTION_NAME, null)
		push_warning("Project Settings Input Map has been changed. Restart the editor to see the change there.")
