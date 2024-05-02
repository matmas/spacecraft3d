@tool
extends Node


func _ready() -> void:
	for shape_class in _get_shape_classes():
		shape_class.register_settings()

	if Engine.is_editor_hint():
		return

	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)


func _on_node_added(node: Node) -> void:
	if node is RigidBody3D:
		for shape_class in _get_shape_classes():
			if shape_class.is_enabled():
				node.add_child(shape_class.new())


func _on_node_removed(node: Node) -> void:
	if node is RigidBody3D:
		for child in node.get_children():
			if child is BaseDebugShape:
				node.remove_child(child)
				child.queue_free()


func _get_shape_classes() -> Array[Script]:
	var result: Array[Script] = []

	for class_info in ProjectSettings.get_global_class_list():
		if class_info.base == &"BaseDebugShape":
			result.append(load(class_info.path))

	return result
