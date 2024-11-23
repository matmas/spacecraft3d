extends Node

signal selection_changed

var selected_block_type: BlockType:
	set(value):
		selected_block_type = value
		selection_changed.emit()
