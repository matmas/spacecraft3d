extends Node
class_name BuildingMechanicsUtils


static func calculate_spatial_bounds(node: Node3D, include_top_level_transform: bool = false) -> AABB:
	# Similar to Node3DEditorViewport::_calculate_spatial_bounds from Godot Engine
	var bounds: AABB

	var visual_instance := node as VisualInstance3D
	if visual_instance:
		bounds = visual_instance.get_aabb()

	for child in node.get_children():
		if child is Node3D:
			var child_bounds := calculate_spatial_bounds(child, not child.top_level)

			if bounds.size == Vector3() and node:
				bounds = child_bounds
			else:
				bounds = bounds.merge(child_bounds)

	if not bounds.size and not node:
		bounds = AABB(Vector3(-0.2, -0.2, -0.2), Vector3(0.4, 0.4, 0.4));

	if include_top_level_transform:
		bounds = node.transform * bounds

	return bounds


static func get_colliders_of_physics_body(body: PhysicsBody3D, collision_mask: int, margin: float = 0.0, offset: Vector3 = Vector3.ZERO, max_results: int = 32) -> Array[CollisionObject3D]:
	var colliders: Array[CollisionObject3D] = []
	var exclude: Array[RID] = [body.get_rid()]
	for i in max_results:
		var collider := _get_collider_of_physics_body(body, collision_mask, margin, offset, exclude)
		if collider:
			colliders.append(collider)
			exclude.append(collider.get_rid())
		else:
			break
	return colliders


static func _get_collider_of_physics_body(body: PhysicsBody3D, collision_mask: int, margin: float = 0.0, offset: Vector3 = Vector3.ZERO, exclude: Array[RID] = []) -> CollisionObject3D:
	for child in body.get_children():
		if child is CollisionShape3D:
			var collider := _get_collider_of_collision_shape(child as CollisionShape3D, collision_mask, margin, offset, exclude)
			if collider:
				return collider
	return null


static func _get_collider_of_collision_shape(collision_shape: CollisionShape3D, collision_mask: int, margin: float = 0.0, offset: Vector3 = Vector3.ZERO, exclude: Array[RID] = []) -> CollisionObject3D:
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = collision_shape.shape
	params.transform = collision_shape.global_transform.translated(offset)
	params.margin = margin
	params.collision_mask = collision_mask
	params.exclude = exclude
	var result := BuildingMechanics.get_viewport().get_camera_3d().get_world_3d().direct_space_state.intersect_shape(params, 1)
	if result.size() != 0:
		if result[0].collider is CollisionObject3D:
			return result[0].collider
		else:
			printerr("intersect_shape collider is not CollisionObject3D")
	return null


static func is_physics_body_colliding(body: PhysicsBody3D, collision_mask: int, margin: float = 0.0, offset: Vector3 = Vector3.ZERO) -> bool:
	for child in body.get_children():
		if child is CollisionShape3D:
			if _is_collision_shape_colliding(child as CollisionShape3D, collision_mask, margin, offset, [body.get_rid()]):
				return true
	return false


static func _is_collision_shape_colliding(collision_shape: CollisionShape3D, collision_mask: int, margin: float = 0.0, offset: Vector3 = Vector3.ZERO, exclude: Array[RID] = []) -> bool:
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = collision_shape.shape
	params.transform = collision_shape.global_transform.translated(offset)
	params.margin = margin
	params.collision_mask = collision_mask
	params.exclude = exclude
	var contact_points := BuildingMechanics.get_viewport().get_camera_3d().get_world_3d().direct_space_state.collide_shape(params, 1)
	return contact_points.size() != 0


static func axis_aligned_basis(basis_: Basis) -> Basis:
	var x := _axis_aligned_unit_vector(basis_.x)
	var y := _axis_aligned_unit_vector(basis_.y)
	var z := _axis_aligned_unit_vector(basis_.z)

	if x.abs() != y.abs():
		z = x.cross(y)
	elif x.abs() != z.abs():
		y = z.cross(x)
	else:
		x = y.cross(z)

	return Basis(x, y, z)


static func _axis_aligned_unit_vector(v: Vector3) -> Vector3:
	var x := absf(v.x)
	var y := absf(v.y)
	var z := absf(v.z)
	if x > y and x > z:
		return Vector3.RIGHT if v.x > 0 else Vector3.LEFT
	elif y > x and y > z:
		return Vector3.UP if v.y > 0 else Vector3.DOWN
	else:
		return Vector3.BACK if v.z > 0 else Vector3.FORWARD


static func override_children_material_recursively(node: Node, material: Material) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			(child as MeshInstance3D).material_override = material
		override_children_material_recursively(child, material)


## Calculates Basis from y and z vectors.
## If y and z are parallel then alternative_z is used instead of z.
static func basis_from_y_z(y: Vector3, z: Vector3, alternative_z: Vector3) -> Basis:
	var b := Basis(
		y.cross(z),
		y,
		z,
	).orthonormalized()
	if not b.is_conformal():
		b = Basis(
			y.cross(alternative_z),
			y,
			alternative_z,
		).orthonormalized()
	return b


static func max_vector3(a: Vector3, b: Vector3) -> Vector3:  # TODO: Use Vector3.max() in Godot 4.3
	return Vector3(maxf(a.x, b.x), maxf(a.y, b.y), maxf(a.z, b.z))
