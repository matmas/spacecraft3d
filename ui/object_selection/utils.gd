extends Node
class_name ObjectSelectionUtils


static func get_rigid_body_ancestor(node: Node) -> RigidBody3D:
	var parent := node.get_parent()
	while parent:
		if parent is RigidBody3D:
			return parent as RigidBody3D
		parent = parent.get_parent()
	return null


static func fix_physics_interpolation(node: Node3D) -> void:
	var camera := node.get_viewport().get_camera_3d()
	var camera_body := get_rigid_body_ancestor(camera)
	if camera_body:
		node.global_position -= camera_body.linear_velocity * node.get_physics_process_delta_time()
		node.get_global_transform_interpolated()
		node.reset_physics_interpolation()
		node.global_position += camera_body.linear_velocity * node.get_physics_process_delta_time()
