extends Node


var selected_collider: Node3D:  # Most likely CollisionObject3D (or VoxelLodTerrain)
	get:
		if is_instance_valid(selected_collider):
			return selected_collider
		return null
