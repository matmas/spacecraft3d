extends Node3D

var block_scenes: Array[PackedScene] = [
	preload("pieces/halfblock.tscn"),
	preload("pieces/block.tscn"),
]
@onready var camera := get_viewport().get_camera_3d()
@onready var ray_cast := $RayCast as RayCast3D

var block_instance: Block


func _ready() -> void:
	ray_cast.reparent(camera, false)
	prepare_block()


func prepare_block() -> void:
	var new_block_instance := block_scenes[0].instantiate() as Block
	new_block_instance.hide()  # correct position is set later in _process()
	add_child(new_block_instance)
	block_instance = new_block_instance


func _process(_delta: float) -> void:
	if block_instance:
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			var point := ray_cast.get_collision_point()
			var normal := ray_cast.get_collision_normal()
			block_instance.global_basis = Basis(
				normal.cross(global_basis.z),
				normal,
				global_basis.z
			).orthonormalized()

			block_instance.global_position = point + normal * 0.001
			block_instance.show()
			if block_instance.is_colliding():
				block_instance.set_ghost_color(Color.YELLOW)
			else:
				block_instance.set_ghost_color(Color.GREEN)
				if InputHints.is_action_just_pressed(&"place_block"):
					block_instance.add_physics_interpolation()
					block_instance.set_ghost(false)
					if ray_cast.get_collider() is RigidBody3D:
						block_instance.linear_velocity = ray_cast.get_collider().linear_velocity
					prepare_block()
		else:
			block_instance.global_basis = global_basis
			block_instance.global_position = camera.global_position - camera.global_basis.z * 3.0
			block_instance.set_ghost_color(Color.RED)
