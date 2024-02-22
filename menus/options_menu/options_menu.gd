extends Control

@onready var tab_bar: TabBar = %TabBar
@onready var tabs: Array[CanvasItem] = [
	%DisplayTab,
	%ControlsTab,
]

func _ready() -> void:
	_set_tab_visible(tab_bar.current_tab)
	Utils.grab_focus_first_visible_button(tabs[tab_bar.current_tab])


func _on_tab_bar_tab_changed(tab: int) -> void:
	_set_tab_visible(tab)


func _set_tab_visible(index: int) -> void:
	for i in tabs.size():
		tabs[i].visible = i == index



func _input(event: InputEvent) -> void:
	var relative_index := 0
	if event.is_action_pressed(&"ui_tab_next"):
		relative_index += 1
	if event.is_action_pressed(&"ui_tab_prev"):
		relative_index -= 1

	if relative_index != 0:
		var target_tab := clampi(tab_bar.current_tab + relative_index, 0, tab_bar.tab_count - 1)
		if tab_bar.current_tab != target_tab:
			tab_bar.current_tab = target_tab
			get_viewport().set_input_as_handled()
			tab_bar.grab_focus()
