extends VBoxContainer

@onready var list: VBoxContainer = %List

const BOOL_OPTION_ROW = preload("bool_option_row.tscn")
const ENUM_OPTION_ROW = preload("enum_option_row.tscn")
const RANGE_OPTION_ROW = preload("range_option_row.tscn")


func _ready() -> void:
	var current_category := ""

	for option in GameOptions.get_options():
		if not option.is_visible():
			continue

		var row: Control
		if option is BoolOption:
			row = BOOL_OPTION_ROW.instantiate()
		elif option is EnumOption:
			row = ENUM_OPTION_ROW.instantiate()
		elif option is RangeOption:
			row = RANGE_OPTION_ROW.instantiate()

		row.set_option(option)

		if option.get_display_category() != current_category:
			var category_label := Label.new()
			category_label.text = option.get_display_category()
			category_label.theme_type_variation = &"CategoryHeader"
			list.add_child(category_label)
			current_category = option.get_display_category()

		list.add_child(row)


func _on_reset_pressed() -> void:
	GameOptions.reset_to_defaults()
