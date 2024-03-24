extends RigidBody3D
class_name Block

@export var display_name := ""


func _to_string() -> String:
	return "Block:%s" % name
