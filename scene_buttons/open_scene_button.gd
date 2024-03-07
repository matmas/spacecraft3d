extends Button
class_name OpenSceneButton

@export var scene: PackedScene

signal scene_opened(scene_instance)

static var _scene_stack := []
var _original_shortcuts := {}


func _ready() -> void:
	if _scene_stack.is_empty():
		_scene_stack.push_front(owner)
		get_tree().quit_on_go_back = false
		get_tree().root.go_back_requested.connect(_on_go_back_requested)
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	_scene_stack.front().hide()
	# Shortcuts are handled even when the buttons are not visible
	# so we clear them now and restore later
	_clear_shortcuts_recursively(_scene_stack.front())

	var scene_instance := scene.instantiate()
	_scene_stack.push_front(scene_instance)
	get_tree().root.add_child(scene_instance)
	scene_opened.emit(scene_instance)

	scene_instance.tree_exiting.connect(_on_tree_exiting)


func _on_tree_exiting() -> void:
	_scene_stack.pop_front()

	_scene_stack.front().show()
	_restore_shortcuts_recursively(_scene_stack.front())
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


func _on_go_back_requested() -> void:
	if _scene_stack.size() == 1:
		get_tree().quit()
		return
	_scene_stack.front().queue_free()
