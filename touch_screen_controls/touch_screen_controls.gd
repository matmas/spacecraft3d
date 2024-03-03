extends CanvasLayer


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PAUSED:
			hide()
		NOTIFICATION_UNPAUSED:
			show()
