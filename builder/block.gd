extends RigidBody3D
class_name Block

@onready var mesh := $Mesh as MeshInstance3D
@onready var ghost_material := preload("ghost_shader_material.tres")

var is_ghost := false

func _init() -> void:
	collision_layer = 0  # Do not affect physics
	collision_mask = 0b11111111_11111111_11111111_11111111  # Scan all layers


func set_ghost(ghost: bool) -> void:
	is_ghost = ghost
	if is_ghost:
		mesh.material_override = ghost_material
		collision_layer = 0
		max_contacts_reported = 1
	else:
		mesh.material_override = null
		collision_layer = 0b10
		max_contacts_reported = 0


func set_ghost_color(color: Color) -> void:
	if not is_ghost:
		set_ghost(true)
	ghost_material.set_shader_parameter("color", color)


func is_colliding() -> bool:
	return get_contact_count() > 0


func add_physics_interpolation() -> void:
	var node := Node3D.new()
	node.set_script(preload("res://physics_interpolation/node_3d.gd"))
	add_child(node)
	mesh.reparent(node)