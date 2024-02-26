extends Node

const PATH = "user://options.cfg"


var options: Array[Option] = [
	preload("options/graphics/display/ui_scale.gd").new(),
	preload("options/graphics/display/fullscreen.gd").new(),
	preload("options/graphics/display/screen.gd").new(),
	preload("options/graphics/display/vsync.gd").new(),
	preload("options/graphics/display/max_fps.gd").new(),
	preload("options/graphics/display/fps_counter.gd").new(),
	preload("options/graphics/res_upscaling_aa/3d_scale.gd").new(),
	preload("options/graphics/res_upscaling_aa/upscaling_mode.gd").new(),
	preload("options/graphics/res_upscaling_aa/taa.gd").new(),
	preload("options/graphics/res_upscaling_aa/fxaa.gd").new(),
	preload("options/graphics/res_upscaling_aa/msaa.gd").new(),
	preload("options/graphics/effects/glow.gd").new(),
	preload("options/graphics/effects/ssao.gd").new(),
	preload("options/graphics/effects/ssil.gd").new(),
	preload("options/graphics/effects/lens_flare.gd").new(),
	preload("options/graphics/effects/motion_particles.gd").new(),
	preload("options/graphics/camera/camera_fov.gd").new(),
	preload("options/graphics/ui/input_hints.gd").new(),
	preload("options/input/mouse_sensitivity.gd").new(),
	preload("options/input/joypad_sensitivity.gd").new(),
	preload("options/audio/master_volume.gd").new(),
]
var _options_dict := {}
var config := ConfigFile.new()


func get_option(section: String, key: String) -> Option:
	return _options_dict[section][key]


func _init() -> void:
	for option in options:
		add_child(option)
		_options_dict.get_or_add(option.section(), {})[option.key()] = option


func _ready() -> void:
	for option in options:
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

	for option in options:
		if config.has_section_key(option.section(), option.key()):
			option.set_value(config.get_value(option.section(), option.key()))


func save() -> void:
	for option in options:
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
	for option in options:
		option.set_value(option.initial_value)

	if FileAccess.file_exists(PATH):
		var error := DirAccess.remove_absolute(PATH)
		if error:
			printerr("Error while removing file %s: %s" % [
				ProjectSettings.globalize_path(PATH), Utils.error_message(error)
			])
