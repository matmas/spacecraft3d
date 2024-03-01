extends Control

func _ready():
	await get_tree().process_frame
	await get_tree().process_frame

	for child in get_children():
		if child is TextureRect:
			var texture_rect := child as TextureRect
			texture_rect.texture.get_image().save_png("res://shader_to_image/output/%s.png" % texture_rect.name.to_snake_case())
