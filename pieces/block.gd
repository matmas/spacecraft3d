extends RigidBody3D
class_name Block

@onready var mesh := $Mesh


func _ready() -> void:
	collision_layer = 0  # Do not affect physics
	collision_mask = (2 << 31) - 1  # All layers
	max_contacts_reported = 1


func set_color(color: Color) -> void:
	if not mesh.material_override:
		var material := StandardMaterial3D.new()
		material.albedo_color = color * 0.5
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
		material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD  # does not cast shadows
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mesh.material_override = material
	else:
		mesh.material_override.albedo_color = color * 0.5
