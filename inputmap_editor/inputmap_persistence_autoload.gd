extends Node

const INPUTMAP_PATH = "user://inputmap.cfg"
const SECTION = "inputmap"
const KEY = "actions"

var config := ConfigFile.new()

func _ready() -> void:
	load_inputmap()


func load_inputmap() -> void:
	if not FileAccess.file_exists(INPUTMAP_PATH):
		return

	var error := config.load(INPUTMAP_PATH)
	if error:
		printerr("Error while loading file %s: %s" % [
			ProjectSettings.globalize_path(INPUTMAP_PATH), Utils.error_message(error)
		])
		return
	var dict := config.get_value(SECTION, KEY) as Dictionary

	for action in dict:
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
			for event in dict[action]:
				InputMap.action_add_event(action, event)


func save_inputmap() -> void:
	var dict := {}

	for action in InputMap.get_actions():
		dict[action] = InputMap.action_get_events(action)

	config.set_value(SECTION, KEY, dict)
	var error := config.save(INPUTMAP_PATH)
	if error:
		printerr("Error while saving file %s: %s" % [
			ProjectSettings.globalize_path(INPUTMAP_PATH), Utils.error_message(error)
		])


func reset_to_default() -> void:
	InputMap.load_from_project_settings()
	if FileAccess.file_exists(INPUTMAP_PATH):
		var error := DirAccess.remove_absolute(INPUTMAP_PATH)
		if error:
			printerr("Error while removing file %s: %s" % [
				ProjectSettings.globalize_path(INPUTMAP_PATH), Utils.error_message(error)
			])
