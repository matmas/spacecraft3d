extends Node
class_name PlayerControllerUtils


static func clamp_vector_length(vector: Vector3, max_length: float = 1.0) -> Vector3:
	if vector.length() > max_length:
		return vector.normalized() * max_length
	return vector


static func get_velocity(node: Node3D) -> Vector3:
	if node is RigidBody3D:
		return (node as RigidBody3D).linear_velocity
	return Vector3.ZERO
