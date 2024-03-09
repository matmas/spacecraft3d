extends VBoxContainer

@onready var list: VBoxContainer = %List

const BOOL_OPTION_ROW = preload("bool_option_row.tscn")
const ENUM_OPTION_ROW = preload("enum_option_row.tscn")
const RANGE_OPTION_ROW = preload("range_option_row.tscn")
const INPUT_ACTION_OPTION_ROW = preload("input_action_option_row.tscn")
const LICENSE_OPTION_ROW = preload("license_option_row.tscn")

var section: GameOptionSection

var _initialized := false


func _ready() -> void:
	_on_visibility_changed()
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible and not _initialized:
		_initialize()
		_initialized = true


func _initialize() -> void:
	var current_category := ""

	for option in GameOptions.get_options(section):
		if not option.is_visible():
			continue

		if option.category.display_name != current_category:
			var category_label := Label.new()
			category_label.text = option.category.display_name
			category_label.theme_type_variation = &"CategoryHeader"
			list.add_child(category_label)
			current_category = option.category.display_name

		var row: Control
		if option is BoolOption:
			row = BOOL_OPTION_ROW.instantiate()
		elif option is EnumOption:
			row = ENUM_OPTION_ROW.instantiate()
		elif option is RangeOption:
			row = RANGE_OPTION_ROW.instantiate()
		elif option is InputActionOption:
			row = INPUT_ACTION_OPTION_ROW.instantiate()
		elif option is LicenseOption:
			row = LICENSE_OPTION_ROW.instantiate()

		row.set_option(option)

		list.add_child(row)
