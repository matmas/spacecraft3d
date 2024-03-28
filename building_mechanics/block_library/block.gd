extends StaticBody3D
class_name Block

@export var display_name := ""
@export_range(0.001, 1000, 0.001, "or_greater", "exp", "suffix:kg") var mass = 1.0

var grid: Grid


func _to_string() -> String:
	return "Block:%s" % name


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if get_parent() is Grid:
				grid = get_parent() as Grid
				grid.on_block_enter(self)
		NOTIFICATION_EXIT_TREE:
			if grid:
				grid.on_block_exit(self)
				grid = null
