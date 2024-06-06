extends Node3D
class_name PhysicsInterpolation

@export var enabled := false

@onready var target := get_parent() as Node3D  # assumes parent movement is controlled by physics

var previous_global_transform := Transform3D()
var current_global_transform := Transform3D()


func _ready() -> void:
	if not enabled:
		set_process(false)
		set_physics_process(false)
		return

	# Process interpolation before camera
	process_priority = -2

	Engine.set_physics_jitter_fix(0.0)

	top_level = true
	_reset()
	target.visibility_changed.connect(_reset)


func _reset() -> void:
	global_transform = target.global_transform
	previous_global_transform = target.global_transform
	current_global_transform = target.global_transform

	# Prevent spawned scenes to appear moving in the corrent place from their velocity direction
	# which is most noticeable when the spawned scene is not moving relative to the camera movement
	var camera_physics_interpolation := get_viewport().get_camera_3d().get_parent() as PhysicsInterpolation
	if camera_physics_interpolation:
		previous_global_transform.origin -= camera_physics_interpolation.current_global_transform.origin - camera_physics_interpolation.previous_global_transform.origin


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
static func apply(node: Node3D) -> PhysicsInterpolation:
	var physics_interpolation := PhysicsInterpolation.new()
	physics_interpolation.name = &"PhysicsInterpolation"
	node.add_child(physics_interpolation)
	for child in node.get_children():
		if child is VisualInstance3D:
			child.reparent(physics_interpolation)
	return physics_interpolation
