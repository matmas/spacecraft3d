extends Node3D
class_name BuildTool

@export_flags_3d_physics var collision_mask := 0b00000000_00000000_00000010_00000000

var _raycast := RayCast3D.new()
var _ghost_block: Block
var _ghost_material := preload("ghost_shader_material.tres")
var _remove_block_material := preload("ghost_shader_material.tres").duplicate() as ShaderMaterial
var _ghost_basis := Basis.IDENTITY
var _block_under_raycast: Block
signal _block_under_raycast_changed
var _block_to_remove: Block


func _ready() -> void:
	_raycast.collision_mask = collision_mask
	_raycast.target_position = Vector3.FORWARD * 10.0
	var camera_parent := get_viewport().get_camera_3d().get_parent().get_parent()  # Need physics uninterpolated position
	camera_parent.add_child(_raycast)
	_on_block_selection_changed()
	BlockLibrary.selection_changed.connect(_on_block_selection_changed)


func _on_block_selection_changed() -> void:
	if _ghost_block:
		remove_child(_ghost_block)
		_ghost_block.queue_free()
		_ghost_block = null

	var selected_block := BlockLibrary.selected_block
	if selected_block:
		_ghost_block = selected_block.instantiate() as Block
		_ghost_block.collision_layer = 0
		_ghost_block.collision_mask = 0
		_override_children_material_recursively(_ghost_block, _ghost_material)
		_ghost_block.hide()  # correct position is set later in _process()
		add_child(_ghost_block)
		PhysicsInterpolation.apply(_ghost_block)


func _physics_process(_delta: float) -> void:
	if not _ghost_block:
		return

	if InputHints.is_action_just_pressed(&"rotate_x+"):
		_ghost_basis = _ghost_basis.rotated(Vector3.RIGHT, TAU * 0.25)
	if InputHints.is_action_just_pressed(&"rotate_x-"):
		_ghost_basis = _ghost_basis.rotated(Vector3.RIGHT, TAU * -0.25)
	if InputHints.is_action_just_pressed(&"rotate_y+"):
		_ghost_basis = _ghost_basis.rotated(Vector3.UP, TAU * 0.25)
	if InputHints.is_action_just_pressed(&"rotate_y-"):
		_ghost_basis = _ghost_basis.rotated(Vector3.UP, TAU * -0.25)
	if InputHints.is_action_just_pressed(&"rotate_z+"):
		_ghost_basis = _ghost_basis.rotated(Vector3.FORWARD, TAU * 0.25)
	if InputHints.is_action_just_pressed(&"rotate_z-"):
		_ghost_basis = _ghost_basis.rotated(Vector3.FORWARD, TAU * -0.25)

	var camera_parent := get_viewport().get_camera_3d().get_parent().get_parent() as Node3D  # Need physics uninterpolated position

	var collider := _raycast.get_collider()
	if _raycast.is_colliding():
		var point := _raycast.get_collision_point()
		var normal := _raycast.get_collision_normal()
		if collider is Block:
			var block := collider as Block
			_ghost_block.global_basis = _grid_aligned_basis(global_basis * _ghost_basis, block.global_basis)
			_ghost_block.global_position = block.global_transform * _calculate_local_offset(block, _ghost_block, point, normal)
		else:
			_ghost_block.global_basis = _basis_from_y_z(normal, global_basis.z, global_basis.y) * _ghost_basis
			var ghost_aabb := Transform3D(_ghost_basis) * Utils.calculate_spatial_bounds(_ghost_block)
			_ghost_block.global_position = point + normal * ((ghost_aabb.size * 0.5 - ghost_aabb.get_center()).y + 0.001)
	else:
		_ghost_block.global_basis = global_basis * _ghost_basis
		_ghost_block.global_position = camera_parent.global_position - camera_parent.global_basis.z * 3.0

	if not _ghost_block.visible:
		_ghost_block.show()

	if Utils.is_physics_body_colliding(_ghost_block, collision_mask, -0.02):
		_ghost_material.set_shader_parameter(&"color", Color.RED)
	else:
		_ghost_material.set_shader_parameter(&"color", Color.GREEN)
		_allow_block_placement(collider)

	_allow_block_removal()


func _allow_block_placement(collider: Object) -> void:
	if SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block"):
		var spawned_block := BlockLibrary.selected_block.instantiate() as Block
		spawned_block.name = _ghost_block.name

		var grid: Grid
		if collider is Block:
			grid = (collider as Block).grid
			spawned_block.transform = grid.global_transform.inverse() * _ghost_block.global_transform  # Precalculate local transform as an alternative to setting global_transform on spawned_block after grid.add_child
			grid.add_child(spawned_block)
		else:
			grid = Grid.new()
			add_child(grid)
			grid.global_transform = _ghost_block.global_transform
			PhysicsInterpolation.apply(grid)  # Useful for 3d_object_selection
			grid.add_child(spawned_block)
			if collider is RigidBody3D:
				grid.linear_velocity = (collider as RigidBody3D).linear_velocity
			else:
				grid.linear_velocity = (get_parent() as Player).linear_velocity
			grid.child_exiting_tree.connect(func(_node): if grid.get_child_count() == 2: grid.queue_free())  # node being removed and PhysicsInterpolation

		_add_grid_collision_shapes(spawned_block, grid)

		PhysicsInterpolation.apply(spawned_block)


