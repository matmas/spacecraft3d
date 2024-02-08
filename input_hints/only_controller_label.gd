extends Label


func _ready() -> void:
	_input_type_changed(ControllerIcons._last_input_type)
	ControllerIcons.input_type_changed.connect(_input_type_changed)


func _input_type_changed(input_type) -> void:
	visible = input_type == ControllerIcons.InputType.CONTROLLER
