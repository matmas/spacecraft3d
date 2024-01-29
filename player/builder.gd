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
	block_instance = block_scenes[0].instantiate() as Block
	player.add_child.call_deferred(block_instance)


func _process(_delta: float) -> void:
	force_raycast_update()
	if is_colliding():
		var point := get_collision_point()
		block_instance.global_position = point + get_collision_normal() * 0.01
		if block_instance.get_contact_count() == 0:
			block_instance.set_ghost_color(Color.GREEN)
			if Input.is_action_just_pressed("fire"):
				block_instance.set_ghost(false)
				block_instance.top_level = true
				prepare_block()
		else:
			block_instance.set_ghost_color(Color.YELLOW)
	else:
		block_instance.global_position = camera.global_position - camera.global_basis.z * 3.0
		block_instance.set_ghost_color(Color.RED)
