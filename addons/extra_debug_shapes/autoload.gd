@tool
extends Node


func _ready() -> void:
	if not Engine.is_editor_hint():
		VisibleCenterOfMass.register_settings()
		VisibleBasis.register_settings()

		get_tree().node_added.connect(_on_node_added)
		get_tree().node_removed.connect(_on_node_removed)


func _on_node_added(node: Node) -> void:
	if node is RigidBody3D:
		if VisibleCenterOfMass.is_enabled():
			node.add_child(VisibleCenterOfMass.new())
		if VisibleBasis.is_enabled():
			node.add_child(VisibleBasis.new())


func _on_node_removed(node: Node) -> void:
	if node is RigidBody3D:
		for child in node.get_children():
			if child is VisibleCenterOfMass or child is VisibleBasis:
				node.remove_child(child)
				child.queue_free()