func _add_grid_collision_shapes(block: Block, grid: Grid) -> void:
	for child in block.get_children():
		if child is CollisionShape3D:
			var collision_shape := child as CollisionShape3D
			var grid_collision_shape := collision_shape.duplicate() as CollisionShape3D
			grid.add_child(grid_collision_shape)
			grid_collision_shape.global_transform = collision_shape.global_transform
			block.tree_exiting.connect(func(): grid_collision_shape.queue_free())


func _allow_block_removal() -> void:
	var collider := _raycast.get_collider()
	if collider is Block:
		var block := collider as Block
		if _block_under_raycast != block:
			_block_under_raycast = block
			_block_under_raycast_changed.emit()
	else:
		if _block_under_raycast:
			_block_under_raycast = null
			_block_under_raycast_changed.emit()

	if _block_under_raycast:
		if SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"remove_block"):
			_block_to_remove = _block_under_raycast
			_override_children_material_recursively(_block_to_remove, _remove_block_material)

			if not _block_under_raycast_changed.is_connected(_update_block_to_remove_material):
				_remove_block_material.set_shader_parameter(&"color", Color.RED)
				_block_under_raycast_changed.connect(_update_block_to_remove_material)

		if SceneManagement.current_scene() is Game and InputHints.is_action_just_released(&"remove_block"):
			if _block_to_remove == _block_under_raycast:
				_block_to_remove.queue_free()
			_block_to_remove = null


func _update_block_to_remove_material() -> void:
	if _block_to_remove:
		_override_children_material_recursively(_block_to_remove, _remove_block_material if _block_under_raycast == _block_to_remove else null)


func _max(a: Vector3, b: Vector3) -> Vector3:  # TODO: Change to Vector3.max() in Godot 4.3
	return Vector3(maxf(a.x, b.x), maxf(a.y, b.y), maxf(a.z, b.z))


func _min(a: Vector3, b: Vector3) -> Vector3:  # TODO: Change to Vector3.max() in Godot 4.3
	return Vector3(minf(a.x, b.x), minf(a.y, b.y), minf(a.z, b.z))


func _calculate_local_offset(block: Block, ghost_block: Block, point: Vector3, normal: Vector3) -> Vector3:
	var block_aabb := Utils.calculate_spatial_bounds(block)
	var ghost_aabb := Transform3D(block.global_basis.inverse() * ghost_block.global_basis) * Utils.calculate_spatial_bounds(ghost_block)
	var local_point := block.global_transform.inverse() * point
	var local_point_normalized := (local_point - block_aabb.get_center()) / (block_aabb.size * 0.5)  # Each component is in the range -1.0..1.0
	var local_normal := block.global_basis.inverse() * normal
	var block_span := (block_aabb.size / block.grid.cell_size).snapped(Vector3.ONE)
	var ghost_span := (ghost_aabb.size / block.grid.cell_size).snapped(Vector3.ONE)
	var span_oddness_by_axis := (ghost_span - block_span).abs().posmod(2)  # Each component is 0 or 1
	var span_oddness := span_oddness_by_axis * local_point.sign() * block.grid.cell_size * 0.5
	var span_oddness_correction := span_oddness - span_oddness * local_normal.abs()  # Set axis aligned with local_normal to zero
	var freedom_by_axis := _max(block_span, ghost_span) - _min(block_span, ghost_span)
	var freedom := ((freedom_by_axis - span_oddness_by_axis) * 0.25 * local_point_normalized).snapped(block.grid.cell_size)
	var freedom_correction := freedom - freedom * local_normal.abs()  # Set axis aligned with local_normal to zero
	var local_offset := local_normal * (
		block_aabb.size * 0.5 + block_aabb.get_center() * local_normal +
		ghost_aabb.size * 0.5 + ghost_aabb.get_center() * -local_normal
	) + freedom_correction + span_oddness_correction
	return local_offset


func _grid_aligned_basis(basis_: Basis, grid_basis: Basis) -> Basis:
	return grid_basis * _axis_aligned_basis(grid_basis.inverse() * basis_)


func _axis_aligned_basis(basis_: Basis) -> Basis:
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


func _axis_aligned_unit_vector(v: Vector3) -> Vector3:
	var x := absf(v.x)
	var y := absf(v.y)
	var z := absf(v.z)
	if x > y and x > z:
		return Vector3.RIGHT if v.x > 0 else Vector3.LEFT
	elif y > x and y > z:
		return Vector3.UP if v.y > 0 else Vector3.DOWN
	else:
		return Vector3.BACK if v.z > 0 else Vector3.FORWARD


## Calculates Basis from y and z vectors.
## If y and z are parallel then alternative_z is used instead of z.
func _basis_from_y_z(y: Vector3, z: Vector3, alternative_z: Vector3) -> Basis:
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


func _override_children_material_recursively(node: Node, material: Material) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			(child as MeshInstance3D).material_override = material
		_override_children_material_recursively(child, material)
