extends VBoxContainer

@onready var tab_bar := %TabBar as TabBar
var tabs: Array[CanvasItem] = []

func _ready() -> void:
	_refresh()
	Utils.grab_focus_first_visible_button(tabs[tab_bar.current_tab])


func _refresh() -> void:
	tabs.clear()
	tab_bar.clear_tabs()

	for child in get_children():
		if child is CanvasItem and child.owner != self:  # Don't add nodes this scene is made of
			tabs.append(child)
			tab_bar.add_tab(child.name)

	_switch_tab_visibility(tab_bar.current_tab)


func _on_tab_bar_tab_changed(tab: int) -> void:
	_switch_tab_visibility(tab)


func _switch_tab_visibility(index: int) -> void:
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


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_CHILD_ORDER_CHANGED:
			if is_node_ready():
				_refresh()
