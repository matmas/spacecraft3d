extends RigidBody3D
class_name Block

@export var display_name := ""

@onready var mesh := $Mesh as MeshInstance3D


func _to_string() -> String:
	return "Block:%s" % name
