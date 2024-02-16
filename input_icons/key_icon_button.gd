@tool
extends Button
class_name InputActionButton

@export var action_name: StringName = "":
	set(value):
		action_name = value
		input_action_rect.action_name = value

@export var show_mode := InputActionTextureRect.ShowMode.ANY:
	set(value):
		show_mode = value
		input_action_rect.show_mode = value

@export var force_mode := InputActionTextureRect.ForceMode.DISABLED:
	set(value):
		force_mode = value
		input_action_rect.force_mode = value

@export var icon_size := Vector2(50, 50):
	set(value):
		icon_size = value
		viewport.size = value
		input_action_rect.size = value

var input_action_rect := InputActionTextureRect.new()
var viewport := SubViewport.new()

func _init() -> void:
	viewport.size = icon_size
	viewport.disable_3d = true
	viewport.gui_disable_input = true
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_PARENT_VISIBLE
	input_action_rect.size = icon_size
	viewport.add_child(input_action_rect)
	icon = viewport.get_texture()
	add_child(viewport)


func _validate_property(property: Dictionary) -> void:
	if property.name == "icon":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE
