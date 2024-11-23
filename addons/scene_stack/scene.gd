extends Node
class_name Scene

@export var close_scene_action := &""
@export var open_scene_actions: Array[ActionSceneMapping] = []


func _ready() -> void:
	SceneStack.current_scene_changed.connect(_on_current_scene_changed)


func _on_current_scene_changed(scene_instance: Node) -> void:
	if scene_instance == self:
		_refresh()


func _refresh() -> void:
	if should_focus_first_visible_button():
		_grab_focus_first_visible_button(self)

	get_tree().paused = should_pause_game()

	if should_hide_mouse_cursor():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var EmulateMouseFromTouch_ := get_node_or_null("/root/EmulateMouseFromTouch")
	if EmulateMouseFromTouch_:
		EmulateMouseFromTouch_.enabled = should_emulate_mouse_from_touch()


func should_focus_first_visible_button() -> bool:
	return true


func should_emulate_mouse_from_touch() -> bool:
	return true


func should_pause_game() -> bool:
	return false


func should_hide_mouse_cursor() -> bool:
	return false


func on_go_back_requested() -> void:
	SceneStack.close_current_scene()


func _input(event: InputEvent) -> void:
	if close_scene_action:
		if SceneStack.current_scene() == self and event.is_action_pressed(close_scene_action):
			get_viewport().set_input_as_handled()
			SceneStack.close_current_scene()
	for mapping in open_scene_actions:
		if SceneStack.current_scene() == self and event.is_action_pressed(mapping.action_name):
			get_viewport().set_input_as_handled()
			SceneStack.open_scene(mapping.scene)


func _process(_delta: float) -> void:
	for mapping in open_scene_actions:
		if SceneStack.current_scene() == self:
			InputHints.is_action_just_pressed(mapping.action_name)


func _grab_focus_first_visible_button(node: Node) -> bool:
	if node is CanvasItem:
		if not (node as CanvasItem).visible:
			return false
	if node is Button:
		(node as Button).grab_focus()
		return true
	for child in node.get_children():
		if _grab_focus_first_visible_button(child):
			return true
	return false
