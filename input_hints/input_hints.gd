extends Control
class_name InputHints

static var _actions_used := {}

func _ready() -> void:
	process_priority = 1  # run after scripts using input functions

	# Running scene alone for debugging purposes?
	if get_parent() == get_tree().root:
		set_process(false)
		set_physics_process(false)


static func is_action_pressed(action: StringName, exact_match: bool = false) -> bool:
	_actions_used[action] = true
	return Input.is_action_pressed(action, exact_match)


static func is_action_just_pressed(action: StringName, exact_match: bool = false) -> bool:
	_actions_used[action] = true
	return Input.is_action_just_pressed(action, exact_match)


static func is_action_just_released(action: StringName, exact_match: bool = false) -> bool:
	_actions_used[action] = true
	return Input.is_action_just_released(action, exact_match)


static func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	_actions_used[negative_action] = true
	_actions_used[positive_action] = true
	return Input.get_axis(negative_action, positive_action)


static func get_vector(negative_x: StringName, positive_x: StringName, negative_y: StringName, positive_y: StringName, deadzone: float = -1.0) -> Vector2:
	_actions_used[negative_x] = true
	_actions_used[positive_x] = true
	_actions_used[negative_y] = true
	_actions_used[positive_y] = true
	return Input.get_vector(negative_x, positive_x, negative_y, positive_y, deadzone)


func _physics_process(_delta: float) -> void:
	for action in InputMap.get_actions():
		if not _actions_used.has(action):
			_actions_used[action] = false

	_update_children_recursivaly(self)
	_actions_used.clear()


func _update_children_recursivaly(node: Node):
	if _actions_used.has(node.name):
		if node is BoxContainer:
			node.visible = _actions_used[node.name]
	for child in node.get_children():
		_update_children_recursivaly(child)