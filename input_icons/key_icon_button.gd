@tool
extends Button
class_name KeyIconButton

@export var icon_size := Vector2(100, 100):
	set(value):
		icon_size = value
		viewport.size = value
		input_action_rect.size = value

@export_multiline var icon_text := "A":
	set(value):
		icon_text = value
		input_action_rect.text = value

var input_action_rect := KeyIconRect.new()
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
