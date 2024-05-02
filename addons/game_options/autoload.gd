@tool
extends Node

const PATH = "user://options.cfg"

var _options: Array[Option] = []  # For internal use, load(), save(), etc.
var _options_dict := {}  # For various game features to decide their settings
var config := ConfigFile.new()

@onready var game_options_root: Node


func _ready() -> void:
	var game_options_scene_property := "game_options/game_options_scene"
	GameOptionsUtils.register_setting(game_options_scene_property, TYPE_STRING, "res://addons/game_options/game_options.tscn", PROPERTY_HINT_FILE, "*.tscn,*.scn,*.res")

	if Engine.is_editor_hint():
		return

	game_options_root = load(ProjectSettings.get_setting(game_options_scene_property)).instantiate()
	add_child(game_options_root)  # Some options rely on get_tree(), get_window() etc.

	_walk_tree(game_options_root, null, null)
	for option in _options:
		option.initial_value = option.get_value()
	_load()


func _walk_tree(node: Node, section: GameOptionSection, category: GameOptionCategory) -> void:
	for child in node.get_children():
		if child is GameOptionSection:
			_walk_tree(child, child as GameOptionSection, category)
		if child is GameOptionCategory:
			_walk_tree(child, section, child as GameOptionCategory)
		if child is Option:
			var option := child as Option
			option.section = section
			option.category = category
			_options.append(option)
			Utils.get_or_add(_options_dict, section.config_name, {})[option.key()] = option


func get_bool_option(section: String, key: String) -> BoolOption:
	return _options_dict[section][key]


func get_range_option(section: String, key: String) -> RangeOption:
	return _options_dict[section][key]


func get_enum_option(section: String, key: String) -> EnumOption:
	return _options_dict[section][key]


func get_sections() -> Array[GameOptionSection]:  # For generating UI section by section
	var sections: Array[GameOptionSection] = []
	for child in game_options_root.get_children():
		if child is GameOptionSection:
			sections.append(child)
	return sections


func get_options(section: GameOptionSection, node: Node = game_options_root) -> Array[Option]:  # For generating UI section by section
	var options: Array[Option] = []
	for child in node.get_children():
		if child is GameOptionSection and child == section:
			options.assign(get_options(section, child))
			break
		elif child is GameOptionCategory:
			options.append_array(get_options(section, child))
		elif child is GodotLicenseBundle:
			for license in (child as GodotLicenseBundle).get_licenses():
				license.section = (child as Option).section
				license.category = (child as Option).category
				options.append(license)
		elif child is Option:
			options.append(child)
	return options


func _load() -> void:
	if not FileAccess.file_exists(PATH):
		return

	var error := config.load(PATH)
	if error:
		printerr("Error while loading file %s: %s" % [
			ProjectSettings.globalize_path(PATH), GameOptionsUtils.error_message(error)
		])
		return

	for option in _options:
		if config.has_section_key(option.section.config_name, option.key()):
			option.set_value(config.get_value(option.section.config_name, option.key()))


func save() -> void:
	for option in _options:
		if option.get_value() != option.initial_value:
			config.set_value(option.section.config_name, option.key(), option.get_value())
		else:
			if config.has_section_key(option.section.config_name, option.key()):
				config.erase_section_key(option.section.config_name, option.key())

	var error := config.save(PATH)
	if error:
		printerr("Error while saving file %s: %s" % [
			ProjectSettings.globalize_path(PATH), GameOptionsUtils.error_message(error)
		])


func reset_to_defaults() -> void:
	for option in _options:
		if option.get_value() != option.initial_value:
			option.set_value(option.initial_value)

	if FileAccess.file_exists(PATH):
		var error := DirAccess.remove_absolute(PATH)
		if error:
			printerr("Error while removing file %s: %s" % [
				ProjectSettings.globalize_path(PATH), GameOptionsUtils.error_message(error)
			])
