extends Node3D
class_name BuildTool

@export_flags_3d_physics var collision_mask := 0b00000000_00000000_00000010_00000000

var _ghost_block: Block
var _ghost_material := preload("ghost_shader_material.tres")


func _ready() -> void:
	_refresh()
	BlockLibrary.selection_changed.connect(_refresh)


func _refresh() -> void:
	if _ghost_block:
		remove_child(_ghost_block)
		_ghost_block.queue_free()
		_ghost_block = null

	var selected_block := BlockLibrary.selected_block
	if selected_block:
		_ghost_block = selected_block.instantiate() as Block
		_ghost_block.collision_layer = 0
		_ghost_block.collision_mask = 0
		for child in _ghost_block.get_children():
			if child is MeshInstance3D:
				(child as MeshInstance3D).material_override = _ghost_material
		_ghost_block.hide()  # correct position is set later in _process()
		add_child(_ghost_block)
		PhysicsInterpolation.apply(_ghost_block)


func _physics_process(_delta: float) -> void:
	if not _ghost_block:
		return

	var camera_parent := get_viewport().get_camera_3d().get_parent().get_parent() as Node3D  # Need physics uninterpolated position
	var camera_global_transform := camera_parent.global_transform
	var raycast_offset := -(get_parent() as Player).linear_velocity * get_physics_process_delta_time()
	var raycast := Utils.raycast(camera_global_transform.translated(raycast_offset), Vector3.FORWARD * 10, collision_mask)

	var collider: Node3D
	if raycast:
		var point := raycast.position as Vector3
		var normal := raycast.normal as Vector3
		collider = raycast.collider
		if collider is Block:
			var block := collider as Block
			var block_aabb := Utils.calculate_spatial_bounds(block.get_node("PhysicsInterpolation") as Node3D)
			var ghost_aabb := Utils.calculate_spatial_bounds(_ghost_block.get_node("PhysicsInterpolation") as Node3D)
			var local_normal := block.global_basis.inverse() * normal
			var block_offset := block.global_basis * _calculate_local_offset(block_aabb, ghost_aabb, local_normal)
			_ghost_block.global_basis = block.global_basis
			_ghost_block.global_position = block.global_position + block_offset
		else:
			_ghost_block.global_basis = _basis_from_y_z(normal, global_basis.z, global_basis.y)
			_ghost_block.global_position = point + normal * 0.001
	else:
		_ghost_block.global_basis = global_basis
		_ghost_block.global_position = camera_parent.global_position - camera_parent.global_basis.z * 3.0

	var offset := Vector3()
	if collider is Block:
		offset = -collider.get_parent().linear_velocity * get_physics_process_delta_time()
	else:
		offset = -(get_parent() as Player).linear_velocity * get_physics_process_delta_time()
	if Utils.is_physics_body_colliding(_ghost_block, collision_mask, -0.02, offset):
		_ghost_material.set_shader_parameter(&"color", Color.RED)
	else:
		_ghost_material.set_shader_parameter(&"color", Color.GREEN)
		_allow_block_placement(collider)

	if not _ghost_block.visible:
		_ghost_block.show()


func _allow_block_placement(collider: Node) -> void:
	if SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block"):
		var spawned_block := BlockLibrary.selected_block.instantiate() as Block
		spawned_block.name = _ghost_block.name
		var grid: Grid
		if collider is Block:
			grid = (collider as Block).grid
			grid.add_child(spawned_block)
		else:
			grid = Grid.new()
			add_child(grid)
			grid.global_transform = _ghost_block.global_transform
			grid.add_child(spawned_block)
			if collider is RigidBody3D:
				grid.linear_velocity = (collider as RigidBody3D).linear_velocity
			else:
				grid.linear_velocity = (get_parent() as Player).linear_velocity

		spawned_block.global_transform = _ghost_block.global_transform

		for child in spawned_block.get_children():
			if child is CollisionShape3D:
				var collision_shape := child as CollisionShape3D
				var grid_collision_shape := collision_shape.duplicate()
				grid.add_child(grid_collision_shape)
				grid_collision_shape.global_transform = collision_shape.global_transform

		PhysicsInterpolation.apply(spawned_block)


func _calculate_local_offset(block_aabb: AABB, ghost_aabb: AABB, local_normal: Vector3) -> Vector3:
	return local_normal * (
		block_aabb.size * 0.5 + block_aabb.get_center() * local_normal +
		ghost_aabb.size * 0.5 + ghost_aabb.get_center() * -local_normal
	)


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
