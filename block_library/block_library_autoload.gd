extends Node

var blocks: Array[PackedScene] = []


func _ready() -> void:
	var dir_path := "res://block_library/blocks"
	var dir := DirAccess.open(dir_path)
	if not dir:
		printerr("Failed opening directory ", dir_path)
		return
	dir.list_dir_begin()
	for file in dir.get_files():
		if file.ends_with(".tscn") or file.ends_with(".tscn.remap"):
			# Exported projects have .remap files instead
			var filename := file.trim_suffix(".remap")
			var path := dir.get_current_dir().path_join(filename)
			var scene := load(path) as PackedScene
			blocks.append(scene)
	dir.list_dir_end()
