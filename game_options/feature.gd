extends Node
class_name Feature

@export var section := ""
@export var key := ""


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	var parent := get_parent()
	parent.visible = GameOptions.get_option(section, key).get_value()
	parent.set_process(parent.visible)
	parent.set_physics_process(parent.visible)
