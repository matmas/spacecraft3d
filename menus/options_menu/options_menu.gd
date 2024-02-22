extends Control


@onready var tabs: Array[CanvasItem] = [
	%DisplayTab,
	%ControlsTab,
]

func _ready() -> void:
	Utils.grab_focus_first_button(self)
	_select_tab(0)


func _on_tab_bar_tab_changed(tab: int) -> void:
	_select_tab(tab)


func _select_tab(index: int) -> void:
	for i in tabs.size():
		tabs[i].visible = i == index
