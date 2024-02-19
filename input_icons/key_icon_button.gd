@tool
extends Button
class_name InputActionButton

var input_action_rect := InputActionTextureRect.new()
var viewport := SubViewport.new()

@export var action_name: StringName = "":
	set(value):
		action_name = value
		input_action_rect.action_name = value

## Convert physical keycodes (US QWERTY) to ones in the active keyboard layout, e.g. AZERTY if supported by DisplayServer
@export var convert_physical_keycodes := false:
	set(value):
		convert_physical_keycodes = value
		input_action_rect.convert_physical_keycodes = value

@export var input_type_mode := InputActionTextureRect.InputTypeMode.ADAPTIVE:
	set(value):
		input_type_mode = value
		input_action_rect.input_type_mode = value

@export var ignore_joypad_direction := false:
	set(value):
		ignore_joypad_direction = value
		input_action_rect.ignore_joypad_direction = value

@export var visibility_mode := InputActionTextureRect.VisibilityMode.ANY_USAGE:
	set(value):
		visibility_mode = value
		input_action_rect.visibility_mode = value

@export var icon_size := Vector2(50, 50):
	set(value):
		icon_size = value
		viewport.size = value
		input_action_rect.size = value


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
