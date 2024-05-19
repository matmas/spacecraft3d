extends StaticBody3D
class_name Block

@export var display_name := ""
@export_range(0.001, 1000, 0.001, "or_greater", "exp", "suffix:kg") var mass := 1.0

var grid: Grid
var neighbors: Array[Block] = []  # Touching blocks


func _to_string() -> String:
	return "Block:%s" % name


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if get_parent() is Grid:
				grid = get_parent() as Grid
		NOTIFICATION_EXIT_TREE:
			grid = null
			for neighbor in neighbors:
				neighbor.neighbors.erase(self)


func _ready() -> void:
	if grid:
		for neighbor in _get_neighbors_in_grid():
			neighbor.neighbors.append(self)
			neighbors.append(neighbor)


func _get_neighbors_in_grid() -> Array[Block]:
	var result: Array[Block] = []
	for direction in [Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN, Vector3.BACK, Vector3.FORWARD]:
		for collider in BuildingMechanicsUtils.get_colliders_of_physics_body(self, grid.block_collision_mask, -0.02, self.basis * direction * 0.04):
				if collider is Block:
					var neighbor := collider as Block
					if neighbor.grid == grid:
						result.append(neighbor)
	return result
