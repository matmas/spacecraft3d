extends Button

@export var scene: PackedScene

var _saved_shortcuts := {}

func _on_pressed():
	var scene_instance := scene.instantiate()
	get_window().add_child(scene_instance)
	owner.hide()
	_clear_shortcuts_recursively(owner)
	scene_instance.tree_exited.connect(_on_scene_closed)


func _on_scene_closed() -> void:
	owner.show()
	_restore_shortcuts_recursively(owner)
	grab_focus()


func _clear_shortcuts_recursively(node: Node) -> void:
	for child in node.get_children():
		if child is BaseButton:
			var button := child as BaseButton
			_saved_shortcuts[child] = button.shortcut
			button.shortcut = null
		_clear_shortcuts_recursively(child)


func _restore_shortcuts_recursively(node: Node) -> void:
	for child in node.get_children():
		if child is BaseButton:
			var button := child as BaseButton
			button.shortcut = _saved_shortcuts[button]
		_restore_shortcuts_recursively(child)
