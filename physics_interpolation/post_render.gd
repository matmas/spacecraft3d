extends Node
class_name PhysicsInterpolationPostRender


func _ready() -> void:
	process_priority = -1000


func _process(_delta: float) -> void:
	for node: Node3D in PhysicsInterpolationAutoload.interpolated_node_set:
		node.top_level = false
		if node in PhysicsInterpolationAutoload.original_node_transforms:
			node.transform = PhysicsInterpolationAutoload.original_node_transforms[node]

