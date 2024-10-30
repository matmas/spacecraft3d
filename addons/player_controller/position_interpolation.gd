extends Node3D

@export var enabled := true

@onready var target := get_parent() as Node3D  # assumes parent movement is controlled by physics

var previous_global_position := Vector3()
var current_global_position := Vector3()

func _ready() -> void:
	if not enabled:
		set_process(false)
		set_physics_process(false)
		return
	_reset()
	target.visibility_changed.connect(_reset)


func _reset() -> void:
	previous_global_position = target.global_position
	current_global_position = target.global_position


func _physics_process(_delta: float) -> void:
	previous_global_position = current_global_position
	current_global_position = target.global_position


func _process(_delta: float) -> void:
	if enabled:
		var f := Engine.get_physics_interpolation_fraction()
		global_position = previous_global_position.lerp(current_global_position, f)
