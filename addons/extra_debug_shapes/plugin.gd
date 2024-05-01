@tool
extends EditorPlugin

const AUTOLOAD_SINGLETON_NAME = "ExtraDebugShapes"

var project_settings_properties = {
	CenterOfMass.get_project_settings_property_name(): CenterOfMass.get_project_settings_property_description(),
}


func _enter_tree() -> void:
	await get_tree().process_frame  # Wait for @tool autoloads to load

	if not get_node_or_null("/root/%s" % AUTOLOAD_SINGLETON_NAME):  # Avoid project modification indicator in the Godot window title (*) everytime project loads
		add_autoload_singleton(AUTOLOAD_SINGLETON_NAME, "autoload.gd")

	for property_name in project_settings_properties:
		if not ProjectSettings.has_setting(property_name):
			ProjectSettings.set(property_name, false)
			ProjectSettings.add_property_info({
				"name": property_name,
				"type": TYPE_BOOL,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": project_settings_properties[property_name]
			})
			ProjectSettings.set_initial_value(property_name, false)


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_SINGLETON_NAME)
