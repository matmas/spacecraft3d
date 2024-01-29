extends RigidBody3D
class_name Block

@onready var mesh := $Mesh as MeshInstance3D
var is_ghost := false

func _ready() -> void:
	collision_mask = (2 << 31) - 1  # All layers

func set_ghost(ghost: bool) -> void:
	is_ghost = ghost
	if is_ghost:
		var material := StandardMaterial3D.new()
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
		material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD  # does not cast shadows
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mesh.material_override = material
		collision_layer = 0  # Do not affect physics
		max_contacts_reported = 1
	else:
		mesh.material_override = null
		collision_layer = 2
		max_contacts_reported = 0


func set_ghost_color(color: Color) -> void:
	if not is_ghost:
		set_ghost(true)
	mesh.material_override.albedo_color = color * 0.5
