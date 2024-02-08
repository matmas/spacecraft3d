extends Node

const INPUTMAP_PATH = "user://inputmap.cfg"
const SECTION = "inputmap"
const KEY = "actions"

var config := ConfigFile.new()

func _ready() -> void:
	load_inputmap()


func load_inputmap() -> void:
	var err := config.load(INPUTMAP_PATH)
	if err != OK:
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
	config.save(INPUTMAP_PATH)
