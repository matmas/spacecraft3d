extends Control

const INPUTMAP_EDITOR = preload("res://inputmap_editor/inputmap_editor.tscn")

func _ready() -> void:
	Utils.grab_focus_first_button(self)


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
