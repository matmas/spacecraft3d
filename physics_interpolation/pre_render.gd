extends Node
class_name PhysicsInterpolationPreRender


func _ready() -> void:
	process_priority = 1000


func _physics_process(_delta: float) -> void:
	for node: Node3D in PhysicsInterpolationAutoload.interpolated_node_set:
		PhysicsInterpolationAutoload.previous_global_transforms[node] = PhysicsInterpolationAutoload.current_global_transforms[node]
		PhysicsInterpolationAutoload.current_global_transforms[node] = node.get_parent().global_transform


func _process(_delta: float) -> void:
	for node: Node3D in PhysicsInterpolationAutoload.interpolated_node_set:
		PhysicsInterpolationAutoload.original_node_transforms[node] = node.transform

		if PhysicsInterpolationAutoload.enabled:
			var f := Engine.get_physics_interpolation_fraction()
			node.global_transform = PhysicsInterpolationAutoload.previous_global_transforms[node].interpolate_with(PhysicsInterpolationAutoload.current_global_transforms[node], f) * PhysicsInterpolationAutoload.original_node_transforms[node]
		else:
			node.global_transform = node.get_parent().global_transform * PhysicsInterpolationAutoload.original_node_transforms[node]
		node.top_level = true
