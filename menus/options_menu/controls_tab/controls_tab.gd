extends VBoxContainer

@onready var list: VBoxContainer = %List
@onready var scroll_container: ScrollContainer = %ScrollContainer

var action_descriptions := {
	&"look_up": tr("Look up"),
	&"look_down": tr("Look down"),
	&"look_left": tr("Look left"),
	&"look_right": tr("Look right"),
	&"move_forward": tr("Move forward"),
	&"move_backward": tr("Move backward"),
	&"move_left": tr("Move left"),
	&"move_right": tr("Move right"),
	&"jump": tr("Jump"),
	&"sprint": tr("Sprint"),
	&"crouch": tr("Crouch"),
	&"move_up": tr("Move up"),
	&"move_down": tr("Move down"),
	&"roll_left": tr("Roll left"),
	&"roll_right": tr("Roll right"),
	&"place_block": tr("Place block"),
	&"pause_menu": tr("Pause menu"),
	&"capture_screenshot": tr("Capture screenshot"),
}

var action_categories := {
	tr("General"): [
		&"look_up",
		&"look_down",
		&"look_left",
		&"look_right",
	],
	tr("Walking"): [
		&"move_forward",
		&"move_backward",
		&"move_left",
		&"move_right",
		&"jump",
		&"sprint",
		&"crouch",
	],
	tr("Flying"): [
		&"move_up",
		&"move_down",
		&"roll_left",
		&"roll_right",
	],
	tr("Building"): [
		&"place_block",
	],
	tr("Other"): [],
}


func _ready() -> void:
	var already_categorized_actions := {}
	Utils.remove_all_children(list)

	for category in action_categories:
		var category_label := Label.new()
		category_label.text = category
		category_label.theme_type_variation = &"CategoryHeader"
		list.add_child(category_label)

		for action in action_categories[category]:
			if not InputMap.has_action(action):
				continue

			_add_row(action)
			already_categorized_actions[action] = true

	for action in InputMap.get_actions():
		if action.begins_with("ui_"):
			continue  # Skip built-in actions and actions with ui_ prefix

		if not already_categorized_actions.has(action):
			_add_row(action)


func _add_row(action: StringName) -> void:
	var row := preload("row.tscn").instantiate()
	row.action = action
	row.action_description = action_descriptions.get(action, action)
	list.add_child(row)


func _on_reset_pressed() -> void:
	InputmapPersistence.reset_to_defaults()
	InputMonitor.input_map_changed.emit()
	for child in list.get_children():
		if child is InputmapEditorRow:
			(child as InputmapEditorRow).refresh()