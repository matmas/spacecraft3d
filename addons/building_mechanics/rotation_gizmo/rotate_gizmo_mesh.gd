@tool
extends ArrayMesh
class_name RotateGizmoMesh
# GDScript adaptation of rotate_gizmo from Godot souces in editor/plugins/node_3d_editor_plugin.cpp

@export var material: Material:
	set(value):
		surface_set_material(0, value)
		material = value

const CIRCLE_SIZE = 1.1


func _init() -> void:
	var surftool := SurfaceTool.new()
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)

	var n := 128  # number of circle segments
	var m := 3  # number of thickness segments

	var step := TAU / n
	for j in range(n):
		var basis := Basis(Vector3.FORWARD, j * step)

		var vertex := basis * (Vector3.LEFT * CIRCLE_SIZE)

		for k in range(m):
			var ofs := Vector2(cos((TAU * k) / m), sin((TAU * k) / m))
			var normal := Vector3.FORWARD * ofs.x + Vector3.LEFT * ofs.y

			surftool.set_normal(basis * normal)
			surftool.add_vertex(vertex)

	for j in range(n):
		for k in range(m):
			var current_ring := j * m
			var next_ring := ((j + 1) % n) * m
			var current_segment := k
			var next_segment := (k + 1) % m

			surftool.add_index(current_ring + next_segment)
			surftool.add_index(current_ring + current_segment)
			surftool.add_index(next_ring + current_segment)

			surftool.add_index(next_ring + current_segment)
			surftool.add_index(next_ring + next_segment)
			surftool.add_index(current_ring + next_segment)

	var arrays := surftool.commit_to_arrays()
	add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
