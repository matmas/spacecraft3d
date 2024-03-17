extends RigidBody3D
class_name Block

@export var display_name := ""

@export_flags_3d_physics var default_collision_mask = 0b11111111_11111111_11111111_11111111  # Scan all layers by default
@export_flags_3d_physics var default_collision_layer = 0b10  # Affect light solids only by default

@onready var mesh := $Mesh as MeshInstance3D
@onready var ghost_material := preload("ghost_shader_material.tres")

var _is_ghost := false
var _original_material_override: Material = null


func _init() -> void:
	collision_layer = 0  # Do not affect physics
	collision_mask = default_collision_mask


func set_ghost(ghost: bool) -> void:
	if ghost:
		_original_material_override = mesh.material_override
		mesh.material_override = ghost_material
		collision_layer = 0
		max_contacts_reported = 1
	else:
		mesh.material_override = _original_material_override
		collision_layer = default_collision_layer
		max_contacts_reported = 0
	_is_ghost = ghost


func set_ghost_color(color: Color) -> void:
	if not _is_ghost:
		set_ghost(true)
	ghost_material.set_shader_parameter("color", color)


func is_colliding() -> bool:
	return get_contact_count() > 0


func add_physics_interpolation() -> void:
	var node := PhysicsInterpolation.new()
	node.name = "PhysicsInterpolation"
	add_child(node)
	mesh.reparent(node)
