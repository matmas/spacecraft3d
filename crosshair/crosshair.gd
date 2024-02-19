extends Node

@onready var center_dot := $CenterDot as Sprite2D


func _ready() -> void:
	_update_crosshair()
	get_tree().root.size_changed.connect(_update_crosshair)


func _update_crosshair() -> void:
	var center := get_viewport().get_visible_rect().size * 0.5
	center_dot.position = center
