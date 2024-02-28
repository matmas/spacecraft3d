extends VBoxContainer

@onready var joypad_tab_container: VBoxContainer = %JoypadTabContainer
const OPTIONS_TAB = preload("res://menus/options_menu/options_tab/options_tab.tscn")


func _ready() -> void:
	for section in GameOptions.get_sections():
		var tab := OPTIONS_TAB.instantiate()
		tab.name = section.display_name
		tab.section = section
		tab.size_flags_vertical = Control.SIZE_EXPAND_FILL
		joypad_tab_container.add_child(tab)


func _on_reset_pressed() -> void:
	GameOptions.reset_to_defaults()
