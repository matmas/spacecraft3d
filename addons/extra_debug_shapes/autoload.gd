@tool
extends Node


func _ready() -> void:
	if not Engine.is_editor_hint():
		for shape_class in ExtraDebugShapesUtils.get_shape_classes():
			shape_class.register_settings()

		get_tree().node_added.connect(_on_node_added)
		get_tree().node_removed.connect(_on_node_removed)


func _on_node_added(node: Node) -> void:
	if node is RigidBody3D:
		for shape_class in ExtraDebugShapesUtils.get_shape_classes():
			if shape_class.is_enabled():
				node.add_child(shape_class.new())


func _on_node_removed(node: Node) -> void:
	if node is RigidBody3D:
		for child in node.get_children():
			if child is BaseShape:
				node.remove_child(child)
				child.queue_free()
