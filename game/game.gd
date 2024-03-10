extends Scene
class_name Game

const PAUSE_MENU_SCENE = preload("res://ui/menus/pause_menu/pause_menu.tscn")


func _input(event: InputEvent) -> void:
	if SceneManagement.current_scene() is Game and event.is_action_pressed(&"pause_menu"):
		SceneManagement.open_scene(PAUSE_MENU_SCENE)
		get_viewport().set_input_as_handled()


func should_pause_game() -> bool:
	return false


func should_emulate_mouse_from_touch() -> bool:
	return false


func should_hide_mouse_cursor() -> bool:
	return true


func on_go_back_requested() -> void:
	SceneManagement.open_scene(PAUSE_MENU_SCENE)
