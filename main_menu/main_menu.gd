extends Control

func _ready() -> void:
	Utils.grab_focus_first_button(self)


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://inputmap_editor/inputmap_editor.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
