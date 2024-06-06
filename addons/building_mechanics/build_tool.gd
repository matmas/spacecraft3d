extends Node3D
class_name BuildTool

@export var cell_size := Vector3(0.5, 0.5, 0.5)
@export var place_block_max_distance := 10.0
@export_flags_3d_physics var block_collision_mask := 0b00000000_00000000_00000010_00000000
@export_flags_3d_physics var grid_collision_layer := 0b00000000_00000000_00000000_00000001
@export_flags_3d_physics var grid_collision_mask := 0b00000000_00000000_00000001_11111111

var raycast := RayCast3D.new()
var _ghost_block: Block
var _ghost_material := preload("ghost_material/ghost_shader_material.tres")
var _remove_block_material := preload("ghost_material/ghost_shader_material.tres").duplicate() as ShaderMaterial
var _ghost_basis := Basis.IDENTITY
var _block_under_raycast: Block
signal _block_under_raycast_changed
var _block_to_remove: Block


func _ready() -> void:
	raycast.collision_mask = block_collision_mask
	raycast.target_position = Vector3.FORWARD * place_block_max_distance
	_on_block_selection_changed()
	BuildingMechanics.selection_changed.connect(_on_block_selection_changed)


func _on_block_selection_changed() -> void:
	if _ghost_block:
		remove_child(_ghost_block)
		_ghost_block.queue_free()
		_ghost_block = null

	var selected_block := BuildingMechanics.selected_block
	if selected_block:
		_ghost_block = selected_block.instantiate() as Block
		_ghost_block.collision_layer = 0
		_ghost_block.collision_mask = 0
		BuildingMechanicsUtils.override_children_material_recursively(_ghost_block, _ghost_material)
		_ghost_block.hide()  # Correct position is set later in _process()
		add_child(_ghost_block)


func _physics_process(_delta: float) -> void:
	if not _ghost_block:
		return

	if is_input_rotate_x_pos():
		_ghost_basis = _ghost_basis.rotated(Vector3.RIGHT, TAU * 0.25)
	if is_input_rotate_x_neg():
		_ghost_basis = _ghost_basis.rotated(Vector3.RIGHT, TAU * -0.25)
	if is_input_rotate_y_pos():
		_ghost_basis = _ghost_basis.rotated(Vector3.UP, TAU * 0.25)
	if is_input_rotate_y_neg():
		_ghost_basis = _ghost_basis.rotated(Vector3.UP, TAU * -0.25)
	if is_input_rotate_z_pos():
		_ghost_basis = _ghost_basis.rotated(Vector3.FORWARD, TAU * 0.25)
	if is_input_rotate_z_neg():
		_ghost_basis = _ghost_basis.rotated(Vector3.FORWARD, TAU * -0.25)

	var camera := get_viewport().get_camera_3d()

	var collider := raycast.get_collider()
	var block: Block
	if raycast.is_colliding():
		var point := raycast.get_collision_point()
		var normal := raycast.get_collision_normal()
		if collider is Block:
			block = collider as Block
			_ghost_block.global_basis = _grid_aligned_basis(global_basis * _ghost_basis, block.global_basis)
			_ghost_block.global_position = block.global_transform * _calculate_local_offset(block, _ghost_block, point, normal)
		else:
			_ghost_block.global_basis = BuildingMechanicsUtils.basis_from_y_z(normal, global_basis.z, global_basis.y) * _ghost_basis
			var ghost_aabb := Transform3D(_ghost_basis) * BuildingMechanicsUtils.calculate_spatial_bounds(_ghost_block)
			_ghost_block.global_position = point + normal * ((ghost_aabb.size * 0.5 - ghost_aabb.get_center()).y + 0.001)
	else:
		_ghost_block.global_basis = global_basis * _ghost_basis
		_ghost_block.global_position = camera.global_position - camera.global_basis.z * 3.0

	if not _ghost_block.visible:
		_ghost_block.show()

	if BuildingMechanicsUtils.is_physics_body_colliding(_ghost_block, block_collision_mask, -0.02):
		_ghost_material.set_shader_parameter(&"color", Color.RED)
	else:
		if not block or BuildingMechanicsUtils.get_colliders_of_physics_body(_ghost_block, block_collision_mask, 0.02).has(block):  # Is ghost_block touching block?
			_ghost_material.set_shader_parameter(&"color", Color.GREEN)
			_allow_block_placement(collider)
		else:
			_ghost_material.set_shader_parameter(&"color", Color.RED)

	_allow_block_removal()


