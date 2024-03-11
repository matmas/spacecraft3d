extends Scene
class_name Game

@export var pause_menu_scene: PackedScene


func should_pause_game() -> bool:
	return false


func should_emulate_mouse_from_touch() -> bool:
	return false


func should_hide_mouse_cursor() -> bool:
	return true


func on_go_back_requested() -> void:
	SceneManagement.open_scene(pause_menu_scene)
