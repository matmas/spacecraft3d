extends Node

var _scene_stack := []
var _original_shortcuts := {}


func open_scene(scene: PackedScene) -> Node:
	current_scene().hide()
	# Shortcuts are handled even when the buttons are not visible
	# so we clear them now and restore later
	_clear_shortcuts_recursively(current_scene())

	var scene_instance := scene.instantiate()
	_scene_stack.push_front(scene_instance)

	get_tree().root.add_child(scene_instance)
	scene_instance.refresh()
	scene_instance.tree_exiting.connect(func(): _on_tree_exiting(scene_instance))
	return scene_instance


func current_scene() -> Node:
	return _scene_stack.front()


func previous_scene() -> Node:
	if _scene_stack.size() < 2:
		return null
	return _scene_stack[1]


func close_current_scene(num_scenes_to_close: int = 1) -> void:
	for i in num_scenes_to_close:
		if previous_scene() != null:
			var scene := current_scene()
			scene.get_parent().remove_child(scene)
			scene.queue_free()
		else:
			get_tree().quit()


func _ready() -> void:
	if _scene_stack.is_empty():
		_scene_stack.push_front(get_tree().current_scene)
		get_tree().quit_on_go_back = false
		get_tree().root.go_back_requested.connect(_on_go_back_requested)


func _on_tree_exiting(scene_instance: Node) -> void:
	if current_scene() != scene_instance:
		printerr("current_scene() != scene_instance")
	_scene_stack.pop_front()
	current_scene().show()
	current_scene().refresh()
	_restore_shortcuts_recursively(current_scene())


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
	current_scene().on_go_back_requested()
