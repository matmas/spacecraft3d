extends VBoxContainer

@onready var list: VBoxContainer = %List

const BOOL_OPTION_ROW = preload("bool_option_row.tscn")
const ENUM_OPTION_ROW = preload("enum_option_row.tscn")
const RANGE_OPTION_ROW = preload("range_option_row.tscn")
const INPUT_ACTION_OPTION_ROW = preload("res://menus/options_menu/options_tab/input_action_option_row.tscn")

var section: GameOptionSection

func _ready() -> void:
	var current_category := ""

	for option in GameOptions.get_options(section):
		if not option.is_visible():
			continue

		var row: Control
		if option is BoolOption:
			row = BOOL_OPTION_ROW.instantiate()
		elif option is EnumOption:
			row = ENUM_OPTION_ROW.instantiate()
		elif option is RangeOption:
			row = RANGE_OPTION_ROW.instantiate()
		elif option is InputActionOption:
			row = INPUT_ACTION_OPTION_ROW.instantiate()

		row.set_option(option)

		if option.category.display_name != current_category:
			var category_label := Label.new()
			category_label.text = option.category.display_name
			category_label.theme_type_variation = &"CategoryHeader"
			list.add_child(category_label)
			current_category = option.category.display_name

		list.add_child(row)