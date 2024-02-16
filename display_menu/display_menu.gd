extends Control

@onready var ui_scaling_slider: HSlider = %UIScalingSlider

func _ready() -> void:
	Utils.grab_focus_first_button(self)


func _on_ui_scaling_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		get_window().content_scale_factor = ui_scaling_slider.value
