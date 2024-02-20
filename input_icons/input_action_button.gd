@tool
extends Button
class_name InputActionButton

var input_action_rect := InputActionTextureRect.new()
var viewport := SubViewport.new()

@export var action_name: StringName = &"":
	set(value):
		action_name = value
		input_action_rect.action_name = value
		_update_viewport_size()

## Convert physical keycodes (US QWERTY) to ones in the active keyboard layout, e.g. AZERTY if supported by DisplayServer
@export var convert_physical_keycodes := false:
	set(value):
		convert_physical_keycodes = value
		input_action_rect.convert_physical_keycodes = value

@export var input_type_mode := InputActionTextureRect.InputTypeMode.ADAPTIVE:
	set(value):
		input_type_mode = value
		input_action_rect.input_type_mode = value
		_update_viewport_size()

@export var ignore_joypad_direction := false:
	set(value):
		ignore_joypad_direction = value
		input_action_rect.ignore_joypad_direction = value

@export var icon_visibility_mode := InputActionTextureRect.VisibilityMode.ANY_USAGE:
	set(value):
		icon_visibility_mode = value
		input_action_rect.visibility_mode = value
		_update_viewport_size()

@export var icon_size := Vector2(50, 50):
	set(value):
		icon_size = value
		_update_viewport_size()

@export var viewport_scaling := true:
	set(value):
		viewport_scaling = value
		_update_viewport_size()


func _init() -> void:
	input_action_rect.minimum_size = icon_size
	_update_viewport_size()
	viewport.disable_3d = true
	viewport.gui_disable_input = true
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_PARENT_VISIBLE
	viewport.add_child(input_action_rect)
	icon = viewport.get_texture()
	add_child(viewport)
	InputMonitor.input_type_changed.connect(func(_input_type): _update_viewport_size())
	InputMonitor.input_map_changed.connect(func(): _update_viewport_size())


func _validate_property(property: Dictionary) -> void:
	if property.name == "icon":
		# Don't persist or show property in the editor
		property.usage = PROPERTY_USAGE_NONE


func _update_viewport_size() -> void:
	var _scale := 1.0
	if viewport_scaling and get_window():
		_scale = get_window().content_scale_factor

	input_action_rect.minimum_size = icon_size
	input_action_rect.scale = Vector2.ONE * _scale
	viewport.size = input_action_rect.custom_minimum_size * _scale

	if not Engine.is_editor_hint():  # Don't change scene file when running as @tool
		# Make sure the icon stays the same size regardless of the window scaling factor
		add_theme_constant_override("icon_max_width", int(icon_size.x))
