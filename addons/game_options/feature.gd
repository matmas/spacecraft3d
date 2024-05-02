extends Node
class_name Feature

@export var section := ""
@export var key := ""
@onready var _GameOptions := get_node_or_null("/root/GameOptions")


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	if _GameOptions:
		_GameOptions.get_bool_option(section, key).value_changed.connect(func(): _update())
		_update()


func _update() -> void:
	var parent := get_parent()
	var option = _GameOptions.get_bool_option(section, key)
	parent.visible = option.get_value()
	parent.set_process(parent.visible)
	parent.set_physics_process(parent.visible)
	parent.set_process_input(parent.visible)
	parent.set_process_shortcut_input(parent.visible)
	parent.set_process_unhandled_input(parent.visible)
	parent.set_process_unhandled_key_input(parent.visible)
