extends Node

const PATH = "user://options.cfg"


var _options: Array[Option] = [
	preload("options/int/ui_scale.gd").new(),
	preload("options/enum/vsync.gd").new(),
	preload("options/int/max_fps.gd").new(),
	preload("options/bool/fullscreen.gd").new(),
	preload("options/bool/fps_counter.gd").new(),
	preload("options/int/camera_fov.gd").new(),
	preload("options/int/3d_scale.gd").new(),
	preload("options/enum/msaa.gd").new(),
	preload("options/bool/taa.gd").new(),
	preload("options/bool/glow.gd").new(),
	preload("options/enum/upscaling_mode.gd").new(),
	preload("options/int/fsr_sharpness.gd").new(),
	preload("options/bool/lens_flare.gd").new(),
	preload("options/bool/motion_particles.gd").new(),
	preload("options/bool/input_hints.gd").new(),
]
var _options_dict := {}
var config := ConfigFile.new()


func get_option(key: String, section: String) -> Option:
	return _options_dict[key][section]


func _init() -> void:
	for option in _options:
		add_child(option)
		_options_dict.get_or_add(option.section(), {})[option.key()] = option


func _ready() -> void:
	for option in _options:
		option.initial_value = option.get_value()
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

	for option in _options:
		if config.has_section_key(option.section(), option.key()):
			option.set_value(config.get_value(option.section(), option.key()))


func save() -> void:
	for option in _options:
		if option.get_value() != option.initial_value:
			config.set_value(option.section(), option.key(), option.get_value())
		else:
			if config.has_section_key(option.section(), option.key()):
				config.erase_section_key(option.section(), option.key())

	var error := config.save(PATH)
	if error:
		printerr("Error while saving file %s: %s" % [
			ProjectSettings.globalize_path(PATH), Utils.error_message(error)
		])


func reset_to_defaults() -> void:
	for option in _options:
		option.set_value(option.initial_value)

	if FileAccess.file_exists(PATH):
		var error := DirAccess.remove_absolute(PATH)
		if error:
			printerr("Error while removing file %s: %s" % [
				ProjectSettings.globalize_path(PATH), Utils.error_message(error)
			])
