extends Node

const PATH = "user://options.cfg"

var _handlers := {
	"display": {
		"ui_scaling": preload("option_handlers/ui_scaling.gd").new(),
		"vsync": preload("option_handlers/vsync.gd").new(),
	}
}

func get_handler(key: String, section: String) -> OptionHandler:
	return _handlers[key][section]


var config := ConfigFile.new()


func _init() -> void:
	for section in _handlers:
		for key in _handlers[section]:
			var handler := _handlers[section][key] as OptionHandler
			add_child(handler)


func _ready() -> void:
	for section in _handlers:
		for key in _handlers[section]:
			var handler := _handlers[section][key] as OptionHandler
			handler.initial_value = handler.get_value()
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

	for section in _handlers:
		for key in _handlers[section]:
			var handler := _handlers[section][key] as OptionHandler

			if config.has_section_key(section, key):
				handler.set_value(config.get_value(section, key))


func save() -> void:
	for section in _handlers:
		for key in _handlers[section]:
			var handler := _handlers[section][key] as OptionHandler
			if handler.get_value() != handler.initial_value:
				config.set_value(section, key, handler.get_value())
			else:
				if config.has_section_key(section, key):
					config.erase_section_key(section, key)

	var error := config.save(PATH)
	if error:
		printerr("Error while saving file %s: %s" % [
			ProjectSettings.globalize_path(PATH), Utils.error_message(error)
		])


func reset_to_defaults() -> void:
	for section in _handlers:
		for key in _handlers[section]:
			var handler := _handlers[section][key] as OptionHandler
			handler.set_value(handler.initial_value)

	if FileAccess.file_exists(PATH):
		var error := DirAccess.remove_absolute(PATH)
		if error:
			printerr("Error while removing file %s: %s" % [
				ProjectSettings.globalize_path(PATH), Utils.error_message(error)
			])
