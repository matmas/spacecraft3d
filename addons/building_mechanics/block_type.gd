extends Resource
class_name BlockType

@export var display_name := ""
@export_range(0.001, 1000, 0.001, "or_greater", "exp", "suffix:kg") var mass := 1.0

# Runtime reference back to the scene that contains it
var scene: PackedScene

# Cached scene texture
var scene_texture: Texture2D
