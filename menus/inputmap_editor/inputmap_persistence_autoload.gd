extends Node

const PATH = "user://inputmap.cfg"
const SECTION = "inputmap"
const KEY = "actions"

var config := ConfigFile.new()
var actions := {}


func _ready() -> void:
	_load()


func _load() -> void:
	if not FileAccess.file_exists(PATH):
		return

	var error := config.load(PATH)
	if error:
		printerr("Error while loading file %s: %s" % [
			ProjectSettings.globalize_path(PATH), Utils.error_message(error)
		])
		return
	var dict := config.get_value(SECTION, KEY) as Dictionary

	for action in dict:
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
			for event in dict[action]:
				InputMap.action_add_event(action, event)
			actions[action] = true


func add_action(action: StringName) -> void:
	if action in InputMap.get_actions():
		actions[action] = true
	else:
		printerr("Invalid action '%s'" % action)


func save() -> void:
	var dict := {}

	for action in actions:
		dict[action] = InputMap.action_get_events(action)

	config.set_value(SECTION, KEY, dict)
	var error := config.save(PATH)
	if error:
		printerr("Error while saving file %s: %s" % [
			ProjectSettings.globalize_path(PATH), Utils.error_message(error)
		])


func reset_to_defaults() -> void:
	InputMap.load_from_project_settings()
	actions.clear()

	if FileAccess.file_exists(PATH):
		var error := DirAccess.remove_absolute(PATH)
		if error:
			printerr("Error while removing file %s: %s" % [
				ProjectSettings.globalize_path(PATH), Utils.error_message(error)
			])
