@tool
extends InputActionTextureRect


func _ready() -> void:
	_input_type_changed(InputMonitor.current_input_type)
	InputMonitor.input_type_changed.connect(_input_type_changed)


func _input_type_changed(input_type) -> void:
	visible = input_type == InputMonitor.InputType.KEYBOARD_AND_MOUSE