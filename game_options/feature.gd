extends Node
class_name Feature

@export var section := ""
@export var key := ""


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	_update()
	GameOptions.get_option(section, key).value_changed.connect(func(_value): _update())


func _update() -> void:
	var parent := get_parent()
	parent.visible = GameOptions.get_option(section, key).get_value()
	parent.set_process(parent.visible)
	parent.set_physics_process(parent.visible)
