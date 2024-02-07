extends Node
class_name InputHints

static var actions_used := {}

func _ready() -> void:
	process_priority = 1  # run after scripts using input functions

static func is_action_pressed(action: StringName, exact_match: bool = false) -> bool:
	actions_used[action] = true
	return Input.is_action_pressed(action, exact_match)


static func is_action_just_pressed(action: StringName, exact_match: bool = false) -> bool:
	actions_used[action] = true
	return Input.is_action_just_pressed(action, exact_match)


static func is_action_just_released(action: StringName, exact_match: bool = false) -> bool:
	actions_used[action] = true
	return Input.is_action_just_released(action, exact_match)


static func get_axis(negative_action: StringName, positive_action: StringName) -> float:
	actions_used[negative_action] = true
	actions_used[positive_action] = true
	return Input.get_axis(negative_action, positive_action)


static func get_vector(negative_x: StringName, positive_x: StringName, negative_y: StringName, positive_y: StringName, deadzone: float = -1.0) -> Vector2:
	actions_used[negative_x] = true
	actions_used[positive_x] = true
	actions_used[negative_y] = true
	actions_used[positive_y] = true
	return Input.get_vector(negative_x, positive_x, negative_y, positive_y, deadzone)


func _physics_process(_delta: float) -> void:
	for action in InputMap.get_actions():
		if not actions_used.has(action):
			actions_used[action] = false

	_update_children_recursivaly(self)
	actions_used.clear()


func _update_children_recursivaly(node: Node):
	if actions_used.has(node.name):
		if node is BoxContainer:
			node.visible = actions_used[node.name]
	for child in node.get_children():
		_update_children_recursivaly(child)
