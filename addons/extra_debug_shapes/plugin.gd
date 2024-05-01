@tool
extends EditorPlugin

const AUTOLOAD_SINGLETON_NAME = "ExtraDebugShapes"


func _enter_tree() -> void:
	await get_tree().process_frame  # Wait for @tool autoloads to load

	if not get_node_or_null("/root/%s" % AUTOLOAD_SINGLETON_NAME):  # Avoid project modification indicator in the Godot window title (*) everytime project loads
		add_autoload_singleton(AUTOLOAD_SINGLETON_NAME, "autoload.gd")

	CenterOfMass.register_settings()


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_SINGLETON_NAME)
