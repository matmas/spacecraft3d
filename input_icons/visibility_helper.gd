extends Node
class_name InputTypeVisibilityHelper

@export var parent_visibility_mode := InputActionTextureRect.VisibilityMode.ANY_USAGE:
	set(value):
		parent_visibility_mode = value
		_update_visibility()


func _init() -> void:
	InputMonitor.input_type_changed.connect(func(_input_type): _update_visibility())


func _ready() -> void:
	_update_visibility()


func _update_visibility() -> void:
	var parent := get_parent()
	if parent is CanvasItem:
		var should_be_visible := (
			parent_visibility_mode == InputActionTextureRect.VisibilityMode.USING_KEYBOARD_AND_MOUSE
				and InputMonitor.current_input_type == InputMonitor.InputType.KEYBOARD_AND_MOUSE
			or parent_visibility_mode == InputActionTextureRect.VisibilityMode.USING_JOYPAD
				and InputMonitor.current_input_type == InputMonitor.InputType.JOYPAD
			or parent_visibility_mode == InputActionTextureRect.VisibilityMode.ANY_USAGE
		)
		(parent as CanvasItem).visible = should_be_visible
