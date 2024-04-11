extends Node

var enabled := true

var _physics_node_set := {}
var interpolated_node_set := {}
var original_node_transforms := {}
var previous_global_transforms := {}
var current_global_transforms := {}


func _ready() -> void:
	Engine.set_physics_jitter_fix(0.0)
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)
	add_child(PhysicsInterpolationPostRender.new())
	add_child(PhysicsInterpolationPreRender.new())


func _on_node_added(node: Node) -> void:
	if node is RigidBody3D:
		_physics_node_set[node] = true

	elif node is VisualInstance3D or node is Camera3D:
		for physics_body: Node3D in _physics_node_set:
			if physics_body.is_ancestor_of(node):

				for existing_node: Node3D in interpolated_node_set:
					if existing_node.is_ancestor_of(node):
						return
				_register_node(node)


func _on_node_removed(node: Node) -> void:
	if node is RigidBody3D:
		if node in _physics_node_set:
			_physics_node_set.erase(node)

	elif node is VisualInstance3D:
		if node in interpolated_node_set:
			_unregister_node(node)


func _register_node(node: Node3D) -> void:
	interpolated_node_set[node] = true
	_reset_node(node)
	node.get_parent().visibility_changed.connect(func(): _reset_node(node))


func _reset_node(node: Node3D) -> void:
	previous_global_transforms[node] = node.global_transform
	current_global_transforms[node] = node.global_transform


func _unregister_node(node: Node3D) -> void:
	interpolated_node_set.erase(node)
	previous_global_transforms.erase(node)
	current_global_transforms.erase(node)
