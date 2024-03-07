extends CanvasLayer


func _on_go_back_requested() -> void:  # OpenSceneButton is looking for this function here
	$PauseMenu._on_go_back_requested()
