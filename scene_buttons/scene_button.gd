extends Button

@export var scene: PackedScene

func _on_pressed():
	var button := get_window().gui_get_focus_owner()
	var scene_instance := scene.instantiate()
	get_window().add_child(scene_instance)
	owner.hide()
	scene_instance.tree_exited.connect(func(): owner.show(); button.grab_focus())
