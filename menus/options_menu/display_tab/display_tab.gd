extends VBoxContainer

@onready var list: VBoxContainer = %List

const ROW_WITH_CHECK_BUTTON = preload("res://menus/options_menu/display_tab/row_with_check_button.tscn")
const ROW_WITH_OPTION_BUTTON = preload("res://menus/options_menu/display_tab/row_with_option_button.tscn")
const ROW_WITH_RANGE = preload("res://menus/options_menu/display_tab/row_with_range.tscn")


func _ready() -> void:
	var current_category := ""

	for option in GameOptions.options:
		var row: Node

		if option is BoolOption:
			row = ROW_WITH_CHECK_BUTTON.instantiate()
		elif option is EnumOption:
			row = ROW_WITH_OPTION_BUTTON.instantiate()
		elif option is FloatOption:
			row = ROW_WITH_RANGE.instantiate()

		row.set_display_name(option.display_name())
		row.set_section(option.section())
		row.set_key(option.key())

		if option.display_category() != current_category:
			var category_label := Label.new()
			category_label.text = option.display_category()
			category_label.theme_type_variation = &"CategoryHeader"
			list.add_child(category_label)
			current_category = option.display_category()

		list.add_child(row)


func _on_reset_pressed() -> void:
	GameOptions.reset_to_defaults()
