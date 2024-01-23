extends RayCast3D

var floor_scene := preload("res://pieces/floor.tscn")
var floor_instance := floor_scene.instantiate()

func _ready() -> void:
	get_first_rigid_body_3d_or_last_node_3d_ancestor(self).add_child.call_deferred(floor_instance)


func _process(_delta: float) -> void:
	force_raycast_update()
	var point := get_collision_point()
	floor_instance.global_position = point


func get_first_rigid_body_3d_or_last_node_3d_ancestor(node: Node3D) -> Node3D:
	var parent := node.get_parent()
	var last_node3d_ancestor := node
	while parent != null:
		if parent is Node3D:
			last_node3d_ancestor = parent as Node3D
		if parent is RigidBody3D:
			return parent as RigidBody3D
		parent = parent.get_parent()
	return last_node3d_ancestor
