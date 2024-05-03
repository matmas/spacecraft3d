@tool
extends EditorPlugin

const AUTOLOAD_SINGLETON_NAME = "ExtraDebugShapes"


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_SINGLETON_NAME, "autoload.gd")


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_SINGLETON_NAME)
