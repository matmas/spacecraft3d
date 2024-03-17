extends Node3D

@onready var camera := get_viewport().get_camera_3d()
@onready var ray_cast := $RayCast as RayCast3D

var block_instance: Block


func _ready() -> void:
	ray_cast.reparent(camera, false)
	prepare_block()


func prepare_block() -> void:
	block_instance = BuildLibrary.pieces[1].instantiate() as Block
	block_instance.hide()  # correct position is set later in _process()
	add_child(block_instance)


func _process(_delta: float) -> void:
	if block_instance:
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			var point := ray_cast.get_collision_point()
			var normal := ray_cast.get_collision_normal()
			block_instance.global_basis = _basis_from_y_z(normal, global_basis.z, global_basis.y)
			block_instance.global_position = point + normal * 0.001
			block_instance.show()
			if block_instance.is_colliding():
				block_instance.set_ghost_color(Color.YELLOW)
			else:
				block_instance.set_ghost_color(Color.GREEN)
				if SceneManagement.current_scene() is Game and InputHints.is_action_just_pressed(&"place_block"):
					block_instance.add_physics_interpolation()
					block_instance.set_ghost(false)
					if ray_cast.get_collider() is RigidBody3D:
						block_instance.linear_velocity = ray_cast.get_collider().linear_velocity
					prepare_block()
		else:
			block_instance.global_basis = global_basis
			block_instance.global_position = camera.global_position - camera.global_basis.z * 3.0
			block_instance.set_ghost_color(Color.RED)


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
