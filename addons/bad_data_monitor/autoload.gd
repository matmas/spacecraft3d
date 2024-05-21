extends Node

var _timer := Timer.new()


func _ready() -> void:
	add_child(_timer)
	_timer.timeout.connect(_on_timer_timeout)
	_timer.start(1.0)


func _on_timer_timeout():
	_check_node_recursively(get_tree().root)


func _check_node_recursively(node: Node) -> void:
	if not is_instance_valid(node):
		return

	if node is Node3D:
		if not node.transform.is_finite():
			printerr("!v.is_finite(): ", node, " ", node.transform)
			_timer.stop()  # Showing data once should be enough for most use cases

	for child in node.get_children():
		_check_node_recursively(child)
