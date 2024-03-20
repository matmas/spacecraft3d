extends Node3D
class_name PhysicsInterpolation

@export var enabled := true

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
	if enabled:
		var f := Engine.get_physics_interpolation_fraction()
		global_transform = previous_global_transform.interpolate_with(current_global_transform, f)
	else:
		global_transform = target.global_transform


## Make sure to apply any desired transform to the node before calling this function
## to prevent it being visible in the old transform for a brief moment between physics frames
## node must be in the scene tree before calling this function
static func apply(node: Node3D) -> void:
	var physics_interpolation := PhysicsInterpolation.new()
	physics_interpolation.name = &"PhysicsInterpolation"
	node.add_child(physics_interpolation)
	for child in node.get_children():
		if child is VisualInstance3D:
			child.reparent(physics_interpolation)
