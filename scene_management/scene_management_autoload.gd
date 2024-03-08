extends Node

var _scene_stack := []
var _original_shortcuts := {}


func _ready() -> void:
	if _scene_stack.is_empty():
		_scene_stack.push_front(get_tree().current_scene)
		get_tree().quit_on_go_back = false
		get_tree().root.go_back_requested.connect(_on_go_back_requested)


func open_scene(scene: PackedScene) -> Node:
	_scene_stack.front().hide()
	# Shortcuts are handled even when the buttons are not visible
	# so we clear them now and restore later
	_clear_shortcuts_recursively(_scene_stack.front())

	var scene_instance := scene.instantiate()
	_scene_stack.push_front(scene_instance)
	get_tree().root.add_child(scene_instance)

	scene_instance.tree_exiting.connect(_on_tree_exiting)
	return scene_instance


func _on_tree_exiting() -> void:
	_scene_stack.pop_front()
	_scene_stack.front().show()
	_restore_shortcuts_recursively(_scene_stack.front())


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
			_original_shortcuts.erase(button)
		_restore_shortcuts_recursively(child)


func _on_go_back_requested() -> void:
	if _scene_stack.size() == 1:
		get_tree().quit()
		return
	if _scene_stack.front().has_method("_on_go_back_requested"):
		_scene_stack.front()._on_go_back_requested()
	else:
		_scene_stack.front().queue_free()
