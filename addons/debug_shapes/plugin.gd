@tool
extends EditorPlugin

const AUTOLOAD_LABELS = {
	"CentersOfMasses": "Centers of Masses",
}
const AUTOLOAD_PATHS = {
	"CentersOfMasses": "shapes/centers_of_masses_autoload.gd",
}
var autoload_enabled = {
	"CentersOfMasses": false
}

func _enter_tree() -> void:
	await get_tree().process_frame  # Wait for @tool autoloads to load

	for autoload in AUTOLOAD_PATHS:
		autoload_enabled[autoload] = _is_autoload_singleton(autoload)

		add_tool_menu_item(_get_tool_menu_item_name(autoload), func(): _toggle(autoload))


func _exit_tree() -> void:
	for autoload in AUTOLOAD_PATHS:
		remove_tool_menu_item(_get_tool_menu_item_name(autoload))


func _toggle(autoload: String) -> void:
	remove_tool_menu_item(_get_tool_menu_item_name(autoload))

	if autoload_enabled[autoload]:
		remove_autoload_singleton(autoload)
	else:
		add_autoload_singleton(autoload, AUTOLOAD_PATHS[autoload])
	autoload_enabled[autoload] = not autoload_enabled[autoload]

	add_tool_menu_item(_get_tool_menu_item_name(autoload), func(): _toggle(autoload))
	await get_tree().process_frame


func _get_tool_menu_item_name(autoload: String) -> String:
	return "%s %s" % [tr("Hide") if autoload_enabled[autoload] else tr("Show"), AUTOLOAD_LABELS[autoload]]


func _is_autoload_singleton(name: String) -> bool:
	if get_node_or_null("/root/%s" % name):  # Avoid project modification indicator in the Godot window title (*) everytime project loads
		return true
	else:
		return false
