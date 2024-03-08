extends Button
class_name OpenSceneButton

@export var scene: PackedScene

signal scene_opened(scene_instance)


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	var scene_instance := SceneManagement.open_scene(scene)
	scene_opened.emit(scene_instance)
	scene_instance.tree_exiting.connect(_on_tree_exiting)


func _on_tree_exiting() -> void:
	if is_inside_tree():
		grab_focus()
