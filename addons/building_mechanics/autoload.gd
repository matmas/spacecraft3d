extends Node

signal selection_changed

var selected_block: PackedScene:
	set(value):
		selected_block = value
		selection_changed.emit()
