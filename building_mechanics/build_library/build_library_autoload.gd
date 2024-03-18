extends Node

@export var pieces: Array[PackedScene] = []

signal selection_changed

var selected_piece: PackedScene:
	set(value):
		selected_piece = value
		selection_changed.emit()
