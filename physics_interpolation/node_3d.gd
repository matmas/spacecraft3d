extends Node3D
class_name PhysicsInterpolation

@onready var target := get_parent() as Node3D  # assumes parent movement is controlled by physics

var previous_global_transform := Transform3D()
var current_global_transform := Transform3D()


func _ready() -> void:
	# Process interpolation before camera
	process_priority = -2

	top_level = true
	global_transform = target.global_transform
	previous_global_transform = target.global_transform
	current_global_transform = target.global_transform


func _physics_process(_delta: float) -> void:
	previous_global_transform = current_global_transform
	current_global_transform = target.global_transform


func _process(_delta: float) -> void:
	global_transform = target.global_transform
	var f := Engine.get_physics_interpolation_fraction()
	global_transform = previous_global_transform.interpolate_with(current_global_transform, f)


static func apply(node: Node3D, mesh_instance: MeshInstance3D) -> void:
	var physics_interpolation := PhysicsInterpolation.new()
	physics_interpolation.name = &"PhysicsInterpolation"
	node.add_child(physics_interpolation)
	mesh_instance.reparent(physics_interpolation)
