extends Control

const INPUTMAP_EDITOR = preload("res://inputmap_editor/inputmap_editor.tscn")

func _ready() -> void:
	Utils.grab_focus_first_button(self)


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_controls_pressed() -> void:
	var button := get_window().gui_get_focus_owner()
	var inputmap_editor := INPUTMAP_EDITOR.instantiate()
	get_window().add_child(inputmap_editor)
	hide()
	inputmap_editor.tree_exited.connect(func(): show(); button.grab_focus())


func _on_quit_pressed() -> void:
	get_tree().quit()
