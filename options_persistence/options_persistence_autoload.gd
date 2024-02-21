extends Node

const PATH = "user://options.cfg"


var _option_handlers: Array[OptionHandler] = [
	preload("option_handlers/ui_scaling.gd").new(),
	preload("option_handlers/vsync.gd").new(),
	preload("option_handlers/max_fps.gd").new(),
]
var _option_handlers_dict := {}
var config := ConfigFile.new()


func get_handler(key: String, section: String) -> OptionHandler:
	return _option_handlers_dict[key][section]


func _init() -> void:
	for handler in _option_handlers:
		add_child(handler)
		_option_handlers_dict.get_or_add(handler.section(), {})[handler.key()] = handler


func _ready() -> void:
	for handler in _option_handlers:
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

	for handler in _option_handlers:
		if config.has_section_key(handler.section(), handler.key()):
			handler.set_value(config.get_value(handler.section(), handler.key()))


func save() -> void:
	for handler in _option_handlers:
		if handler.get_value() != handler.initial_value:
			config.set_value(handler.section(), handler.key(), handler.get_value())
		else:
			if config.has_section_key(handler.section(), handler.key()):
				config.erase_section_key(handler.section(), handler.key())

	var error := config.save(PATH)
	if error:
		printerr("Error while saving file %s: %s" % [
			ProjectSettings.globalize_path(PATH), Utils.error_message(error)
		])


func reset_to_defaults() -> void:
	for handler in _option_handlers:
		handler.set_value(handler.initial_value)

	if FileAccess.file_exists(PATH):
		var error := DirAccess.remove_absolute(PATH)
		if error:
			printerr("Error while removing file %s: %s" % [
				ProjectSettings.globalize_path(PATH), Utils.error_message(error)
			])
