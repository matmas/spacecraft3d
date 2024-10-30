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


static func transfer_basis_by_fraction(source: Node3D, target: PhysicsDirectBodyState3D, fraction: float) -> void:
	var basis_delta := Basis.IDENTITY.slerp(source.transform.basis.orthonormalized(), fraction)
	target.transform.basis *= basis_delta
	source.transform.basis *= basis_delta.inverse()


static func transfer_basis_to_euler_xz_by_fraction(source: PhysicsDirectBodyState3D, target_x: Node3D, target_z: Node3D, target_basis: Basis, fraction: float) -> void:
	var euler := (target_basis.inverse() * source.transform.basis).get_euler()
	var basis_delta_x := Basis.IDENTITY.slerp(Basis.from_euler(Vector3(euler.x, 0, 0)), fraction)
	var basis_delta_z := Basis.IDENTITY.slerp(Basis.from_euler(Vector3(0, 0, euler.z)), fraction)
	target_x.transform.basis *= basis_delta_x
	target_z.transform.basis *= basis_delta_z
	source.transform.basis *= basis_delta_x.inverse() * basis_delta_z.inverse()


static func reset_basis_by_fraction(node: Node3D, fraction: float) -> void:
	node.basis = node.basis.orthonormalized().slerp(Basis.IDENTITY, fraction).orthonormalized()
