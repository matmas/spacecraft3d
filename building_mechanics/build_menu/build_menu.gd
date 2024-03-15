extends Scene
class_name BuildMenu

const SCENE_VIEWER_SCENE = preload("scene_viewer/scene_viewer.tscn")

@onready var flow_container: HFlowContainer = %HFlowContainer


func _ready() -> void:
	for scene in BuildLibrary.pieces:
		var scene_viewer := SCENE_VIEWER_SCENE.instantiate()
		scene_viewer.scene = scene
		flow_container.add_child(scene_viewer)
	super._ready()


func should_pause_game() -> bool:
	return false
