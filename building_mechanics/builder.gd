extends Node3D

@onready var camera := get_viewport().get_camera_3d()
@onready var ray_cast := $RayCast as RayCast3D

var piece: Piece


func _ready() -> void:
	ray_cast.reparent(camera, false)
	prepare_block()


func prepare_block() -> void:
	piece = BuildLibrary.pieces[1].instantiate() as Piece
	piece.hide()  # correct position is set later in _process()
	add_child(piece)


func _process(_delta: float) -> void:
	if piece:
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			var point := ray_cast.get_collision_point()
			var normal := ray_cast.get_collision_normal()
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
					if ray_cast.get_collider() is RigidBody3D:
						piece.linear_velocity = ray_cast.get_collider().linear_velocity
					prepare_block()
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
