extends Button

@export var scene: PackedScene

var _original_shortcuts := {}


func _on_pressed():
	var scene_instance := scene.instantiate()
	get_window().add_child(scene_instance)
	owner.hide()
	# Shortcuts are handled even when the buttons are not visible
	# so we clear them now and restore later
	_clear_shortcuts_recursively(owner)
	scene_instance.tree_exited.connect(_on_scene_closed)


func _on_scene_closed() -> void:
	owner.show()
	_restore_shortcuts_recursively(owner)
	if is_inside_tree():
		grab_focus()


func _clear_shortcuts_recursively(node: Node) -> void:
	for child in node.get_children():
		if child is BaseButton:
			var button := child as BaseButton
			_original_shortcuts[child] = button.shortcut
			button.shortcut = null
		_clear_shortcuts_recursively(child)


func _restore_shortcuts_recursively(node: Node) -> void:
	for child in node.get_children():
		if child is BaseButton:
			var button := child as BaseButton
			button.shortcut = _original_shortcuts[button]
		_restore_shortcuts_recursively(child)
