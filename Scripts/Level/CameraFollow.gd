extends Camera2D

var follow: Node2D

export var follow_out_of_bounds = false

func _process(_delta):
	follow_constrained()

func follow_constrained():
	if follow:
		var room = GameUtil.game.world.get_room_at_pos(follow.position)
		
		# Follow node
		if room or follow_out_of_bounds:
			position = follow.position
		
		# Constrain camera to room size
		if room:
			zoom = Vector2.ONE * room.scale
			
			var size = room.scale * get_viewport().size / 2
			var start_offset = (position - size) - room.rect_position
			var end_offset = room.rect_position + room.rect_size - (position + size)
			
			start_offset = VectorUtil.min(start_offset, Vector2.ZERO)
			end_offset = VectorUtil.min(end_offset, Vector2.ZERO)
			
			position += end_offset - start_offset
