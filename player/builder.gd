extends RayCast3D

var block_scenes: Array[PackedScene] = [
	preload("res://pieces/block.tscn"),
	preload("res://pieces/suzanne.tscn"),
	preload("res://pieces/halfblock.tscn"),
]
var block_instance: Block

@onready var player := owner as Player
@onready var camera := get_viewport().get_camera_3d()

func _ready() -> void:
	prepare_block()


func prepare_block() -> void:
	var new_block_instance := block_scenes[0].instantiate() as Block
	new_block_instance.hide()  # corrent position is set later in _process()
	player.add_child.call_deferred(new_block_instance)
	await new_block_instance.ready
	block_instance = new_block_instance


func _process(_delta: float) -> void:
	if block_instance:
		force_raycast_update()
		if is_colliding():
			var point := get_collision_point()
			var normal := get_collision_normal()
			block_instance.global_basis = Basis(
				normal.cross(-normal.cross(player.global_basis.x)),
				normal,
				normal.cross(-normal.cross(player.global_basis.z))
			).orthonormalized()
			block_instance.global_position = point + normal * 0.001
			block_instance.show()
			if block_instance.is_colliding():
				block_instance.set_ghost_color(Color.YELLOW)
			else:
				block_instance.set_ghost_color(Color.GREEN)
				if Input.is_action_just_pressed("fire"):
					block_instance.add_physics_interpolation()
					block_instance.set_ghost(false)
					if get_collider() is RigidBody3D:
						block_instance.linear_velocity = get_collider().linear_velocity
					prepare_block()
		else:
			block_instance.global_basis = player.global_basis
			block_instance.global_position = camera.global_position - camera.global_basis.z * 3.0
			block_instance.set_ghost_color(Color.RED)
