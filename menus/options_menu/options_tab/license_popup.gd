extends PopupPanel
class_name LicensePopup


func set_license_text(license_text: String) -> void:
	%Label.text = license_text


func _ready() -> void:
	_on_size_changed.call_deferred()
	get_tree().root.size_changed.connect(_on_size_changed)
	close_requested.connect(_on_close_requested)



func _on_size_changed() -> void:
	var csf := get_tree().root.content_scale_factor
	size = Vector2(
		minf(get_tree().root.size.x - 20 * csf, %Label.size.x + 20 * csf),
		minf(get_tree().root.size.y - 50 * csf, %Label.size.y + 20 * csf),
	)
	move_to_center()

func _on_close_requested() -> void:
	get_tree().root.size_changed.disconnect(_on_size_changed)
	queue_free()