func _allow_block_placement(collider: Object) -> void:
	if is_input_place_block():
		var spawned_block := BuildingMechanics.selected_block.instantiate() as Block
		spawned_block.name = _ghost_block.name

		var grid: Grid
		if collider is Block:
			grid = (collider as Block).grid
			spawned_block.transform = grid.global_transform.inverse() * _ghost_block.global_transform  # Precalculate local transform as an alternative to setting global_transform on spawned_block after grid.add_child
			grid.add_child(spawned_block)
		else:
			grid = Grid.new(grid_collision_layer, grid_collision_mask, block_collision_mask)
			add_child(grid)
			grid.global_transform = _ghost_block.global_transform
			grid.add_child(spawned_block)
			if collider is RigidBody3D:
				grid.linear_velocity = (collider as RigidBody3D).linear_velocity
			else:
				grid.linear_velocity = (get_player_rigid_body() as RigidBody3D).linear_velocity


func _allow_block_removal() -> void:
	var collider := raycast.get_collider()
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
		if is_input_remove_block_pressed():
			_block_to_remove = _block_under_raycast
			BuildingMechanicsUtils.override_children_material_recursively(_block_to_remove, _remove_block_material)

			if not _block_under_raycast_changed.is_connected(_update_block_to_remove_material):
				_remove_block_material.set_shader_parameter(&"color", Color.RED)
				_block_under_raycast_changed.connect(_update_block_to_remove_material)

		if is_input_remove_block_released():
			if _block_to_remove == _block_under_raycast:
				_block_to_remove.queue_free()
			_block_to_remove = null


func _update_block_to_remove_material() -> void:
	if _block_to_remove:
		BuildingMechanicsUtils.override_children_material_recursively(_block_to_remove, _remove_block_material if _block_under_raycast == _block_to_remove else null)


func _calculate_local_offset(block: Block, ghost_block: Block, point: Vector3, normal: Vector3) -> Vector3:
	var block_aabb := BuildingMechanicsUtils.calculate_spatial_bounds(block)
	var ghost_aabb := Transform3D(block.global_basis.inverse() * ghost_block.global_basis) * BuildingMechanicsUtils.calculate_spatial_bounds(ghost_block)
	var local_point := block.global_transform.inverse() * point
	var local_point_normalized := (local_point - block_aabb.get_center()) / (block_aabb.size * 0.5)  # Each component is in the range -1.0..1.0
	var local_normal := block.global_basis.inverse() * normal
	var block_span := (block_aabb.size / cell_size).snapped(Vector3.ONE)
	var ghost_span := (ghost_aabb.size / cell_size).snapped(Vector3.ONE)
	var span_oddness_by_axis := (ghost_span - block_span).abs().posmod(2)  # Each component is 0 or 1
	var span_oddness := span_oddness_by_axis * local_point.sign() * cell_size * 0.5
	var span_oddness_correction := span_oddness - span_oddness * local_normal.abs()  # Set axis aligned with local_normal to zero
	var freedom_by_axis := BuildingMechanicsUtils.max_vector3(block_span, ghost_span)
	var freedom := ((freedom_by_axis - span_oddness_by_axis) * 0.5 * cell_size * local_point_normalized).snapped(cell_size) + block_aabb.get_center() - ghost_aabb.get_center()
	var freedom_correction := freedom - freedom * local_normal.abs()  # Set axis aligned with local_normal to zero
	var local_offset := local_normal * (
		block_aabb.size * 0.5 + block_aabb.get_center() * local_normal +
		ghost_aabb.size * 0.5 + ghost_aabb.get_center() * -local_normal
	) + freedom_correction + span_oddness_correction
	return local_offset


func _grid_aligned_basis(basis_: Basis, grid_basis: Basis) -> Basis:
	return grid_basis * BuildingMechanicsUtils.axis_aligned_basis(grid_basis.inverse() * basis_)


func is_input_place_block() -> bool:
	return Input.is_action_just_pressed(&"place_block")


func is_input_remove_block_pressed() -> bool:
	return Input.is_action_just_pressed(&"remove_block")


func is_input_remove_block_released() -> bool:
	return Input.is_action_just_released(&"remove_block")


func is_input_rotate_x_pos() -> bool:
	return Input.is_action_just_pressed(&"rotate_x+")


func is_input_rotate_x_neg() -> bool:
	return Input.is_action_just_pressed(&"rotate_x-")


func is_input_rotate_y_pos() -> bool:
	return Input.is_action_just_pressed(&"rotate_y+")


func is_input_rotate_y_neg() -> bool:
	return Input.is_action_just_pressed(&"rotate_y-")


func is_input_rotate_z_pos() -> bool:
	return Input.is_action_just_pressed(&"rotate_z+")


func is_input_rotate_z_neg() -> bool:
	return Input.is_action_just_pressed(&"rotate_z-")


func get_player_rigid_body() -> RigidBody3D:
	return get_parent()
