extends Scene

@onready var joypad_tab_container: VBoxContainer = %JoypadTabContainer
const OPTIONS_TAB = preload("options_tab/options_tab.tscn")


func _ready() -> void:
	for section in GameOptions.get_sections():
		var tab := OPTIONS_TAB.instantiate()
		tab.name = section.display_name
		tab.section = section
		tab.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tab.visible = false
		joypad_tab_container.add_child(tab)


func should_focus_first_visible_button() -> bool:
	return false


func _on_reset_all_pressed() -> void:
	GameOptions.reset_to_defaults()
