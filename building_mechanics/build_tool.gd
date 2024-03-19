extends Node3D
class_name BuildTool

@export_flags_3d_physics var raycast_collision_mask := 0b00000000_00000000_00000000_11111111

var _raycast: RayCast3D

var piece: Piece


func _ready() -> void:
	_raycast = RayCast3D.new()
	_raycast.collision_mask = raycast_collision_mask
	_raycast.target_position = Vector3.FORWARD * 100.0
	get_viewport().get_camera_3d().add_child(_raycast)
	_refresh()
	BuildLibrary.selection_changed.connect(_refresh)


func _refresh() -> void:
	var selected_piece := BuildLibrary.selected_piece
	if piece:
		remove_child(piece)
		piece.queue_free()

	if selected_piece:
		piece = selected_piece.instantiate()
		piece.hide()  # correct position is set later in _process()
		add_child(piece)


func _process(_delta: float) -> void:
	if piece:
		var camera := get_viewport().get_camera_3d()

		#var params := PhysicsRayQueryParameters3D.new()
		#params.from = camera.global_position
		#params.to = -camera.global_basis.z * 100.0
		#params.collision_mask = raycast_collision_mask
		#var result := get_world_3d().direct_space_state.intersect_ray(params)

		_raycast.force_raycast_update()
		if _raycast.is_colliding():
			var point := _raycast.get_collision_point()
			var normal := _raycast.get_collision_normal()
			piece.global_basis = _basis_from_y_z(normal, global_basis.z, global_basis.y)
			piece.global_position = point + normal * 0.001
			piece.show()
			if piece.is_colliding():
				piece.set_ghost_color(Color.YELLOW)
			else:
				piece.set_ghost_color(Color.GREEN)
				if SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block"):
					piece.add_physics_interpolation()
					piece.set_ghost(false)
					if _raycast.get_collider() is RigidBody3D:
						piece.linear_velocity = _raycast.get_collider().linear_velocity
					piece = null
					_refresh()
		else:
			piece.global_basis = global_basis
			piece.global_position = camera.global_position - camera.global_basis.z * 3.0
			piece.set_ghost_color(Color.RED)


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
